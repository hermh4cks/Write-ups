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
# Step 1 map the image upload functionality

I verify I can load and image, and even a webshell; both request got responses, and I can see the directory listing for my file on my account page:

![image](https://user-images.githubusercontent.com/83407557/171196230-e8c2ad89-946a-47d6-b356-e1e3f1edce8a.png)

however, going to that url /files/avatars/get_secret.php, it does not execute the script, but instead output it on the screen:

![image](https://user-images.githubusercontent.com/83407557/171196544-6eb35be5-9927-47e7-b25d-ff0d6001efe8.png)

reviewing my POST request for uploading the webshell I see how it is creating the file on the server:

![image](https://user-images.githubusercontent.com/83407557/171197027-38f126df-7cf2-4655-acf9-ba82b2d3ff0a.png)


# Step 2 Use filename to make a directory traversal attack

while I cannot execute scripts in this /avatars/ directory, maybe I still may from /files/ or even the root directory. I will try them in turn, but intercepting my request and modifying the filename attribute and insert directory traversal sequences.

however, it seems that changing the name to ../get_secret.php, it gets stripped:

![image](https://user-images.githubusercontent.com/83407557/171199302-47d153b4-dedc-4405-9411-936d100bece7.png)

So I need to url encode it first in burp:

![image](https://user-images.githubusercontent.com/83407557/171200231-c864ca5c-43b7-40c3-afb2-240c32f5ab37.png)

then send the request to repeater and change the filename

![image](https://user-images.githubusercontent.com/83407557/171200952-1fd405a6-06e3-4ed1-b9cf-81a134697853.png)


# Step 3 See if /files/get_secret.php will execute

![image](https://user-images.githubusercontent.com/83407557/171201204-6703be61-5df9-4ad0-8805-60868ff25ef6.png)

# Step 4 Enter secret

![image](https://user-images.githubusercontent.com/83407557/171201306-5a7ac69e-52bc-48c3-a29c-00e720dc6cc7.png)

![image](https://user-images.githubusercontent.com/83407557/171201369-5c9fa8ba-6840-4472-b3fc-a97f554adc91.png)
