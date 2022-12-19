# Lab: SQL injection with filter bypass via XML encoding

[Lab link}(https://portswigger.net/web-security/sql-injection/lab-sql-injection-with-filter-bypass-via-xml-encoding)

 This lab contains a SQL injection vulnerability in its stock check feature. The results from the query are returned in the application's response, so you can use a UNION attack to retrieve data from other tables.

The database contains a users table, which contains the usernames and passwords of registered users. To solve the lab, perform a SQL injection attack to retrieve the admin user's credentials, then log in to their account. 

## Hint

A web application firewall (WAF) will block requests that contain obvious signs of a SQL injection attack. You'll need to find a way to obfuscate your malicious query to bypass this filter. We recommend using the Hackvertor extension to do this. 

# Step 1 finding XXE

![image](https://user-images.githubusercontent.com/83407557/208496069-c4727c63-c3e2-41a5-be32-d08e5d4c5937.png)

Clicking on the View details option under a product I see there is an option to check the stock of a given item.

![image](https://user-images.githubusercontent.com/83407557/208496340-370edd90-cebb-47b9-aab3-a5aaeacfcb2c.png)

Capturing this request with burp I see that this is being sent to /product/stock as a post request, and using XML:

![image](https://user-images.githubusercontent.com/83407557/208496590-fbbe7d7f-001a-498b-9ba4-3915a891a825.png)

The XML parser on the server then checks the stock and returns a value on the screen:

![image](https://user-images.githubusercontent.com/83407557/208496782-14177840-60f0-46b8-b28c-3bb5fffb46fb.png)

If I change the store id I see that that the xml store id value is now 2 instead of 1:
![image](https://user-images.githubusercontent.com/83407557/208497326-5b1d4622-ce1c-42d3-92dc-a4fde3caa0a3.png)

![image](https://user-images.githubusercontent.com/83407557/208497438-6a007893-456a-4d94-8865-ee395671de4b.png)

![image](https://user-images.githubusercontent.com/83407557/208497557-85727d55-478d-4b05-89ea-59992c33c92b.png)

However if I send a mathamatical expression that equals the same number for store id (2) and product id (4) I find that the operation is being evaluated server-side and I get the same result:

![image](https://user-images.githubusercontent.com/83407557/208497827-02120d90-fcda-46f2-b569-ace2c5a93624.png)

![image](https://user-images.githubusercontent.com/83407557/208497892-300e6434-4b53-4ff8-b8f4-b36cc7fe62c5.png)

# Step 2 performing SQLi via XXE

Since I can get the application to execute server-side code, the next step is to see if I can get an SQLi payload to trigger via this XXE. I do this by sending the request to repeater. 

## Checking for the number of columns returned by the query:

I check be using an order by query:

Checking for 1 column:

![image](https://user-images.githubusercontent.com/83407557/208499468-19bbff47-67f6-4270-9bc2-1392c077b546.png)


![image](https://user-images.githubusercontent.com/83407557/208499499-9f309d4e-c439-4a9b-907b-2c413cb9c90a.png)

Checking for 2 columns:

![image](https://user-images.githubusercontent.com/83407557/208499623-f14b3478-2764-434b-80b7-01edd915dd2b.png)

![image](https://user-images.githubusercontent.com/83407557/208499665-80f4b9c3-53bc-4713-8573-9fce09c4130e.png)

This tells me I only have a single column being returned by the query.

## Finding DB version

When I try and check to see which DB version this is I get blocked by a WAF:

![image](https://user-images.githubusercontent.com/83407557/208500155-a0507bad-2725-434c-9f76-3115118878f8.png)

![image](https://user-images.githubusercontent.com/83407557/208500291-f69f70e8-7872-4bc1-ad82-3fbdbc361462.png)

![image](https://user-images.githubusercontent.com/83407557/208500364-0ee32909-1962-43a0-91d5-dbb416536620.png)

Because every injection was stopped, I need to find some way to bypass the WAF in order to use any UNION SELECT query

# Bypassing WAF

Using hex_entities from the Hackvertor burp extension I am able to bypass the WAF: as I see that now the SQL query errors out (0 units) instead of saying attack detected:
![image](https://user-images.githubusercontent.com/83407557/208501602-7abc830a-6bd3-4b0a-9b5e-17123d183616.png)

# Getting DB version with WAF bypass

Trying each version detection payload again, finally one doesn't error out and I discover the DB is postreSQL:

![image](https://user-images.githubusercontent.com/83407557/208501909-919fd2af-d3d2-4251-863d-2a20987fe20b.png)

# Getting usernames and passwords

Since I know that I only have a single column to work with, I need to use string concatenation to get both values to return on a single line. Instead of having to discover table and column names, the lab prompt already told me there is a users table with username and password columns. So I can craft the following payload to exfil that info using string concatenation:

```sql
UNION SELECT username || ' has a password of ' || password FROM users
```
![image](https://user-images.githubusercontent.com/83407557/208504813-e8091cb9-b213-46ce-930d-d2417aba3067.png)




# Using found username and password to solve the lab

Going back to the "My Account" link, I can use the found creds for the administrator:

![image](https://user-images.githubusercontent.com/83407557/208504944-916ef027-4759-4158-a3ea-6c72b4d8f1de.png)

and solve the lab:

![image](https://user-images.githubusercontent.com/83407557/208505032-73ebadf4-fb49-419d-89f5-288c91a7ec06.png)

