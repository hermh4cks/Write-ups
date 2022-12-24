# Lab: Flawed enforcement of business rules

 This lab has a logic flaw in its purchasing workflow. To solve the lab, exploit this flaw to buy a "Lightweight l33t leather jacket".

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 login and check functionality

Before login I see that there is a special code for new customers:

![image](https://user-images.githubusercontent.com/83407557/209449602-04cf761b-85d2-4906-98f0-40f1a5343c57.png)

I also see I have $100 in store credit

![image](https://user-images.githubusercontent.com/83407557/209449610-8a306b4b-3641-41fa-88be-300e8341bd4e.png)

I find that if I apply the coupon I get $5 off my purchase

![image](https://user-images.githubusercontent.com/83407557/209449645-50e8a473-0c81-4f2f-a5bb-fa5800e9066b.png)

# Step 2 Try to apply coupon more than once

![image](https://user-images.githubusercontent.com/83407557/209449665-4e6e4f57-5bcb-41ef-a80b-7bce213812a9.png)


However I see that I can only apply a coupon once:

![image](https://user-images.githubusercontent.com/83407557/209449685-3465c8b7-0418-4800-abef-c007ef8664df.png)

Looking at the request I see that the coupon is passed as a post request:

![image](https://user-images.githubusercontent.com/83407557/209449716-bee7d7dd-ae81-4c33-9eef-9d79ad758f62.png)

# Step 3 Clear order and add the coupon again

This time I capture the request and see if I can add multiple coupons:

![image](https://user-images.githubusercontent.com/83407557/209449785-2f8f511c-c1c8-4e63-aa27-1814cdd15971.png)

however this still only goes through once

![image](https://user-images.githubusercontent.com/83407557/209449798-839b6d9c-0e0c-4d5c-aca9-6fa7ba7a0ded.png)

# Step 4 Find another coupon

I find that if I sign up for the newsletter:

![image](https://user-images.githubusercontent.com/83407557/209449861-0df75630-0e93-4ab0-b75b-56a364e053c0.png)

I Find that there is another coupon:

![image](https://user-images.githubusercontent.com/83407557/209449873-7a076e93-2a6c-46d0-a9ae-444f53031c1a.png)

# Step 5 apply the other coupon

![image](https://user-images.githubusercontent.com/83407557/209449892-29f0d5a6-6bf4-408f-bc5b-3b98e3ea810e.png)

![image](https://user-images.githubusercontent.com/83407557/209449900-c191b66c-f3e9-4279-8666-84e5ea8c8f36.png)


# Step 6 Try and apply new coupon again

![image](https://user-images.githubusercontent.com/83407557/209449908-db3c905d-ea69-4b18-8f34-e71ba4d57d5d.png)

I get the same error

![image](https://user-images.githubusercontent.com/83407557/209449912-4408d0fb-5a26-4399-9765-1b815d80b1c6.png)

# Step 7 try to alternate coupons:

After both coupons are applied, I try and add the origional again:

![image](https://user-images.githubusercontent.com/83407557/209449935-194ac867-35d6-4225-9177-8f54b397d223.png)

And find that it adds two of the same coupon!

![image](https://user-images.githubusercontent.com/83407557/209449943-21c3b5b8-d590-4f5d-b24b-33cfbfd7d45d.png)

Trying to see if I can apply SIGNUP coupon again I find that I can!

![image](https://user-images.githubusercontent.com/83407557/209449961-8c2b8cfa-18e7-420b-923a-6fbd2ae87703.png)


# Step 8 alternate coupons until I can afford jacket

I alternate coupons until the price reaches zero:

![image](https://user-images.githubusercontent.com/83407557/209450021-af334bea-5011-42da-bc84-1bd881ef6249.png)

Then I can place the order and solve the lab!

![image](https://user-images.githubusercontent.com/83407557/209450035-b704d4af-8026-433a-84a9-3e638fbb8c7d.png)
