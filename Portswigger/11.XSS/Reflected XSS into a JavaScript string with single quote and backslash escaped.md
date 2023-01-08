# Lab: Reflected XSS into a JavaScript string with single quote and backslash escaped

 This lab contains a reflected cross-site scripting vulnerability in the search query tracking functionality. The reflection occurs inside a JavaScript string with single quotes and backslashes escaped.

To solve this lab, perform a cross-site scripting attack that breaks out of the JavaScript string and calls the alert function. 

# Step 1 Find where input is being reflected on the page

When I make a search:

![image](https://user-images.githubusercontent.com/83407557/211176082-001878e7-377d-465e-aee1-a7c4c863704d.png)

I see my input reflected in the response:

![image](https://user-images.githubusercontent.com/83407557/211176102-47992e4a-2747-4244-ae51-e8e7d60edecb.png)

I also see that the input exists inside a script block in the response:

![image](https://user-images.githubusercontent.com/83407557/211176129-85f76034-af32-4f62-ab61-c00748c869e1.png)

# Step 2 Find which characters are encoded and escaped

I want to see what characters that are going to be useful for XSS are going to be escaped and encoded in some was within this script block. Each of the following characters could potentially be useful to me:

```html
/ \ < > ' " - 
```
![image](https://user-images.githubusercontent.com/83407557/211176189-27adc6bf-fd36-416c-b321-75860af5ef91.png)

I find the following:

![image](https://user-images.githubusercontent.com/83407557/211176215-d067249e-40a4-48c3-8c5a-4379b0e3fbab.png)

backslashes `\` and single quotes `'` are escaped, so I cannot escape them on my own. However the slash `/` and angle brackets `<>` are going through, so I can terminate the script tag:

# Step 3 Break out of code block

I can try and break out of the script block by terminating the script with </script>:

![image](https://user-images.githubusercontent.com/83407557/211176351-745aacc6-295a-47ef-bb38-ade228bce6dc.png)

I can see that it breaks before ever even looking at the script block:

![image](https://user-images.githubusercontent.com/83407557/211176363-870654f7-a471-4cb6-9464-6223a4d74553.png)

However looking in burp history, I can see why document.write is now showing up under the search bar:

![image](https://user-images.githubusercontent.com/83407557/211176391-3b017411-0b41-4567-9068-20d9c2014a36.png)


# Step 4 Create XSS payload 

I can use the following payload to terminate the origional script block, then inject my own script:

```html
</script><script>alert(document.domain)</script>
```

![image](https://user-images.githubusercontent.com/83407557/211176473-596f4522-0887-482d-a995-663a32e89d35.png)

Which executes XSS:

![image](https://user-images.githubusercontent.com/83407557/211176486-771e5689-a4be-4450-baaa-270f545674fa.png)

![image](https://user-images.githubusercontent.com/83407557/211176494-fcffe3e0-1996-40f2-b37b-495c16771884.png)

Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/211176516-036268ee-7544-46bc-820b-f56881896d31.png)
