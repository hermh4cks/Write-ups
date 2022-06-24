# Dancing From Hack The Box

By Herman Detwiler

[Back](/Hack-The-Box#hack-the-box-write-ups)
## Tags

- Windows

## Settup

1. Connect to the Hack The Box Starting Point VPN
2. Spawn Dancing
3. Copy machine ip and set to an env variable

```bash
export ip=10.129.113.234
```

# Tasks

## 1.)  What does the 3-letter acronym SMB stand for? 


From Google:

*The Server Message Block protocol (SMB protocol) is a client-server communication protocol used for sharing access to files, printers, serial ports and other resources on a network. It can also carry transaction protocols for interprocess communication.*

The answer is `Server Message Block`

## 2.) What port dose SMB use to operate at?

From [Techtarget](https://www.techtarget.com/searchnetworking/definition/Server-Message-Block-Protocol)

*The SMB protocol operates at the application layer but relies on lower network levels for transport. At one time, SMB ran on top of Network Basic Input/Output System over Transmission Control Protocol/Internet Protocol (NetBIOS over TCP/IP, or NBT) or, to a lesser degree, legacy protocols such as Internetwork Packet Exchange or NetBIOS Extended User Interface. When SMB was using NBT, it relied on ports 137, 138 and 139 for transport. Now, SMB runs directly over TCP/IP and uses port 445.*

The ansswer is `445`

## 3.)  What is the service name for port 445 that came up in our Nmap scan? 

To perform a service scan of just port 445 with nmap:

```bash
sudo nmap -sC -sV -p 445 $ip
```

```bash
Nmap scan report for 10.129.113.234
Host is up (0.055s latency).

PORT    STATE SERVICE       VERSION
445/tcp open  microsoft-ds?

Host script results:
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2022-06-23T18:38:09
|_  start_date: N/A
|_clock-skew: 3h59m33s

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 25.46 seconds

```

To verify microsoft-ds I can run a netcat banner grab to see what the service responds with:

```bash
nc -zn $ip 445
```
```
(UNKNOWN) [10.129.113.234] 445 (microsoft-ds) open

```

The answer is `microsoft-ds`

## 4.)  What is the 'flag' or 'switch' we can use with the SMB tool to 'list' the contents of the share? 


From `man smbclient`:

```
  -L|--list
           This option allows you to look at what services are available on a server. You use it as smbclient -L
           host and a list should appear. The -I option may be useful if your NetBIOS names don't match your
           TCP/IP DNS host names or if you are trying to reach a host on another network.


```

Making the answer `-L`


## 5.)  What is the name of the share we are able to access in the end with a blank password? 

To login with a username of Anonymous and a blank password with smbclient:

```bash
smbclient -L $ip -U Anonymous -N
```

```
─$ smbclient -L $ip -U Anonymous -N                                                                            1 ⨯

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        C$              Disk      Default share
        IPC$            IPC       Remote IPC
        WorkShares      Disk      
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.129.113.234 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available

```

The name of the share is `WorkShare`


## 6.)  What is the command we can use within the SMB shell to download the files we find? 


From the help command from within smb, `get`



## 7.) Get the root flag

To connect to the Share I can access (Workshares)

```bash
smbclient //$ip/workshares -U Anonymous -N

```
Then, I can list directories and files with the `ls` command, and `cd` to enter into directories I want to explore. When I see files I want to exfiltrate I can use the `get` command.

```bash
└─$ smbclient //$ip/workshares -U Anonymous -N
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Thu Jun 23 14:48:58 2022
  ..                                  D        0  Thu Jun 23 14:48:58 2022
  Amy.J                               D        0  Mon Mar 29 05:08:24 2021
  James.P                             D        0  Thu Jun  3 04:38:03 2021

                5114111 blocks of size 4096. 1752071 blocks available
smb: \> cd Amy.J\
smb: \Amy.J\> ls
  .                                   D        0  Mon Mar 29 05:08:24 2021
  ..                                  D        0  Mon Mar 29 05:08:24 2021
  worknotes.txt                       A       94  Fri Mar 26 07:00:37 2021

                5114111 blocks of size 4096. 1752071 blocks available
smb: \Amy.J\> get worknotes.txt 
getting file \Amy.J\worknotes.txt of size 94 as worknotes.txt (0.3 KiloBytes/sec) (average 0.3 KiloBytes/sec)
smb: \Amy.J\> cd ..
smb: \> cd James.P\
smb: \James.P\> ls
  .                                   D        0  Thu Jun  3 04:38:03 2021
  ..                                  D        0  Thu Jun  3 04:38:03 2021
  flag.txt                            A       32  Mon Mar 29 05:26:57 2021

                5114111 blocks of size 4096. 1752071 blocks available
smb: \James.P\> get flag.txt 
getting file \James.P\flag.txt of size 32 as flag.txt (0.1 KiloBytes/sec) (average 0.2 KiloBytes/sec)
smb: \James.P\> quit

```

Then I can view these file locally with the `cat` command locally:

```bash
└─$ cat worknotes.txt                         
- start apache server on the linux machine
- secure the ftp server
- setup winrm on dancing                                                                                                                                                                                                                                              

```

```bash
└─$ cat flag.txt     
5f61c10dffbc77a704d76016a22f1664                                                                                                                                                                                                                                             

```

Giving me the root flag
