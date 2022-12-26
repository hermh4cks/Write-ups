# Lab: Source code disclosure via backup files

This lab leaks its source code via backup files in a hidden directory. To solve the lab, identify and submit the database password, which is hard-coded in the leaked source code. 

# Step 1 directory brute-force

Normally, I would manually inspect the webapp as a first step. However, since the lab description said that the info leak was going to be found inside of a hidden directory, I am going to start this time with a basic directory brute-force using burp intruder:

### Sending web root to intruder attack

![image](https://user-images.githubusercontent.com/83407557/209584135-bacbbaa7-b0e4-4197-8755-5d734f33e86f.png)

### Adding a payload position infront of the root directory

![image](https://user-images.githubusercontent.com/83407557/209584177-a8965297-437f-48fc-80a9-c5261719022c.png)

### Selecting directories-long payload

![image](https://user-images.githubusercontent.com/83407557/209584233-d0650030-8822-4d06-865a-d5d37fa0c277.png)

### Checking results

I find there is an accessable directory called backup, after I sort by status codes

![image](https://user-images.githubusercontent.com/83407557/209584500-3c92f856-fbbc-41d0-be24-e020366302be.png)

# Step 2 inspect /backup directory

I find a file in the /backup directory called ProductTemplate.java.bak

![image](https://user-images.githubusercontent.com/83407557/209584661-beba7b35-b4ae-4183-870d-81cddba88ce4.png)

# Step 3 inspecting ProductTemplate.java.bak

Using wget, I download the file I found:

![image](https://user-images.githubusercontent.com/83407557/209584808-a682d9be-e632-4d48-95fe-67b47da7d943.png)

Using File, I see that it contains text:

![image](https://user-images.githubusercontent.com/83407557/209584826-1bf2ece7-c575-4714-b59b-612229e3774c.png)

Viewing the source code directly I find that it contains a postgres DB username and password:

![image](https://user-images.githubusercontent.com/83407557/209584936-2742044a-8e9b-4cd5-b313-22058cc92df9.png)

# Step 4 submit found password

![image](https://user-images.githubusercontent.com/83407557/209584975-eaa5576f-1f37-460c-a661-12a0f8bb20d6.png)

This solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209584999-07da01cc-f2e3-4fd5-83b7-ede0804a5955.png)
