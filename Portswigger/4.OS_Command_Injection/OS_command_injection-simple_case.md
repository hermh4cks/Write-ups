# Lab: OS command injection, simple case

 This lab contains an OS command injection vulnerability in the product stock checker.

The application executes a shell command containing user-supplied product and store IDs, and returns the raw output from the command in its response.

To solve the lab, execute the whoami command to determine the name of the current user.

# Step 1 walk the application

Specifically I want to see how this webapp is checking the stock of products:

![image](https://user-images.githubusercontent.com/83407557/209016144-792227f4-478d-4431-a0da-1e4a7b421f77.png)

![image](https://user-images.githubusercontent.com/83407557/209016196-6a82e53a-acad-4ac2-ae98-1dcb25b22035.png)

![image](https://user-images.githubusercontent.com/83407557/209016306-92d2eec4-90ea-4981-9889-1a4c54f5377c.png)

![image](https://user-images.githubusercontent.com/83407557/209016368-717dc1b0-b453-475e-86c3-a3b2aa5b21e6.png)

# Step 2 plan the attack

In many shell scripting language commands can be chained together using various charaters, you can pipe output with `| < > ` or have processes run at the same time wiht `&` or `&&`, and have commands run one after another on a single line with `;`.

Example:
```bash
└─$ echo 1;echo 2;echo 3        
1
2
3

└─$ echo 1&echo 2&echo 3
1
[1] 504765
2
[2] 504766
[1]  - done       echo 1
3
[2]  + done       echo 2  

└─$ echo 1&&echo 2&&echo 3
1
2
3
```

Because the check stock request is being passed as `productId=1&storeId=1` to a program on the sever there could be several ways to form a POC to get OS command injection.

# Step 3 Test for RCE(command injection)

Sending this to repeater we can form a POC to write hello world onto the page

![image](https://user-images.githubusercontent.com/83407557/209017809-b3115a6d-a3e7-4adc-94b2-76deba9d89b2.png)

# Step 4 exucte whoami

I also exucte some other usefull commands to get some background on the target:

![image](https://user-images.githubusercontent.com/83407557/209018574-9596fce1-8f43-4151-a70f-47b981246a23.png)

This can be used to build a reverse shell onto the server, a webshell backdoor or basically anything that the server can do, this vuln for an attacker is like getting the keys to the kingdom.

However with just getting whoami to execute I solve the lab:

![image](https://user-images.githubusercontent.com/83407557/209018981-7a43d07e-bde4-41ad-9e20-4aec3c0e8c27.png)

