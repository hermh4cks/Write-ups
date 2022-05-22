# Lab: SQL injection UNION attack, retrieving multiple values in a single column

## Description

*This lab contains an SQL injection vulnerability in the product category filter. The results from the query are returned in the application's response so you can use a UNION attack to retrieve data from other tables.*

*The database contains a different table called **users**, with columns called **username** and **password**.* 

*To solve the lab, perform an SQL injection UNION attack that retrieves all usernames and passwords, and use the information to log in as the **administrator** user.* 

## Hint

You can find some useful payloads on our [SQL injection cheat sheet.](https://portswigger.net/web-security/sql-injection/union-attacks)
