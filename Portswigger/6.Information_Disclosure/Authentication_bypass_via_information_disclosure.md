# Lab: Authentication bypass via information disclosure

 This lab's administration interface has an authentication bypass vulnerability, but it is impractical to exploit without knowledge of a custom HTTP header used by the front-end.

To solve the lab, obtain the header name then use it to bypass the lab's authentication. Access the admin interface and delete Carlos's account.

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 Walk the application

I login to the webapp and try to get to the administration interface:

![image](https://user-images.githubusercontent.com/83407557/209589146-86e6cd53-1789-4d9a-890b-2eabb1dfbfcd.png)

![image](https://user-images.githubusercontent.com/83407557/209590398-b45cbc38-09a0-446d-abbe-fd4a70a9f1ea.png)


![image](https://user-images.githubusercontent.com/83407557/209589162-dc44e566-f846-4935-bb70-6c7f869286b7.png)


# Step 2 resend request with TRACE instead of GET

I send the request for /admin to repeater and change the request method from GET to TRACE

![image](https://user-images.githubusercontent.com/83407557/209590545-471127b7-9a6a-4d2e-8499-b0dbf2a46328.png)

doing so I see my public IP address displayed in a custom header: `X-Custom-IP-Authorization:`

# Step 3 add X-Custom-IP-Authorization header

Since the error I got when trying to access the /admin directory said that the request needed to come from localhost, I add the custom header to my request coming from 127.0.0.1:

![image](https://user-images.githubusercontent.com/83407557/209590646-5d9aa217-a498-4161-8533-e3077f51d1b3.png)

And I am able to get to the admin pannel:

![image](https://user-images.githubusercontent.com/83407557/209590670-25a982b9-3eba-40f0-8910-fff695546bb4.png)

# Step 4 delete carlos

I open the request in my browser and turn intercept on

![image](https://user-images.githubusercontent.com/83407557/209590714-079a3287-06f6-43ac-a0a0-227c3ec542ca.png)

Then I delete Carlos and capture the request:

![image](https://user-images.githubusercontent.com/83407557/209590767-6fa2d6a3-c8ad-44a8-b00b-3bae7ff26f82.png)

I add the custom header before forwarding the request

![image](https://user-images.githubusercontent.com/83407557/209590823-21606d77-a1b5-4794-ab0a-3238923aa2d8.png)

and the one to get back to /admin

![image](https://user-images.githubusercontent.com/83407557/209590872-a16dc3a4-fe17-4b94-bbab-b3cfeea08849.png)

which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209590890-c0ec3559-f9ab-450e-b5ec-c50632c2330a.png)

