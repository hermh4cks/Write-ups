# Lab: Web shell upload via Content-Type restriction bypass

## Description

 This lab contains a vulnerable image upload function. It attempts to prevent users from uploading unexpected file types, but relies on checking user-controllable input to verify this.

To solve the lab, upload a basic PHP web shell and use it to exfiltrate the contents of the file */home/carlos/secret*. Submit this secret using the button provided in the lab banner.

You can log in to your own account using the following credentials: *wiener:peter*

## Tips from Portswigger

 When submitting HTML forms, the browser typically sends the provided data in a POST request with the content type application/x-www-form-url-encoded. This is fine for sending simple text like your name, address, and so on, but is not suitable for sending large amounts of binary data, such as an entire image file or a PDF document. In this case, the content type multipart/form-data is the preferred approach.

Consider a form containing fields for uploading an image, providing a description of it, and entering your username. Submitting such a form might result in a request that looks something like this: 

```
POST /images HTTP/1.1
Host: normal-website.com
Content-Length: 12345
Content-Type: multipart/form-data; boundary=---------------------------012345678901234567890123456

---------------------------012345678901234567890123456
Content-Disposition: form-data; name="image"; filename="example.jpg"
Content-Type: image/jpeg

[...binary content of example.jpg...]

---------------------------012345678901234567890123456
Content-Disposition: form-data; name="description"

This is an interesting description of my image.

---------------------------012345678901234567890123456
Content-Disposition: form-data; name="username"

wiener
---------------------------012345678901234567890123456--
```

With this in mind, I should keep an eye out for a post request like this while mapping the application.

# Step 1 Mapping the image upload functionality.

I see that I can post an image to the server much like I could in the last lab. And I can see where the server is saving my file.

![image](https://user-images.githubusercontent.com/83407557/171187206-bff8ff4e-aa00-41da-a774-b26c42134adf.png)

Also the post request looks much like the one in the portswigger tip example. With the multipart/form-data and content-type headers.

![image](https://user-images.githubusercontent.com/83407557/171187078-de64a9f0-cb3a-4001-ad65-e51b83945640.png)

# Step 2 Attempt to upload the same webshell as last lab
get_secret.php
```php
<?php echo file_get_contents('/home/carlos/secret'); ?>
```


Trying to upload my get_secret.php, I get the following error:

![image](https://user-images.githubusercontent.com/83407557/171187609-2ef13ac6-9b3b-46c7-bbc0-ef40f0bbf4bd.png)

I can see the content-type in my request is indeed changed.

![image](https://user-images.githubusercontent.com/83407557/171188150-96b685b0-f755-43b2-bb04-946feadaec95.png)


# Step 3 intercept request and change value before sending to sever.

I am going to re-attempt to submit my get_secret.php, however this time I will turn burp's intercept on first.

![image](https://user-images.githubusercontent.com/83407557/171188509-405fd3af-6d6a-4c40-abed-4607b81abf97.png)

I get the request and change the content-type to image/jpeg

![image](https://user-images.githubusercontent.com/83407557/171188841-591e0189-d75c-4c31-a8e2-d62c0afb7c5d.png)


And do not get the same error

![image](https://user-images.githubusercontent.com/83407557/171188918-1c2ea0f9-100b-4804-8901-6c30ab5f3487.png)

# Step 4 Execute websell on server

I already know the directory structure from step 1, so now I just have to turn intercept back off, and go to /files/avatars/get_secret.php

![image](https://user-images.githubusercontent.com/83407557/171189194-7a016b33-d77a-4073-aa67-efd0b7466dfe.png)

# Step 5 Submit secret

![image](https://user-images.githubusercontent.com/83407557/171189356-bda44624-db58-4490-83a9-71a458479b22.png)

![image](https://user-images.githubusercontent.com/83407557/171189433-f581759f-3599-43f6-bafb-d6d379731fa1.png)

