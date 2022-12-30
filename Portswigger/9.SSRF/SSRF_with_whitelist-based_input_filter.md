# Lab: SSRF with whitelist-based input filter

 This lab has a stock check feature which fetches data from an internal system.

To solve the lab, change the stock check URL to access the admin interface at http://localhost/admin and delete the user carlos.

The developer has deployed an anti-SSRF defense you will need to bypass. 

# Step 1 Find SSRF in stock check

![image](https://user-images.githubusercontent.com/83407557/210104457-28cec093-9a40-4371-87c6-cc6d6dfce9d8.png)

Testing localhost

![image](https://user-images.githubusercontent.com/83407557/210104490-65912d2c-307a-434e-b9ac-0f8b1d3b07d5.png)

Find that the white-listed URL is leaked

![image](https://user-images.githubusercontent.com/83407557/210104577-594a7ad9-fe20-4e4d-8bb9-b149264f40e7.png)

# Step 2 Embeded credentials?

I want to see if I can embed credentials to the white-listed URL, using repeater I see that this bypasses the filter

![image](https://user-images.githubusercontent.com/83407557/210105052-2570247a-3cf5-4ba6-b384-939f5b6aa8cf.png)

# Step 3 Try and fragment the URL

I want to fragment the URL by adding an octothorp with repeater, however it gets blocked by the filter:

![image](https://user-images.githubusercontent.com/83407557/210105258-8708c660-5a89-41db-a011-abbe2aa8a096.png)

# Step 4 fragment filter bypass

I want to try and URL encode the `#` to see if it will bypass the filter

![image](https://user-images.githubusercontent.com/83407557/210105358-f5794532-5248-4d6d-8453-b956e62cb6cc.png)

But I am still blocked:

![image](https://user-images.githubusercontent.com/83407557/210105380-62e3c745-109d-42b5-89ea-6900c84c3722.png)

Next I try to double URL encode the `#`

![image](https://user-images.githubusercontent.com/83407557/210105623-4f10e9ad-24a2-4644-bd4e-a8b85b999177.png)

And bypass the filter and get a internal server error

![image](https://user-images.githubusercontent.com/83407557/210105661-5c760ff7-4ea6-441d-b0bd-eb9fd6606e57.png)

# Step 5 try and get to localhost:

with the fragment going through the filter, I now want to see if I can get to localhost:

![image](https://user-images.githubusercontent.com/83407557/210105795-dcba8066-189b-4943-af1b-fdd7c838a65b.png)

It not only goes through but I see the admin panel:

![image](https://user-images.githubusercontent.com/83407557/210105828-20447455-58f6-4040-96ac-2a734df72ad3.png)

# Step 6 try to get to admin panel

I am able to make it and see the href to delete carlos

![image](https://user-images.githubusercontent.com/83407557/210105907-5a7d35a6-422d-41ba-a13d-cc8755dea660.png)


# Step 7 delete carlos

![image](https://user-images.githubusercontent.com/83407557/210105945-6325e66a-c78d-40a1-8b8d-bcd35ebf11c9.png)

I see that carlos was deleted as I have solved the lab:

![image](https://user-images.githubusercontent.com/83407557/210105991-f20e7542-e9f6-4e31-aa43-2bd6fdd78add.png)






