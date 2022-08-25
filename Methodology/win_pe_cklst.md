# Checklist - Local Windows Privilege Escalation

## System Info

- [ ] Obtain **System information**
- [ ] Search for **kernel version exploits using scripts**
- [ ] Use **Google** to search for **kernel exploits**
- [ ] Use **searchsploit** to search for **kernel exploits**
- [ ] Interesting info in **env vars**?
- [ ] Passwords in **PowerShell history**?
- [ ] Interesting info in **Internet settings**?
- [ ] **Drives**?
- [ ] **WSUS** exploit?
- [ ] **AlwaysInstallElevated** Enabled?

## Logging/AV enumeration

- [ ] Check **Audit* and **WEF** settings
- [ ] Check **LAPS**
- [ ] Check if **WDigest** is active
- [ ] **LSA Protection**?
- [ ] **Credentials Guard**?
- [ ] **Cached Credentials**?
- [ ] Check if any **AV**
- [ ] **AppLocker Policy**?
- [ ] **UA** **User Privileges**
- [ ] Check **current user privileges**
- [ ] Are you **member of any privileged group**?
- [ ] Check if you have any of these tokens enabled:**SeImpersonatePrivilege, SeAssignPrimaryPrivilege, SeTcbPrivilege, SeBackupPrivilege, SeRestorePrivilege, SeCreateTokenPrivilege, SeLoadDriverPrivilege, SeTakeOwnershipPrivilege, SeDebugPrivilege**
- [ ] **Users Sessions**?
- [ ] Check **users homes** (access?)
- [ ] Check **Password Policy**
- [ ] What is **inside the Clipboard**?

## Network

- [ ] Check current **network information**
- [ ] Check **hidden local services** that had been restricted from the outside
- [ ] Enumerate the network(shares, interfaces, routes, neighbours...)
- [ ] Take a special look to network services listing on local (127.0.0.1)



## Running Processes

- [ ] Processes binaries **file and folders permissions**
- [ ] **Memory Password mining**
- [ ] **Insecure GUI apps**

## Services

- [ ] Can you **modify any service**?
- [ ] Can you **modify** the **binary** that is **executed** by any **service**?
- [ ] Can you **modify** the **registry*- of any **service**?windows-local-privilege-escalation/#services-registry-permissions)
- [ ] Can you take advantage of any **unquoted service** binary **path**?

## Applications

- [ ] **Write** permissions on **installed applications**
- [ ] **Startup Applications**
- [ ] **Vulnerable Drivers**


## DLL Hijacking
- [ ] Can you **write in any folder inside PATH**?
- [ ] Is there any known service binary that **tries to load any non-existant DLL**?
- [ ] Can you **write*- in any **binaries folder**?

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
