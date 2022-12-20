# Lab: Password reset poisoning via middleware

This lab is vulnerable to password reset poisoning. The user carlos will carelessly click on any links in emails that he receives. To solve the lab, log in to Carlos's account. You can log in to your own account using the following credentials: wiener:peter. Any emails sent to this account can be read via the email client on the exploit server. 

# Step 1 Walk the application

Sending my own password reset request to burp

![image](https://user-images.githubusercontent.com/83407557/208763280-88830314-db73-4210-8563-dd1cb4ef3979.png)

I capture the request and send it to repeater:

![image](https://user-images.githubusercontent.com/83407557/208763511-1e591e2e-f3fa-4687-bab8-1c18e173b2a3.png)

# Checking for x-forwarded-host being enabled

First I take note of my own attack server url:

![image](https://user-images.githubusercontent.com/83407557/208764191-c0c06521-10ee-44ef-ba6d-16b5eed7bef7.png)

I then add this url in repeater with an x-forwarded-host header:

![image](https://user-images.githubusercontent.com/83407557/208764672-bb739c3b-8826-407d-96a3-e28645b2b56d.png)

Then I check the provided email client and click the link that was sent to me:

![image](https://user-images.githubusercontent.com/83407557/208764886-e87f53fe-34a1-4f79-9f20-d8a13867e004.png)

In my server logs I find that I captured my own reset token:

![image](https://user-images.githubusercontent.com/83407557/208765269-11bbd004-dac2-4dec-95a4-5357608db8c1.png)

# capturing target's reset token

Now that I know I can capture reset tokens, I will send a request to reset the carlos user's password to repeater:

![image](https://user-images.githubusercontent.com/83407557/208765664-958813ec-bb30-4033-aa2a-365da6404241.png)

And I will add the X-Forwarded-Host head to the request as I did for my own account

![image](https://user-images.githubusercontent.com/83407557/208765966-81f545e7-2bcf-4b03-a299-ab5a39690832.png)


In my logs I get the victem's reset token

![image](https://user-images.githubusercontent.com/83407557/208766342-abb98341-84d3-4381-baf9-6550d60bba2d.png)

# using reset token

Using the previous get request I had for resetting a password I will change the token to the one I captured in repeater and then open the response in a new browser window:

![image](https://user-images.githubusercontent.com/83407557/208768276-8def9526-a9b8-4321-89d7-2bc59825c76d.png)

![image](https://user-images.githubusercontent.com/83407557/208768392-9598ee5c-ce92-41bf-864b-3541672a2985.png)

![image](https://user-images.githubusercontent.com/83407557/208768197-954b0f71-6b87-46d8-b17f-85c26c65e93d.png)


Now I can reset the password for carlos, and use the new password to login:

![image](https://user-images.githubusercontent.com/83407557/208768665-7e061402-af56-42c4-acdb-d8e5874251d1.png)

which solves the lab

![image](https://user-images.githubusercontent.com/83407557/208768737-7ce93f47-1ffd-4b7a-9d7e-3a2baca9b565.png)

