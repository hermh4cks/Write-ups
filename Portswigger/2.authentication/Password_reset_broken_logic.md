# Lab: Password reset broken logic

 This lab's password reset functionality is vulnerable. To solve the lab, reset Carlos's password then log in and access his "My account" page.

    Your credentials: wiener:peter
    Victim's username: carlos


# Step 1 Walking the application's password reset function

First thing I see is that there is a forgot password feature on the login page that is asking for an email.

![image](https://user-images.githubusercontent.com/83407557/208758085-44177522-477a-4c3f-a71f-73ee9781a388.png)

I see that is is asking for a username OR and email, I also see that the lab provides an email client

![image](https://user-images.githubusercontent.com/83407557/208758273-8d9d4cdd-a5f0-4774-8565-9d91016b77d5.png)

![image](https://user-images.githubusercontent.com/83407557/208758329-7a3060c0-0f97-4304-a7db-60233c9b8bce.png)

If I capture the request via burp for the password reset using the carlos username, I see that the POST request contains a username parameter

![image](https://user-images.githubusercontent.com/83407557/208758682-fa1ed1a1-245d-4ef3-9008-169d268cd122.png)

If I drop that request and resend it with my provided email I see the username field changes to my email:

![image](https://user-images.githubusercontent.com/83407557/208759104-98e40e33-920e-4f45-b9b9-2158d76c8a46.png)

When I check the email I see that I get a reset token:

![image](https://user-images.githubusercontent.com/83407557/208759384-877dd739-043d-40eb-b9d6-3d6d5a3d03d5.png)

Capturing the token request:

![image](https://user-images.githubusercontent.com/83407557/208759714-abfcf3db-9583-4d77-9e42-a3d3aecf4004.png)

it sends me to a reset form

![image](https://user-images.githubusercontent.com/83407557/208759993-9aa53aa5-d955-4605-9b7e-55d8d8b574fc.png)

# Step 2 change username in password reset form:

Seeing that my username is sent in the post request to reset the password, I capture that and send it to repeater:

![image](https://user-images.githubusercontent.com/83407557/208760146-5da2b03f-e03f-41aa-95c8-536c89f67e71.png)

I then change my username to the targets (carlos)

![image](https://user-images.githubusercontent.com/83407557/208760322-158332e4-309d-484d-970d-12e36c91b4d3.png)

# Step 3 login to carlos with the new password

Now that carlos' password has been restet, I can login to thier account:

![image](https://user-images.githubusercontent.com/83407557/208760551-10702fd8-b560-49a0-b8f2-b32d513c27de.png)

Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/208760620-ca00fef4-25d3-44da-8d0f-e5e8e88aff03.png)




