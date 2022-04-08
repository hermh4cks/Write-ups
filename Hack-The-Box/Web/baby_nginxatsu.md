# baby nginxatsu write-up | By Herman Detwiler

Baby nginxatsu is an easy box on Hack the Box, and can be found on the OWASP top 10 track. We are given the following description and address:

*Can you find a way to login as the administrator of the website and free nginxatsu?*

`134.209.28.38:31584`

As always I am going to begin the cyclical process of gathering as much information as possible using both manual and automated techniques. To start I will run an nmap scan of the target while viewing the webapp in my browser as would be intented by a normal user.

# Recon

## Nmap scan

```bash
PORT      STATE SERVICE VERSION
31584/tcp open  http    nginx
| http-title: nginxatsu
|_Requested resource was http://134.209.28.38:31584/auth/login

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 22.14 seconds
```

## Webapp

![image](https://user-images.githubusercontent.com/83407557/162471346-81e2cb5c-81c5-4aba-8b25-f6de02f81f65.png)

### Hidden token value on page

![image](https://user-images.githubusercontent.com/83407557/162471950-03a5cf10-c339-4b8d-b7a6-41671cf3ce06.png)

### User creation page

![image](https://user-images.githubusercontent.com/83407557/162472843-c049297a-c992-4a00-92e3-99b40f89893f.png)
