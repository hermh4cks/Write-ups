# Lab: Referer-based access control

 This lab controls access to certain admin functionality based on the Referer header. You can familiarize yourself with the admin panel by logging in using the credentials administrator:admin.

To solve the lab, log in using the credentials wiener:peter and exploit the flawed access controls to promote yourself to become an administrator. 

# Step 1 Walk the application as admin

after loging in and going to the admin panel, I see that I can promote users:

![image](https://user-images.githubusercontent.com/83407557/209986238-d22a7db1-1ee3-4299-868b-405898374c7f.png)

I see that to promote a user I see the referer header is set to /admin

![image](https://user-images.githubusercontent.com/83407557/209986349-cb2b0372-d364-4ab7-91b3-7f5247750cde.png)


# Step 2 try the same as a normal user

As a normal user I cannont access the /admin panel

![image](https://user-images.githubusercontent.com/83407557/209986571-77475b02-a6a8-4590-a6c2-6c28e0df35b7.png)

![image](https://user-images.githubusercontent.com/83407557/209986587-fd74e971-3e71-4f44-a3ad-e47f72791070.png)

Same thing with trying to go directly to the /admin-roles request:

![image](https://user-images.githubusercontent.com/83407557/209986804-47dfe4e9-89d7-4db0-b340-e5c05853311b.png)


# Step 3 change referer header

If I change the referer header to point at /admin

![image](https://user-images.githubusercontent.com/83407557/209987003-03ce8ae9-fef9-4356-ad58-22e994d3ff11.png)

I bypass the restriction and can upgrade my account:

![image](https://user-images.githubusercontent.com/83407557/209987056-72665639-dd05-4b61-9bf5-4fa67af9ebd5.png)

Going back to my account, I now have access to the admin panel and solve the lab:

![image](https://user-images.githubusercontent.com/83407557/209987158-da4fac45-9b36-4326-a0e8-05b8f20a067b.png)
