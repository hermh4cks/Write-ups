# Lab: 2FA simple bypass

## Description

This lab's two-factor authentication can be bypassed. You have already obtained a valid username and password, but do not have access to the user's 2FA verification code. To solve the lab, access Carlos's account page.


Your credentials: **wiener**:**peter**

Victim's credentials **carlos**:**montoya**

# Step 1: Mapping the application

Using burp as a proxy, I go through the normal function of a login using my supplied username. I also use the provided email client, in order to recieve the pin needed for the 2FA.

From this I begin to build a mental picture of how authentication works for this particular webapp:

1. A correct username and password are provided by my browser, creating a session and generating a cookie, and a secret pin tied to that session on the server.
This is a post request to /login(1)

![image](https://user-images.githubusercontent.com/83407557/170764507-f74139e7-4dc5-4964-8c9b-d371854bae20.png)



2. The cookie is sent to my browser and the pin is emailed to the email I have set in my account settings; I am redirected to /login2

![image](https://user-images.githubusercontent.com/83407557/170764930-25be82ce-a98d-4937-844b-dd7f10977710.png)


3. I need to enter a pin
This is a post request to /login2
![image](https://user-images.githubusercontent.com/83407557/170764857-4ba10cd9-a63b-4b51-9c80-88014d34e7c8.png)


4. (If the pin I enter is right) I am redirected to /my-account

![image](https://user-images.githubusercontent.com/83407557/170764386-dbee0dec-e3fa-4127-8ad8-421e7c049858.png)


4. (If the pin I enter is WRONG) I am sent to a 200 response with an error message:

![image](https://user-images.githubusercontent.com/83407557/170764806-0c02e3c5-723c-4aac-a8b9-3edce684621d.png)

# Step 2: Plan the attack.

so to simplify the above

passing 2FA
/login1 -> /login2 -> /my-account

Failing 2FA
/login1 -> /login2 -> /login2

My hopes are that once I pass step one, a valid session is created. If this is true I may be able to bypass step 3 completely. By completing the first step of login of the webapp with the carlos username, instead of entering any pin at the second, I just send a get request for /my-account. This should login as the carlos user, they were actually logged in as soon as they passed stage 1.

# Step 3. Bypass 2FA

1. Enter the carlos username and montoya password (can be done normally in browser)

![image](https://user-images.githubusercontent.com/83407557/170766328-3c950afe-adc8-46ef-9908-9a96713dbbd3.png)

![image](https://user-images.githubusercontent.com/83407557/170766880-c1e8129a-f3c8-46ed-a6b7-717ddfcce942.png)


2. in browser delete /login2 and instead go to /my-account 

![image](https://user-images.githubusercontent.com/83407557/170766951-c45e81f9-a563-4aa2-8584-211d85e400f5.png)

![image](https://user-images.githubusercontent.com/83407557/170766991-0e958664-6cc2-4403-a7e0-9c5f0f1ca5ed.png)
