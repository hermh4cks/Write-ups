# Checklist - Local Windows Privilege Escalation

## System Info

- [ ] Obtain **System information**
<details>
<summary>cmd</summary>
<br>
<code>
systeminfo

systeminfo | findstr /B /C:"OS Name" /C:"OS Version" #Get only that information

wmic qfe get Caption,Description,HotFixID,InstalledOn #Patches

wmic os get osarchitecture || echo %PROCESSOR_ARCHITECTURE% #Get system architecture
  </code>
</details>

<details>
<summary>powershel</summary>
<br>
<code>

[System.Environment]::OSVersion.Version #Current OS version

Get-WmiObject -query 'select * from win32_quickfixengineering' | foreach {$_.hotfixid} #List all patches

Get-Hotfix -description "Security update" #List only "Security Update" patches

</code>
</details>

- [ ] Search for **kernel version exploits using scripts**
<details>
<summary>powershel</summary>
<br>
<code>

[System.Environment]::OSVersion.Version #Current OS version

Get-WmiObject -query 'select * from win32_quickfixengineering' | foreach {$_.hotfixid} #List all patches

Get-Hotfix -description "Security update" #List only "Security Update" patches

</code>
</details>

- [ ] Use **Google** to search for **kernel exploits**
- [ ] Use **searchsploit** to search for **kernel exploits**
- [ ] Interesting info in **env vars**?
- [ ] Passwords in **PowerShell history**?
- [ ] Interesting info in **Internet settings**?
- [ ] **Drives**?
- [ ] **WSUS** exploit?
- [ ] **AlwaysInstallElevated** Enabled?

## Logging/AV enumeration

- [ ] Check [**Audit*- windows-local-privilege-escalation/#audit-settings)and [**WEF*- windows-local-privilege-escalation/#wef)settings
- [ ] Check [**LAPS**windows-local-privilege-escalation/#laps)
- [ ] Check if [**WDigest*- windows-local-privilege-escalation/#wdigest)is active
- [ ] [**LSA Protection**windows-local-privilege-escalation/#lsa-protection)?
- [ ] [**Credentials Guard**windows-local-privilege-escalation/#credentials-guard)[?windows-local-privilege-escalation/#cached-credentials)
- [ ] [**Cached Credentials**windows-local-privilege-escalation/#cached-credentials)?
- [ ] Check if any [**AV**windows-local-privilege-escalation/#av)
- [ ] [**AppLocker Policy**windows-local-privilege-escalation/#applocker-policy)?
- [ ] [**UA**windows-local-privilege-escalation/#uac)[**User Privileges**windows-local-privilege-escalation/#users-and-groups)
- [ ] Check [**current*- user **privileges**windows-local-privilege-escalation/#users-and-groups)
- [ ] Are you [**member of any privileged group**windows-local-privilege-escalation/#privileged-groups)?
- [ ] Check if you have [any of these tokens enabledwindows-local-privilege-escalation/#token-manipulation): **SeImpersonatePrivilege, SeAssignPrimaryPrivilege, SeTcbPrivilege, SeBackupPrivilege, SeRestorePrivilege, SeCreateTokenPrivilege, SeLoadDriverPrivilege, SeTakeOwnershipPrivilege, SeDebugPrivilege*- ?
- [ ] [**Users Sessions**windows-local-privilege-escalation/#logged-users-sessions)?
- [ ] Check[ **users homes**windows-local-privilege-escalation/#home-folders) (access?)
- [ ] Check [**Password Policy**windows-local-privilege-escalation/#password-policy)
- [ ] What is[ **inside the Clipboard**windows-local-privilege-escalation/#get-the-content-of-the-clipboard)?

### [Networkwindows-local-privilege-escalation/#network)

- [ ] Check **current*- [**network*- **information**windows-local-privilege-escalation/#network)
- [ ] Check **hidden local services*- restricted to the outside

### [Running Processeswindows-local-privilege-escalation/#running-processes)

- [ ] Processes binaries [**file and folders permissions**windows-local-privilege-escalation/#file-and-folder-permissions)
- [ ] [**Memory Password mining**windows-local-privilege-escalation/#memory-password-mining)
- [ ] [**Insecure GUI apps**windows-local-privilege-escalation/#insecure-gui-apps)

### [Serviceswindows-local-privilege-escalation/#services)

- [ ] [Can you **modify any service**?windows-local-privilege-escalation/#permissions)
- [ ] [Can you **modify*- the **binary*- that is **executed*- by any **service**?windows-local-privilege-escalation/#modify-service-binary-path)
- [ ] [Can you **modify*- the **registry*- of any **service**?windows-local-privilege-escalation/#services-registry-permissions)
- [ ] [Can you take advantage of any **unquoted service*- binary **path**?windows-local-privilege-escalation/#unquoted-service-paths)

### [**Applications**windows-local-privilege-escalation/#applications)

- [ ] **Write*- [**permissions on installed applications**windows-local-privilege-escalation/#write-permissions)
- [ ] [**Startup Applications**windows-local-privilege-escalation/#run-at-startup)
- [ ] **Vulnerable*- [**Drivers**windows-local-privilege-escalation/#drivers)

### [DLL Hijackingwindows-local-privilege-escalation/#path-dll-hijacking)

- [ ] Can you **write in any folder inside PATH**?
- [ ] Is there any known service binary that **tries to load any non-existant DLL**?
- [ ] Can you **write*- in any **binaries folder**?

### [Networkwindows-local-privilege-escalation/#network)

- [ ] Enumerate the network(shares, interfaces, routes, neighbours...)
- [ ] Take a special look to network services listing on local (127.0.0.1)

### [Windows Credentialswindows-local-privilege-escalation/#windows-credentials)

- [ ] [**Winlogon*- windows-local-privilege-escalation/#winlogon-credentials)credentials
- [ ] [**Windows Vault**windows-local-privilege-escalation/#windows-vault) credentials that you could use?
- [ ] Interesting [**DPAPI credentials**windows-local-privilege-escalation/#dpapi)?
- [ ] Passwords of saved [**Wifi networks**windows-local-privilege-escalation/#wifi)?
- [ ] Interesting info in [**saved RDP Connections**windows-local-privilege-escalation/#saved-rdp-connections)?
- [ ] Passwords in [**recently run commands**windows-local-privilege-escalation/#recently-run-commands)?
- [ ] [**Remote Desktop Credentials Manager**windows-local-privilege-escalation/#remote-desktop-credential-manager) passwords?
- [ ] [**AppCmd.exe*- existswindows-local-privilege-escalation/#appcmd-exe)? Credentials?
- [ ] [**SCClient.exe**windows-local-privilege-escalation/#scclient-sccm)? DLL Side Loading?

### [Files and Registry (Credentials)windows-local-privilege-escalation/#files-and-registry-credentials)

- [ ] **Putty:*- [**Creds**windows-local-privilege-escalation/#putty-creds) **and*- [**SSH host keys**windows-local-privilege-escalation/#putty-ssh-host-keys)
- [ ] [**SSH keys in registry**windows-local-privilege-escalation/#ssh-keys-in-registry)?
- [ ] Passwords in [**unattended files**windows-local-privilege-escalation/#unattended-files)?
- [ ] Any [**SAM & SYSTEM**windows-local-privilege-escalation/#sam-and-system-backups) backup?
- [ ] [**Cloud credentials**windows-local-privilege-escalation/#cloud-credentials)?
- [ ] [**McAfee SiteList.xml**windows-local-privilege-escalation/#mcafee-sitelist-xml) file?
- [ ] [**Cached GPP Password**windows-local-privilege-escalation/#cached-gpp-pasword)?
- [ ] Password in [**IIS Web config file**windows-local-privilege-escalation/#iis-web-config)?
- [ ] Interesting info in [**web*- **logs**windows-local-privilege-escalation/#logs)?
- [ ] Do you want to [**ask for credentials**windows-local-privilege-escalation/#ask-for-credentials) to the user?
- [ ] Interesting [**files inside the Recycle Bin**windows-local-privilege-escalation/#credentials-in-the-recyclebin)?
- [ ] Other [**registry containing credentials**windows-local-privilege-escalation/#inside-the-registry)?
- [ ] Inside [**Browser data**windows-local-privilege-escalation/#browsers-history) (dbs, history, bookmarks....)?
- [ ] [**Generic password search**windows-local-privilege-escalation/#generic-password-search-in-files-and-registry) in files and registry
- [ ] [**Tools**windows-local-privilege-escalation/#tools-that-search-for-passwords) to automatically search for passwords

### [Leaked Handlerswindows-local-privilege-escalation/#leaked-handlers)

- [ ] Have you access to any handler of a process run by administrator?

### [Pipe Client Impersonationwindows-local-privilege-escalation/#named-pipe-client-impersonation)

- [ ] Check if you can abuse it

<details>

<summary><strong>Support HackTricks and get benefits!</strong></summary>

Do you work in a **cybersecurity company**? Do you want to see your **company advertised in HackTricks**? or do you want to have access the **latest version of the PEASS or download HackTricks in PDF**? Check the [**SUBSCRIPTION PLANS**https://github.com/sponsors/carlospolop)!

Discover [**The PEASS Family**https://opensea.io/collection/the-peass-family), our collection of exclusive [**NFTs**https://opensea.io/collection/the-peass-family)

Get the [**official PEASS & HackTricks swag**https://peass.creator-spring.com)

**Join the*- [**💬**https://emojipedia.org/speech-balloon/) [**Discord group**https://discord.gg/hRep4RUj7f) or the [**telegram group**https://t.me/peass) or **follow*- me on **Twitter*- [**🐦**https://github.com/carlospolop/hacktricks/tree/7af18b62b3bdc423e11444677a6a73d4043511e9/\[https:/emojipedia.org/bird/README.md)[**@carlospolopm**https://twitter.com/carlospolopm)**.**

**Share your hacking tricks submitting PRs to the*- [**hacktricks github repo**https://github.com/carlospolop/hacktricks)**.**

</details>
