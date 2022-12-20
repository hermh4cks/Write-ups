# Lab: File path traversal, simple case

This lab contains a file path traversal vulnerability in the display of product images.

To solve the lab, retrieve the contents of the /etc/passwd file. 

# Step 1 open an image in a new tab

![image](https://user-images.githubusercontent.com/83407557/208781599-01481bad-bf25-4bb4-89ad-8f4a03e0963e.png)


# Step 2 inspect url 
I See that there is a filename parameter used to get the image file from the server

![image](https://user-images.githubusercontent.com/83407557/208781827-d5d818c7-c601-46d9-9301-caf84f89b757.png)


# Step 3 try and traverse the directories with `../`

![image](https://user-images.githubusercontent.com/83407557/208782016-a1f22cc7-358f-4e09-89b7-e593aa02d527.png)


Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/208782185-f7064a3d-b9fe-4206-8124-c627b9677f13.png)
