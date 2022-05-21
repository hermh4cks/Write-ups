# Lab: SQL injection UNION attack, determining the number of columns returned by the query

## Description

*This lab contains an SQL injection vulnerability in the product category filter. The results from the query are returned in the application's response, so you can use a UNION attack to retrieve data from other tables. The first step of such an attack is to determine the number of columns that are being returned by the query. You will then use this technique in subsequent labs to construct the full attack.*

*To solve the lab, determine the number of columns returned by the query by performing an SQL injection UNION attack that returns an additional row containing null values.*

## Plan of Attack

In order to figure out how many columns I will use an order by clause. Once an injection point is located, I will be able to sequentially increase the number that I am ordering by, until the server throws an error. At the point I will know the previous number is the number of columns being returned in the query:

```sql
# Note '<injection point>--

' order by 1--
' order by 2--
' order by 3--
# When going to 4 an error is thrown, I therefore know there are 3 columns
```


## Finding the numer of Columns with order clauses

### Step 1. Verifying an injection point

With a single quote

![image](https://user-images.githubusercontent.com/83407557/169661686-3690cec0-ba02-4c01-b04d-71e7c1142838.png)

![image](https://user-images.githubusercontent.com/83407557/169661701-77e2f290-75b0-4254-8f3b-38b6d538cdc7.png)

With a single quote and a comment in sql

![image](https://user-images.githubusercontent.com/83407557/169661737-9fa2be01-8294-4b29-b4cf-e91f9b25572a.png)


![image](https://user-images.githubusercontent.com/83407557/169661749-0e8c654e-32fb-4e4b-abd3-f0f09b2f024e.png)

*Note that there is no error, telling me that I can run my own sql commands within these two characters as an "injection point"*

### Step 2. Use order by clauses until I get an error.

*Requests have been url-encoded*

```sql
order by 1
```

![image](https://user-images.githubusercontent.com/83407557/169661852-fd8899e8-fc28-4089-9ab9-fccf4fa86c2a.png)


![image](https://user-images.githubusercontent.com/83407557/169661860-8c3cd677-649e-41f3-93af-78620c9b7f42.png)


```sql
order by 2
```

![image](https://user-images.githubusercontent.com/83407557/169661883-8930b783-5660-4e36-adb9-065bf766d4c0.png)


![image](https://user-images.githubusercontent.com/83407557/169661894-4323d7b5-7298-4037-927d-3d3d3b7c42c4.png)

```sql
order by 3
```

![image](https://user-images.githubusercontent.com/83407557/169661909-504aaf96-0f8d-41db-8024-6b2dd2792122.png)


![image](https://user-images.githubusercontent.com/83407557/169661913-580fd8c7-d5da-408a-8e98-886a52fee4fb.png)


```sql
order by 4
```

![image](https://user-images.githubusercontent.com/83407557/169661933-b96916ae-af21-4fa1-8aa9-edbb46372137.png)


![image](https://user-images.githubusercontent.com/83407557/169661952-862c37a9-02e2-45fd-a013-a39937f5e8db.png)

this lets me know that there are 3 columns being returned by my query. The same thing can be achieved using UNION SELECT within sql and sending increasing number of NULL values seperated by commas until and error is thrown:

```sql
`UNION SELECT NULL--
`UNION SELECT NULL,NULL--
`UNION SELECT NULL,NULL,NULL--
```

### Determining number of columns with UNION SELECT and NULL values

since I already determined that there are three columns being returned, I can verify with two requests using UNION SELECT and NULL values, first with 3 nulls then with 4. If an error is not thrown on 3 nulls, but is on 4, I verify 3 columns.


```sql
`UNION SELECT NULL,NULL,NULL--
```

![image](https://user-images.githubusercontent.com/83407557/169662234-f55c4f1a-7c8a-430d-8e5b-1d9b811e53a9.png)

![image](https://user-images.githubusercontent.com/83407557/169662248-d104ef68-ac4d-4cd2-ab02-54f4fa8a6ba4.png)


```sql
`UNION SELECT NULL,NULL,NULL,NULL--
```

![image](https://user-images.githubusercontent.com/83407557/169662290-badf9c9a-3937-4567-b26e-1541ac2c9b7f.png)

![image](https://user-images.githubusercontent.com/83407557/169662315-8b6fb3a5-75e1-4817-89ca-0d05c03481af.png)

And the lab is solved!
