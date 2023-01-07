# Lab: Reflected XSS into a JavaScript string with angle brackets and double quotes HTML-encoded and single quotes escaped

 This lab contains a reflected cross-site scripting vulnerability in the search query tracking functionality where angle brackets and double are HTML encoded and single quotes are escaped.

To solve this lab, perform a cross-site scripting attack that breaks out of the JavaScript string and calls the alert function. 

# Step 1 Find Reflected input

When I perform a search:

![image](https://user-images.githubusercontent.com/83407557/211168681-fa2a1b6c-0f2a-40cb-93aa-2b4653a60c85.png)

I see my input is reflected on the response:

![image](https://user-images.githubusercontent.com/83407557/211168694-50115d2d-4e7c-457b-991d-c74beec6601f.png)

Looking a burp history, I find that my input is inside a code-block:

![image](https://user-images.githubusercontent.com/83407557/211168722-4bca07f2-fd41-4c4d-aaa4-ac2487cc1230.png)

# Step 2 Find what input is getting encoded and escaped

I want to enter a characters that can be used to perform XSS and see how they are returned on the page:

`<>'"`

![image](https://user-images.githubusercontent.com/83407557/211168779-b203f99b-196c-498d-8bd3-a161c5a454be.png)

![image](https://user-images.githubusercontent.com/83407557/211168793-641d22df-4bad-41e3-9ce8-65a0f714a1e2.png)

I see the following

| Character | Converted to | What happened? |
| - | - | - |
| `<` | `&lt` | encoded |
| `>` | `&gt` | encoded |
| `"` | `&guot` | encoded |
| `'` | `\'` | escaped |

With this in mind, I am not goint to be able to use angle brackets or double quotes for the attack, however if the escape character `\` is allowed I can escape the escape character.

# Step 3 Create a payload

First I want to see if I am able to send an escape character:

![image](https://user-images.githubusercontent.com/83407557/211168960-398de510-89f9-41b6-8b2a-ed2e77abdb12.png)

And I see that it goes through

![image](https://user-images.githubusercontent.com/83407557/211168981-8da1ce84-6070-4689-9846-7aa54f3acbc7.png)

Next I build a payload that will escape the escape that is messing with my single quote and then also coment out the `;` at the end of the line (to not just break the script)

```html
\';I CAN CONTROL THIS//
```
![image](https://user-images.githubusercontent.com/83407557/211169095-6fc062be-9fb5-471c-a022-a86340ab8360.png)

And I find that I can inject my own malicious javascript within this script tag:

![image](https://user-images.githubusercontent.com/83407557/211169139-bc85898a-264f-478f-bee1-8b1a73100fc7.png)

So I build an alert payload:

```html
\';alert(document.domain)//
```

![image](https://user-images.githubusercontent.com/83407557/211169231-e7f73898-64dd-4ffd-828f-fd8a4f235331.png)

Causing an alert:

![image](https://user-images.githubusercontent.com/83407557/211169243-da81aa60-f3cf-45da-9e83-e5a846e68dc1.png)

![image](https://user-images.githubusercontent.com/83407557/211169257-3f4b03a0-5991-4820-a3bf-e4c65279e396.png)

And solves the lab:

![image](https://user-images.githubusercontent.com/83407557/211169280-7b5ca1c3-91b5-41c3-84ee-a8881f1ba0a7.png)
