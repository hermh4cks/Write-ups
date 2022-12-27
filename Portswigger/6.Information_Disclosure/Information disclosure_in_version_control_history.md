# Lab: Information disclosure in version control history

This lab discloses sensitive information via its version control history. To solve the lab, obtain the password for the administrator user then log in and delete Carlos's account. 

# Step 1 Directory brute-force

To perform a directory brute-force I go to the http history in burp and send the following to intruder:

![image](https://user-images.githubusercontent.com/83407557/209682769-a1581111-bd4f-43c8-b48b-60fb9f0d8f0a.png)

I use the following payload possition

![image](https://user-images.githubusercontent.com/83407557/209682869-817447d4-44e2-4d2e-b2af-dd3082f864f2.png)

And add a directories-long payload from the default lists in burp

![image](https://user-images.githubusercontent.com/83407557/209683022-8814c3d9-3c51-4349-8f41-5cada0c1ab18.png)

While this shows me previously unknown locations on the webapp, it does not find anything related to version control:

![image](https://user-images.githubusercontent.com/83407557/209683449-6380cb99-eb93-4762-836b-8a7caa6f04eb.png)

## Checking for a .git directory

After failing to find any version control with a wordlist, I manually check for a .git directory and find the developers have left it in the production version of this webapp:

![image](https://user-images.githubusercontent.com/83407557/209684867-2e472f4f-ebb5-4e03-8278-604d31cd14a7.png)

Checking the commit I see a reference to the config:

![image](https://user-images.githubusercontent.com/83407557/209684964-dc45ec86-0581-48fd-a8f7-2561d413fc7e.png)

Checking the current config I see that the admin password has been removed:

![image](https://user-images.githubusercontent.com/83407557/209685235-c79b83b1-58cb-4305-920b-83c620de05ee.png)

I can also see the diffent versions of this app in the logs:

![image](https://user-images.githubusercontent.com/83407557/209685482-23adc852-8cc0-47fa-bc6f-3794efd03bf4.png)

# Step 2 inspecting with git-cola

First I want to download the files with wget with the `-r` flag to download all files recursively:

```bash
└─$ wget -r https://0aa60086044b796dc2ab160400de0029.web-security-academy.net/.git       
```

Then I can go into the directory I just downloaded:

```bash
└─$ ls                 
0aa60086044b796dc2ab160400de0029.web-security-academy.net
└─$ cd 0aa60086044b796dc2ab160400de0029.web-security-academy.net 
```

Then I can open this repository using git-cola to view the changes:

![image](https://user-images.githubusercontent.com/83407557/209688872-c772a2fa-1874-43e7-a322-a7a06aeab47c.png)


I can then undo the last commit using git-cola from the menu Commit>Undo last commit

![image](https://user-images.githubusercontent.com/83407557/209689150-bc4a6963-3fe3-4309-8d3e-a91dad7e7c68.png)

This restores the old admin.conf file

![image](https://user-images.githubusercontent.com/83407557/209689564-1cd38c74-f27d-41bd-ae4a-c61115a932bb.png)

![image](https://user-images.githubusercontent.com/83407557/209689606-123bdfc3-dc97-4313-92dd-0227f79ac8a2.png)

# Step 3 use the found password to login as admin

I use the password on the admin pannel login I found from brute-forcing:

![image](https://user-images.githubusercontent.com/83407557/209689881-d226270c-848e-4d17-b56d-aa8bc3af498e.png)

![image](https://user-images.githubusercontent.com/83407557/209689911-8b686b40-8bcd-46a1-9322-2110c5acc911.png)

From the admin pannel, I can delete the carlos user:

![image](https://user-images.githubusercontent.com/83407557/209689971-88abb1fa-63ce-4ac3-9757-593392ae4ce1.png)

which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209690007-8ab5a5f7-6584-46ee-a803-56921644dc10.png)

