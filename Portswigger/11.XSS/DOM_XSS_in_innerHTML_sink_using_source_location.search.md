# Lab: DOM XSS in innerHTML sink using source location.search

## Description

 This lab contains a DOM-based cross-site scripting vulnerability in the search blog functionality. It uses an innerHTML assignment, which changes the HTML contents of a div element, using data from location.search.

To solve this lab, perform a cross-site scripting attack that calls the *alert* function. 

# Step 1: Enter a unique string in the search bar

![image](https://user-images.githubusercontent.com/83407557/171754639-c7d2b932-551b-420a-b0ed-9b4a898b22c4.png)

# Step 2: Check to see if unique string is reflected on page with dev tools

![image](https://user-images.githubusercontent.com/83407557/171755148-11e51e62-2c8f-46e1-9e4e-e75391c71a7f.png)

# Step 3: Inject an onerror XSS payload

```html
<img src=hermh4cks onerror=alert(1)>
```
The page will try and load hermh4cks as an image, which causes an error. Then the error causes the alert function to be called.

![image](https://user-images.githubusercontent.com/83407557/171757093-54b92bf3-a63c-4c69-8b06-475d7a4ae788.png)

The lab is solved, and we can see the errored out image that didn't load

![image](https://user-images.githubusercontent.com/83407557/171757298-4612716d-b217-4778-a575-10fd3f32831c.png)

