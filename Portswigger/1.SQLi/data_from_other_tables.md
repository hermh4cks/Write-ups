# Lab: SQL injection UNION attack, retrieving data from other tables

## Description

 *This lab contains an SQL injection vulnerability in the product category filter. The results from the query are returned in the application's response, so you can use a UNION attack to retrieve data from other tables. To construct such an attack, you need to combine some of the techniques you learned in previous labs. *
 
 * The database contains a different table called users, with columns called username and password. *

* To solve the lab, perform an SQL injection UNION attack that retrieves all usernames and passwords, and use the information to log in as the administrator user. *

# Step 1 Finding the SQLi



# Step 2 finding the number of columns with union select null
