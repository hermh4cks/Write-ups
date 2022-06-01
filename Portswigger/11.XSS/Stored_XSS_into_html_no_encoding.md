# Lab: Stored XSS into HTML context with nothing encoded

## Description

This lab contains a stored cross-site scripting vulnerability in the comment functionality.

To solve this lab, submit a comment that calls the alert function when the blog post is viewed.

# Step 1 Examine the comment functionality

I fill out a comment, but I add some html tags to see if it gets stripped from my post.

![image](https://user-images.githubusercontent.com/83407557/171459330-2cee19f9-b4e9-4abd-957d-8289fa18c842.png)

And viewing comments I see I now have the biggest.

![image](https://user-images.githubusercontent.com/83407557/171459706-60063e5d-a441-4f0b-93fa-571bda05034d.png)


# Step 2 Attempt to store javascript within the comment funtion

I make a new comment, this time with html in my name field, and an alert script in the body

![image](https://user-images.githubusercontent.com/83407557/171460190-e14c0232-ae7b-4eb9-9be6-738cde6cd4e2.png)

Entering it solves the lab

![image](https://user-images.githubusercontent.com/83407557/171460326-51898439-9964-4393-8860-3f25c9c89757.png)

going back to the comments, we can see our alert script run

![image](https://user-images.githubusercontent.com/83407557/171460409-abeb2cad-f73a-44b3-8f24-73e13bcf854f.png)

clicking ok I see that there was not the same XSS vuln in the name field:

![image](https://user-images.githubusercontent.com/83407557/171460540-0b065cf5-46d9-4843-892c-fbb32677b65a.png)
