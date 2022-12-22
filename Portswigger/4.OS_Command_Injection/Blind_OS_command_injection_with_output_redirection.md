# Lab: Blind OS command injection with output redirection

 This lab contains a blind OS command injection vulnerability in the feedback function.

The application executes a shell command containing the user-supplied details. The output from the command is not returned in the response. However, you can use output redirection to capture the output from the command. There is a writable folder at:
/var/www/images/

The application serves the images for the product catalog from this location. You can redirect the output from the injected command to a file in this folder, and then use the image loading URL to retrieve the contents of the file.

To solve the lab, execute the whoami command and retrieve the output. 

## What is output redirection

Just as a quick example with bash

I can see that /tmp/whoami doesn't exist:

```bash
└─$ ls -la /tmp/whoami        
ls: cannot access '/tmp/whoami': No such file or directory
```

I can use echo to show the whoami command to standard output:

```
└─$ echo $(whoami)                                                                                             2 ⨯
hermh4cks
```

If I wasn't able to see what was being sent to standard output, I could redirect the output to a file:

```bash
└─$ echo $(whoami) > /tmp/whoami
```
Then I could view the results 

```bash
└─$ ls -la /tmp/whoami
-rw-r--r-- 1 hermh4cks hermh4cks 5 Dec 22 11:30 /tmp/whoami
└─$ cat /tmp/whoami        
hermh4cks
```

# Step 1 find directory where the images are being stored

Opening an image on a new page, I see that files are being passed to a file parameter

![image](https://user-images.githubusercontent.com/83407557/209181181-bc36f2c2-d3c8-42c0-88c9-c95afe4214cd.png)

I was already told that this directory is /var/www/images/


# Step 2 Find OS command injection in feedback function:

First I submit feedback and capture the request with burp

![image](https://user-images.githubusercontent.com/83407557/209183746-130a434a-e828-44fa-a26c-d7d6758ecf9c.png)


Looking at the request I see that it is potentially vulnerable to command injection:

![image](https://user-images.githubusercontent.com/83407557/209184438-9a755d29-988f-4586-9577-de81d998bd74.png)

# Step 3 build a payload

The payload I want in order to output the whoami command to the /var/www/images directory is as follows:

```bash
echo $(whoami)>/var/www/images/whoami
```
I will try this payload at each of the potential injection points of the POST request:

![image](https://user-images.githubusercontent.com/83407557/209185464-98d846d5-f7d3-4fc3-af62-b4a9619feee4.png)


# Step 4 get output of new file

If any of these params are vulnerable, I can go back to the image and replace the image filename with my newly made filename "whoami"

![image](https://user-images.githubusercontent.com/83407557/209186020-84197a6b-2549-4e53-8bb5-77d8b9244771.png)

looking at the http history in burp, I can see the contents of the file:

![image](https://user-images.githubusercontent.com/83407557/209186268-57ffb736-ec0c-42d5-bab0-cc98662da4f3.png)


Which solves the lab

![image](https://user-images.githubusercontent.com/83407557/209186344-2e64edcd-d2f0-4f37-b046-08bbf246f481.png)
