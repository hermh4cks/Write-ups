# Lab: Stored XSS into anchor href attribute with double quotes HTML-encoded

This lab contains a stored cross-site scripting vulnerability in the comment functionality. To solve this lab, submit a comment that calls the alert function when the comment author name is clicked. 

# Step 1 Locate Stored href

I want to see how commenting works on this webapp, specifically at the website field, that create a clickable link for my username

![image](https://user-images.githubusercontent.com/83407557/211164862-b90e868a-cce0-4b8f-b5f8-4927beba1adf.png)

![image](https://user-images.githubusercontent.com/83407557/211164894-9e7d313c-36ad-41e5-b43a-1fac693ca271.png)

I can see this response in my burp history to start building the attack:

![image](https://user-images.githubusercontent.com/83407557/211164956-e26af68a-7788-450f-805f-f4e82805242f.png)

# Step 2 Create a payload

To get xxs to fire within this context I can use the following, which would create a clickable link called XSS:

```html
<a href="javascript:alert('XSS')">XSS</a>
```
An example on a local server:

![image](https://user-images.githubusercontent.com/83407557/211165245-0a59e314-e762-4d35-8c49-bbe82ca86beb.png)

Since my input is already being placed within an `<a>` tag with an `href` attribute and within double quotes, I can make a payload such as the following:

```html
javascript:alert(1)
```
# Step 3 test payload:

![image](https://user-images.githubusercontent.com/83407557/211165332-992d8141-54e1-48d9-a5c2-9ba34154daf8.png)

Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/211165356-14035377-500f-4648-b35f-2421149b69a5.png)

Going back to blog, I can test it myself:

![image](https://user-images.githubusercontent.com/83407557/211165397-65054d2b-7223-4630-a7ca-1eb2b36e52c8.png)

And in burp HTTP history I can see why it works:

![image](https://user-images.githubusercontent.com/83407557/211165439-cb404457-ba9e-4fed-adca-1f75d97591ae.png)
