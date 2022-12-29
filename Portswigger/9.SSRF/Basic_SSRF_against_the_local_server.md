# Lab: Basic SSRF against the local server

This lab has a stock check feature which fetches data from an internal system.

To solve the lab, change the stock check URL to access the admin interface at http://localhost/admin and delete the user carlos. 

# Step 1 Walk the application

I want to see how the webapp is performing the stock check functionality

![image](https://user-images.githubusercontent.com/83407557/209991520-e4366058-f4c8-427b-85f5-1e93eb77c127.png)

I see that a post request is being sent to the stockApi:

![image](https://user-images.githubusercontent.com/83407557/209991615-abc2c79c-80de-43ea-a484-c968ac5502d7.png)

decoding the stockApi I see that it is a URL:

![image](https://user-images.githubusercontent.com/83407557/209991715-dd1f2438-bcda-4179-848f-f103747d12cf.png)

# Step 2 target admin panel via StockApi call:

Changing to target URL

![image](https://user-images.githubusercontent.com/83407557/209991860-10c20eea-f7d5-4feb-8725-f0a5c609857a.png)

I see that instead of a stock number I get the admin panel:

![image](https://user-images.githubusercontent.com/83407557/209992172-2b33082a-016f-4c05-bd3b-af83bd31590d.png)

# Step 3 delete carlos

If I try and access it straight from the product page, I get access denied:

![image](https://user-images.githubusercontent.com/83407557/209992275-885ce1a8-4b82-47b4-90a8-d7da7309dbc4.png)

However, now that I can see the request to delete a user

![image](https://user-images.githubusercontent.com/83407557/209992348-80648494-99d0-4a81-95e5-1d5780760922.png)

I can use SSRF to delete the user

![image](https://user-images.githubusercontent.com/83407557/209992504-efaf4000-2020-491b-b06d-a38e85bea331.png)

while this does not give output:

![image](https://user-images.githubusercontent.com/83407557/209992577-426f5281-e8f4-497a-b0e7-7a2b24d7a466.png)

I can access the admin panel again and confirm that the user has been deleted(and that the lab is solved)

![image](https://user-images.githubusercontent.com/83407557/209992687-9bc8c44e-6e13-4f42-bbe9-b981d0b6f22c.png)

![image](https://user-images.githubusercontent.com/83407557/209992731-bb432360-cb85-438c-b5bb-52671d29681c.png)
