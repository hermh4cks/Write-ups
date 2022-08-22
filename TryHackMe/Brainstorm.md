# Brainstorm From TryHackMe

Write-up by Herman Detwiler

### Briefing

Deploy the machine and scan the network to start enumeration!

Please note that this machine does not respond to ping (ICMP) and may take a few minutes to boot up.


## Recon


The first step is to scan the machine to see which services have open ports that I can further enumerate. To scan all ports with nmap I use the following flags:


```bash
nmap 10.10.52.192 -p- -Pn -T4 -oA nmap/all-ports
```

- `-p-` To scan ALL ports

- `-Pn` To treat the target as online (skipping the ping scan since we were told the machine will not respond)

- `-oA nmap/all-ports` to output in all formats into files named all-port.*

- `-T4` to speed up the scan with more threads

This shows the following three ports as being open:

```
Nmap scan report for 10.10.52.192
Host is up (0.082s latency).
Not shown: 65532 filtered tcp ports (no-response)
PORT     STATE SERVICE
21/tcp   open  ftp
3389/tcp open  ms-wbt-server
9999/tcp open  abyss
```

To follow up I also want to scan all UPD ports (a slower scan that requires root privs)

```bash
 sudo nmap 10.10.52.192 -p- -sU -Pn -oA nmap/udp_scan -T4
```

- `sU` UPD scan

- `sudo` Run nmap with root privs

While this scan is going I will continue to manually investigate the ports that I found open.

## Port 21 FTP

First step would be to banner grab to see if I could get the version info, I can do this with netcat

`nc -vn 10.10.52.192 21`

```bash
└─$ nc -vn 10.10.52.192 21
(UNKNOWN) [10.10.52.192] 21 (ftp) open
220 Microsoft FTP Service
```

I can next see if this file transfer server allows for anonymous access.

`ftp 10.10.52.192`

Entering a blank password, I see that it does allow anonymous access:

```bash
└─$ ftp 10.10.52.192   
Connected to 10.10.52.192.
220 Microsoft FTP Service
Name (10.10.52.192:kali): Anonymous
331 Anonymous access allowed, send identity (e-mail name) as password.
Password: 
230 User logged in.
Remote system type is Windows_NT.
```

### Exploring contents of FTP

First I make sure passive mode is off, then I can use the dir command 

```
ftp> passive
Passive mode: off; fallback to active mode: off.
ftp> dir
200 EPRT command successful.
150 Opening ASCII mode data connection.
08-29-19  08:36PM       <DIR>          chatserver
```

Seeing a directory for chatserver I go into it and download the contents to kali(first seting binary mode)

```
ftp> cd chatserver
250 CWD command successful.
ftp> dir
200 EPRT command successful.
150 Opening ASCII mode data connection.
08-29-19  10:26PM                43747 chatserver.exe
08-29-19  10:27PM                30761 essfunc.dll
226 Transfer complete.
ftp> mget *
mget chatserver.exe [anpqy?]? n
mget essfunc.dll [anpqy?]? n
ftp> bin
200 Type set to I.
ftp> mget *
mget chatserver.exe [anpqy?]? y
200 EPRT command successful.
125 Data connection already open; Transfer starting.
100% |**************************************************************| 43747      105.60 KiB/s    00:00 ETA
226 Transfer complete.
43747 bytes received in 00:00 (105.55 KiB/s)
mget essfunc.dll [anpqy?]? y
200 EPRT command successful.
150 Opening BINARY mode data connection.
100% |**************************************************************| 30761       94.64 KiB/s    00:00 ETA
226 Transfer complete.
30761 bytes received in 00:00 (94.47 KiB/s)
```

### Investigating binary

Using the file command I can see what kind of files I just downloaded

```bash
─$ file chatserver.exe 
chatserver.exe: PE32 executable (console) Intel 80386 (stripped to external PDB), for MS Windows

└─$ file essfunc.dll 
essfunc.dll: PE32 executable (DLL) (console) Intel 80386 (stripped to external PDB), for MS Windows
```

Using the strings command on the .exe file I also find that it seems to have a potential port number of 9999, and it seems to be an App called Brainstorm chat (beta)

```bash
└─$ strings chatserver.exe                                                                                 
!This program cannot be run in DOS mode.                                                                   
.text                                                                                                      
P`.data                                                                                                    
.rdata                                                                                                     
0@.bss                                                                                                     
.idata                                                                                                     
.CRT              
...
Encountered following winsock error while starting server:                                                 
%d: %s                                                                                                     
9999                                                                                                       
Chat Server started!                                                                                       
Waiting for connections.                                                                                   
Received a client connection from %s:%u                                                                    
Welcome to Brainstorm chat (beta)                                                                          
Please enter your username (max 20 characters):                                                            
Client %s:%u selected username: %s                                                                         
Write a message:                                                                                           
%s%s said: %s                                                                                              
Write a message:                                                                                           
Client %s:%u closed connection.                                                                            
Unknown error                                                                                              
_matherr(): %s in %s(%g, %g)  (retval=%g) 

...
..
```

Further investigation finds a "[dangerous](https://www.geeksforgeeks.org/why-strcpy-and-strncpy-are-not-safe-to-use/)" function in C strcpt and puts

From Google:

*strcpy sets a bunch of bytes starting at where you told it to. puts reads a bunch of bytes starting at where you told it to. Neither strcpy nor puts knows whether that area actually belongs to you or someone else.*

```
└─$ strings chatserver.exe|grep -B 5 -A 5 strcpy
memset
printf
puts
signal
sprintf
strcpy
strlen
strncat
strncmp
strncpy
_unlock
```

I now belive that I have found the app that is running on this machine's port 9999, and that it will be vulnerable to a buffer overflow. First I want to finish enumerating the system, to verify my findings and plan the next step.


## Port 3389

I find that RPD is running, but that I need credentials to get in

```
└─$ xfreerdp /v:10.10.52.192                                                                           1 ⨯
[11:13:29:510] [11932:11933] [INFO][com.freerdp.client.x11] - No user name set. - Using login name: kali
[11:13:30:154] [11932:11933] [WARN][com.freerdp.crypto] - Certificate verification failure 'self signed certificate (18)' at stack position 0
[11:13:30:154] [11932:11933] [WARN][com.freerdp.crypto] - CN = brainstorm
[11:13:30:154] [11932:11933] [ERROR][com.freerdp.crypto] - @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
[11:13:30:154] [11932:11933] [ERROR][com.freerdp.crypto] - @           WARNING: CERTIFICATE NAME MISMATCH!           @
[11:13:30:154] [11932:11933] [ERROR][com.freerdp.crypto] - @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
[11:13:30:154] [11932:11933] [ERROR][com.freerdp.crypto] - The hostname used for this connection (10.10.52.192:3389) 
[11:13:30:154] [11932:11933] [ERROR][com.freerdp.crypto] - does not match the name given in the certificate:
[11:13:30:154] [11932:11933] [ERROR][com.freerdp.crypto] - Common Name (CN):
[11:13:30:154] [11932:11933] [ERROR][com.freerdp.crypto] -      brainstorm
[11:13:30:154] [11932:11933] [ERROR][com.freerdp.crypto] - A valid certificate for the wrong name should NOT be trusted!
Certificate details for 10.10.52.192:3389 (RDP-Server):
        Common Name: brainstorm
        Subject:     CN = brainstorm
        Issuer:      CN = brainstorm
        Thumbprint:  dd:d7:9a:08:44:fa:15:15:9c:ed:49:64:d5:cb:82:55:ca:81:42:a8:20:d4:b3:e0:ac:34:b1:72:12:a5:7a:49
The above X.509 certificate could not be verified, possibly because you do not have
the CA certificate in your certificate store, or the certificate has expired.
Please look at the OpenSSL documentation on how to add a private CA to the store.
Do you trust the above certificate? (Y/T/N) Y
Domain:   
Password: 
[11:13:35:838] [11932:11933] [ERROR][com.freerdp.core.transport] - transport_ssl_cb: ACCESS DENIED
[11:13:35:838] [11932:11933] [ERROR][com.freerdp.core] - transport_ssl_cb:freerdp_set_last_error_ex ERRCONNECT_AUTHENTICATION_FAILED [0x00020009]
[11:13:35:838] [11932:11933] [ERROR][com.freerdp.core.transport] - BIO_read returned an error: error:14094419:SSL routines:ssl3_read_bytes:tlsv1 alert access denied
```

## port 9999

Again using netcat I want to see if this program matches what I found in my strings search of the .exe binary.

It apears to match many of the strings

```
└─$ nc 10.10.52.192 9999                                                                               1 ⨯
Welcome to Brainstorm chat (beta)
Please enter your username (max 20 characters): Hacker
Write a message: Test


Mon Aug 22 08:18:32 2022
Hacker said: Test
```
