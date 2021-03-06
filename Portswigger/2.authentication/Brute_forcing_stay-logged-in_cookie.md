# Lab: Brute-forcing a stay-logged-in cookie

## Description

This lab allows users to stay logged in even after they close their browser session. The cookie used to provide this functionality is vulnerable to brute-forcing.

To solve the lab, brute-force Carlos's cookie to gain access to his "My account" page.

Your credentials: wiener:peter
Victim's username: carlos
Candidate [passwords](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/passwords)

# Step 1 Use application as normal user and enable stay-loggen-in cookie

I notice there is a checkbox for staying logged in on the login page

![image](https://user-images.githubusercontent.com/83407557/171418798-d465401e-7b28-4300-b2c3-ee1335d4d92a.png)

Viewing my POST request and server response in burp I see the stay-logged-in cookie being set

![image](https://user-images.githubusercontent.com/83407557/171419220-b2f8f718-6ac9-42a8-a0da-2a8791d62bb0.png)


# Step 2 Inspect cookie

I send the cookie to burp decoder:

Decoding the cookie as base64 I find that my username is the first part

![image](https://user-images.githubusercontent.com/83407557/171419978-5fccc8aa-afb3-4310-a90b-33d53c79efce.png)

Now the second part of the cookie apears to be a hashed version of my password. I send that to an online rainbow table: [CrackStation](https://crackstation.net/)

![image](https://user-images.githubusercontent.com/83407557/171420961-6917d17e-ff0f-4fc3-a931-4f889ff2dad8.png)

I see that it uses md5 hashing for the passwords.

# Step 3 create an md5 hashed list of my passwords

Since there is no salt to this hash, it is easy to write a small python script to do that:

```python
#!/usr/bin/env python3
import hashlib



with open("passwords.txt", mode="r", encoding="utf-8") as f:
    for line in f:
        line = line.rstrip("\r\n")
        result = hashlib.md5(line.encode())
        print(result.hexdigest())
```
This script, along with a file in the same directory called "passwords.txt" containing the provided passwords, gives an md5-hashed version of each password

![image](https://user-images.githubusercontent.com/83407557/171424308-3fcafff6-a955-4431-8a27-cee8cb623622.png)

Just to verify it is working as intended I run the first through crackstation and see if I get back the original input:

![image](https://user-images.githubusercontent.com/83407557/171424858-acd9cbde-035d-45c7-a826-118e38416899.png)


# Step 4 add carlos username and base64 encode the entire string

Since my cookie was more than just my hashed password, I also need to add the carlos username and a ":" character and then base64 the whole string. I can modify my python script to do this.

```python
#!/usr/bin/env python3
import hashlib
import base64

with open("passwords.txt", mode="r", encoding="utf-8") as f:
    for line in f:
        line = line.rstrip("\r\n")
        result = hashlib.md5(line.encode())
        cookiedough ="carlos:" + result.hexdigest()
        cookie_bytes = cookiedough.encode('ascii')
        base64_cookie = base64.b64encode(cookie_bytes)
        cookies = base64_cookie.decode("utf-8")
        print(cookies)
```
Running this script I can get a list of possible cookie values based on the passwords list I have and on the structure I mapped out from my own cookie and the known values it contained.

![image](https://user-images.githubusercontent.com/83407557/171432130-7452f34b-2dee-4c6c-af1e-eceea3e1489d.png)

# Step 5 Use our new cookies in a burp intruder attack

The simplest way I found to transfer this list to burp is to use xclip in linux, I pipe my script to the following command and the output from the script gets saved in my clipboard. Then I just paste it into burp. I could also just pipe the output to a file. Both are shown below

![image](https://user-images.githubusercontent.com/83407557/171432948-de910c68-18f0-436d-a61c-924f9476ff80.png)

I then send the GET request for /my-account to intruder with the stay-logged-in cookie as the position and change the paramiter to carlos

![image](https://user-images.githubusercontent.com/83407557/171439119-2d4f047e-41e5-4cc0-8765-715cc9914696.png)


I then paste the cookies I made using the xclip method 

![image](https://user-images.githubusercontent.com/83407557/171437971-1eef02a0-d181-4de0-a9fc-203f5a28fd70.png)

I then make sure to log-out of the wiener account to free up the session cookie I will be using and launch the attack. One result stands out:

![image](https://user-images.githubusercontent.com/83407557/171439378-c1cd21a9-10c7-4118-b2ff-a4b56d9565e3.png)

Opening the 200 response in my browser, I confirm that I have brute forced carlos' stay-logged-in cookie and solve the lab:

![image](https://user-images.githubusercontent.com/83407557/171439592-c1c07191-5c28-4cc3-a128-48a3b3c5c85e.png)


# Alt to python using intruder.

Okay, we are all learning here...I was more comfortable with the python method...however, after reading the solution that portswigger has I want to explain how intruder alone can be used to do this attack. I now am thinking that in the future I may just use burp because it now seems a little faster. That being said, I think knowing both ways is better than just knowing one.

Knowing that structure of the cookie, I can log into my account and send the request to intruder. I then log out in my browser and go set up the attack.

I set the stay-logged-in cookie as that payload possition

![image](https://user-images.githubusercontent.com/83407557/171442219-4ae1d7ad-652d-4790-ab7a-0cec181846ab.png)

But this time, for the payload I just add the passwords

![image](https://user-images.githubusercontent.com/83407557/171442606-356fcdee-7bfc-4c4b-83dc-a784b7ff34fc.png)

But then the magic is in the payload processing

1. hash the password
2. add the string 'carlos:'
3. base64 encode the whole thing

![image](https://user-images.githubusercontent.com/83407557/171442912-0d40df4e-5aa5-465c-8cf7-d90decac6e7d.png)

As can be seen, the results are exactly the same as the original attack, but settup is muuuch faster (imo)

![image](https://user-images.githubusercontent.com/83407557/171443329-166dae94-efb0-4327-ae5b-ec9362ade19b.png)



