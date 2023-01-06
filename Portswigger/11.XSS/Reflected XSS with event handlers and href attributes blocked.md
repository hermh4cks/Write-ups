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

 And I find that several tags are allowed:
 
 ![image](https://user-images.githubusercontent.com/83407557/211087233-e330eaa2-a3c5-4ee1-90b1-13adb4f33936.png)

# Step 3 Find a tag that allows href
 
I need to find one of these white-listed tags that can also use an href attribute in someway to create a clickable link, again to do this I use the cheat sheet:
 
 ```html
 <a href="javascript:alert(1)">XSS</a>
 ```
 ![image](https://user-images.githubusercontent.com/83407557/211088377-fee17038-c7f0-4419-8775-b749ea218385.png)

however I get an error:

![image](https://user-images.githubusercontent.com/83407557/211088456-6fa614e1-381c-4df3-b078-10a8dd397944.png)

After a bit of searching on the cheat sheet, I find one that my work as it passes the href attribute differently:
 
 ![image](https://user-images.githubusercontent.com/83407557/211089072-12fccc27-90e4-44d4-9257-41776d04ab00.png)

```html
<svg><animate xlink:href=#xss attributeName=href values=javascript:alert(1) /><a id=xss><text x=20 y=20>XSS</text></a>
```
 
 However it still has an href= attribute
 
 ![image](https://user-images.githubusercontent.com/83407557/211089378-dee2749b-65c0-405f-af04-9f2f159987c8.png)

 And is blocked:
 
 ![image](https://user-images.githubusercontent.com/83407557/211089481-29b95c8e-ca44-4ced-a056-d3e45914e84c.png)
 
 I try to modify the payload to see if I can bypass the blocked attribute, by removing the `href=` the `id=xss` and then wrapping the entire payload in `<a>` tags:
 
 ```html
<svg><a><animate attributeName=href values=javascript:alert(1) /><text x=20 y=20>XSS</text></a>
```

 ![image](https://user-images.githubusercontent.com/83407557/211090784-0cc6fe3a-a8b7-4fac-8fec-12dd5e62bee2.png)

This bypasses the filters and creates a clickable link that will cause and alert pop-up
 
 ![image](https://user-images.githubusercontent.com/83407557/211090935-05d3c890-7961-49da-a751-11e9dbd18da0.png)

 
# Step 4 Deliver the exploit
 
 Now that I have a payload, I just need to modify it slightly to make the link titled "Click me" instead of XSS:
 
 ```html
 <svg><a><animate attributeName=href values=javascript:alert(1) /><text x=20 y=20>Click me</text></a>
 ```
 
 Doing so solves the lab:
  
  ![image](https://user-images.githubusercontent.com/83407557/211091431-587b759f-5b78-4105-969c-3bca316943a9.png)

 
