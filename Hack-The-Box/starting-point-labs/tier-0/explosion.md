# Explosion From Hack The Box

## Tags

- Network
- Account Misconfiguration

## Settup


1. Connect to startingpoint VPN
2. Spawn machine
3. Store machine ip in a variable for further use

```bash
export ip=10.129.1.13
```

## Tasks

### 1.)  What does the 3-letter acronym RDP stand for? 

`Remote Desktop Protocol`

### 2.)  What is a 3-letter acronym that refers to interaction with the host through a command line interface? 

Command line interface is shortened to the acronym `CLI`

### 3.)  What about graphical user interface interactions? 

Graphical user interface is shortened to the acronym `GUI`

### 4.)  What is the name of an old remote access tool that came without encryption by default and listens on TCP port 23? 

From Google:

*Port 23 is typically used by the Telnet protocol. Telnet commonly provides remote access to a variety of communications systems. Telnet is also often used for remote maintenance of many networking communications devices including routers and switches.*

So the answer is Telnet

### 5.)  What is the name of the service running on port 3389 TCP? 

Running a service scan of TCP port 3389 with nmap:

```bash
sudo nmap -sC -sV -p 3389 $ip
```
```bash
Nmap scan report for 10.129.1.13
Host is up (0.059s latency).

PORT     STATE SERVICE       VERSION
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| rdp-ntlm-info: 
|   Target_Name: EXPLOSION
|   NetBIOS_Domain_Name: EXPLOSION
|   NetBIOS_Computer_Name: EXPLOSION
|   DNS_Domain_Name: Explosion
|   DNS_Computer_Name: Explosion
|   Product_Version: 10.0.17763
|_  System_Time: 2022-06-24T03:25:59+00:00
| ssl-cert: Subject: commonName=Explosion
| Not valid before: 2022-06-23T03:19:15
|_Not valid after:  2022-12-23T03:19:15
|_ssl-date: 2022-06-24T03:25:59+00:00; -26s from scanner time.
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: -26s, deviation: 0s, median: -26s

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 13.99 seconds
                                                                    
```
Making the answer `ms-wbt-server`

### 6.)  What is the switch used to specify the target host's IP address when using xfreerdp? 


From running xfreerdp with a help flag (-h)

```
Examples:
    xfreerdp connection.rdp /p:Pwd123! /f
    xfreerdp /u:CONTOSO\JohnDoe /p:Pwd123! /v:rdp.contoso.com
    xfreerdp /u:JohnDoe /p:Pwd123! /w:1366 /h:768 /v:192.168.1.100:4489
    xfreerdp /u:JohnDoe /p:Pwd123! /vmconnect:C824F53E-95D2-46C6-9A18-23A5BB403532 /v:192.168.1.100

```
The answer is `/v:`

### 7.)  Submit root flag 

Using xfreerdp to connect to the service as an Administrator:

```bash
xfreerdp /v:$ip /u:Administrator
```

We are prompted for a password, but hitting enter shows that the Administrator account has been misconfigured and can login without a password. On the Administrator's desktop, I see the root flag

![image](https://user-images.githubusercontent.com/83407557/175458734-c012d768-f4d4-480b-962c-bb8b8f4d8b7a.png)

