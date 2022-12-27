# Lab: User role can be modified in user profile

 This lab has an admin panel at /admin. It's only accessible to logged-in users with a roleid of 2.

Solve the lab by accessing the admin panel and using it to delete the user carlos.

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 Login and find the roleid

I login with the username and password given to me for testing:

![image](https://user-images.githubusercontent.com/83407557/209713955-2f172083-b330-4def-93d8-0f5f954d353f.png)

I see that I can update my email:

![image](https://user-images.githubusercontent.com/83407557/209714160-38c60b25-72bc-4ee3-9340-d0a16f874620.png)

# Step 2 seeing if having a localhost email bypasses filter

![image](https://user-images.githubusercontent.com/83407557/209714812-a51b7e40-17e0-4ac1-a368-b0fde60a81f1.png)

While I cannot access the /admin, the respones to changing email shows my role ID:

![image](https://user-images.githubusercontent.com/83407557/209715172-44227346-83b6-4665-87a7-7558207ab2e7.png)

# Step 3 add json to change roleid when I change my email

I change my email again, and capture the request:

![image](https://user-images.githubusercontent.com/83407557/209715298-6b2a28b1-ecf6-45fd-a191-0905939849b6.png)

I add rolid and change it to 2

![image](https://user-images.githubusercontent.com/83407557/209715407-4cc20d35-2c5f-4a72-83bb-bca097ef44d7.png)

Checking the response, I see that my roleid was also changed:

![image](https://user-images.githubusercontent.com/83407557/209715495-cda12150-9abb-459f-96ae-75ee4c632279.png)


# Step 4 access /admin with new role

I find that with roleid set to 2 I can get to the admin pannel:

![image](https://user-images.githubusercontent.com/83407557/209715607-71a40d4b-0837-4abc-adf8-100d82e74466.png)


# Step 5 delete carlos

![image](https://user-images.githubusercontent.com/83407557/209715642-9b9452f3-ad81-46ed-8037-c37900f5101b.png)

Which solves the lab

![image](https://user-images.githubusercontent.com/83407557/209715696-09616e5f-3de1-46bb-be8c-e45749bf1e71.png)


