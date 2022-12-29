# Lab: Multi-step process with no access control on one step

 This lab has an admin panel with a flawed multi-step process for changing a user's role. You can familiarize yourself with the admin panel by logging in using the credentials administrator:admin.

To solve the lab, log in using the credentials wiener:peter and exploit the flawed access controls to promote yourself to become an administrator. 

# Step 1 login as admin and walk the promotion process

Once in the admin panel I can upgrade users

![image](https://user-images.githubusercontent.com/83407557/209984539-67b44257-c47c-454d-9a09-f5cf5006ee2a.png)

![image](https://user-images.githubusercontent.com/83407557/209984802-44155a84-3499-48de-a76e-613d2f825e0f.png)


However first there is a confirmation page

![image](https://user-images.githubusercontent.com/83407557/209984589-96a79e25-e156-4999-8eaf-fa7fa65eabf5.png)

![image](https://user-images.githubusercontent.com/83407557/209984851-0c67b5a7-9e12-49c1-b191-d35925ae1360.png)


![image](https://user-images.githubusercontent.com/83407557/209984620-cd599566-7c4f-4fda-8632-cac19462e409.png)

# Step 2 login as a normal user and try to promote self

I find that I cannot access the admin pannel as a normal user:

![image](https://user-images.githubusercontent.com/83407557/209985057-e5dc2e81-e730-40fa-bf82-cff857b877a6.png)

I also am not authorized to make a POST request to upgrade a user:

![image](https://user-images.githubusercontent.com/83407557/209985303-fad41e30-7581-4a04-bf64-eb1a61ad5c70.png)

However if I add the confirmation parameter I can bypass the block:

![image](https://user-images.githubusercontent.com/83407557/209985454-772fb6e3-a835-40fa-98f5-c73e21d84011.png)

This promotes me to an admin and solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209985570-7f1840cf-3c5a-4e09-a48f-af4313dae7a2.png)
