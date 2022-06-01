# Lab: Reflected XSS into HTML context with nothing encoded

## Description

 This lab contains a simple reflected cross-site scripting vulnerability in the search functionality.

To solve the lab, perform a cross-site scripting attack that calls the alert function.

# Step 1: verify search funtion reflects output on page within the HTML document

I see my search term hacks reflected in the response

![image](https://user-images.githubusercontent.com/83407557/171456989-aecba642-2954-4214-93ac-4f02b8d60cb5.png)

# Step 2: Enter an alert script

I usually use the following javascript as my test string

```html
<script>alert(document.domain)</script>
```

sending that as my search parameter I get a pop-up containing the domain of the lab

![image](https://user-images.githubusercontent.com/83407557/171457595-3fe2052e-7e71-418d-b079-12f93e9f5c9e.png)

clicking okay on my pop-up I solve the lab

![image](https://user-images.githubusercontent.com/83407557/171457686-52d17eb4-fbd6-4f39-b243-78e5ae8f4a62.png)
