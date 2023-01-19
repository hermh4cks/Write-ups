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

```php
O:4:"User":2:{s:8:"username";s:6:"wiener";s:12:"access_token";s:32:"yl39nsun020qly1w1uy03cxalj4i0pii";}
```
