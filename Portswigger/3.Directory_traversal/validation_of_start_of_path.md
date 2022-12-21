# Lab: File path traversal, validation of start of path

 This lab contains a file path traversal vulnerability in the display of product images.

The application transmits the full file path via a request parameter, and validates that the supplied path starts with the expected folder.

To solve the lab, retrieve the contents of the /etc/passwd file. 

# Walking the application

Opening an image in a new tab I see that it is using the full file path when it loads the image:

![image](https://user-images.githubusercontent.com/83407557/208815512-13ce05ca-73af-43d1-9503-f53ff0a08877.png)

# Bypassing with escape sequence at end of directory path

To get to the /etc/passwd file I can just append it to the directory folder:

![image](https://user-images.githubusercontent.com/83407557/208816002-64298360-f8b5-4f3e-8a53-88583adaccc6.png)

![image](https://user-images.githubusercontent.com/83407557/208816072-6cd0f6f6-57db-466a-b85d-8bffb8b0ceeb.png)

This solves the lab:

![image](https://user-images.githubusercontent.com/83407557/208816110-430d869a-bc05-46c0-ae62-a5fc19e1c1d6.png)
