# Lab: Username enumeration via different responses

## Description

 This lab is vulnerable to username enumeration and password brute-force attacks. It has an account with a predictable username and password, which can be found in the following wordlists:
 
 
 Candidate [usernames](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/usernames)
 
 Candidate [passwords](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/passwords)

To solve the lab, enumerate a valid username, brute-force this user's password, then access their account page.

---
# Step 1 Gather a normal login attempt using burp

I first enter a testname for a username and a testpassword for a password on the login mechanism for the webapp and capture the request with a proxy to automate future responses:

![image](https://user-images.githubusercontent.com/83407557/170169583-681b7020-7665-4a26-966b-c9f44d10e37d.png)


# Step 2 Find a valid username

I capture this request and send it to burp intruder and set a sniper attack on just the username parameter:

![image](https://user-images.githubusercontent.com/83407557/170169831-2016c1fa-c439-48cc-836e-cdd6b0df9ad8.png)

and set the payload to a simple list of the supplied usernames:

![image](https://user-images.githubusercontent.com/83407557/170169980-4d6e3962-b3ea-437d-835e-5d718a94a147.png)

While every request gets a 200 response, one response stands out as having a slighly different length, on further inspecting this response is sending a new error: "Incorrect Password"

![image](https://user-images.githubusercontent.com/83407557/170170539-cd6fbc7c-fee0-4c38-93be-463ecaa83684.png)


because this is diffent from the error I got from the other username: "Incorrect Username"

![image](https://user-images.githubusercontent.com/83407557/170170692-31450509-10a6-45df-bfc3-964ea5ae03f8.png)


This lets me know that the user "accounting" exists

# Step 3 Find accounting user's password

Sending the request that was for the accounting user back to intruder, I can build an almost identical sniper attack but this time using the supplied password list and targeting the password parameter of the post request.

![image](https://user-images.githubusercontent.com/83407557/170171858-6465abbb-17b1-46d4-8e0c-56fd64748e4d.png)

![image](https://user-images.githubusercontent.com/83407557/170171890-3bf6fb02-180d-4341-bea9-ad24a8077439.png)

one password "computer" returns a 302 redirect telling me that is the password:

![image](https://user-images.githubusercontent.com/83407557/170172318-147a5483-77a2-439f-9c6d-17991dc2d3a0.png)

# login as accounting

using the found username and password, I now can just use my browser to login and solve the lab:

![image](https://user-images.githubusercontent.com/83407557/170172480-7dd5d0f6-1810-4e5f-808d-3da863595f94.png)


