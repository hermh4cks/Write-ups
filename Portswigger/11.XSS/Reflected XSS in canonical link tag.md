# Lab: Reflected XSS in canonical link tag

 This lab reflects user input in a canonical link tag and escapes angle brackets.

To solve the lab, perform a cross-site scripting attack on the home page that injects an attribute that calls the alert function.

To assist with your exploit, you can assume that the simulated user will press the following key combinations:

    ALT+SHIFT+X
    CTRL+ALT+X
    Alt+X

Please note that the intended solution to this lab is only possible in Chrome. 

## Research

From [this](https://portswigger.net/research/xss-in-hidden-input-fields) blogpost

*Eventually I thought about access keys and wondered if the onclick event would be called on the hidden input when it activated via an access key. It most certainly does on Firefox! This means we can execute an XSS payload inside a hidden attribute, provided you can persuade the victim into pressing the key combination. On Firefox Windows/Linux the key combination is ALT+SHIFT+X and on OS X it is CTRL+ALT+X. You can specify a different key combination using a different key in the access key attribute. Here is the vector:*
```html
<input type="hidden" accesskey="X" onclick="alert(1)">
```

*This technique now works in Chrome! It also works in link elements that means previously unexploitable XSS bugs in link elements where you only control attributes can be exploited using this technique. For example you might have a link element with a rel attribute on canonical, if you inject the accesskey attribute with an onclick event then you have XSS.*

```html
<link rel="canonical" accesskey="X" onclick="alert(1)" />
```
POC:
![image](https://user-images.githubusercontent.com/83407557/211166009-e0e54f2b-1724-4421-a19c-d0ee4f8de0b3.png)

