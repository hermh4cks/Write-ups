# Lab: Username enumeration via subtly different responses

## Description

 This lab is subtly vulnerable to username enumeration and password brute-force attacks. It has an account with a predictable username and password, which can be found in the following wordlists:

 Candidate [usernames](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/usernames)
 
 Candidate [passwords](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/passwords)

To solve the lab, enumerate a valid username, brute-force this user's password, then access their account page.


# Step one: Walk the application

I want to see the normal funtions of the webapp, specifically the login funtion. I will do this while sending all my traffic through a web-proxy, in order to view and modify the resaults in the future.

![image](https://user-images.githubusercontent.com/83407557/170290184-ea67f07f-2ac6-4fb7-952d-8ca6b61b1440.png)

I then send a test name and password and view the response in burp

![image](https://user-images.githubusercontent.com/83407557/170290393-ab015e04-c2c5-4f2c-93f7-5c726c33535a.png)

![image](https://user-images.githubusercontent.com/83407557/170290622-cce5abc8-af45-423a-88f7-f8d00ebd9cc7.png)

# Step 2: attempt to enumerate usernames.

I will create a burp intruder attack, selecting just the username field from the above request, and then create a sniper attack payload comprised of the provided usernames.

![image](https://user-images.githubusercontent.com/83407557/170291461-a45dc796-ec5e-43c2-baa4-34389d0a5562.png)
![image](https://user-images.githubusercontent.com/83407557/170291690-b0cb8f9d-3f85-4fa9-9cca-2f7f672180b7.png)

To see if any response if different from the others, I will also set a grep-extract, to flag all responses containing that exact string:
(This should help show if there is an error with a subtle difference.

![image](https://user-images.githubusercontent.com/83407557/170293013-473f6711-9224-4a4b-b3aa-72db4a81874b.png)

As can be seen from the attack results, every name returned a 200 response AND also had variable length; so neither can be used to flush out a valid username. However with the grep-extract flag that I had set I see that one response is missing the period ( a typo by the app dev)

![image](https://user-images.githubusercontent.com/83407557/170295451-e0870e5c-817d-46be-b2b9-9a0c9937066d.png)

With this I can now brute force the aq user's password:

# Step 3: Brute force password

I will send the request that had a sublty different response back to intruder to set up another attack.

This time I will select the password field and use the provided password list, leaving the aq user at is

![image](https://user-images.githubusercontent.com/83407557/170295852-387e0eae-97d8-464d-b0ec-574e4f7cab41.png)

![image](https://user-images.githubusercontent.com/83407557/170296041-bd49c0f4-ac6b-44af-904e-c8be26c5c63d.png)

This time, one of the responses is a 302 instead of a 200, letting me know the password is hockey

![image](https://user-images.githubusercontent.com/83407557/170296611-1e25a834-f9ea-45cd-8804-70b52d322c34.png)


# Step 4 login as aq with password hockey

![image](https://user-images.githubusercontent.com/83407557/170296756-b1e9f330-622a-4b2d-9353-d2595aa5d764.png)


