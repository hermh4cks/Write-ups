# Lab: Username enumeration via account lock

 This lab is vulnerable to username enumeration. It uses account locking, but this contains a logic flaw. To solve the lab, enumerate a valid username, brute-force this user's password, then access their account page.

+ [Candidate usernames](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/usernames)

+ [Candidate passwords](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/passwords)

# Walking the application

First thing I want to do is just manually interact with the webapp, in order to get a basic idea of how it is functioning. Specifically I want to test how authentication is being performed.

![image](https://user-images.githubusercontent.com/83407557/208713317-999cb8d5-9f9a-4ddd-971f-a32eddf98a14.png)

my first step is to see what happens if I try and login multiple times with an account that I know does not exist, I will do this by sending the login POST request for this login form to burp repeater, and then test a few passwords:

![image](https://user-images.githubusercontent.com/83407557/208715418-a7a6b7b0-6671-45cb-ae9c-c659a24080c3.png)

![image](https://user-images.githubusercontent.com/83407557/208715674-49e56728-ae72-4fc3-baeb-25a49b5adf40.png)

![image](https://user-images.githubusercontent.com/83407557/208715772-5a1d9f26-eced-4f9c-add6-088f4ec7e7f0.png)

![image](https://user-images.githubusercontent.com/83407557/208715873-b25dcfb9-d53b-46ff-b7aa-12d2d117fa70.png)

No matter how many bad passwords I send for a user that doesn't exist, I get the same response (the account doesn't lock because it is not a valid account):

![image](https://user-images.githubusercontent.com/83407557/208716080-83cee47c-7a99-4928-8c2a-c6fb4e148cf0.png)

## Locking an account on purpose

To do this I will send an intruder clusterbomb attack with my list of usernames and a null values for passwords (after my test password of testing123)

![image](https://user-images.githubusercontent.com/83407557/208727948-88c1027e-c604-4205-bce9-2ebc8d6e03f5.png)


Payload set 1 (usernames list)

![image](https://user-images.githubusercontent.com/83407557/208726922-4056512e-d10d-48d2-8e6f-f7c0ad27853b.png)

payload set 2 (null values being sent 5 times after each testing12 password)

![image](https://user-images.githubusercontent.com/83407557/208727106-763969c1-6af5-45ee-8ba2-61b539359172.png)

In the results I see that one account gets locked, this lets me know "at" is valid

## Finding a flaw in the lockout

I send one of these requests that got locked out back to repeater and create a sniper attack with the password field as the payload:

![image](https://user-images.githubusercontent.com/83407557/208728819-25ebbe66-c303-4340-887c-9f340b16e8ba.png)

I then add the passwords as the payload:

![image](https://user-images.githubusercontent.com/83407557/208729015-251a68d6-84ba-4717-bd52-14629461bb30.png)


and for payload options I create a grep extract for the lockout warning:

![image](https://user-images.githubusercontent.com/83407557/208729355-eaad7a43-3e52-4225-b6e7-754b04c1af4e.png)

One of the responses does not contain a warning:

![image](https://user-images.githubusercontent.com/83407557/208729521-275296c4-e6c0-4d14-bfc4-9660b572d028.png)

this tells me that there was no actual lockout, just a warning telling me I was locked out.

## Using at:654321 to login

With these found creds I solve the lab:

![image](https://user-images.githubusercontent.com/83407557/208729759-7f9a0dcb-8411-457f-960f-bccab46eba26.png)
