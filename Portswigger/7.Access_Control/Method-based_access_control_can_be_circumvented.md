# Lab: Method-based access control can be circumvented

 This lab implements access controls based partly on the HTTP method of requests. You can familiarize yourself with the admin panel by logging in using the credentials administrator:admin.

To solve the lab, log in using the credentials wiener:peter and exploit the flawed access controls to promote yourself to become an administrator. 

# Step 1 login as administrator to see admin pannel

Since I was provided with admin credentials, I want to walk the application and account promotion functionality as admin before trying to do the same process as a non-admin user:

## admin pannel

First thing I see is that users are promoted from the admin panel at /admin with a POST request to /admin-roles

![image](https://user-images.githubusercontent.com/83407557/209963910-684fd1ad-3975-4fee-a505-17b51fe6e409.png)

Checking the POST request I see that there is a username and action parameter being passed:

![image](https://user-images.githubusercontent.com/83407557/209964004-9bbe6428-4541-4cd0-897f-0658218b97b2.png)

# Step 2 Logout and do the same with a normal user:

Checking if I can view the admin panel itself I get a 401 response and am blocked:

![image](https://user-images.githubusercontent.com/83407557/209964298-99e47cff-d501-4460-a1c6-363a70a21728.png)

If I try and go directly to the /admin-roles and make a POST request I see that I am also blocked:

![image](https://user-images.githubusercontent.com/83407557/209964540-c51621f0-2913-4659-a252-233287460434.png)

# Step 3 change request method

However, if I change the request method to GET, I find that I can bypass this block:

![image](https://user-images.githubusercontent.com/83407557/209964740-eddbf7c8-052f-4617-80f7-91605eaf5089.png)


This has successfully promoted me to admin, which I can check by going to the admin panel from my current session:

![image](https://user-images.githubusercontent.com/83407557/209964917-c7e24318-8bf7-46ef-a120-86c7a5e71109.png)

This solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209964978-9b1c0153-0bb4-4688-8a5b-e8724dae19a7.png)
