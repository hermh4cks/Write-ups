# Cold VVars From Try Hack Me!
write-up by Herman Detwiler (hermh4cks)

## Brief

Part of Incognito 2.0 CTF

Note- The machine may take about 5 minutes to fully boot.

Like my work, Follow on twitter to be updated and know more about my work! (@0cirius0)


## Recon

To start out recond I am going to use nmap to perform a port-scan of the target machine.

```bash
└─$ sudo nmap -sC -sV 10.10.105.27                                                                            139 ⨯
Starting Nmap 7.92 ( https://nmap.org ) at 2022-09-27 14:26 EDT
Nmap scan report for 10.10.105.27
Host is up (0.12s latency).
Not shown: 996 closed tcp ports (reset)
PORT     STATE SERVICE     VERSION
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 4.7.6-Ubuntu (workgroup: WORKGROUP)
8080/tcp open  http        Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
8082/tcp open  http        Node.js Express framework
|_http-title: Site doesn't have a title (text/html; charset=UTF-8).
Service Info: Host: INCOGNITO

Host script results:
|_clock-skew: mean: 1m10s, deviation: 0s, median: 1m10s
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
|_nbstat: NetBIOS name: INCOGNITO, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb2-time: 
|   date: 2022-09-27T18:27:44
|_  start_date: N/A
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.7.6-Ubuntu)
|   Computer name: incognito
|   NetBIOS computer name: INCOGNITO\x00
|   Domain name: \x00
|   FQDN: incognito
|_  System time: 2022-09-27T18:27:44+00:00
```

From the above scan I can see that the target is being identified as an Ubuntu machine, that is running SMB(samba 4.7.6) and two http services.

## Service enumeration: Samba

Using enum4linux, I can get a bunch of juicy info from the Samba service:

Nbstat info:
![image](https://user-images.githubusercontent.com/83407557/192608849-a7a08279-99b6-42c3-9b21-c14f5493f5ed.png)

OS info:
![image](https://user-images.githubusercontent.com/83407557/192608943-171e4a22-aacd-4967-8179-a9bdf9953191.png)

Share Enumeration:
![image](https://user-images.githubusercontent.com/83407557/192609050-fe8373f9-3789-492a-ac16-08913aa6dc00.png)


