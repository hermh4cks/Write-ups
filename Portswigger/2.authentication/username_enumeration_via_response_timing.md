# Lab: Username enumeration via response timing

## Description 

This lab is vulnerable to username enumeration and password brute-force attacks. It has an account with a predictable username and password, which can be found in the following wordlists:
 
 Your credentials: wiener:peter
 
 Candidate [usernames](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/usernames)
 
 Candidate [passwords](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/passwords)

To solve the lab, enumerate a valid username, brute-force this user's password, then access their account page.

## HINT

To add to the challenge, the lab also implements a form of IP-based brute-force protection. However, this can be easily bypassed by manipulating HTTP request headers.

## Background info I found usefull

From [Portswigger](https://portswigger.net/web-security/authentication/password-based) on timing attacks:

*Response times: If most of the requests were handled with a similar response time, any that deviate from this suggest that something different was happening behind the scenes. This is another indication that the guessed username might be correct. For example, a website might only check whether the password is correct if the username is valid. This extra step might cause a slight increase in the response time. This may be subtle, but an attacker can make this delay more obvious by entering an excessively long password that the website takes noticeably longer to handle.*

From Sjoerd Langkemper's [web application security blog](https://www.sjoerdlangkemper.nl/2017/03/01/bypass-ip-block-with-x-forwarded-for-header/)

*Sometimes the IP address is used for access control or rate limiting. If the client is behind a proxy, the proxy forwards the IP address of the client to the server in a specific header, X-Forwarded-For. In some cases, a client can use this header to spoof his IP address.*

# Step 1: Use the application normally while capturing traffic with a proxy

I was given an account for testing purposes, so I want to login with this account and see what this webapp does. I can then use these requests to build an attack utilizing information I have gathered about the target.

![image](https://user-images.githubusercontent.com/83407557/170720249-f055529d-5328-4066-ac5c-9e370ba4553d.png)

![image](https://user-images.githubusercontent.com/83407557/170721058-66a42446-91f4-48c5-a537-4794f549dc17.png)

# Step 2: Build an intruder attack to enumerate usernames.

First I need to see if I can get the server to make a different response time based on an invalid vs. valid username. Since I have a test username I can do this. I must log-out in my browser, and also keep inmind the ip-brute-force protection. For this reason I will also add the X-Forwarded-For header to my intruder attack, and add a prong of my pitchfork attack just for spoofing my ip with headers. Hopefully this will be enough to stop the ip block.

I will test this first with the repeater tool

sending a valid user and long password

![image](https://user-images.githubusercontent.com/83407557/170724247-56431f3e-f3f6-4c69-8042-524314972495.png)


increasing the XFF header and sending an invalid username

![image](https://user-images.githubusercontent.com/83407557/170724897-711aa112-98ed-4b81-b123-169e99a82baf.png)


I notice that a valid username takes much longer to return a server response.

I can then build an intruder attack with this request, and set the payload to the username, and XFF header with a pitchfork attack.

![image](https://user-images.githubusercontent.com/83407557/170725346-86d39262-62c8-4380-8796-34ec8f24a7c6.png)

XFF payload is a simple list of numbers that cover the number of names I have 

![image](https://user-images.githubusercontent.com/83407557/170725617-73c49bd7-a04a-4eef-ac8c-83fa4627577b.png)

and the usernames that I am testing for a second

![image](https://user-images.githubusercontent.com/83407557/170725699-eba91fff-f699-436b-87c6-1181d5624e2c.png)


## Results:

I can see one name took a much longer response time, this lets me know it is a valid username.

![image](https://user-images.githubusercontent.com/83407557/170726150-a0362f74-998e-45c5-bf48-153e64579616.png)


# Step 3: Enumerate valid user's password.

At this point, I only need to account to the ip-lockout and I can bruteforce the passwords of the found username.

## I send the request that took the longest back to intruder:

I keep the username and add payload possitions at the XFF header and password params

![image](https://user-images.githubusercontent.com/83407557/170726593-c1918094-e88b-494f-be67-e914aa3a67bd.png)


payload 1 needs to be around 100 new numbers

![image](https://user-images.githubusercontent.com/83407557/170726784-fe2efcda-d249-4e28-95ca-9b46e37687dc.png)

and payload 1 is the provided password wordlist

![image](https://user-images.githubusercontent.com/83407557/170726988-98422fa9-2166-4089-b25b-b087bc61b716.png)

One of these requests returns a redirect, letting me know I have found the username/password combo.

![image](https://user-images.githubusercontent.com/83407557/170727509-49578a42-09ca-4573-bcad-ba53a5ed2bb6.png)


# Step 4: login as found user





