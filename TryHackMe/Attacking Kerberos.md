# TryHackMe's Attacking Kerberos Lab Write-up
>Written by Herman Detwiler | 8/2/2021

*Learning how to abuse the Kerberos Ticket Granting Service inside of a Windows Domain Controller*

### Table of Contents
- [Introduction](#Introduction)
- [Machine Information](#Machine-Information)
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




Machine Information
======================================================================================================



