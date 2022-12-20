# Lab: Password brute-force via password change

 This lab's password change functionality makes it vulnerable to brute-force attacks. To solve the lab, use the list of candidate passwords to brute-force Carlos's account and access his "My account" page.

Your credentials: wiener:peter
Victim's username: carlos
[Candidate passwords](https://portswigger.net/web-security/authentication/auth-lab-passwords)


# Step 1 Walk the password change function

I see there is a change password feature once logged into the webapp

![image](https://user-images.githubusercontent.com/83407557/208775832-d04bf428-0f5f-4328-bdad-5c035e5fc941.png)

If I capture the post request to change the password, I see it is passed 4 parameters:

![image](https://user-images.githubusercontent.com/83407557/208776029-2e2c7c46-47a6-4352-bea1-602bb73a6fc7.png)

If I pass it along with a password I know is wrong I get logged out and sent back to the login page:

![image](https://user-images.githubusercontent.com/83407557/208776405-d2aa9bd1-a60f-4e83-88ae-d2100efa5c97.png)

If I try to simply brute force the password, even after 1 failed attempt I get locked out:

![image](https://user-images.githubusercontent.com/83407557/208776466-1a0bb735-09b8-49f2-96d3-57555056765d.png)

# Step 2 changing the new passwords to not match

If I send a known bad password with two mismatched new password:

![image](https://user-images.githubusercontent.com/83407557/208778554-086b9f86-ad1c-48bd-a8cb-5b84d9a24a48.png)

Instead of getting logged out, I get the following error msg:

![image](https://user-images.githubusercontent.com/83407557/208778655-1235d439-98f4-4424-86ec-6c44ed1a91ab.png)

However if I send the same request with a valid password:

![image](https://user-images.githubusercontent.com/83407557/208779006-c4a27954-10db-43e5-95a3-1cbc0c2b4e6e.png)

I get a different error msg:

![image](https://user-images.githubusercontent.com/83407557/208779085-3c036f82-1235-4fff-a39e-dc1ad9da9847.png)



# Step 3 build an intruder attack with mismatched passwords

I create an intruder attack with the username carlos, password as the payload and two diffent new passwords

![image](https://user-images.githubusercontent.com/83407557/208779297-310dbe26-3710-4d50-8168-0240779f1faa.png)

I use the provided passwords as the payload set

![image](https://user-images.githubusercontent.com/83407557/208779490-b08b3b17-8d5d-472f-81e1-f8e1214519de.png)

and I use a grep extract for the error msg:

![image](https://user-images.githubusercontent.com/83407557/208779635-91fb2e1e-be2b-4395-8ce8-e784bb9aba1e.png)

Launching the attack, a single password has a different error msg, telling me this is the password for carlos:

![image](https://user-images.githubusercontent.com/83407557/208779742-06b9aa7a-3fd1-4328-85c8-dfcc3f1992e0.png)


# Step 4 login as Carlos with the found password

![image](https://user-images.githubusercontent.com/83407557/208779867-ca1c5253-7c33-42fc-81c3-57b1245768ce.png)

Which solves the lab

![image](https://user-images.githubusercontent.com/83407557/208779961-799c0b70-89ab-4001-8f86-1d1684b9c5c6.png)
