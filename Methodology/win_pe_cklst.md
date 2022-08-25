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

## Windows Credentials

- [ ] **Winlogon** credentials
- [ ] **Windows Vault** credentials that you could use?
- [ ] Interesting **DPAPI credentials**?
- [ ] Passwords of saved **Wifi networks**?
- [ ] Interesting info in **saved RDP Connections**?
- [ ] Passwords in **recently run commands**?
- [ ] **Remote Desktop Credentials Manager** passwords?
- [ ] **AppCmd.exe** exists? Credentials?
- [ ] **SCClient.exe**? DLL Side Loading?

## Files and Registry (Credentials)

- [ ] **Putty Creds** and **SSH host keys**
- [ ] **SSH keys in registry**?
- [ ] Passwords in **unattended files**?
- [ ] Any **SAM & SYSTEM** backup?
- [ ] **Cloud credentials**?
- [ ] **McAfee SiteList.xml** file?
- [ ] **Cached GPP Password**?
- [ ] Password in **IIS Web config file**?
- [ ] Interesting info in **web logs**?
- [ ] Do you want to **ask for credentials** to the user?
- [ ] Interesting **files inside the Recycle Bin**?
- [ ] Other **registry containing credentials**?
- [ ] Inside **Browser data** (dbs, history, bookmarks....)?
- [ ] **Generic password search** in files and registry
- [ ] **Tools** to automatically search for passwords

## Leaked Handlers

- [ ] Have you access to any handler of a process run by administrator?

## Pipe Client Impersonation

- [ ] Check if you can abuse it
