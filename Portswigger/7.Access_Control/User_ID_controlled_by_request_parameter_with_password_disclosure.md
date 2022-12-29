# Lab: User ID controlled by request parameter with password disclosure

 This lab has user account page that contains the current user's existing password, prefilled in a masked input.

To solve the lab, retrieve the administrator's password, then use it to delete carlos.

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 login and walk the application

I want to see how I am identified and where my password is displayed. I see that my password can be seen in the server response:

![image](https://user-images.githubusercontent.com/83407557/209976494-d43014c9-995c-4503-84fb-532fcf45d72f.png)

And that my username is passed as a parameter when going to /my-account

![image](https://user-images.githubusercontent.com/83407557/209976645-60917efc-d312-488a-9c59-c8dbcae88e25.png)

# Step 2 change username parameter

I want to send the request to repeater and change the username, and find that I can leak the admin's password:

![image](https://user-images.githubusercontent.com/83407557/209976855-7f248f06-43b2-4471-8ccb-39d22ec2fdc4.png)

# Step 3 login as admin and delete carlos:

I use the found password to login:

![image](https://user-images.githubusercontent.com/83407557/209976972-9d097c5c-b5e3-4e73-9c0e-bdc1fc49feba.png)

![image](https://user-images.githubusercontent.com/83407557/209977033-ac0d1a09-4e17-4d03-9a27-4d72e9aa3492.png)

I go to the admin panel:

![image](https://user-images.githubusercontent.com/83407557/209977103-d06e5851-cf07-4515-aa86-c7aba0a10887.png)

And deleting carlos solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209977154-aee5edcf-5d97-4c67-bc96-fbc6a45c2528.png)

