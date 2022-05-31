# Lab: Web shell upload via path traversal

## Description 

 This lab contains a vulnerable image upload function. The server is configured to prevent execution of user-supplied files, but this restriction can be bypassed by exploiting a secondary vulnerability.

To solve the lab, upload a basic PHP web shell and use it to exfiltrate the contents of the file /home/carlos/secret. Submit this secret using the button provided in the lab banner.

You can log in to your own account using the following credentials: wiener:peter 

## Tip from directory traversal

 The sequence ../ is valid within a file path, and means to step up one level in the directory structure. The three consecutive ../ sequences step up from /var/www/images/ to the filesystem root, and so the file that is actually read is:
```
/etc/passwd
```
On Unix-based operating systems, this is a standard file containing details of the users that are registered on the server.

On Windows, both ../ and ..\ are valid directory traversal sequences, and an equivalent attack to retrieve a standard operating system file would be:
```
https://insecure-website.com/loadImage?filename=..\..\..\windows\win.ini
```
