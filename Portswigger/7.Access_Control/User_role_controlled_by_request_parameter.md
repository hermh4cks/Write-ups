# Lab: User role controlled by request parameter

 This lab has an admin panel at /admin, which identifies administrators using a forgeable cookie.

Solve the lab by accessing the admin panel and using it to delete the user carlos.

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 Login an walk the app

I login

![image](https://user-images.githubusercontent.com/83407557/209694960-3c2ef78c-ed19-4a3a-a173-7cd43be45e03.png)

And see that I have a cookie called Admin=false

![image](https://user-images.githubusercontent.com/83407557/209695139-3c61b7b1-3a4a-49d5-959b-0139629974fe.png)


And try and go to the admin pannel at /admin

![image](https://user-images.githubusercontent.com/83407557/209695210-6afc541e-f720-4b3a-a1a9-f95c19c200ce.png)

![image](https://user-images.githubusercontent.com/83407557/209695260-d4c27f90-35ff-46f8-9aa5-a267f6b95daa.png)

# Step 2 modify Admin=false cookie

I try and goto the pannel again, but change the cookie to Admin=True

![image](https://user-images.githubusercontent.com/83407557/209695360-649e2b03-bd7e-40ed-a68c-d80b87494280.png)

And get access to the admin pannel

![image](https://user-images.githubusercontent.com/83407557/209695423-fe302d75-d7f6-4a8c-b90b-7cf23b96fc2b.png)

# Step 3 delete carlos

I make sure to capture the request and change the cookie again:

![image](https://user-images.githubusercontent.com/83407557/209695508-d670742f-1e87-415f-a942-9389412a5e77.png)

And doing so solves the lab

![image](https://user-images.githubusercontent.com/83407557/209695570-b6439804-ce84-4cab-b92b-5cfefa53e7c7.png)
