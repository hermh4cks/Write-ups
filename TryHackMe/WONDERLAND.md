# Wonderland

write-up by Herman Detwiler 9/26/21

## Recon

Starting off with an nmap scan, I see that ssh and http are running on the box. Next step is to run some background enum as I check out the website.

### Nmap

```bash
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 8e:ee:fb:96:ce:ad:70:dd:05:a9:3b:0d:b0:71:b8:63 (RSA)
|   256 7a:92:79:44:16:4f:20:43:50:a9:a8:47:e2:c2:be:84 (ECDSA)
|_  256 00:0b:80:44:e6:3d:4b:69:47:92:2c:55:14:7e:2a:c9 (ED25519)
80/tcp open  http    Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
|_http-title: Follow the white rabbit.
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 473.71 seconds
```

### Http

Running a gobuster scan in the background I am going to start manually poking at the website in my browser while capturing the traffic with a proxy.

![image](https://user-images.githubusercontent.com/83407557/134839444-7e0a7e07-46a6-4d3d-84dc-0f2a7df66c9c.png)

It would seem the target is based on the Lewis Carrol classic, Alice in wonderland.

The gobuster scan gives me some places to start. Just out of dumb luck, seeing the /r/ made me try /r/a/ in order to spell rabbit.

At the end of this, inspecting the entire page I am able to find what looks like Alice's password. Since SSH was also open, that is my next avenue for investigation.

![image](https://user-images.githubusercontent.com/83407557/134839583-b22b4342-c793-474b-b8f8-a37897d2744c.png)




`/r/a/b/b/`

![image](https://user-images.githubusercontent.com/83407557/134839888-3e865b2c-b893-48d9-813f-b3589c15dd00.png)


`/r/a/b/b/i/`

![image](https://user-images.githubusercontent.com/83407557/134839821-79c82470-1d85-419f-aaa5-4fb701f7bdcd.png)


`/r/a/b/b/i/t/`
![image](https://user-images.githubusercontent.com/83407557/134839746-9c14ed7a-3156-4890-9f34-1ef761061f59.png)

### SSH

The password was indeed a doorway into wonderland, and I am able to ssh in as Alice:

![image](https://user-images.githubusercontent.com/83407557/134840447-a64d295d-749f-4b3d-8fe0-5cccc046410d.png)

## Priv Esc

Trying to get a bearing on my surrondings I begin to enumerate the system, starting with the low hanging fruit what I can run as root.

![image](https://user-images.githubusercontent.com/83407557/134840907-151b85d9-4deb-4871-a1b9-c2cf89832a26.png)

...right off the bat I cam see that I have a python script that is world readable and owned by root, and that I can run python3.6 and that script as root.
