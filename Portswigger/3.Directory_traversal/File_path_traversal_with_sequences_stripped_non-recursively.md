# Lab: File path traversal, traversal sequences stripped non-recursively

 This lab contains a file path traversal vulnerability in the display of product images.

The application strips path traversal sequences from the user-supplied filename before using it.

To solve the lab, retrieve the contents of the /etc/passwd file. 


# Step 1 Open an image in a new tab and find a potential directory traversal vuln

![image](https://user-images.githubusercontent.com/83407557/208784784-04bb1d9f-8dd3-4e3b-b904-cd72e9426e2d.png)


# Step 2 see that the application strips traversal sequences

![image](https://user-images.githubusercontent.com/83407557/208784843-3252cc32-d49c-4e79-a14d-bf91d714a582.png)

# Step 3 plan the bypass of the stripped sequence

If the application is stripping out `../` if I put `....//` and `../` is taken out, the result is `../`

With that in mind I can use ....//....//....//....//....//etc/passwd, and once stripped it will become ../../../../etc/passwd



![image](https://user-images.githubusercontent.com/83407557/208786111-1adaa39e-3ea6-459d-841a-320d534a5905.png)

![image](https://user-images.githubusercontent.com/83407557/208786263-4da32f5b-e748-4fec-93ab-1542ccf9ff92.png)

Which solves the lab

![image](https://user-images.githubusercontent.com/83407557/208786316-1cb99e1c-9031-4c0e-97a6-ebbc5efe0c51.png)


