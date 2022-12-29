# Lab: User ID controlled by request parameter, with unpredictable user IDs 

 This lab has a horizontal privilege escalation vulnerability on the user account page, but identifies users with GUIDs.

To solve the lab, find the GUID for carlos, then submit his API key as the solution.

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 login and walk the application

I want to login as wiener and then go through the process of view the http history with burp, I notice that trying to go to my-account after login an id parameter is passed:

![image](https://user-images.githubusercontent.com/83407557/209969264-33e6f9e4-7f3e-4ea0-8fe0-5854bece85ac.png)

This id seems way too long to brute-force, so I decide to check the rest of the application

# Step 2 view blog posts

I find that the first blog-post is written by carlos (my target)

![image](https://user-images.githubusercontent.com/83407557/209970241-48a8bc3b-cc19-4820-bf89-b9b3b2ceae74.png)

When I click on his username, I find that the user-id is leaked:

`c44aa987-7a3e-4f24-afbe-6600143f02c5`

![image](https://user-images.githubusercontent.com/83407557/209970316-93cd2a8c-eba2-42d4-bc61-2d9300f07417.png)


# Step 3 change user-id

I intercept the request to go to my account:

![image](https://user-images.githubusercontent.com/83407557/209970576-f3c05add-c2e9-4519-a332-cda7acbd228f.png)

and change the user-id to the one leaked for carlos:

![image](https://user-images.githubusercontent.com/83407557/209970735-e685d3de-34c2-4d8a-a67d-0cebe1f0f4c6.png)

When I forward the request I get to carlos' account page:

![image](https://user-images.githubusercontent.com/83407557/209970816-a480d4c8-8b71-4d2b-b666-30e365fa950d.png)

# Step 4 submit API key

I submit carlos' API key 

![image](https://user-images.githubusercontent.com/83407557/209970895-3c7cfd59-c0cb-4d54-96c1-580789b0c748.png)

Which solves the lab

![image](https://user-images.githubusercontent.com/83407557/209970949-6401e4bf-614a-4fb1-90c2-35c3e3494372.png)

