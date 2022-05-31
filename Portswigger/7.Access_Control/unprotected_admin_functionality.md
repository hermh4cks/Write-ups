# Lab: Unprotected admin functionality

## Description

 This lab has an unprotected admin panel.

Solve the lab by deleting the user carlos. 

# Step 1 Brute force directories

For this I will be using gobuster, but proxying through burp incase I need to use it later.

the command will be 

```
gobuster -u "url to brutefoce" -w "path-to-wordlist" -p "burp's proxy address"
```

