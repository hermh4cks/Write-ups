# Lab: User ID controlled by request parameter

 This lab has a horizontal privilege escalation vulnerability on the user account page.

To solve the lab, obtain the API key for the user carlos and submit it as the solution.

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 Walk the application

I want to login and see what functionality is in my account page and see that my username is passed as a parameter

![image](https://user-images.githubusercontent.com/83407557/209966631-44913a8d-71a1-4171-94b3-ea9859a49c63.png)

I see that my API key is displayed on my page

![image](https://user-images.githubusercontent.com/83407557/209966810-67002981-f890-47e3-b69b-18d80e646410.png)


# Step 2 change username parameter to carlos

If I capture my request to /my-account but change the user id to carlos:

![image](https://user-images.githubusercontent.com/83407557/209966945-5fb0078f-621e-45dd-9c6a-76d09ada70c5.png)

when I forward that request I get to carlos' page instead of getting logged out

![image](https://user-images.githubusercontent.com/83407557/209967042-eb993f17-543f-42e9-b98b-89ded27fe393.png)

# Step 3 submit API key

![image](https://user-images.githubusercontent.com/83407557/209967492-db64776e-a511-4fb7-a7ab-d74cdae8951f.png)

Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209967540-b311c44c-4b44-4423-9670-3c9cb9fddca4.png)
