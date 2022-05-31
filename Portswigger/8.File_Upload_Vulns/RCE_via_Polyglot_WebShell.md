# Lab: Remote code execution via polyglot web shell upload

## Description

 This lab contains a vulnerable image upload function. Although it checks the contents of the file to verify that it is a genuine image, it is still possible to upload and execute server-side code.

To solve the lab, upload a basic PHP web shell, then use it to exfiltrate the contents of the file /home/carlos/secret. Submit this secret using the button provided in the lab banner.

You can log in to your own account using the following credentials: wiener:peter 

## Tip from portswigger

Flawed validation of the file's contents

Instead of implicitly trusting the Content-Type specified in a request, more secure servers try to verify that the contents of the file actually match what is expected.

In the case of an image upload function, the server might try to verify certain intrinsic properties of an image, such as its dimensions. If you try uploading a PHP script, for example, it won't have any dimensions at all. Therefore, the server can deduce that it can't possibly be an image, and reject the upload accordingly.

Similarly, certain file types may always contain a specific sequence of bytes in their header or footer. These can be used like a fingerprint or signature to determine whether the contents match the expected type. For example, JPEG files always begin with the bytes FF D8 FF.

This is a much more robust way of validating the file type, but even this isn't foolproof. Using special tools, such as ExifTool, it can be trivial to create a polyglot JPEG file containing malicious code within its metadata. 

## Man page for exiftool

On comments

![image](https://user-images.githubusercontent.com/83407557/171235222-c13c726f-73e0-4fde-a934-6ac54e016285.png)

On outputting to a new file

![image](https://user-images.githubusercontent.com/83407557/171235390-3415000e-5037-491e-8608-3ee7c7e6d07d.png)

# Step 1 Map out the normal functionality of the image upload

The functionality seems very similar to the previous labs, only none of the attacks that have worked so far are working here.

# Step 2 Create a polyglot using exiftool

Using it to view and unmodified nana.jpg

![image](https://user-images.githubusercontent.com/83407557/171236157-69dcb82e-4ba8-456c-8d74-737e8b22dc6e.png)

Adding a comment to insert my php code and outputting a new polyglot called nana.php

```bash
exiftool -Comment="<?php echo 'Executed Code--> ' . file_get_contents('/home/carlos/secret') . ' <--Executed Code'; ?>" nana.jpg -o nana.php
```
![image](https://user-images.githubusercontent.com/83407557/171237302-98de1d70-2d88-41f0-9707-7613b2dc9e08.png)

Running exiftool on this new file I can see that it has my code as a comment but is keeping the jpg extension and jpeg filetype.

![image](https://user-images.githubusercontent.com/83407557/171238960-1885e295-12aa-4fe4-a83d-f1ecbf8f224a.png)

# Step 3 upload polyglot

While trying to upload the php code normally I get this error

![image](https://user-images.githubusercontent.com/83407557/171241755-868945da-9909-41d4-aaf1-06d9156bfafc.png)

However, my polyglot uploads just fine

![image](https://user-images.githubusercontent.com/83407557/171242528-2d2fb372-0728-430b-934c-e66e9da706a9.png)

# Step 4 execute polyglot on server

Going to the directory /files/avatars/nana.php it still tries to load it as an image...however I can see the secret the response between my execturd code markers:

![image](https://user-images.githubusercontent.com/83407557/171244335-becb6382-a298-470c-b87e-b9741f85073a.png)

This tells me the code did execute on the server and highlighted above is the secret.

# Step 5 submit secret

![image](https://user-images.githubusercontent.com/83407557/171245275-a9d3364d-bbbf-424b-9b97-c45823c63e35.png)

![image](https://user-images.githubusercontent.com/83407557/171245489-00a7fe80-a349-4de2-8404-a9f183c4dcff.png)



