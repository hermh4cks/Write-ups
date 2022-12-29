# Lab: User ID controlled by request parameter with data leakage in redirect

 This lab contains an access control vulnerability where sensitive information is leaked in the body of a redirect response.

To solve the lab, obtain the API key for the user carlos and submit it as the solution.

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 login and walk the application

I want to see what information gets leaked during the login process:

## login

![image](https://user-images.githubusercontent.com/83407557/209972233-134d7a29-a60f-4ed9-b9ff-221ca61ccf85.png)

![image](https://user-images.githubusercontent.com/83407557/209972279-cc05be26-aef0-4b8d-9b4a-c616908332d8.png)

## my-account


![image](https://user-images.githubusercontent.com/83407557/209972377-a27001ae-68bb-4276-9e8f-ca16391bc14a.png)

# Step 2 change username parameter

Since when I viewed my own account it passed my username as a parameter, I want to see what happens if I change my name to the target's name

![image](https://user-images.githubusercontent.com/83407557/209972587-0a62a47a-fdde-466e-85ba-a5186a32e383.png)

This just sends me back to the login

# Step 3 inspect the responses

Going back to see the response from the server before the redirects to the login page, I see that the target's home page and API key also gets sent first. I find this by doing the same as above but using repeater instead of intercept and forwarding:

![image](https://user-images.githubusercontent.com/83407557/209974181-b6a14990-28d1-472a-b7d6-bc2111e26c99.png)

# Step 4 Submit API key

I submit this found API key

![image](https://user-images.githubusercontent.com/83407557/209974268-bf80ba13-690a-422d-94e3-e76902e5b908.png)

which solves the lab

![image](https://user-images.githubusercontent.com/83407557/209974409-0dbf10f1-b779-4bd5-9ede-79a5cc6606bf.png)
