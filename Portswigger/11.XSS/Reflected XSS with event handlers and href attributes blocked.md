# Lab: Reflected XSS with event handlers and href attributes blocked

 This lab contains a reflected XSS vulnerability with some whitelisted tags, but all events and anchor href attributes are blocked..

To solve the lab, perform a cross-site scripting attack that injects a vector that, when clicked, calls the alert function.

Note that you need to label your vector with the word "Click" in order to induce the simulated lab user to click your vector. For example: 

```html
<a href="">Click me</a>
```

# Step 1 Find reflected input

If I do a search using the string "Reflected"

![image](https://user-images.githubusercontent.com/83407557/211085925-508cbe69-7cde-4b4d-98a2-ba5a6693bf7e.png)

I see that that my input is reflected on the page:

![image](https://user-images.githubusercontent.com/83407557/211086002-0b9a8e32-9c27-4473-b0cc-9d03b5af7090.png)

However when I try a simple alert payload:

![image](https://user-images.githubusercontent.com/83407557/211086136-d4b15e11-c377-48ed-b90e-4dbcd9076c67.png)

I get the following error:

![image](https://user-images.githubusercontent.com/83407557/211086182-6c4a883e-9bce-4651-8a01-1a6c8b08ebd5.png)

# Step 2 find allowed html tags

I send a <test> tag through the searchbar and capture the request with burp:
  
![image](https://user-images.githubusercontent.com/83407557/211086468-e39089cd-273e-41b2-848e-d52bc1d20e30.png)

![image](https://user-images.githubusercontent.com/83407557/211086601-621d55d6-af45-4d87-a50b-8d4c24ac5e81.png)

I then send that request to intruder, and set a payload position on the word "test"

![image](https://user-images.githubusercontent.com/83407557/211086777-c49ba789-7f09-4067-b548-2d134f886238.png)

  
Using portswigger's [XSS Cheat Sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet) I copy all the tags to my clipboard:
  
![image](https://user-images.githubusercontent.com/83407557/211086868-d24ef092-c1e7-4d94-a81e-776db85943e5.png)

And paste them as payloads for my intruder attack

![image](https://user-images.githubusercontent.com/83407557/211087017-f967a133-8fd9-4c49-82f0-39c6736242e7.png)
