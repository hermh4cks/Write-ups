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
