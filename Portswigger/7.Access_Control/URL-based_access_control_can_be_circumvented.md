# Lab: URL-based access control can be circumvented

 This website has an unauthenticated admin panel at /admin, but a front-end system has been configured to block external access to that path. However, the back-end application is built on a framework that supports the X-Original-URL header.

To solve the lab, access the admin panel and delete the user carlos. 

# Step 1 Walk the application

I see that there is an admin panel available

![image](https://user-images.githubusercontent.com/83407557/209718440-5c63fc62-f80d-49ee-99c7-646a8087e268.png)

however, trying to access it, I am blocked:

![image](https://user-images.githubusercontent.com/83407557/209718522-1774eb5c-15d7-4e9b-b1f8-ed744d72eb97.png)

# Step 2 use X-Original-URL header

I send the request for the root directory to burp and intercept it:

![image](https://user-images.githubusercontent.com/83407557/209718640-62d53b5c-8947-43d3-ad69-861a08276edf.png)

I add the x-Original-URL header to point at the /admin directory:

![image](https://user-images.githubusercontent.com/83407557/209718716-eecf8e78-5bd6-495d-9e49-05cd47bfd079.png)

and doing so get to the admin panel

# Step 3 delete carlos

Trying to delete carlos from this page I once again get blocked, but am able to see the request being made:

![image](https://user-images.githubusercontent.com/83407557/209718847-a19b8b51-b66e-4ef8-a264-f3f8a432c2d3.png)

I resend the webroot and add the header for this found url:

![image](https://user-images.githubusercontent.com/83407557/209718915-b4339131-f847-4879-9a5a-ca3ef5af1c7d.png)

But I get the following error:

![image](https://user-images.githubusercontent.com/83407557/209719085-ad99532e-871b-4ef0-a0b7-3c3640095185.png)

(Had to restart the lab to take a break, URL changes here)

I restart and send the root directory to burp

![image](https://user-images.githubusercontent.com/83407557/209840869-afbdd473-b430-4e8b-820e-f19b26cd9fe4.png)

I use the X-Origional-URL to point at /admin/delete, and pass the ?username=carlos to the webroot:

![image](https://user-images.githubusercontent.com/83407557/209842183-9d264af6-a4c9-4b9e-b98c-744661fb5063.png)

Doing so deletes carlos and solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209842378-14a9776f-4952-4efd-9714-2a0b6afe6a91.png)
