# Lab: SQL injection vulnerability allowing login bypass

## Description

*This lab contains an SQL injection vulnerability in the login function. To solve the lab, perform an SQL injection attack that logs in to the application as the administrator user. *

## Mapping the application

The application is an online shop, that is attatched to a backend database. This shop also has a session management feature that allows you to login, and presumably sets a cookie. There also seems to be an anti-CSRF token in place to defend against some attacks.

![image](https://user-images.githubusercontent.com/83407557/167275243-f602daee-95b1-4b71-98b0-37074966cb3d.png)

The login function.

![image](https://user-images.githubusercontent.com/83407557/167275273-a50df281-7a71-4ca0-b74e-66e9bb0c6726.png)
