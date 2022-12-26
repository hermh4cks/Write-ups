# Lab: Information disclosure on debug page

This lab contains a debug page that discloses sensitive information about the application. To solve the lab, obtain and submit the SECRET_KEY environment variable. 

# Step 1 Walk the application

At first look, nothing seem very interesting about the application

![image](https://user-images.githubusercontent.com/83407557/209582851-6122b75d-cc43-4781-8bf1-7139a7ad94f3.png)

However looking at the site-map in the burp target tab, it seems that phpinfo could be leaked, this will contain env variables:

![image](https://user-images.githubusercontent.com/83407557/209582982-0ecf87c5-f067-46f6-90db-a4344abfd390.png)

# Step 2 inspect phpinfo.php

Going to phpinfo.php in my browser, I find that it is indeed accessable:

![image](https://user-images.githubusercontent.com/83407557/209583126-c38bfbd8-1ce9-4664-80a6-b59fbf58dbd8.png)

Using CTR-F to search the page, I find there is a value for SECRET_KEY:

![image](https://user-images.githubusercontent.com/83407557/209583171-55abc53a-cd8e-4581-9e44-2b22c89ac3dd.png)

# Step 3 submit SECRET_KEY

When I submit this value:

![image](https://user-images.githubusercontent.com/83407557/209583228-502563fe-3c89-4d9c-b0cf-bd57d7b0b396.png)

I am able to solve the lab:

![image](https://user-images.githubusercontent.com/83407557/209583251-cdf4681f-344a-4ecb-8dd3-2e2bb28a4e3f.png)
