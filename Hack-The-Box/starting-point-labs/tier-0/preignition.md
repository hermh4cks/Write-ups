# Preignition From Hack The Box
By Herman Detwiler

[Back](/Hack-The-Box#hack-the-box-write-ups)

## Tags

- `PHP`
- `Default Credentials`

## Settup

1. Connect to HTB's Starting Point VPN
2. Spawn Preignition
3. Copy the ip and store in a bash variable to use in future commands

```bash
export ip=10.129.111.121
```

# Tasks

## 1.)  What is considered to be one of the most essential skills to possess as a Penetration Tester? 

I found this question a bit confusing without seeing that the format was `*** ******g`. I was pretty sure that this was going to have something to do with enumerating web, terms that come to mind are spidering, directory brute-forcing, manual walking of the webapp. Most of these can be shortened to a more general slang: `dir busting`

## 2.)  What switch do we use for nmap's scan to specify that we want to perform version detection 

In nmap this is done with the `-sV` flag

## 3.)  What does Nmap report is the service identified as running on port 80/tcp? 

To perform a service scan of tcp port 80 via nmap:

```bash
nmap -sV -p 80 $ip
```
Output:
```bash
Nmap scan report for 10.129.111.121
Host is up (0.064s latency).

PORT   STATE SERVICE VERSION
80/tcp open  http    nginx 1.14.2

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 13.47 seconds

```


Making the service `http`

## 4.)  What server name and version of service is running on port 80/tcp? 


From the previous scan I can see the server name and version is `nginx 1.14.2`

## 5.)  What switch do we use to specify to Gobuster we want to perform dir busting specifically? 

From `gobuster -h`

```
Usage:
  gobuster [command]

Available Commands:
  dir         Uses directory/file enumeration mode
  dns         Uses DNS subdomain enumeration mode
  fuzz        Uses fuzzing mode
  help        Help about any command
  s3          Uses aws bucket enumeration mode
  version     shows the current version
  vhost       Uses VHOST enumeration mode

```

So the answer is `dir`

## 6.)  What page is found during our dir busting activities? 


From running the command: (Using the `-w` flag to specify a wordlist)

```bash
gobuster dir -u $ip -w /usr/share/dirb/wordlists/common.txt
```
```
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.129.111.121
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/dirb/wordlists/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2022/06/24 09:47:55 Starting gobuster in directory enumeration mode
===============================================================
/admin.php            (Status: 200) [Size: 999]

```


The page that was found was `admin.php`


## 7.)  What is the HTTP status code reported by Gobuster for the discovered page? 

From the above dir bust I can see the status code was `200` 

## 8.)  Submit root flag 


Going to the found page I see a login page

![image](preignition_admin.php.png2)

Sending this to burpsuite I can enter a test name and password and intercept the POST request

![image](https://user-images.githubusercontent.com/83407557/175552663-18222805-355e-4c2d-9836-dc87bf12a048.png)


I can then send it to intruder and select the name and password as payload positions for a clusterbomb attack:
![image](https://user-images.githubusercontent.com/83407557/175553535-82402894-3150-4c33-a02d-77185e0e19ce.png)

And manually add some comman usernames and passwords to the payloads

Payload 1
![image](https://user-images.githubusercontent.com/83407557/175553666-4dbce1d0-2e8e-49ab-8d2a-95cf794bc153.png)


Payload2

![image](https://user-images.githubusercontent.com/83407557/175553747-7f870935-a38a-4fc9-882c-b5578bbf8594.png)

After running the attack, I can see one response is shorter that the others. Further inspection shows that it is titled admin console:

![image](https://user-images.githubusercontent.com/83407557/175554025-c3f3ee0b-aed1-4490-825b-660b93a500c4.png)


Using the render page option for a response, I can clearly see the flag (also know the username is admin and password is admin)


![image](https://user-images.githubusercontent.com/83407557/175554271-487013b7-305c-4aef-8029-2eeb84ac4292.png)

