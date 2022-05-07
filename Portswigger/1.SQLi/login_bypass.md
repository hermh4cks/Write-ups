# Lab: SQL injection vulnerability allowing login bypass

## Description

*This lab contains an SQL injection vulnerability in the login function. To solve the lab, perform an SQL injection attack that logs in to the application as the administrator user. *

## Mapping the application

The application is an online shop, that is attatched to a backend database. This shop also has a session management feature that allows you to login, and presumably sets a cookie. There also seems to be an anti-CSRF token in place to defend against some attacks.

![image](https://user-images.githubusercontent.com/83407557/167275243-f602daee-95b1-4b71-98b0-37074966cb3d.png)

The login function.

![image](https://user-images.githubusercontent.com/83407557/167275273-a50df281-7a71-4ca0-b74e-66e9bb0c6726.png)

## Verifying a SQLi vuln

from the prompt I already know the username I am to be targeting: administrator. So to test for a vuln to bypass that password field I will enter that for the username. I will use a single quote to attempt to get an sql error from the server.

username: administrator

password: '

![image](https://user-images.githubusercontent.com/83407557/167275381-f20b2c02-f1e1-47cb-9be3-ec0ae2cb97e3.png)

## Exploiting SQLi to bypass login

This shows me that there is infact a potential sqli vuln in the server. Now all that I have to do to bypass the password field is comment out that section of the code using a comment (--) in sql.

username: administrator'--

password: anything

![image](https://user-images.githubusercontent.com/83407557/167275693-83aabd8b-ada4-4a8c-8f26-c267a80c6529.png)

![image](https://user-images.githubusercontent.com/83407557/167275700-225b5a40-947a-4330-a100-d9613fcef2f7.png)

# Why does this happen?

I do not need to know the admin password to bypass the login mechanism, for the sake of this example let's say the admin has the password of password123. This SQL query that the server uses to pull this name and password from the database will look something like this:

```sql
SELECT * FROM users WHERE username = 'admin' AND password = 'password123'
```

Since I can control what goes into the username and password fields via my post request, I can use a single quote to break the logic and throw a server error:

```sql
SELECT * FROM users WHERE username = 'admin'' AND password = 'password123'
```

Taking is a step further the comment in sql -- will just ignore the rest of the sql query (the password field) therefore I can enter anything as a password and still log in.

```sql
SELECT * FROM users WHERE username = 'admin'--' AND password = 'itdoesntmatter'
```
