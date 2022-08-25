# Methodologies

By Herman Detwiler 2022

[back to write-ups](/README.md#write-ups--by-herman-detwiler)


A large part of this was taken from [Hacktricks](https://book.hacktricks.xyz/welcome/readme), I have combined the information I found the most useful on that site with my own OSCP notes. As well as any notes that I gather from doing CTFs. The intention of posting this up, is that writing it helps me learn, and in the hopes that reading it helps someone else. If it peaks your interest, reading only helps so much. Go out and try these on systems you own or on servers you have permission to.

## Pre-attack

+ ### Defining Scope

+ ### Defining Objective

## 0. Base of Operations 
Settup of attack machines, testing environments, and their use
	
+ ### [Your Attack Machine](/Methodology/Attack_Machine.md#your-hacking-computer)

+ ### [Comand & Control (C2)](/Methodology/C2.md#command-and-control)

+ ### [Setting up a Home Lab](/Methodology/Home_Lab.md#building-a-hacking-lab-at-home-in-order-to-sharpen-your-skills)

+ ### Hardware Hacking

+ ### Reverse Engineering

## 1. Discovery
Finding Hosts on a network and/or Assets of a Company
	
+ ### [Host Discovery from inside a network](/Methodology/Network/README.md#network-hacking)

+ ### [Asset Discovery from the internet](/Methodology/External/README.md#external-recon)

## 2. Network
Scanning the Hosts of a Network

+ ### [Pentesting the Network](/Methodology/Network/Scanning_Hosts.md#scanning-discovered-hosts-on-a-network)

## 3. Service Discovery
Port scanning specific services, and how to enumerate them

+ ### [Scanning Services](/Methodology/Network/Services.md#service-scanning)


## 4. Service Version Exploits
A service may have a known vulnerabilty, how to look for them

## 5. Pentesting Services
Each service has a unique methodogy when it comes to attack

## 6. Phishing
People make mistakes, learn to exploit them

## 7. Getting a Shell
Found a way to execute code? Turn it into a shell

+ ### [Linux Shells}
+ ### [Windows Shells]
+ ### [msfvenom]
+ ### [Making Dumb-Shells Full TTYs]
+ ### [Rev-Shell Gens]

## 8. Living off the land
Using target's built in functionality to attack it

+ ### [Linux Systems](/Methodology/Attack_Machine.md#linux)
+ ### [Windows Systems](/Methodology/Attack_Machine.md#windows)
+ ### [Active Directory](/Methodology/AD.md)

## 9. Exfiltration
You snuck in, now sneak some data out

## 10. Privilege Escalation
If you not root/Administrator you should find a way to escalate privileges

+ ### [Windows Priv Esc](/Methodology/win_priv_esc.md)
+ ### [Linux Priv Esc](/Methodology/lin_priv_esc.md)

Checklists

+ #### [win](/Methodology/win_pe_cklst.md)
+ #### [nux](/Methodology/lin_pe_cklst.md)
## 11. POST
Loot all the data you can with root access, and find a way to persist within the system

## 12.Pivoting
Now that you pwned this system, can you use it to get to another target?
