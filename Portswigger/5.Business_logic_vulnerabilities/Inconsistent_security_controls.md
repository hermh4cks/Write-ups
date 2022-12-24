# Lab: Inconsistent security controls

This lab's flawed logic allows arbitrary users to access administrative functionality that should only be available to company employees. To solve the lab, access the admin panel and delete Carlos. 

# Step 1 Walk the application

## Directory brute-force

I want to brute-force directories to find the admin pannel, so I create the following intruder attack:

![image](https://user-images.githubusercontent.com/83407557/209417084-ffe44384-50ed-4205-a5e0-1ac83a591670.png)

For payloads I use directories-long from burp (you can also use others but this is what I start with)

![image](https://user-images.githubusercontent.com/83407557/209417156-0cb2ca83-6606-4489-96a0-891b4ac11092.png)

I want to sort the results based on status codes, 404 is not found so I only want to see everything that isn't a 404:

![image](https://user-images.githubusercontent.com/83407557/209417197-f549b9b5-f3ca-4685-94de-f67df631bde1.png)

This shows me that the admin pannel is at /admin

## My email client

![image](https://user-images.githubusercontent.com/83407557/209417222-78d7f8bf-f3f8-41bf-a6c2-3f27ccc0591c.png)


## Register form

![image](https://user-images.githubusercontent.com/83407557/209417244-b59833fb-299e-4576-b20c-386d6658140c.png)

![image](https://user-images.githubusercontent.com/83407557/209417254-78a444ce-1c79-4a54-987d-9e336c287d5f.png)

## Account confirmation:

![image](https://user-images.githubusercontent.com/83407557/209417266-ab5efdaf-ece4-48e0-af89-63dd10746f3e.png)

![image](https://user-images.githubusercontent.com/83407557/209417278-81f7c018-1cfd-4146-a0c8-409dbc55e467.png)

![image](https://user-images.githubusercontent.com/83407557/209417281-52f782ce-9797-43f6-8414-789ceac7bc6f.png)

## Account login

![image](https://user-images.githubusercontent.com/83407557/209417289-7d1f9e0a-5616-4bfc-ac22-61fb529e2653.png)

![image](https://user-images.githubusercontent.com/83407557/209417303-8e52d606-9aa8-4ac0-8533-14034eb2c6de.png)

![image](https://user-images.githubusercontent.com/83407557/209417313-ad7e970f-75d8-4099-8ffb-84fb98758311.png)

# Step 2 update email

If I try and view /admin from my current account, I get an error:

![image](https://user-images.githubusercontent.com/83407557/209417336-3be00131-d392-484f-83b6-5f29f483478b.png)

However, if I am able to update my email, I can make it seem like I have a DontWannaCry email address:

![image](https://user-images.githubusercontent.com/83407557/209417366-6ecd9153-2c6f-4001-8bbf-93519c1f7d3e.png)

![image](https://user-images.githubusercontent.com/83407557/209417372-a10306ad-119e-4bc6-bb63-a3ba7f335746.png)


And with that I can access the /admin pannel

![image](https://user-images.githubusercontent.com/83407557/209417398-35fea331-103a-4884-8844-6580c21ae2ae.png)


# Step 3 delete carlos' account

Now that I have admin access, I can delete the carlos user, and in doing so I solve the lab:

![image](https://user-images.githubusercontent.com/83407557/209417421-7038e65c-df0d-4281-9fb6-cdcd8e0d9a3e.png)
