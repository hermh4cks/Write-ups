# Lab: Reflected XSS in canonical link tag

 This lab reflects user input in a canonical link tag and escapes angle brackets.

To solve the lab, perform a cross-site scripting attack on the home page that injects an attribute that calls the alert function.

To assist with your exploit, you can assume that the simulated user will press the following key combinations:

    ALT+SHIFT+X
    CTRL+ALT+X
    Alt+X

Please note that the intended solution to this lab is only possible in Chrome. 

## Research

From [this](https://portswigger.net/research/xss-in-hidden-input-fields) blogpost

*Eventually I thought about access keys and wondered if the onclick event would be called on the hidden input when it activated via an access key. It most certainly does on Firefox! This means we can execute an XSS payload inside a hidden attribute, provided you can persuade the victim into pressing the key combination. On Firefox Windows/Linux the key combination is ALT+SHIFT+X and on OS X it is CTRL+ALT+X. You can specify a different key combination using a different key in the access key attribute. Here is the vector:*
```html
<input type="hidden" accesskey="X" onclick="alert(1)">
```

*This technique now works in Chrome! It also works in link elements that means previously unexploitable XSS bugs in link elements where you only control attributes can be exploited using this technique. For example you might have a link element with a rel attribute on canonical, if you inject the accesskey attribute with an onclick event then you have XSS.*

```html
<link rel="canonical" accesskey="X" onclick="alert(1)" />
```
POC:
![image](https://user-images.githubusercontent.com/83407557/211166009-e0e54f2b-1724-4421-a19c-d0ee4f8de0b3.png)

# Step 1 Find that the home page is being represented with a canonical link tag:

![image](https://user-images.githubusercontent.com/83407557/211166690-3adb535e-a463-4f1f-869b-c47157ed44d6.png)

# Step 2 Create a payload using the research from above

Noting that the url for the homepage is https://0ace002503e63ae8c00caeab003d000c.web-security-academy.net/

I want to try and add an accesskey attribute and an onclick event, I also need to try to break out of the single quotes being used:

```
https://0ace002503e63ae8c00caeab003d000c.web-security-academy.net/?'accesskey='X'onclick='alert(1)
```

Inspecting the page, it can be seen how this escapes the quotes and adds the attribute and element to the page:

![image](https://user-images.githubusercontent.com/83407557/211167258-5affcaff-b522-4cc4-b6b3-38ddd4c072af.png)

or using burp's HTTP history:

![image](https://user-images.githubusercontent.com/83407557/211167342-bbcb54a4-190c-47e3-a2a9-ea45076a53ca.png)

Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/211167273-4ec57650-a761-4c0e-8d93-bb60ecb50c8f.png)

I can also test it by hitting ALT+X:

![image](https://user-images.githubusercontent.com/83407557/211167368-842f4431-a4ef-4873-8d9c-f638734ef531.png)
