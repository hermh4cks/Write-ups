# Lab: Unprotected admin functionality with unpredictable URL

 This lab has an unprotected admin panel. It's located at an unpredictable location, but the location is disclosed somewhere in the application.

Solve the lab by accessing the admin panel, and using it to delete the user carlos. 

# Step 1 walk the app and view the source

Viewing the source code for the appliaction I see there is a href for the admin pannel:

![image](https://user-images.githubusercontent.com/83407557/209694072-96cd8236-071d-4199-ba27-caca33f40de1.png)


# Step 2 go to admin pannel

Seeing that `/admin-csg7y2` was leaked I go there and to try and access the pannel:

![image](https://user-images.githubusercontent.com/83407557/209694208-d0e0f885-543b-485c-afbc-b1de5693f52f.png)

Finding the admin pannel unprotected, I delete carlos and solve the lab:

![image](https://user-images.githubusercontent.com/83407557/209694260-be45363c-74bd-4785-aab4-14c74599ffc3.png)
