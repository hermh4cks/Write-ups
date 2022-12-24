# Lab: Authentication bypass via flawed state machine

 This lab makes flawed assumptions about the sequence of events in the login process. To solve the lab, exploit this flaw to bypass the lab's authentication, access the admin interface, and delete Carlos.

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 Walk the application

I want to pay close attention to the login process

## Logging in as wiener

![image](https://user-images.githubusercontent.com/83407557/209447567-2e521777-de9c-4856-bb35-e7f3b652ffdd.png)

next it sends me to a role-selector

![image](https://user-images.githubusercontent.com/83407557/209447578-1b105de8-ddbc-4fa3-8176-26799574812f.png)

This has a drop-down with two options

![image](https://user-images.githubusercontent.com/83407557/209447597-24c1a43f-ff1d-4f55-8e7b-d1a547c0c3a7.png)

![image](https://user-images.githubusercontent.com/83407557/209447607-4314f289-8348-4733-b5d6-67260ab54737.png)

## Trying to get to admin interface:

![image](https://user-images.githubusercontent.com/83407557/209447635-fd707ebc-b898-4f2f-ac91-36c38fcd928f.png)

# Step 2

Try to go to role-selection without logging in

First I capture the login page to create a session cookie:

![image](https://user-images.githubusercontent.com/83407557/209447665-5100688e-f12b-4036-a21c-17c5cb89505c.png)

Then I go to the HTTP history and send my previous request for /role-selector to repeater

![image](https://user-images.githubusercontent.com/83407557/209447703-08b3960b-3d6b-4f61-950d-bd811af4ab63.png)

In the repeater tab I change out the session cookie:

![image](https://user-images.githubusercontent.com/83407557/209447730-18ada874-988c-4499-ac94-28182465dd39.png)

I then open the response in the browser:

![image](https://user-images.githubusercontent.com/83407557/209447745-4b415ecd-7ad6-49ad-8657-7611f356ca61.png)

I select the content author role

![image](https://user-images.githubusercontent.com/83407557/209447767-c0c94433-b372-4a95-98c0-d6ef1ff14943.png)

but get the following error:

![image](https://user-images.githubusercontent.com/83407557/209447778-1c9c6499-371b-4029-81bf-39fe409be7e3.png)

# Step 3 Try and login normally but make a new role:

![image](https://user-images.githubusercontent.com/83407557/209447816-adbd4f9f-c2e6-4ed2-baad-6cdd7d065691.png)

![image](https://user-images.githubusercontent.com/83407557/209447834-b14fddba-3261-4631-85da-dfd5cc3548ab.png)

I change user to an option that wasn't available in the dropdown (administrator)

![image](https://user-images.githubusercontent.com/83407557/209447848-d8172be9-1f3a-4857-90c2-a7e4b560081b.png)

# Step 4 Try and drop the role-selection request

Instead of changing the role selection, I will intercept and drop it

## login

![image](https://user-images.githubusercontent.com/83407557/209447912-4add7171-740e-4fa8-aac9-74c02e8874e0.png)

## Drop the role-selector

![image](https://user-images.githubusercontent.com/83407557/209447927-e7180d36-92ef-47dc-b0e9-34c0cc279fcf.png)

## go to /admin after the role-selector request was dropped

![image](https://user-images.githubusercontent.com/83407557/209447949-749a2905-1af4-4d7f-a2ed-cbf949ae4c82.png)

And I am now in the admin pannel

![image](https://user-images.githubusercontent.com/83407557/209447959-1e50f6f0-5a45-42fd-ac62-91f9a07693e8.png)


# Step 5 delete carlos

I delete the carlos account using the admin pannel, and solve the lab:

![image](https://user-images.githubusercontent.com/83407557/209447978-d5c94f71-ed41-40ce-9d63-09f384afb067.png)
