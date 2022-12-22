# Lab: Excessive trust in client-side controls

 This lab doesn't adequately validate user input. You can exploit a logic flaw in its purchasing workflow to buy items for an unintended price. To solve the lab, buy a "Lightweight l33t leather jacket".

You can log in to your own account using the following credentials: wiener:peter 

# Step 1 Walk the application

I want to get an idea of how purchasing of the "Lightweight l33t leather jacket" works on this webapp from a client-side perspective.

![image](https://user-images.githubusercontent.com/83407557/209240830-b1f2a69f-4761-499d-af06-68eee57325a6.png)

I add this item to my cart

![image](https://user-images.githubusercontent.com/83407557/209240870-f0792565-0413-4203-a1c0-543ad2521836.png)

However I capture the request with burp proxy, and notice that the price is being sent as part of the POST request:

![image](https://user-images.githubusercontent.com/83407557/209241146-5e432ef6-e070-446f-b53e-1b77a64845c2.png)

if I send this along without modification, I see that 1337.00 is the price inside my cart:

![image](https://user-images.githubusercontent.com/83407557/209241251-72ec6a1d-b712-4bb8-991a-46208cadacef.png)

I then remove it from my cart, and resend the add to cart request

# Step 2 modify the price before item enters cart:

![image](https://user-images.githubusercontent.com/83407557/209241367-94a0c71e-f951-4218-9bb4-b8e4acb5746e.png)

however this does not change my cart being emptry

![image](https://user-images.githubusercontent.com/83407557/209241532-296ebbf1-a7ef-4b17-8e5d-3b90011c628d.png)

# Step 3 try to manipulate the checkout fields

This time I log in as wiener, and see that I have $100 in store credit, so lets see what that looks like when captured:

![image](https://user-images.githubusercontent.com/83407557/209242482-67b42f45-804a-43d7-83e4-ecb2ea31cb18.png)

If I modify the coupon field before sending it to match the price of the jacket:

![image](https://user-images.githubusercontent.com/83407557/209242547-e944e9a0-62d3-422c-94ae-a688f042852a.png)

I get that the coupon is invalid:

![image](https://user-images.githubusercontent.com/83407557/209242600-ff8dab62-e2b8-4103-ba10-eb8fb77b24d2.png)

# Step 4 Try and add a different product, but change the product id

![image](https://user-images.githubusercontent.com/83407557/209242895-7b00b289-c710-4383-84f9-ed31134235ee.png)

If I capture this request, with a valid price, but modify the product id:

![image](https://user-images.githubusercontent.com/83407557/209242972-f5d9c743-bc70-4a4f-9fe1-5d623aac5b45.png)

![image](https://user-images.githubusercontent.com/83407557/209242996-e871672c-9ffc-4683-bf36-0661e1d23461.png)

I see that now I have the leather jacket in my cart, but with a price that is covered by my store credit:

![image](https://user-images.githubusercontent.com/83407557/209243103-1d91a02b-64e4-4c40-9d6d-6bead6444aba.png)

# Step 5 place order and check-out

I get the 1337 jacket and solve the lab!

![image](https://user-images.githubusercontent.com/83407557/209243194-73f8ae21-00c3-457f-a54b-1320fc69f342.png)
