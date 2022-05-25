# Lab: Username enumeration via response timing

## Description 

This lab is vulnerable to username enumeration and password brute-force attacks. It has an account with a predictable username and password, which can be found in the following wordlists:
 
 
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
