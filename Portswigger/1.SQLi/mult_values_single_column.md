# Lab: SQL injection UNION attack, retrieving multiple values in a single column

## Description

*This lab contains an SQL injection vulnerability in the product category filter. The results from the query are returned in the application's response so you can use a UNION attack to retrieve data from other tables.*

*The database contains a different table called **users**, with columns called **username** and **password**.* 

*To solve the lab, perform an SQL injection UNION attack that retrieves all usernames and passwords, and use the information to log in as the **administrator** user.* 

## Hint

You can find some useful payloads on our [SQL injection cheat sheet.](https://portswigger.net/web-security/sql-injection/union-attacks)

# STEP 1: Verify SQLi

Normal "Lifestyle" catagory filter

![image](https://user-images.githubusercontent.com/83407557/169698350-c3aa882a-44d4-4147-a552-987381fef539.png)

Adding a single quote to the query in an attempt to get a server error

![image](https://user-images.githubusercontent.com/83407557/169698378-9d80ae44-4b3b-4e0e-aef2-e22d03c17030.png)

And then a comment to see if the error goes away(verifying SQL injection point)

![image](https://user-images.githubusercontent.com/83407557/169698431-6d3d63b9-b05e-47e8-80d8-360fe32f302e.png)

# STEP 2: Find the number of columns being returned by the query

Using a UNION SELECT statement with increasing number of NULL queries, regardless of datatype I can determin the number of columns if no SQL error is thrown.

using 1 NULL

![image](https://user-images.githubusercontent.com/83407557/169698561-fc22692c-0e2a-4a73-a520-d8fb5f27be3d.png)

using 2 NULLs

![image](https://user-images.githubusercontent.com/83407557/169698588-a8522d56-fb34-47be-a127-69d9d4d11c13.png)

This tells me 2 columns are being returned in the query.

# STEP 3: Find which columns are returning string data

I can sequentially replace the NULLs that I sent before with unique strings, to see where on the page the strings will be returned. I can then use this to return data from a different table.

First to test the first column, note that I leave the NULL for the second column, so as to test them one at a time.

```sql
'UNION SELECT '1',NULL--
```

![image](https://user-images.githubusercontent.com/83407557/169698789-1673e3bb-e252-4077-8d8a-c1269bf11099.png)

Since I got an error, I know that the first column does not return string data onto the page, so lets test the second column.

```sql
'UNION SELECT NULL,'2'--
```

![image](https://user-images.githubusercontent.com/83407557/169698869-9457c9e5-65d5-4216-8858-4c1b2a5a7ae6.png)

I do not get an error, and I can see my string "2" on the page. Now with this I need to find a way to concatenate two columns into one, as I want them both displayed in a single column on the page.

# STEP 4: Concatenation

From the prompt I know that I need to get the username and password columns from the users table. If each column returned string data I could get what I wanted with:

```sql
UNION SELECT username,password FROM users
```

However since only one column returns data I need to concat the username and password columns with || like so:

```sql
UNION SELECT NULL,username||password FROM users
```
![image](https://user-images.githubusercontent.com/83407557/169699211-808ef9b6-eb69-4f1d-855c-90aaac60c29d.png)

While this does give me the username and password in one column, and with it I could solve the lab, without knowing the administrator username, it would be hard to tell where the username ended and the password began. To account for this, I can make my own delimeter on the page, resaulting in a much easier to read output. In this case i will use a single |

```sql
UNION SELECT NULL,username||' | '||password FROM users
```
![image](https://user-images.githubusercontent.com/83407557/169699405-c0101f63-3b77-430c-b088-8b86e1bf1c7f.png)

At least for me this makes it much easier to see the three usernames and passwords.

# STEP 5: Log in as Administrator

We saw the password for the administrator user is 7grebkce0vo86r7rydtp. Time to use it and solve the lab:

![image](https://user-images.githubusercontent.com/83407557/169699495-9f272a93-ed8e-43d2-91b1-c863bbe76a5d.png)
