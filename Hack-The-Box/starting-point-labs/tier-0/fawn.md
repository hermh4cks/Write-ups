# Fawn From Hack The Box

## Tags

- External
- Penetration Tester level 1
- Enumeration
- FTP

## Settup

1. Connect to HTB starting Point VPN
2. Spawn Machine
3. Copy machine ip into an env variable:

```bash
export ip=10.129.234.173
```

# Tasks

## 1.)  What does the 3-letter acronym FTP stand for? 

`File Transfer Protocol`

## 2.)  Which port does the FTP service listen on usually? 

Normally ftp is on port `21`

## 3.)  What acronym is used for the secure version of FTP? 

From google:

*FTP is not secure in and of itself, and it is often secured with SSL/TLS (to become FTPS) or replaced with SFTP (SSH File Transfer Protocol). Secure File Transfer Protocols help you transfer data within and outside of your organization safe in the knowledge that your information is protected.Oct 20, 2011*

So `SFTP` is the secure version of FTP

## 4.)  What is the command we can use to send an ICMP echo request to test our connection to the target? 

Default program is `ping`

## 5.)  From your scans, what version is FTP running on the target? 

To run a complete port scan of the target with nmap to find the ftp service (incase it isn't default):

```bash
sudo nmap -p- $ip
```

```bash
Nmap scan report for 10.129.234.173
Host is up (0.057s latency).
Not shown: 65534 closed tcp ports (reset)
PORT   STATE SERVICE
21/tcp open  ftp

Nmap done: 1 IP address (1 host up) scanned in 82.87 seconds

```
And find an ftp service running on port, the next step is to enumerate the service with nmap's nse scripts: 

```bash
sudo nmap -sC -sV -p 21 $ip
```

```bash
Nmap scan report for 10.129.234.173
Host is up (0.072s latency).

PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.10.15.246
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 1
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_-rw-r--r--    1 0        0              32 Jun 04  2021 flag.txt
Service Info: OS: Unix

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 7.85 seconds
                                                                  
```
From the output I see the version of ftp is `vsftpd 3.0.3`

## 6.)  From your scans, what OS type is running on the target? 

I am already fairly certain the OS is unix, however to run an OS scan with nmap to solidify my findings:

```bash
sudo nmap -sC -sV -O -p 21 $ip
```
```
Nmap scan report for 10.129.234.173
Host is up (0.054s latency).

PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_-rw-r--r--    1 0        0              32 Jun 04  2021 flag.txt
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.10.15.246
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 4
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Unix

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 12.73 seconds

```
From this I submit `Unix`


## 7.)  What is the command we need to run in order to display the 'ftp' client help menu? 

From `man ftp`

```bash
ftp -h
```
## 8.)  What is username that is used over FTP when you want to log in without having an account? 

From google:

`Anonymous`

## 9.)  Submit root flag 

Logging in with `Anonymous` and hitting enter when prompted for a password. I then use `ls` to list the files `get <filename>` to grab what I want

```bash
─$ ftp Anonymous@$ip                                                                                         127 ⨯
Connected to 10.129.234.173.
220 (vsFTPd 3.0.3)
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
229 Entering Extended Passive Mode (|||17249|)
150 Here comes the directory listing.
-rw-r--r--    1 0        0              32 Jun 04  2021 flag.txt
226 Directory send OK.
ftp> get flag.txt
local: flag.txt remote: flag.txt
229 Entering Extended Passive Mode (|||12569|)
150 Opening BINARY mode data connection for flag.txt (32 bytes).
100% |***********************************************************************|    32        4.51 KiB/s    00:00 ETA
226 Transfer complete.
32 bytes received in 00:00 (0.44 KiB/s)

```

Now I have flag.txt locally and I can use `cat` to view it.

```bash
└─$ cat flag.txt 
035db21c881520061c53e0536e44f815
```

And get the root flag `035db21c881520061c53e0536e44f815`
