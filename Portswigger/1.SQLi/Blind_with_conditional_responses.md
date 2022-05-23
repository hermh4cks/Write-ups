# Lab: Blind SQL injection with conditional responses

## Description

* This lab contains a blind SQL injection vulnerability. The application uses a tracking cookie for analytics, and performs an SQL query containing the value of the submitted cookie.

The results of the SQL query are not returned, and no error messages are displayed. But the application includes a "Welcome back" message in the page if the query returns any rows.

The database contains a different table called users, with columns called username and password. You need to exploit the blind SQL injection vulnerability to find out the password of the administrator user.

To solve the lab, log in as the administrator user. *

---

# STEP 1: Verify Blind SQLi

The page with a normal tracking cookie

![image](https://user-images.githubusercontent.com/83407557/169717979-383b0251-ea74-43d2-980f-4b40ae2f6578.png)

## with a conditionally true payload of 

```sql
'and 'a'='a
```

![image](https://user-images.githubusercontent.com/83407557/169718045-1a2378d7-ae0f-4245-89b5-1b44198ee40b.png)

I get the welcome back message

## sending a conditionally false payload:

```sql
'and 'a'='b
```

![image](https://user-images.githubusercontent.com/83407557/169718103-df5dc3e6-0329-4db5-bab6-ed5af585af08.png)

being false the welcome back message goes away

# STEP 2: Determine target table, columns, and rows

Normally this step would involve conditionals to build out the names of the tables in the database and then their columns, however for this lab they are provided. My target is the password of the administrator user:

table: users

columns: username, password

row: administrator, target

# STEP 3: Determine the length of the administrator's password

I can use a greater than and sequential numbers. I should get the welcome back message until I go one number past the length of the password.

```sql
' AND (SELECT 'a' FROM users WHERE username='administrator' AND LENGTH(password)>1)='a
```
Greater than 1?
![image](https://user-images.githubusercontent.com/83407557/169718804-41d3570a-fe58-491e-b253-96966dc62fc6.png)
Greater than 2?
![image](https://user-images.githubusercontent.com/83407557/169718841-83cc12ec-e65d-4be9-9c8d-cbbcddb15e42.png)
Greater than 3?
![image](https://user-images.githubusercontent.com/83407557/169718861-1006c697-7726-4534-8914-7482e9709a4c.png)
ect...

until

![image](https://user-images.githubusercontent.com/83407557/169718920-b66bd139-2021-47ec-a95a-0466775a0b48.png)

Letting me know that the administrator's password is 19 character's long

# STEP 4: Using subsrings to build the password

Substrings from sql cheat sheet:

![image](https://user-images.githubusercontent.com/83407557/169719316-0a633d86-7e92-4286-8d86-46b20e3160b3.png)

So to see if the first letter is an a:

```sql
' AND (SELECT SUBSTRING(password,1,1) FROM users WHERE username='administrator')='a
```

I can create this attack using burp intruder with a cluster bomb payload:

![image](https://user-images.githubusercontent.com/83407557/169719608-ae2e5acf-584f-42a2-a8e7-565c77fbefce.png)

I also use grep extract on the response message to look for the Welcome back! response

![image](https://user-images.githubusercontent.com/83407557/169719671-513fdf25-54ad-4264-8a20-c3638b14dbf3.png)

My first payload will be numbers 1-19 for each character in the password

![image](https://user-images.githubusercontent.com/83407557/169719735-a307fb74-4aa4-4620-9925-326932ab7c36.png)

For the character payload, I add all letter and numbers in a single list

![image](https://user-images.githubusercontent.com/83407557/169719925-84370e25-1c3a-4562-9a24-a6d3da15ca1c.png)

I then let the payload run, and wait a few minutes(this attack can take a very long time, if like me you are using the community addition) for it to complete:


