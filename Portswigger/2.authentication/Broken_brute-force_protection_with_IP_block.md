# Lab: Broken brute-force protection, IP block

 This lab is vulnerable due to a logic flaw in its password brute-force protection. To solve the lab, brute-force the victim's password, then log in and access their account page.

    Your credentials: wiener:peter
    Victim's username: carlos 
    
We are also given a list of possible [passwords](Candidate_passowrds)

# Step 1 Discovering brute force protection of the webapp:


If I try and bruteforce any more than 3 times on a given username I get locked out for 1 minute

![image](https://user-images.githubusercontent.com/83407557/208515927-2ba28a62-e314-4709-89ed-5ca4e41df5d1.png)

However if I login to my own account after any of these three attempts, the counter resets and I get more guesses 

![image](https://user-images.githubusercontent.com/83407557/208516226-a53332c4-ae48-4f92-ba26-d65a04fb008c.png)


(this completely bypasses the protection, with the correct wordlists)


# Step 2 building new wordlists
 
 I want to make a list that alternates between my username and the targets, as well as my known password and the brute force attempts from the given list. First lets use a bash for loop to modify the passwords list:
 
 ```bash
 for i in $(cat passwords);do echo $i>>new_passwords;echo peter>>new_passwords;done
 ```
 
 This will go through each password in passwords, pipe it to a document and before piping the next password in the list, insert my known password "peter":
 
```bash
└─$ head new_passwords     
123456
peter
password
peter
12345678
peter
qwerty
peter
123456789
peter
```

New I want to see how long this new_passwords wordlist is so I can build an equal sized username list:

```bash
└─$ wc new_passwords 
 200  200 1352 new_passwords
```

This tells me that there are now 200 passwords in my new list, so I need to make an equal wordlist alternating between my username and the targets (so my passwords always line up with my password):

Take note, that because each sequence will print 2 usernames to the list, I need to do this 100 times to make 200 total names:

```bash
└─$ for i in $(seq 100);do echo carlos>>usernames;echo wiener>>usernames;done   
```
```bash
└─$ head usernames    
carlos
wiener
carlos
wiener
carlos
wiener
carlos
wiener
carlos
wiener
```
```bash
└─$ wc usernames    
 200  200 1400 usernames
```

# Using new wordlists to bruteforce and bypass the block

First thing is to send the request to an intruder attack, with a pitchfork attack type, and payload possitions on the username and password field:

![image](https://user-images.githubusercontent.com/83407557/208517393-9759bba1-5bc2-44a0-a1f7-027ef6344cfa.png)


Next I need to change my resource Pool to make sure requests are sent 1 at a time to avoid getting locked out with multiple requests being sent at once:

![image](https://user-images.githubusercontent.com/83407557/208516916-25f21fd6-7e82-4f65-bed6-142021a8740f.png)

Finally I need to set the payloads using the wordlists I made in the last section:

Payload 1(usernames):

![image](https://user-images.githubusercontent.com/83407557/208517099-88135714-fc7f-4253-9eac-6460340483f8.png)

Payload 2(Passwords):

![image](https://user-images.githubusercontent.com/83407557/208517317-fe3e1c50-ff7d-4abb-b064-97738a8d60ae.png)

# Launching attack

I can see that my correct passwords return a status code of 302, while invalid passwords return a 200:

![image](https://user-images.githubusercontent.com/83407557/208517639-5aa5204a-3bf0-416c-bf50-de1d91ac5478.png)


After the attack finishes I can sort by status code, and find the single 302 returned for carlos:

![image](https://user-images.githubusercontent.com/83407557/208518057-449741d0-fa08-46fd-99b8-70b2e92c2fd3.png)

This tells me the password for carlos is jennifer:

# using found creds to solve the lab:

![image](https://user-images.githubusercontent.com/83407557/208518216-c5a5fc95-85e6-4ee2-8cdd-1874eb17d6da.png)

![image](https://user-images.githubusercontent.com/83407557/208518379-995a5eea-de96-4dbf-9e5e-c5dcfcc6a424.png)
