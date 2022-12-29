# Lab: Insecure direct object references

 This lab stores user chat logs directly on the server's file system, and retrieves them using static URLs.

Solve the lab by finding the password for the user carlos, and logging into their account. 

# Step 1 Walk the application

I find that this app has a live chat feature:

![image](https://user-images.githubusercontent.com/83407557/209978186-c5a03941-2ff6-400c-bc57-319a04e2ed8d.png)

I find that I can download the transcript of my chat and it is called 2.txt:

![image](https://user-images.githubusercontent.com/83407557/209978379-c84b6c16-e7b4-42d6-94b5-eb6a642bb398.png)

```bash
└─$ cat 2.txt
CONNECTED: -- Now chatting with Hal Pline --<br/>DISCONNECTED: -- Chat has ended --  
```

# Step 2 download other chats

I start a new chat:

![image](https://user-images.githubusercontent.com/83407557/209978540-24f30af2-5c47-41ed-bb48-0bae8923db5f.png)

Each time I click view transcript I get a file with a predictable filename:

![image](https://user-images.githubusercontent.com/83407557/209978660-be88cd8b-123e-4d92-97d3-9bf832fb9dce.png)

I try and download 1.txt:

![image](https://user-images.githubusercontent.com/83407557/209978751-a3ef3eb0-a586-4468-9381-b80105e6df13.png)

I find that this chat contains a password:

```bash
└─$ cat 1.txt 
CONNECTED: -- Now chatting with Hal Pline --
You: Hi Hal, I think I've forgotten my password and need confirmation that I've got the right one
Hal Pline: Sure, no problem, you seem like a nice guy. Just tell me your password and I'll confirm whether it's correct or not.
You: Wow you're so nice, thanks. I've heard from other people that you can be a right ****
Hal Pline: Takes one to know one
You: Ok so my password is dpzm8fj3ix9hin419pbe. Is that right?
Hal Pline: Yes it is!
You: Ok thanks, bye!
Hal Pline: Do one!                                  
```

# Step 3 login as carlos

![image](https://user-images.githubusercontent.com/83407557/209980155-76f65815-ef39-4bcb-abd0-66b24d296c22.png)

which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209980234-d8a54e52-2375-4383-84bb-61d0cd9dd216.png)
