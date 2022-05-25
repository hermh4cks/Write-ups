# Lab: Username enumeration via subtly different responses

## Description

 This lab is subtly vulnerable to username enumeration and password brute-force attacks. It has an account with a predictable username and password, which can be found in the following wordlists:

 Candidate [usernames](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/usernames)
 
 Candidate [passwords](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/passwords)

To solve the lab, enumerate a valid username, brute-force this user's password, then access their account page.


# Step one: Walk the application

I want to see the normal funtions of the webapp, specifically the login funtion. I will do this while sending all my traffic through a web-proxy, in order to view and modify the resaults in the future.

![image](https://user-images.githubusercontent.com/83407557/170290184-ea67f07f-2ac6-4fb7-952d-8ca6b61b1440.png)

I then send a test name and password and view the response in burp

![image](https://user-images.githubusercontent.com/83407557/170290393-ab015e04-c2c5-4f2c-93f7-5c726c33535a.png)

![image](https://user-images.githubusercontent.com/83407557/170290622-cce5abc8-af45-423a-88f7-f8d00ebd9cc7.png)

# Step 2: attempt to enumerate usernames.

I will create a burp intruder attack, selecting just the username field from the above request, and then create a sniper attack payload comprised of the provided usernames.

![image](https://user-images.githubusercontent.com/83407557/170291461-a45dc796-ec5e-43c2-baa4-34389d0a5562.png)
![image](https://user-images.githubusercontent.com/83407557/170291690-b0cb8f9d-3f85-4fa9-9cca-2f7f672180b7.png)

To see if any response if different from the others, I will also set a grep-extract, to flag all responses containing that exact string:
(This should help show if there is an error with a subtle difference.

![image](https://user-images.githubusercontent.com/83407557/170293013-473f6711-9224-4a4b-b3aa-72db4a81874b.png)
