# Lab: Reflected XSS into attribute with angle brackets HTML-encoded

This lab contains a reflected cross-site scripting vulnerability in the search blog functionality where angle brackets are HTML-encoded. To solve this lab, perform a cross-site scripting attack that injects an attribute and calls the alert function. 

### NOTES FROM PORTSWIGGER:

![image](https://user-images.githubusercontent.com/83407557/211163573-e45952af-a882-4067-8a02-d351f9987302.png)

# Step 1 Find where input is being reflected on page

When I make a search:

![image](https://user-images.githubusercontent.com/83407557/211163633-27ae703b-a3b4-4689-8c77-cfab44bd378b.png)

I find that my input is being reflected on the page

![image](https://user-images.githubusercontent.com/83407557/211163652-21c1afb9-1bd2-47e2-928a-9f3a50877ad0.png)

# Step 2 Start testing for XSS

When I try and get a simple xss payload to execute with the search bar:

![image](https://user-images.githubusercontent.com/83407557/211163704-3b909c79-a4bd-4986-bc4e-7c83b3f3cbef.png)

I see that it is reflected, but not executing:

![image](https://user-images.githubusercontent.com/83407557/211163741-bf6bd18c-da80-4934-bfc1-4a6e8acc6f98.png)

Checking the response in burp, I can see that the angle brackets are being encoded to &lt and &gt

![image](https://user-images.githubusercontent.com/83407557/211163841-36e70265-e677-489a-ae4a-cff36911c0ff.png)

# Step 3 Breakout payloads

I see that my input is inside of angle brackest:

```html
<input type=text placeholder='Search the blog...' name=search value="&lt;script&gt;alert(1)&lt;/script&gt;">
```

I can try the sample payload as described from portswigger, to breakout by "introducing a new attribute that creates a scriptable context:

```html
" autofocus onfocus=alert(document.domain) x="
```
Looking at the [cheat sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet) there are several posible payloads that may actually work with an input tag:

```html
<input type=image src=1 onerror=alert(1)>
<input autofocus onfocus=alert(1)>
<input type=image src=validimage.png onload=alert(1)>
ect..
```

To transform them each into a context that an exist inside an input tag:

```html
" type=image src=1 onerror=alert(1) x="
" autofocus onfocus=alert(1) x="
" type=image src=validimage.png onload=alert(1) x="
```
# Step 4 Try breakout payloads

![image](https://user-images.githubusercontent.com/83407557/211164243-2d11d8f5-9d30-4e0d-9cb1-a886a1451d3e.png)

This fails as there is already a type attribute:

![image](https://user-images.githubusercontent.com/83407557/211164360-57c31d61-e18d-4ed1-95d2-4df27b988fb1.png)

This rules out several of the found payloads, so next I try the autofocus payload:

![image](https://user-images.githubusercontent.com/83407557/211164410-b610ac04-1b7a-40f2-80e8-e9b6bb64144e.png)

Which gets XSS to execute:

![image](https://user-images.githubusercontent.com/83407557/211164430-fea5f7ae-96e3-4288-8718-94fc9df258b8.png)

Looking at the response it can be seen why this happens:

![image](https://user-images.githubusercontent.com/83407557/211164496-62ecb489-8780-4fa6-9c59-e399e86c137c.png)

The lab has now been solved:

![image](https://user-images.githubusercontent.com/83407557/211164508-23dbf48b-b9b8-40dd-85e7-a1bb46a72493.png)
