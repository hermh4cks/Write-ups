# Lab: Insufficient workflow validation

 This lab makes flawed assumptions about the sequence of events in the purchasing workflow. To solve the lab, exploit this flaw to buy a "Lightweight l33t leather jacket".

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 Walk the application

I want to login and see what trying to purchase a jacket normally would look like:

## login

![image](https://user-images.githubusercontent.com/83407557/209445291-a03e45db-80df-4d10-a345-4fed781546cb.png)

## my-account

![image](https://user-images.githubusercontent.com/83407557/209445318-8b33ae60-7bdc-44fa-917d-67440233485a.png)

## adding jacket to cart

![image](https://user-images.githubusercontent.com/83407557/209445348-3dc23c8a-0498-4b5d-87ef-47130020825e.png)

![image](https://user-images.githubusercontent.com/83407557/209445371-83353e70-89b9-4d34-bb1a-1f4fa94cf3a6.png)


## placing an order

![image](https://user-images.githubusercontent.com/83407557/209445394-578cb7a0-c882-4430-b3f0-89965493d3e8.png)

![image](https://user-images.githubusercontent.com/83407557/209445408-b6be2553-d9f5-41a8-a175-149a13c1d614.png)

## Removing an item from cart

![image](https://user-images.githubusercontent.com/83407557/209445424-ee677022-3a2f-413d-b41e-d40a0844b4ee.png)

## Purchasing an item I can afford

![image](https://user-images.githubusercontent.com/83407557/209445540-4d142d6d-a124-4555-aac1-82afb62993d4.png)

![image](https://user-images.githubusercontent.com/83407557/209445729-3f4a762e-1638-4e5f-84ee-2d49f9c5b62f.png)

Here I see a new page that I didn't get to last time for order confirmation:

![image](https://user-images.githubusercontent.com/83407557/209445814-0099f24a-1fbb-43d9-8fd9-2fb1d08cc47b.png)

![image](https://user-images.githubusercontent.com/83407557/209445829-bfa4e539-5a5c-4edb-b276-22a9af2af45e.png)

# Step 2

Add the jacket to my cart before submitting the order confirmation

## Add cheaper item to cart

![image](https://user-images.githubusercontent.com/83407557/209445867-74db1078-ef3c-45a2-b74c-6be57c172958.png)

## go to checkout 

![image](https://user-images.githubusercontent.com/83407557/209445898-fc3759d7-7d4f-4762-b89b-988fb983b8ad.png)

## send confirmation to repeater and drop the request:

![image](https://user-images.githubusercontent.com/83407557/209445983-2c8821d7-1817-4b6d-86e4-3c3758fe4404.png)

## Go back and add the jacket to my cart

![image](https://user-images.githubusercontent.com/83407557/209446014-eccffacb-e59c-4441-8598-cdce1460669b.png)

## Use repeater to confirm order, bypassing the funds check:

![image](https://user-images.githubusercontent.com/83407557/209446048-66238773-9281-45b0-ba65-73a835022def.png)

In doing so I am able to purchase the jacket without it costing anything

![image](https://user-images.githubusercontent.com/83407557/209446070-19e695ac-4a0c-48a5-9af6-b9f13d7ea0cb.png)


