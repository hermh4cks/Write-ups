# Lab: Modifying serialized objects

 This lab uses a serialization-based session mechanism and is vulnerable to privilege escalation as a result. To solve the lab, edit the serialized object in the session cookie to exploit this vulnerability and gain administrative privileges. Then, delete Carlos's account.

You can log in to your own account using the following credentials: wiener:peter 


# Step login and inspect session cookie

When I login to the webapp, I am given a session cookie, using inspector I see that this cookie is encoded twice. First it is URL encoded, then it is base64 encoded. Once decoded I see that this is a PHP serialized object:

![image](https://user-images.githubusercontent.com/83407557/213496556-18a93732-b88d-4b40-805f-a64a85b7368e.png)


# Step 2 inspect decoded cookie

Taking a look at the cookie:

```php
O:4:"User":2:{s:8:"username";s:6:"wiener";s:5:"admin";b:0;}
```

Lets break down what each part of this means:

`O:4:"User":2` - An object with 4-character class name "User" and 2 attributes

`s:8:"username` - the first attribute's key is a 8-character long string "username"

`s:6:"wiener"` - the value of the first attribute is a 6-character long string "wiener"

`s:5:"admin"` - the second attributes' key is a 5-character long string "admin"

`b:0` - the value of the second attribute is the boolean value *false* (0)


# Step 3 modify the cookie object to set admin attribute to true

To set the value of the second attribute to true, I change the `b:0` to `b:1`:

```php
O:4:"User":2:{s:8:"username";s:6:"wiener";s:5:"admin";b:1;}
```

# Step 4 encode the changes

First I want to base64 encode my changes:

![image](https://user-images.githubusercontent.com/83407557/213499668-e7e74cce-62fb-42fd-a3d2-28d00fcdd9cd.png)

```
Tzo0OiJVc2VyIjoyOntzOjg6InVzZXJuYW1lIjtzOjY6IndpZW5lciI7czo1OiJhZG1pbiI7YjoxO30=
```

Next, looking back at the origional decoded cookie, I see that only the `=` is being url-encoded to `%3d`:


![image](https://user-images.githubusercontent.com/83407557/213500053-5b91234e-54cb-42d3-8e14-ec03eb6d5ad0.png)


so that is the only character that I encode as well:

```
Tzo0OiJVc2VyIjoyOntzOjg6InVzZXJuYW1lIjtzOjY6IndpZW5lciI7czo1OiJhZG1pbiI7YjoxO30%3d
```

# Step 5 capture the request to my-account and change the cookie value

With intercept on, I capture the request for my account

![image](https://user-images.githubusercontent.com/83407557/213501519-7c16a9a7-0296-4336-88d1-4b7f9cdffcbd.png)

From here, I can either paste in my edited cookie, or just change it in inspector and hit apply changes:

![image](https://user-images.githubusercontent.com/83407557/213502185-91b4943c-7fbc-41ac-b462-2d71f30c2020.png)


# Step 6 delete carlos

Having changed my cookie, the app now thinks that I am an admin, and therefore I have access to the admin panel:

![image](https://user-images.githubusercontent.com/83407557/213503669-04e1138b-5022-409c-9306-4e1ba8ffab22.png)

However, I need to modify my cookie again to gain access:

![image](https://user-images.githubusercontent.com/83407557/213504055-5d45ba99-fb1d-4817-93fe-005c5b5f5fa8.png)

![image](https://user-images.githubusercontent.com/83407557/213504164-5bdcc4fd-4f82-4bb1-a8d6-8b16cd93086f.png)

I change my cookie a final time to delete carlos:

![image](https://user-images.githubusercontent.com/83407557/213504333-1591eb4c-43b1-4e9a-9211-65f5b251a88b.png)

And in doing so, I solve the lab:

![image](https://user-images.githubusercontent.com/83407557/213504444-80be690e-301a-4668-b071-e90743c990c1.png)
