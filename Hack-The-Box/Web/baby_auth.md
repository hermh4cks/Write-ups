# Baby Auth write-up | By Herman Detwiler

## Overview

Baby Auth is an easy box on Hack the Box, and can be found on the OWASP top 10 track. We are given the following description:

*Who needs session integrity these days?*

The first step is to gather as much initial information about the target as I possibly can.

## Recon

We are given a docker address of our target from hack the box:

`46.101.61.42:30734`

Using nmap I can scan the target, while using my browser to manually view the address (since I know this is a web challange)

### Nmap scan

```bash
└─$ sudo nmap -sC -sV 46.101.61.42 -p 30734 -Pn  -oA nmap/port_30734-Pn


Nmap scan report for 46.101.61.42
Host is up (0.097s latency).

PORT      STATE SERVICE VERSION
30734/tcp open  http    nginx
| http-title: broken authentication
|_Requested resource was /login
```

### Viewing page in browser

/login
![image](https://user-images.githubusercontent.com/83407557/162455374-b62e1d58-f441-45c5-ac87-352c3ef6600b.png)
/register
![image](https://user-images.githubusercontent.com/83407557/162456190-44a43ee2-5ab8-4b74-97ab-3edea355afe1.png)

## Enumeration

After finding login and account creation pages, I will start running a dirbusting scan in the background, while manually exploring the functions of the webapp. However while viewing the page I will be using burpsuite to proxy and potentially modify my requests and server responses.

### Creating a user account

![image](https://user-images.githubusercontent.com/83407557/162458853-89d7517a-f248-4b80-964f-68ee79c6cbae.png)


### Logging in as that user

![image](https://user-images.githubusercontent.com/83407557/162459052-8c1c9a40-6353-47bc-9a1f-794c64e2b2d6.png)

![image](https://user-images.githubusercontent.com/83407557/162459737-1a746857-f754-49d2-8e92-80b63dc38693.png)

### Response setting session cookie

![image](https://user-images.githubusercontent.com/83407557/162460627-d839351f-5f6a-4600-b4d7-8f36997adfbc.png)

### Decoding cookie with burp (base64)

![image](https://user-images.githubusercontent.com/83407557/162461115-bde72185-b045-4502-b6c6-40ac38c1ecb4.png)


With all of this I can see a few things. I can see that my cookie contains my own username, and I can see that the username that I want is admin. I also see that the server is expecting that cookie to be base64 encoded. I can again use burp to edit the value and then encode back into base64:

![image](https://user-images.githubusercontent.com/83407557/162462624-5a5a3c31-838f-4bd2-8719-c1684b07246f.png)

With the value eyJ1c2VybmFtZSI6ImFkbWluIn0=, I can now edit my cookie while logged in as an standard user and likely will be able to create a new session as admin once I refresh my page:

initial value:
![image](https://user-images.githubusercontent.com/83407557/162463058-dbbdca1c-84bc-42c0-9974-efedf91d7713.png)

After changing the value and hitting refresh we are now logged in as admin and get the flag!

![image](https://user-images.githubusercontent.com/83407557/162463452-f39b90e6-ab25-4b4c-ac22-80c002c98819.png)


