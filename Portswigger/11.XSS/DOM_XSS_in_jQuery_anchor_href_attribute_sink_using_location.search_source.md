# Lab: DOM XSS in jQuery anchor href attribute sink using location.search source

## Description

 This lab contains a DOM-based cross-site scripting vulnerability in the submit feedback page. It uses the jQuery library's $ selector function to find an anchor element, and changes its href attribute using data from location.search.

To solve this lab, make the "back" link alert document.cookie. 

## Tips From Portswigger

If a JavaScript library such as jQuery is being used, look out for sinks that can alter DOM elements on the page. For instance, jQuery's attr() function can change the attributes of DOM elements. If data is read from a user-controlled source like the URL, then passed to the attr() function, then it may be possible to manipulate the value sent to cause XSS. For example, here we have some JavaScript that changes an anchor element's href attribute using data from the URL: 

```js
$(function() {
	$('#backLink').attr("href",(new URLSearchParams(window.location.search)).get('returnUrl'));
});
```

You can exploit this by modifying the URL so that the location.search source contains a malicious JavaScript URL. After the page's JavaScript applies this malicious URL to the back link's href, clicking on the back link will execute it: 

```js
?returnUrl=javascript:alert(document.domain)
```

# Step 1 Review webapp

Note that jQuery is used

![image](https://user-images.githubusercontent.com/83407557/172033088-2caf4e95-122c-4139-ab65-3f79eb6bfde6.png)

Looking at feedback code, I see it looks like the portswigger example.

```js
 $(function() {
                                $('#backLink').attr("href", (new URLSearchParams(window.location.search)).get('returnPath'));
                            });
                     
```

# Step 2 inject unique string into attr via return path parameter, and see if it is reflected on page

![image](https://user-images.githubusercontent.com/83407557/172050312-e9a85e66-b616-46b3-905c-5e2f50841131.png)

![image](https://user-images.githubusercontent.com/83407557/172050344-f400804a-b370-4f62-b3e5-3122a8ae02f8.png)


# Step 3 inject XSS into backLink

As in the example I can do this via the url of my browser, replacing document.domain to document.cookie

![image](https://user-images.githubusercontent.com/83407557/172033177-9f2cd155-d194-41a4-894a-3e670533add6.png)

viewing the page source, I can see my payload

![image](https://user-images.githubusercontent.com/83407557/172033227-380173c4-86de-48ef-9dc8-a9b5f5c0c518.png)


Now hitting back executes my js

![image](https://user-images.githubusercontent.com/83407557/172033238-576f7799-04e9-400a-a630-164d0c15c962.png)
