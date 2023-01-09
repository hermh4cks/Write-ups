# Lab: Reflected XSS into a template literal with angle brackets, single, double quotes, backslash and backticks Unicode-escaped

This lab contains a reflected cross-site scripting vulnerability in the search blog functionality. The reflection occurs inside a template string with angle brackets, single, and double quotes HTML encoded, and backticks escaped. To solve this lab, perform a cross-site scripting attack that calls the alert function inside the template string. 

### Notes from Portswigger

 JavaScript template literals are string literals that allow embedded JavaScript expressions. The embedded expressions are evaluated and are normally concatenated into the surrounding text. Template literals are encapsulated in backticks instead of normal quotation marks, and embedded expressions are identified using the ${...} syntax.

For example, the following script will print a welcome message that includes the user's display name: 

```html
document.getElementById('message').innerText = `Welcome, ${user.displayName}.`;
```
 When the XSS context is into a JavaScript template literal, there is no need to terminate the literal. Instead, you simply need to use the ${...} syntax to embed a JavaScript expression that will be executed when the literal is processed. For example, if the XSS context is as follows: 

```html
 <script>
...
var input = `controllable data here`;
...
</script>
```
 then you can use the following payload to execute JavaScript without terminating the template literal: 
 
 ```html
${alert(document.domain)}
```

# Step 1 Find input being reflected in response

Searching for a string:

![image](https://user-images.githubusercontent.com/83407557/211389128-fa23ebf7-fd1e-4efa-b369-e63053134904.png)

I see it reflected on the page:

![image](https://user-images.githubusercontent.com/83407557/211389242-df22ee4e-b000-4258-9b0e-163303060cb0.png)

# Step 2 find what characters are escaped and or encoded

Searching for useful characters:

![image](https://user-images.githubusercontent.com/83407557/211389422-f3f50866-daf5-451c-ba74-844e45c631d8.png)

![image](https://user-images.githubusercontent.com/83407557/211389478-319425e7-eb7a-49cf-a4b8-ec24b8a0dc66.png)

I see that all the characters other than `{}` are unicode-escaped:

![image](https://user-images.githubusercontent.com/83407557/211389760-b22820a2-bdca-4d93-897b-1b3678adc1cd.png)

# Step 3 Try a POC payload

I want to see if I can cause template injecting with the following

```html
${7*7}
```
![image](https://user-images.githubusercontent.com/83407557/211390292-22b45dd9-482c-438b-87f1-d5055d300c1b.png)

And I see that the result is 49, telling me I have template injection:

![image](https://user-images.githubusercontent.com/83407557/211390392-079c74b5-733d-49c9-9922-47a3ccd108dd.png)

# Step 4 Create an XSS payload

To call an alert function using the same template injection, I use the following:

```html
${alert(document.domain)}
```
![image](https://user-images.githubusercontent.com/83407557/211390599-eddbe35f-49e2-4d4a-949f-122830504b02.png)

Causing an alert:

![image](https://user-images.githubusercontent.com/83407557/211390651-82f1ca0a-dd2e-4575-8a48-d71dbe4314a9.png)

And solving the lab:

![image](https://user-images.githubusercontent.com/83407557/211390724-9a1e06e6-7613-43f5-aaac-9ad452d74856.png)


