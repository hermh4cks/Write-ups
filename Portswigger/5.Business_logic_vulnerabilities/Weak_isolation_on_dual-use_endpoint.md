# Lab: Weak isolation on dual-use endpoint

 This lab makes a flawed assumption about the user's privilege level based on their input. As a result, you can exploit the logic of its account management features to gain access to arbitrary users' accounts. To solve the lab, access the administrator account and delete Carlos.

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 Walking the application

I want to pay special attention to how the webapp does account management.

## login

![image](https://user-images.githubusercontent.com/83407557/209443915-29fee478-e420-481c-bfa0-105b85b12723.png)

![image](https://user-images.githubusercontent.com/83407557/209443928-6e864223-f32e-455f-80cb-cad4014b1339.png)

## My account

![image](https://user-images.githubusercontent.com/83407557/209444047-106585a5-72c1-431c-ba59-f1bf172a4b9b.png)


![image](https://user-images.githubusercontent.com/83407557/209443960-3b528fb5-6936-4b58-a8fa-7498844a0219.png)

## Viewing blog posts:

![image](https://user-images.githubusercontent.com/83407557/209443983-382bdaae-ed5b-4b26-abac-a95e798443aa.png)



# Step 2 Check to see if I can bypass account page

Want to see what happens if I change my account name via that my account page

![image](https://user-images.githubusercontent.com/83407557/209444121-6a9b8bba-5818-49ea-9a75-2b0a613f25e6.png)

however this sends me back to the login page

![image](https://user-images.githubusercontent.com/83407557/209444133-751835b7-4546-4b46-8d27-92ae26d04c17.png)


# Step 3 See if I can update another user's password

If I capture the request to change my password, but change the username to administrator:

![image](https://user-images.githubusercontent.com/83407557/209444174-43c280a1-e9d4-490b-8828-6e13caa64731.png)

![image](https://user-images.githubusercontent.com/83407557/209444185-9493c17d-de03-4ba5-85a6-49e3f0718b50.png)

I get an error, but it also says that my username is now administrator:

![image](https://user-images.githubusercontent.com/83407557/209444228-d86a166e-a5aa-4173-994f-69ccfc5cc755.png)


# Step 4 try and change password with no username field

![image](https://user-images.githubusercontent.com/83407557/209444277-6c8d7f9e-c805-481a-afa5-2563bfd91876.png)

removed username parameter:

![image](https://user-images.githubusercontent.com/83407557/209444295-f1404fbc-2555-4639-9ef1-c49ff877fd16.png)

I get an error

![image](https://user-images.githubusercontent.com/83407557/209444300-eb8fca69-3777-42b2-9cfb-5bd5b394b86a.png)

# Step 5 try and change password with 2 username fields:

adding another username:

![image](https://user-images.githubusercontent.com/83407557/209444338-5c7c0182-80e2-4043-9e9d-0f85b7632d6e.png)

![image](https://user-images.githubusercontent.com/83407557/209444355-d5ba4273-13cd-41d2-b85f-592b1b153df6.png)

Trying with a different order:

![image](https://user-images.githubusercontent.com/83407557/209444365-9ae0310a-b5a1-49f2-b8cc-bb9beed354a4.png)

The error goes away

![image](https://user-images.githubusercontent.com/83407557/209444370-a7ca8a59-1fd1-4872-9a28-3b9b108643d4.png)

# Step 6 see if administrator password is also changed

![image](https://user-images.githubusercontent.com/83407557/209444411-bb62ad29-7a68-4268-897c-6009e793d757.png)

![image](https://user-images.githubusercontent.com/83407557/209444423-e674f9ad-4d6d-4684-b28a-74351cc4c7b2.png)

# Step 7 try and change password with no password field

Since I can control which username the password reset is aimed at, what happens if I try and remove the current password field:

![image](https://user-images.githubusercontent.com/83407557/209444539-e14d7276-d459-4cfd-8055-666cb36b2ff3.png)

removing current password:

![image](https://user-images.githubusercontent.com/83407557/209444552-82053f3f-a640-41e8-aee6-43f804d70846.png)

It says that the password was changed!

![image](https://user-images.githubusercontent.com/83407557/209444572-14e18e50-c2d5-46fd-976d-f332243304ba.png)

# Step 8 try and login as administrator with the new password

![image](https://user-images.githubusercontent.com/83407557/209444598-c1dd1c80-8ff9-4bee-8433-931e3cd81e0e.png)

I log in and see that there is a new menu option:

![image](https://user-images.githubusercontent.com/83407557/209444617-5c517eab-db39-4b01-8fc2-be2bcc82abe4.png)

# Step 9 Use admin pannel to delete carlos:

![image](https://user-images.githubusercontent.com/83407557/209444628-68002499-a0d4-46a8-b0cf-8c25d01cdea2.png)

Which solves the lab

![image](https://user-images.githubusercontent.com/83407557/209444647-377620ec-f106-4101-8723-1f8f7eb3ff68.png)
