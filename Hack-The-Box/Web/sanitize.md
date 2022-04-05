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

