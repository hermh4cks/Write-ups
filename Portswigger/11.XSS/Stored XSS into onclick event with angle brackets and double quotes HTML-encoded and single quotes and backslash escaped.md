# Lab: Stored XSS into onclick event with angle brackets and double quotes HTML-encoded and single quotes and backslash escaped

 This lab contains a stored cross-site scripting vulnerability in the comment functionality.

To solve this lab, submit a comment that calls the alert function when the comment author name is clicked. 

## Notes from portswigger:

 When the XSS context is some existing JavaScript within a quoted tag attribute, such as an event handler, it is possible to make use of HTML-encoding to work around some input filters.

When the browser has parsed out the HTML tags and attributes within a response, it will perform HTML-decoding of tag attribute values before they are processed any further. If the server-side application blocks or sanitizes certain characters that are needed for a successful XSS exploit, you can often bypass the input validation by HTML-encoding those characters.

For example, if the XSS context is as follows: 

```html
<a href="#" onclick="... var input='controllable data here'; ...">
```
 and the application blocks or escapes single quote characters, you can use the following payload to break out of the JavaScript string and execute your own script: 
 
 ```html
&apos;-alert(document.domain)-&apos;
```

 The `&apos;` sequence is an HTML entity representing an apostrophe or single quote. Because the browser HTML-decodes the value of the onclick attribute before the JavaScript is interpreted, the entities are decoded as quotes, which become string delimiters, and so the attack succeeds. 

# Step 1 Find stored input

I enter payloads in the comment fields:

![image](https://user-images.githubusercontent.com/83407557/211382541-66831f37-28bd-43f0-a281-df3710387f08.png)

And get an error:

![image](https://user-images.githubusercontent.com/83407557/211382652-b42d0675-b08f-4d85-a60a-4956360a02c2.png)

Checking the source I see something very similar to portswigger's example above on the page when viewing my comment:

![image](https://user-images.githubusercontent.com/83407557/211383364-65d76927-9557-4735-be93-9cb8616b6e36.png)

# Step 2

Trying the payload in the website field:

```html
&apos;-alert(document.domain)-&apos;
```
![image](https://user-images.githubusercontent.com/83407557/211383617-61323a03-f406-4f35-a918-37c328795778.png)

I get an error:

![image](https://user-images.githubusercontent.com/83407557/211383746-8da75f5a-85c5-42a6-988f-ffc725754fbf.png)

changing to 

```html
http://&apos;-alert(document.domain)-&apos;.com
```

I view the source after posting:

![image](https://user-images.githubusercontent.com/83407557/211384174-221fc3bc-2e88-4fd3-be49-a473966c2ef9.png)

And when I click my link, I get an alert window:

![image](https://user-images.githubusercontent.com/83407557/211384281-a924efb3-934e-4704-9789-5e24b1ec7d8f.png)

However the link is broken an the lab is not solved:

![image](https://user-images.githubusercontent.com/83407557/211385065-c916ff17-0ddb-46e4-b716-352f7c4f358d.png)

However adding a valid website first:

![image](https://user-images.githubusercontent.com/83407557/211385552-a6ec780b-bdde-41d5-8090-a765c4f9436d.png)

Still doesn't go to an acual page:

![image](https://user-images.githubusercontent.com/83407557/211386123-e15df4af-1e1b-4ed8-b936-79e065943fb3.png)

but will solve the lab

![image](https://user-images.githubusercontent.com/83407557/211385619-c669bf9b-fbd7-436d-8dda-e1477448907e.png)

alternatively a random parameter name also solves the lab (more gracefully?)

![image](https://user-images.githubusercontent.com/83407557/211385832-26cffdbd-d9bf-4a77-9c2d-fa26301694ed.png)

![image](https://user-images.githubusercontent.com/83407557/211385932-c571a257-b72f-47dd-97d7-46af0b9fe46a.png)


