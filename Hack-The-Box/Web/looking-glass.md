# Looking Glass write-up by Herman Detwiler

## Overview

Looking glass is an easy box on Hack the Box, and can be found on the OWASP top 10 track. We are given the following description: 

*We've built the most secure networking tool in the market, come and check it out!*

The first step is going to be to gather as much information about the target as possible.

## Recon

Given that we are given a docker address to looking glass: 161.35.47.235:30278 first I will run an nmap scan of the target to attempt and enumerate service and underlying OS information about the target. To do this I use the following nmap command to enumerate serverice version, run basic nse scripts, and to attempt OS detection:

```bash
sudo nmap -sC -sV -O 161.35.47.235 -p 30278
```

However initially the host seems down because the host is blocking ping attempts. To counter this we can add the -Pn flag to our nmap command.

```bash
└─$ sudo nmap -sC -sV 161.35.47.235 -p 30278 -Pn -O
Starting Nmap 7.92 ( https://nmap.org ) at 2022-04-04 10:57 EDT
Nmap scan report for 161.35.47.235
Host is up (0.086s latency).

PORT      STATE SERVICE VERSION
30278/tcp open  http    nginx
|_http-title: rce
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.1 (94%), Linux 3.2 (94%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (93%), HP P2000 G3 NAS device (92%), ASUS RT-N56U WAP (Linux 3.4) (91%), Linux 3.16 (91%), Linux 2.6.32 (91%), Linux 2.6.39 - 3.2 (91%), Ubiquiti AirMax NanoStation WAP (Linux 2.6.32) (91%), Linux 3.1 - 3.2 (91%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 10 hops

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 18.28 seconds
```
Based on these findings, I can be fairly certain that this is a linux box, running an nginx web server. My next step is to further enumerate this service using various commands to try and see if I can get an idea of the functionality of this web server.

## Enumeration

Using my web browser to manually view the webapp I can see that it is desiegned to perform two different network tests, traceroute and ping. It also displays my actual ip address, which has been redacted on the screenshots.

![image](https://user-images.githubusercontent.com/83407557/161574988-faf3c1c6-6625-47cf-ad47-70933d97f7e2.png)
