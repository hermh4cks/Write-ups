# Lab: Inconsistent handling of exceptional input

This lab doesn't adequately validate user input. You can exploit a logic flaw in its account registration process to gain access to administrative functionality. To solve the lab, access the admin panel and delete Carlos.

**Hint**

*You can use the link in the lab banner to access an email client connected to your own private mail server. The client will display all messages sent to @YOUR-EMAIL-ID.web-security-academy.net and any arbitrary subdomains. Your unique email ID is displayed in the email client.*

# Step 1 Walk the application's account registration process


I see that @dontwannacry.com emails will be linked to the company hosting this website:

![image](https://user-images.githubusercontent.com/83407557/209391386-3c2b2bd1-d16a-48ba-862e-c74f030d64e1.png)

I also see that my provided email client has the following email address:

![image](https://user-images.githubusercontent.com/83407557/209391602-cf897375-a8c5-47ce-aa11-a2a51e3fc707.png)

I also see that it specifically says  I will get access to ALL subdomains

# Step 2 craft an email that makes me a company member:

my main email is:

```
 attacker@exploit-0a2a00000328513dc0acda97019b0067.exploit-server.net
```

lets see what happens if I use something with the dontwannacry subdomain:

```
attacker@dontwannacry.com.exploit-0a2a00000328513dc0acda97019b0067.exploit-server.net
```
![image](https://user-images.githubusercontent.com/83407557/209393676-9dc07480-fa19-4dc8-b80d-bf0029c74271.png)

![image](https://user-images.githubusercontent.com/83407557/209393716-471f64e0-38ae-45c2-a7fa-00d292f44a20.png)

and I get a confirmation email:

![image](https://user-images.githubusercontent.com/83407557/209393787-1f8810e7-350d-4388-be89-970d9106938c.png)

![image](https://user-images.githubusercontent.com/83407557/209393804-2be66143-edcc-43ba-ad3a-72b464aa9349.png)


# Step 3 login to account:

![image](https://user-images.githubusercontent.com/83407557/209393872-fb1c8024-fce6-4982-b42d-9e77c908c3ba.png)

![image](https://user-images.githubusercontent.com/83407557/209393915-27a1d490-18a8-4573-abde-70c3f3f9bf32.png)

However if I find the admin directory, I find that I cannot access it:

![image](https://user-images.githubusercontent.com/83407557/209394195-31d00296-0db3-4e34-abf1-16f908a20a7d.png)

# Step 4 Create a new account with a very long email address

I want to see if I can get my email to read adim@dontwannacry.com, so I will see if the server truncates the email

First I will make a wordlist of "A" increasing 5 at a time from 0-500, I do this with bash and python:

```bash
└─$ for i in $(seq 0 5 500);do python -c "print($i*'A')">>/tmp/wordlist;done
```

```bash
└─$ head /tmp/wordlist 

AAAAA
AAAAAAAAAA
AAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

I will use this in an intruder attack and add it onto the front of my email:

I capture the POST request:

![image](https://user-images.githubusercontent.com/83407557/209399678-86bdfd04-30f5-49a8-bca8-f5e5dd79852d.png)

I add a payload position portion of my email:

![image](https://user-images.githubusercontent.com/83407557/209400646-f74671b9-97a3-457b-abe1-86f2ed72fdfa.png)

Then I add my wordlist as a payload:

![image](https://user-images.githubusercontent.com/83407557/209399852-43b17ff5-d1b5-4dc8-9aed-ec09319dd69d.png)

This creates 100 emails to check

![image](https://user-images.githubusercontent.com/83407557/209400751-563288fa-da03-42f0-98b0-5a8e1a411501.png)

I check the first one, and see that the email is indeed filled with A's

![image](https://user-images.githubusercontent.com/83407557/209400835-6d563e38-1089-4a04-80af-1e7d77f03261.png)

When I count the number of A's I see that there are 256 of them

```bash
└─$ echo └─$ echo 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'|wc
      1       1     256
                        
```

# Step 5 create a payload

Now I need to get the length of my email I want to try and truncate:

```bash
└─$ echo '@dontwannacry.com'|wc                                                                                    
      1       1      18
```

And then I can use python to create my payload (NOTE my email changed because I took a break and restarted the lab):

```bash
└└─$ python -c 'print((256-18)*"A"+"@dontwannacry.com.exploit-0afd00a503ed6081c1de9809015f003a.exploit-server.net")'
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA@dontwannacry.com.exploit-0afd00a503ed6081c1de9809015f003a.exploit-server.net
```

I then register a new account with the above payload as my email:

![image](https://user-images.githubusercontent.com/83407557/209407884-6c3c646f-b8ae-45e3-bc57-0ec566e48427.png)

I confirm it:

![image](https://user-images.githubusercontent.com/83407557/209407912-23eb31b0-5276-40c9-91e3-c2b8ac6d5dfc.png)

And see that the email has been clipped to seem like I am now a member of the host company:

![image](https://user-images.githubusercontent.com/83407557/209407973-ddc33f33-07d7-4fe0-adef-5b80ad82b288.png)

This allows me to get to the /admin directory that I discovered before:

![image](https://user-images.githubusercontent.com/83407557/209408046-d78505a8-9aa5-4dfd-966e-7124f05eb05a.png)

# Step 6 Delete carlos

After deleting the carlos account, I solve the lab:

![image](https://user-images.githubusercontent.com/83407557/209408104-45df0ebb-0a9d-47c8-b13f-14027909d7d7.png)


