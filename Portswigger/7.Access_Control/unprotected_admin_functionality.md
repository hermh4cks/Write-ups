# Lab: Unprotected admin functionality

## Description

 This lab has an unprotected admin panel.

Solve the lab by deleting the user carlos. 

# Step 1 Brute force directories

For this I will be using gobuster, but proxying through burp incase I need to use it later.

the command will be 

```
gobuster dir -u "url to brutefoce" -w "path-to-wordlist" -p "burp's proxy address"
```

![image](https://user-images.githubusercontent.com/83407557/171257740-ffec71d0-7720-4e77-975b-92b26a2b430c.png)

# Step 2 looks for site map or robots.txt

robots.txt will tell friendly web crawlers which pages should not be indexed for search engines. However checking this page can also reviel content that developers wanted to keep hidden. Like admin panels.

and it would apear that one such panel is listed here

![image](https://user-images.githubusercontent.com/83407557/171258162-c699f281-8a3b-40d2-b45f-42a122316228.png)

# Step 3 go to found administrator-panel

It is not protected in anyway and we log right in

![image](https://user-images.githubusercontent.com/83407557/171258305-987f3f9e-c5b6-4ba0-948d-b2a3028e9b1c.png)

# Step 4 Delete Carlos

![image](https://user-images.githubusercontent.com/83407557/171258469-74e39ab8-5a86-4876-9b0f-2fc1647d1b4e.png)
