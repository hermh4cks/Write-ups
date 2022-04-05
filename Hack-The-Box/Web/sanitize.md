# Sanitize from Hack the Box write-up | By Herman Detwiler

## Overview:

Sanitize is an easy box on the OWASP top 10 track from Hack the Box. We are given the following description:

*Can you escape the query context and log in as admin at my super secure login page?*

To start off, I need to gather more information about my target.

## Recon

### Port scanning with nmap

I start out with a basic nmap scan against the target:

```bash
└─$ sudo nmap -sC -sV 159.65.81.40 -p 30957 -Pn -oA nmap/initial-Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-04-04 20:24 EDT
Nmap scan report for 159.65.81.40
Host is up (0.090s latency).

PORT      STATE SERVICE VERSION
30957/tcp open  http    Werkzeug httpd 1.0.1 (Python 2.7.17)
|_http-server-header: Werkzeug/1.0.1 Python/2.7.17
|_http-title: SQLi


```
From this I can gather that sql injection is going to be the intended method of compromise against the target. I also see that it is running an older version of python server. 

### Examining http server using burpsuite

My next course of action is to manually view the webapp while proxying my traffic through burpsuite. I will not be intercepting the traffic initially, as I want to use burp to map out the application.

![image](https://user-images.githubusercontent.com/83407557/161655580-e430d2fe-ef2c-40d2-b4df-083e0caa6f8d.png)

Again with the proxy on but intercept off, I can view both my request and the server's response directly from burpsuite:

![image](https://user-images.githubusercontent.com/83407557/161655799-9a02178f-f3d2-48c3-bbe0-1f9d93d3b852.png)

## Exploiting SQLi

The first step to exploiting sqli is to attempt to break-out of the sql query in either the username or password field. I will try a single quote as the username and the word password as the password:

![image](https://user-images.githubusercontent.com/83407557/161656326-3f4b9bfa-d60a-40dd-b36d-017e2fb4c9fa.png)

I get both a meme and some juicy error output that with some google-foo:

![image](https://user-images.githubusercontent.com/83407557/161656519-a07b8b9f-3877-448b-a6ac-533bb2f37ac0.png)

## Logging in as admin

Well since we know that this webapp is vulnerable to sqli, and that the challange is to login as the admin user, next lets try the username admin with a single quote to see if we can still get an error:

![image](https://user-images.githubusercontent.com/83407557/161656724-ea811e7a-a591-4dc9-bfee-057ab111955e.png)

while this didn't log us in, it is still what I was looking for in that the error msg still exists for the password field. To try and not get any error I will do the same thing again, but this time with a comment in sqlite3(again found via google-foo)

![image](https://user-images.githubusercontent.com/83407557/161656964-f858147a-8225-4afc-b8ce-0342edca7a50.png)

![image](https://user-images.githubusercontent.com/83407557/161657028-1a67ee30-a3b0-4508-8180-c74304d2e07c.png)

As can be seen above there is now no error msg at the bottem of the page. My final step is to enter a conditionally true statement into sql in order to bypass the password check: for this my username will still be admin, but my password is now 'or 1=1--

With this I can bypass the login and get the flag!

![image](https://user-images.githubusercontent.com/83407557/161657406-ae859509-87c6-455b-85ef-b4a49abce9ee.png)
