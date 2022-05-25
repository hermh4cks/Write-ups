# Lab: Username enumeration via subtly different responses

## Description

 This lab is subtly vulnerable to username enumeration and password brute-force attacks. It has an account with a predictable username and password, which can be found in the following wordlists:

 Candidate [usernames](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/usernames)
 
 Candidate [passwords](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/passwords)

To solve the lab, enumerate a valid username, brute-force this user's password, then access their account page.


# Step one: Walk the application

I want to see the normal funtions of the webapp, specifically the login funtion. I will do this while sending all my traffic through a web-proxy, in order to view and modify the resaults in the future.

