# Lab: SQL injection UNION attack, retrieving data from other tables

## Description

 *This lab contains an SQL injection vulnerability in the product category filter. The results from the query are returned in the application's response, so you can use a UNION attack to retrieve data from other tables. To construct such an attack, you need to combine some of the techniques you learned in previous labs. *
 
 * The database contains a different table called users, with columns called username and password. *

* To solve the lab, perform an SQL injection UNION attack that retrieves all usernames and passwords, and use the information to log in as the administrator user. *

# Step 1 Finding the SQLi

Using a single quote to try and break the slq logic

![image](https://user-images.githubusercontent.com/83407557/169665168-44033304-d0b3-4b0b-8c10-a5432184358c.png)

Using a single quote and a comment to see if the error goes away: verifying sqli

![image](https://user-images.githubusercontent.com/83407557/169665202-2f49ab6c-f214-4f93-925e-2a0c73d47588.png)

# Step 2 finding the number of columns with union select null

Now that I know where my injection point is, the next step is to figure out the number of columns being returned by the query:

I will do this with a union select statement and increasing numbers of NULL values until no error is thrown, which will tell me the number of columns based 
on the number of nulls I submitted:

```sql
union select null
```
![image](https://user-images.githubusercontent.com/83407557/169665299-c1e96d06-aba5-4bb2-96ed-66393d7a6e73.png)

```sql
union select null,null
```
![image](https://user-images.githubusercontent.com/83407557/169665356-1741ef22-9ba4-47dd-9019-1725f4a38eba.png)

This tells me that there are two columns being returned by the query

# Step 3 Finding which columns return string data, and where that data will show up

I will place the strings 'a' and 'b' in the two columns I will be accessing to see where the string data will show up:

```sql
union select 'a','b'
```

![image](https://user-images.githubusercontent.com/83407557/169665448-ed20e27c-d9e3-441c-bc92-6736d2d60a30.png)

I can see that a is the title and b is the content, and both can return string data.

# step 4 Selecting two columns from a different table

I am able to select data from another table as long as I know the column and table names that I want to target

I want to target the username and password columns from the users table (this infomation is given to us in this lab, but the process for gathering this info can be found in it's own lab)

the sql statement will look as follows:

```sql
UNION SELECT username, password FROM users
```

![image](https://user-images.githubusercontent.com/83407557/169665602-7be9c7e2-c5d8-48fc-98db-9d647ad969d0.png)

As can be seen, the usernames have been added to the titles on the webpage, with the passwords as the comment. Including the admin user as can be seen hihglighted.

# step 5 log in as administrator

name: administrator
password: tfmls0z4dhlf22u6h7wb

![image](https://user-images.githubusercontent.com/83407557/169665670-57813aed-e6fc-43d6-bd05-a17d7972bdf6.png)
![image](https://user-images.githubusercontent.com/83407557/169665682-7c8521cb-d75a-4788-807d-b89d47c60f1e.png)
