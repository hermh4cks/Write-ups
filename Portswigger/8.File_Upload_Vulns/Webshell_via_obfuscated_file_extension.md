# Lab: Web shell upload via obfuscated file extension

## Description 

 This lab contains a vulnerable image upload function. Certain file extensions are blacklisted, but this defense can be bypassed using a classic obfuscation technique.

To solve the lab, upload a basic PHP web shell, then use it to exfiltrate the contents of the file /home/carlos/secret. Submit this secret using the button provided in the lab banner.

You can log in to your own account using the following credentials: wiener:peter 

## Tips from Portswigger

### Obfuscating file extensions

Even the most exhaustive blacklists can potentially be bypassed using classic obfuscation techniques. Let's say the validation code is case sensitive and fails to recognize that exploit.pHp is in fact a .php file. If the code that subsequently maps the file extension to a MIME type is not case sensitive, this discrepancy allows you to sneak malicious PHP files past validation that may eventually be executed by the server.

You can also achieve similar results using the following techniques:

- Provide multiple extensions. Depending on the algorithm used to parse the filename, the following file may be interpreted as either a PHP file or JPG image: exploit.php.jpg
- Add trailing characters. Some components will strip or ignore trailing whitespaces, dots, and suchlike: exploit.php.
- Try using the URL encoding (or double URL encoding) for dots, forward slashes, and backward slashes. If the value isn't decoded when validating the file extension, but is later decoded server-side, this can also allow you to upload malicious files that would otherwise be blocked: exploit%2Ephp
- Add semicolons or URL-encoded null byte characters before the file extension. If validation is written in a high-level language like PHP or Java, but the server processes the file using lower-level functions in C/C++, for example, this can cause discrepancies in what is treated as the end of the filename: exploit.asp;.jpg or exploit.asp%00.jpg
- Try using multibyte unicode characters, which may be converted to null bytes and dots after unicode conversion or normalization. Sequences like xC0 x2E, xC4 xAE or xC0 xAE may be translated to x2E if the filename parsed as a UTF-8 string, but then converted to ASCII characters before being used in a path.

Other defenses involve stripping or replacing dangerous extensions to prevent the file from being executed. If this transformation isn't applied recursively, you can position the prohibited string in such a way that removing it still leaves behind a valid file extension. For example, consider what happens if you strip .php from the following filename:
```
exploit.p.phphp
```
This is just a small selection of the many ways it's possible to obfuscate file extensions. 

---

# Step 1 Map image upload funtionality

When trying to upload my sample nana.jpeg avatar image I get the following error

![image](https://user-images.githubusercontent.com/83407557/171216273-1a18d5d1-cd42-4706-a4dc-40d2f394f224.png)

Turning intercept on I resend the upload POST request, but change the name to nana.jpg.jpeg to see if that goes through

![image](https://user-images.githubusercontent.com/83407557/171216603-f43badd8-5035-44c7-96d7-662739dabda6.png)

but get the same error

![image](https://user-images.githubusercontent.com/83407557/171216703-743c0c88-4c25-4643-a82a-c3e439e39769.png)

trying the same thing but with nana.jpeg.jpg

![image](https://user-images.githubusercontent.com/83407557/171216990-c56aa73a-7cd6-4c8b-a8ef-6333c19c868c.png)

and it goes through

![image](https://user-images.githubusercontent.com/83407557/171217105-94b93224-dab2-4bd6-979c-9a2da1d60046.png)


# Step 2 upload a webshell with objuscated file extension:

I now know that my file has to end with .jpg or presumably .png. I will attempt to upload the following webshell to output carlos' secret:

```php
<?php echo file_get_contents('/home/carlos/secret'); ?>
```
![image](https://user-images.githubusercontent.com/83407557/171217661-0d8026bb-d19c-4833-9f26-dadd9af44141.png)


but change the name to get_secret.php.jpg in the request

![image](https://user-images.githubusercontent.com/83407557/171217714-3785b74f-82d9-4b04-af62-6276436f60ba.png)

and it apears to go through

![image](https://user-images.githubusercontent.com/83407557/171217844-0f9874d9-2b92-4f80-8aa9-47468a4a437c.png)

# Step 3 attempt to execute webshell on server

turning off intercept and going back to my account page I can see the directory listing for my avatar(php code)

![image](https://user-images.githubusercontent.com/83407557/171218049-ea34c948-76df-41c6-a0c9-9db9492136e0.png)

I can go there in my browser and have the php code execute server side, however this just returns an image

![image](https://user-images.githubusercontent.com/83407557/171218859-1bee9cee-cef6-4e13-b46d-73abe8cc730a.png)

# Step 4 Strip out the .jpg extension with a null byte character

I repeat step 2, but with an added null byte %00

![image](https://user-images.githubusercontent.com/83407557/171219476-21f4465e-940e-4e39-8d37-033045f10505.png)


With that I see the .jpg was stripped:

![image](https://user-images.githubusercontent.com/83407557/171219573-cc14dc5d-06e7-4c01-be30-219a7de34393.png)

# Step 5 execute webshell on sever

Going to the directory location /files/avatars/get_secret.php I see the code executes on the server and returns the secret:

![image](https://user-images.githubusercontent.com/83407557/171219848-2c332020-f6c0-4fac-9922-06fa2d1b1734.png)


# Step 6 Submit secret

![image](https://user-images.githubusercontent.com/83407557/171219969-71751d17-b2ad-4422-ac8d-dc96a2635d54.png)

![image](https://user-images.githubusercontent.com/83407557/171220040-103621d0-419d-4bcf-9981-d756fd5c43f6.png)
