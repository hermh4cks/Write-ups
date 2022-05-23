# Lab: Blind SQL injection with conditional errors

## Description

 This lab contains a blind SQL injection vulnerability. The application uses a tracking cookie for analytics, and performs an SQL query containing the value of the submitted cookie.

The results of the SQL query are not returned, and the application does not respond any differently based on whether the query returns any rows. If the SQL query causes an error, then the application returns a custom error message.

The database contains a different table called users, with columns called username and password. You need to exploit the blind SQL injection vulnerability to find out the password of the administrator user.

To solve the lab, log in as the administrator user. 

## HINT

This lab uses an Oracle database. For more information, see the SQL injection cheat sheet.

# Step 1: Verify blind, conditional-error-based SQLi

## STEP 1 Finding injection point

I will be using burpsuite for this lab. To start, I start with intercept off and visit the target page in the browser. I also pull up the browser dev tools, in order to view and modify my cookie values.

![image](https://user-images.githubusercontent.com/83407557/169845297-c31515b2-98b3-478d-bdd7-07ed9c1e259c.png)

I then will try and attempt to get the server to error with a single quotation mark added to my tracking cookie and refreshing the page:

![image](https://user-images.githubusercontent.com/83407557/169846190-10990e6d-5b0e-4fe4-87a6-ff97b40404d2.png)

If I then add a comment -- the error goes away:

![image](https://user-images.githubusercontent.com/83407557/169846508-c3987f72-d92d-467a-9082-729621022ca5.png)


## STEP 2 Using true and false Select statement to cause an error

In oracle I need to select from something, which I will use the always valid table *dual*. 

A Valid statement would be:

```sql
SELECT * FROM dual
```

This is because dual exists and as long as the server can select from it, the statement will not error

and invalid statement would be:

```sql
SELECT * FROM doesnt_exist
```

So with that mind, I will need to concatonate this onto my payload like the following:

```sql

#Should NOT error
'||(SELECT * FROM dual)--

# SHOULD error
'||(SELECT * FROM doesn't_exist)--
```

![image](https://user-images.githubusercontent.com/83407557/169852091-d4c0f322-8cf5-408b-aca0-53e5724100ad.png)

![image](https://user-images.githubusercontent.com/83407557/169852204-6e97b877-fccd-4935-80d5-1b7878e34e55.png)

and it acts as expected.

## STEP 3 building an attack payload

since the goal is to guess each character of the administrators password, we need to make it so that if our select statement is true, the server will throw an error:

Because 1 does equal 1, this should error because 1/0 is an invalid operation

```sql
'||(SELECT CASE WHEN (1=1) THEN TO_CHAR(1/0) ELSE '' END FROM dual)--
```

![image](https://user-images.githubusercontent.com/83407557/169855167-14bdbf28-ab76-4e57-83cb-d699e7aefd39.png)

However with the following because 1 does not equal 2, the sever will select anything ('') from dual and therefore not error

```sql
'||(SELECT CASE WHEN (1=2) THEN TO_CHAR(1/0) ELSE '' END FROM dual)--
```


![image](https://user-images.githubusercontent.com/83407557/169855765-b282598e-32da-4d1e-9325-dac145575ca6.png)


