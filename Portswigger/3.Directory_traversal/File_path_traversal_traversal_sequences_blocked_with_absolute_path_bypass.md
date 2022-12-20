# Lab: File path traversal, traversal sequences blocked with absolute path bypass

 This lab contains a file path traversal vulnerability in the display of product images.

The application blocks traversal sequences but treats the supplied filename as being relative to a default working directory.

To solve the lab, retrieve the contents of the /etc/passwd file. 


# Step 1 display a product image on its own page

![image](https://user-images.githubusercontent.com/83407557/208783455-9da16ec8-e23f-44c1-8963-f494495e1f50.png)

![image](https://user-images.githubusercontent.com/83407557/208783494-b75870e1-1536-461c-9b4c-178689b0fddf.png)

# Step 2 change the filename to the absolute path for /etc/passwd

![image](https://user-images.githubusercontent.com/83407557/208783565-927aa78f-89df-45e0-9a67-ba767356053a.png)

which solves the lab

![image](https://user-images.githubusercontent.com/83407557/208783614-e536e681-2e57-457f-bca3-e6f6f13390c6.png)

