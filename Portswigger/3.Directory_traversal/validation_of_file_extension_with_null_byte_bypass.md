# Lab: File path traversal, validation of file extension with null byte bypass

 This lab contains a file path traversal vulnerability in the display of product images.

The application validates that the supplied filename ends with the expected file extension.

To solve the lab, retrieve the contents of the /etc/passwd file. 

# Step 1 Walk the application

I find that the images on the site is displaying images using a parameter called "filename" and passing files contained within the root directory:

![image](https://user-images.githubusercontent.com/83407557/209013551-7f627609-56c7-44c2-8367-a683401f7c45.png)

# Step 2 directory traversal

I try and view the /etc/passwd file using common directory traversal:

This however fails to find a file:

![image](https://user-images.githubusercontent.com/83407557/209013803-921ce246-25ab-4276-b74b-c254829ae1eb.png)


# Step 3 use a .jpg file ext

I add a null byte `%00` so when the the file passwd.jpg is passed to the server, the ext .jpg is stripped:

![image](https://user-images.githubusercontent.com/83407557/209014067-2f076a36-3c1b-47dc-8d33-2b53dcdfe67c.png)

This bypasses the filter and exfils the passwd file:

![image](https://user-images.githubusercontent.com/83407557/209014177-f93071f3-74df-412b-8633-5435088c5331.png)

Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209014387-57b85542-54fc-4e35-a3ea-c6ea910c063c.png)
