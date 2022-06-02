# Lab: DOM XSS in document.write sink using source location.search

## Description

This lab contains a DOM-based cross-site scripting vulnerability in the search query tracking functionality. It uses the JavaScript **document.write** function, which writes data out to the page. The document.write function is called with data from **location.search**, which you can control using the website URL.

To solve this lab, perform a cross-site scripting attack that calls the **alert** function.


# Step 1: Enter a unique string into search

![image](https://user-images.githubusercontent.com/83407557/171752254-047246d2-9bac-424a-bf9e-e64e49f7c827.png)

# Step 2: See if the string is reflected on page using in-browser dev tools

 I see it reflected in two places, one of which being an img tag
 
 ![image](https://user-images.githubusercontent.com/83407557/171752503-f10a460f-7e62-4a04-8eb5-5891e7b81830.png)

# Step 3: Check to see if I can break out of img tag

I see that I can, as now my search string apears below the search bar, and I can see in the source why it is happening

![image](https://user-images.githubusercontent.com/83407557/171752667-30322e57-00c3-4b22-a322-e9e6a5263d47.png)

# Step 4: Inject an svg onload XSS payload

![image](https://user-images.githubusercontent.com/83407557/171752857-9897f5d7-e0b6-4670-9940-e001ca719052.png)

which solves the lab
