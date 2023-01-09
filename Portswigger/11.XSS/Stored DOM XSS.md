# Lab: Stored DOM XSS

This lab demonstrates a stored DOM vulnerability in the blog comment functionality. To solve this lab, exploit this vulnerability to call the alert() function. 

# Step 1 Find sources and sinks

Using my DOM invader canary, I put it in every input that I can find when posting a comment:

![image](https://user-images.githubusercontent.com/83407557/211371763-6414ffeb-21b5-455c-bfaa-9dc98b870281.png)

And find several sinks:

![image](https://user-images.githubusercontent.com/83407557/211371903-7e04e443-6828-44c4-8d4e-08a4bdecf6eb.png)

# Step 2 create a payload

Trying to add a script tag to the author field, I can see that angle brackets are encoded:

![image](https://user-images.githubusercontent.com/83407557/211373285-3662eb52-2b86-4534-962e-b6c24dfce0ca.png)

If I try and inject javascript into the href of the website field:

![image](https://user-images.githubusercontent.com/83407557/211374091-faa3a99d-53ce-46c1-a2f4-5341b160b414.png)

It gets blocked client-side

![image](https://user-images.githubusercontent.com/83407557/211374168-9f9f7042-4c2f-4a71-b419-d7828024dcdb.png)

So I change it to a valid format

![image](https://user-images.githubusercontent.com/83407557/211374301-33a789e7-8dbe-40f9-89ee-4d2b47c74756.png)

But intercept the request:

![image](https://user-images.githubusercontent.com/83407557/211374437-9bbcabe8-34c3-4142-b0cd-ed6195bcf077.png)

And change it back before forwarding the request:

![image](https://user-images.githubusercontent.com/83407557/211374580-1c6dc36c-4894-442c-a5e4-76cf1cebaa4c.png)

But also get blocked server-side

![image](https://user-images.githubusercontent.com/83407557/211374674-5db66969-b1e1-41de-8872-cb3e5f849bf9.png)

# Step 3 Inspect code

Looking at how the javascript is encoding angle brackets, I notice something interesting:

Why did my `<script>` tag get encoded and returned, while the closing tag `</script>` never apears on the page

![image](https://user-images.githubusercontent.com/83407557/211377202-76b25e44-851b-4749-b480-5b6285b832d0.png)

I find why when looking at the code, only the frist angle brackets are encoded

```javascript
    function escapeHTML(html) {
        return html.replace('<', '&lt;').replace('>', '&gt;');
    }

```

Meaning that if I just send a set before my payload, the remaining angle brackets will be left alone:

![image](https://user-images.githubusercontent.com/83407557/211378074-581e9e8a-1adb-46ea-b823-b0ccd85b3939.png)

![image](https://user-images.githubusercontent.com/83407557/211378168-8d25908b-e472-47d2-8540-b2b74590d138.png)

With this I can create two simple XSS payloads as long as I enter a set of angle brackets first

```html
<><img src onerror=alert(1)>
```
![image](https://user-images.githubusercontent.com/83407557/211378688-0b8176bc-459a-4fd4-b526-30e5717f57ba.png)

![image](https://user-images.githubusercontent.com/83407557/211378851-e09a7794-70cc-4728-91dd-74cb11919a35.png)


![image](https://user-images.githubusercontent.com/83407557/211378755-aa8f1458-c1e4-4e82-8e52-38fd8c35770c.png)

So both the name and comment fields are vulnerable, which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/211379021-b7ba47c8-f033-45f5-84c5-63cbded5aeab.png)


