# Lab: SQL injection attack, querying the database type and version on MySQL and Microsoft

## Description

* This lab contains an SQL injection vulnerability in the product category filter. You can use a UNION attack to retrieve the results from an injected query. 

* To solve the lab, display the database version string. 
* 
## HINT

You can find some useful payloads on our [SQL injection cheat sheet.](https://portswigger.net/web-security/sql-injection/cheat-sheet)

---

# STEP 1: Verify SQLi

## Normal use of Accessories filter

![image](https://user-images.githubusercontent.com/83407557/169703848-58daa93d-4672-41eb-a02f-536319f74f53.png)

## Adding a single to force a server error

![image](https://user-images.githubusercontent.com/83407557/169703912-0f04bab4-494e-4267-a839-e26ca15dc3bb.png)

## Using a comment to bypass error

take note that in MySQL a space is needed after the --, so a %20 which is a url-encoded space character must be added as follows:

```sql
'--%20
```

![image](https://user-images.githubusercontent.com/83407557/169704083-0d515d1a-914b-4871-b751-b96abfe118d7.png)

---
# STEP 2: Determine the number of columns

## Checking for 1 column

![image](https://user-images.githubusercontent.com/83407557/169704145-6be4cf08-2c09-4e07-9519-8f071b4a6886.png)

## Checking for 2 columns

![image](https://user-images.githubusercontent.com/83407557/169704166-c5f8b381-4d33-4dee-84b4-44318ffb048b.png)

This verifies that two columns are being returned with the query

---

# STEP 3: Determine which columns return string data

## Checking column 1

```sql
%27UNION SELECT 'abc', NULL--%20
```

![image](https://user-images.githubusercontent.com/83407557/169704274-3c8d3d81-59fd-4757-8e84-1868932e497d.png)

It does return string data. Since I only need a single query for MySQL database version, I should be good to go onto the next step.

---

# STEP 4: Return target data

I know that the syntax for querying the database version in MySQL is SELECT @@version, my query will look like this:

```sql
'UNION SELECT @@version, NULL--%20
```

![image](https://user-images.githubusercontent.com/83407557/169704429-a58bb935-0ecb-43b2-8b7c-baee568b38db.png)

And with that the lab is solved, because the desired data is returned to the page if I scroll down:

![image](https://user-images.githubusercontent.com/83407557/169704467-5c1be2ea-f811-466e-9b3b-e579b2b30050.png)

