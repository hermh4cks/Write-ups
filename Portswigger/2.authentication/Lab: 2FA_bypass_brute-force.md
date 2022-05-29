# Lab: 2FA bypass using a brute-force attack

## Description

This lab's two-factor authentication is vulnerable to brute-forcing. You have already obtained a valid username and password, but do not have access to the user's 2FA verification code. To solve the lab, brute-force the 2FA code and access Carlos's account page.

Victim's credentials: carlos:montoya

## HINT

You will need to use Burp macros in conjunction with Burp Intruder to solve this lab. For more information about macros, please refer to the Burp Suite documentation. Users proficient in Python might prefer to use the Turbo Intruder extension, which is available from the BApp store.

# Step 1: Map the 2FA functionality of the webapp

Unlike the last lab, after the second failed attempt to log into the 2FA pin we are logged out altogether.

![image](https://user-images.githubusercontent.com/83407557/170842722-84636989-5044-479b-be3f-21dd4fb73d3f.png)

# Step 2: Set up a burp macro

I want to almost mirror the pin brute force from the last lab, but I need it to log me back into carlos for every failed attempt. To do this I create a session handling macro in burp

![image](https://user-images.githubusercontent.com/83407557/170842962-205b5eb8-40b8-4d7a-ab6a-0ef68324727d.png)

testing macro

![image](https://user-images.githubusercontent.com/83407557/170843368-c1658dd8-28f8-4274-a5e7-3cbd544c017e.png)


# Step 3: brute force pin

With the macro set, I can now just send login 2 to intruder and bruteforce the pin, knowing I will be logged back into carlos each time I fail once (therefore not resetting the mfa pin)

![image](https://user-images.githubusercontent.com/83407557/170843032-c757e4d8-c522-4309-80ef-daf9a56d8341.png)

Running the defult 10 threads caused a lot of network error, so in order to get the 200 responses I needed I also needed to change my threads down to 1. Slower but needed.
![image](https://user-images.githubusercontent.com/83407557/170843551-f89577c1-015d-443b-93ef-3cb1f7bb7064.png)

I can then view the results, and pick out the 302 response

![image](https://user-images.githubusercontent.com/83407557/170849695-f66b1040-ccfb-4fbd-8f31-ac6c02c9cf4f.png)


and open that response in my browser

![image](https://user-images.githubusercontent.com/83407557/170849702-a1d767b2-6026-4532-a2dc-0da34c983fcf.png)

