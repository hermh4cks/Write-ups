| A write-up on Retro | By Herman Detwiler | 8/6/22

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
Checking out /retro I get a pretty sweet retro gaming blog being hosted, I start pulling out some potentially useful info, while throwing the /retro sub domain back into gobuster to keep some scanning going on while I work at poking around the website more.

![image](https://user-images.githubusercontent.com/83407557/128460426-35865e35-e121-4bb7-8a5b-71cb8fdd8b6e.png)
*Clicking on account Wade I am able to get some potential password leakage in a comment*

![image](https://user-images.githubusercontent.com/83407557/128460933-e2e8b439-bb26-417c-9df2-a839baadb2f8.png)
*The comment did contain a password, and we login as admin to this wordpress site*

also find Wade's company Email: darkstar@darkstar7471.com

Since you can upload plugins in the form of php code on wordpress, I am going to see if I can get a webshell as a plugin.

I find something to try that used previously: https://github.com/danielmiessler/SecLists/blob/master/Web-Shells/WordPress/plugin-shell.php



# Questions

1. A web server is running on the target. What is the hidden directory which the website lives on?

2. what is the user.txt

3. what is the root.txt
