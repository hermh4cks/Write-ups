# Lab: Reflected XSS into a JavaScript string with angle brackets HTML encoded

This lab contains a reflected cross-site scripting vulnerability in the search query tracking functionality where angle brackets are encoded. The reflection occurs inside a JavaScript string. To solve this lab, perform a cross-site scripting attack that breaks out of the JavaScript string and calls the alert function.

## Research from portswigger:

Breaking out of a JavaScript string

In cases where the XSS context is inside a quoted string literal, it is often possible to break out of the string and execute JavaScript directly. It is essential to repair the script following the XSS context, because any syntax errors there will prevent the whole script from executing.

Some useful ways of breaking out of a string literal are: 

```html
'-alert(document.domain)-'
';alert(document.domain)//
```

# Step 1 Find reflected input

When I do a search for a string:

![image](https://user-images.githubusercontent.com/83407557/211168013-be0b2e2a-67e4-48a7-adc3-60786604f265.png)

I can see my input reflected on the response page:

![image](https://user-images.githubusercontent.com/83407557/211168039-9963261d-8732-49eb-a8c9-5f002587bc3b.png)

Looking at the response in burp, I see that I am inside a code-block:

![image](https://user-images.githubusercontent.com/83407557/211168105-8c1c7530-764b-45eb-b0f6-92427cdca5a0.png)

# Step 2 Break out of the string literal

If I try and break the single quote and execute my own script I first try:

```html
'-alert(document.domain)-'
```
![image](https://user-images.githubusercontent.com/83407557/211168198-c62ee2d7-8018-4d7c-b84e-01f38a5a1f56.png)

And get a pop-up:

![image](https://user-images.githubusercontent.com/83407557/211168219-ecf7c5b7-0fce-4001-b125-b673a5683182.png)

Viewing the response in burp, I can see why this executes:

![image](https://user-images.githubusercontent.com/83407557/211168249-b8eadc4c-08ae-4c8f-805c-e521cd476c27.png)

Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/211168260-5763c99a-4a15-4604-bdf1-4f874e008b99.png)

Just to test, the other payload:

```html
';alert(document.domain)//
```

Also works

![image](https://user-images.githubusercontent.com/83407557/211168306-96f84dbf-9714-4124-97c4-3835c8105105.png)

![image](https://user-images.githubusercontent.com/83407557/211168336-d44186ca-f35f-40e9-94fc-3b476f3b0805.png)

As would this:

```html
';alert(document.domain);//
```

![image](https://user-images.githubusercontent.com/83407557/211168475-5658026f-a019-41b6-9bcf-5b26e9c6d49c.png)
