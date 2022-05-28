# Lab: 2FA broken logic

## Description

 This lab's two-factor authentication is vulnerable due to its flawed logic. To solve the lab, access Carlos's account page.

 Your credentials: wiener:peter
 
 Victim's username: carlos

You also have access to the email server to receive your 2FA verification code.

## Hint

Carlos will not attempt to log in to the website himself.


# Step 1: Map the webapp

I will start by using the webapp as intended by a normal end user, only I will be capturing all of my traffic with a proxy. I do this in order to record and view my finding, as well as launch further attacks in the future. I will use the valid username and password while mapping the functionality of the app, but will also submit intentially incorrect information. This should give me a good starting point for where to go next.

# Step 2: Try and understand the app logic;

When I login as wiener:peter it sets a cookie to my username

![image](https://user-images.githubusercontent.com/83407557/170805989-eb1a621c-cabf-4c67-bcfb-cf1b1cfcdcac.png)

When I get to /login2 for the 2FA I have to submit these two cookies, and a successful 2FA pin.

![image](https://user-images.githubusercontent.com/83407557/170806107-4b82ee81-4e83-484f-8c1e-8a2413f36f0f.png)

I then get sent to my account.

# Step 3: Plan the attack

Whereas the last lab I was able to skip the pin step, this time because of the verify cookie being sent to /login2 perhaps /login1 can be bypassed. I can get a code to generate for carlos, it should be easy to then brute force as it is only 4 characters long. The other thing to keep in mind is the HINT, I think it is telling us that even if our attack takes a long time, the session cookie that we get should remain valid. Just a thought though.

# Step 4 Create a mfa code for the carlos user

I do this by sending my original get request to repeater and changing the wiener value to carlos.

![image](https://user-images.githubusercontent.com/83407557/170806440-8de8f7c8-7924-4c5b-ad12-fa08fd261d3e.png)

# Step 5 Login as wiener:peter with invalid mfa code to create an intruder attack

![image](https://user-images.githubusercontent.com/83407557/170806490-362177af-742b-47f5-bb73-8069394199d9.png)

before setting up payload positions, I change the wiener and session cookies to the ones I got from step 4. Then set the payload pos. to just the mfa code

![image](https://user-images.githubusercontent.com/83407557/170806618-218d4ed9-e3b8-4da0-bb16-86465bf173ab.png)

Then to create the payload we will create a brute-force with all possible 4 digit numbers.

![image](https://user-images.githubusercontent.com/83407557/170806790-a6e4cf54-246c-4d27-98f1-d6f2a61dc6d9.png)

Of the 10,000 requests, one response is the right 4 digit mfa code:

![image](https://user-images.githubusercontent.com/83407557/170834591-71cc6f3e-57af-469d-9ddf-260d7aecff16.png)

Right clicking and sending that response to my browser, I am now logged in as carlos and solve the lab.

![image](https://user-images.githubusercontent.com/83407557/170834619-8be4a708-6659-4a1f-8a02-0bd916dc0f18.png)

