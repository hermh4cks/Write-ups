# Lab: DOM XSS in AngularJS expression with angle brackets and double quotes HTML-encoded

 This lab contains a DOM-based cross-site scripting vulnerability in a AngularJS expression within the search functionality.

AngularJS is a popular JavaScript library, which scans the contents of HTML nodes containing the ng-app attribute (also known as an AngularJS directive). When a directive is added to the HTML code, you can execute JavaScript expressions within double curly braces. This technique is useful when angle brackets are being encoded.

To solve this lab, perform a cross-site scripting attack that executes an AngularJS expression and calls the alert function. 

# Step 1 Check search functionality using DOM invader

I enter a canary into the search field:

![image](https://user-images.githubusercontent.com/83407557/211351765-bcfe5539-8936-4b50-90f6-2c71c5dd9062.png)

I find that the canary is present in several sources:

![image](https://user-images.githubusercontent.com/83407557/211352663-9109c077-5760-4c3a-8a97-525695ce3c41.png)

I also run a stack trace and see that angular js is being used:

![image](https://user-images.githubusercontent.com/83407557/211352869-dcc0c616-61e9-4702-9c5a-4804a0043615.png)

And in burps target tab, I can see that this version is vulnerable to several attacks:

![image](https://user-images.githubusercontent.com/83407557/211353707-51afd329-af13-40e9-ac31-47bf28ab5a82.png)

# Step 2 Find payloads from [Cheat Sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet)

I find a few that I can try:

![image](https://user-images.githubusercontent.com/83407557/211354362-7043136a-d418-4e51-922f-83b07109669d.png)


```javascript
{{constructor.constructor('alert(1)')()}}
{{$on.constructor('alert(1)')()}}
```

# Step 3 test payloads

**`{{constructor.constructor('alert(1)')()}}`**

![image](https://user-images.githubusercontent.com/83407557/211355028-f0a7c7ad-e75e-42f0-a201-cc300ba474c4.png)

**`{{$on.constructor('alert(1)')()}}`**

![image](https://user-images.githubusercontent.com/83407557/211355273-41a74d93-cdf0-4c3c-af73-3897bbbdd052.png)

I find that either payload is valid, and solve the lab:

![image](https://user-images.githubusercontent.com/83407557/211355368-dcc2e336-3541-4d5f-b12f-c77ed3c644d8.png)
