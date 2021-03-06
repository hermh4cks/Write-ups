# Lab: SQL injection vulnerability in WHERE clase allowing retrieval of hidden data.

## Description.

*This lab contains an SQL injection vulnerability in the product category filter. When the user selects a category, the application carries out an SQL query like the following:*

```sql
SELECT * FROM products WHERE category = 'Gifts' AND released = 1
```

*To solve the lab, perform an SQL injection attack that causes the application to display details of all products in any category, both released and unreleased.*

# Walking the application

Even though I know the purpose of this exercise, I am still going to manually explore the funtions of this webapp, while intercepting the traffic using burpsuite as a proxy to help map out the structure of what I will be attacking.

![image](https://user-images.githubusercontent.com/83407557/164745346-8aab83ca-53d9-4d2b-8fdd-af1df4ae7159.png)

by clicking the links under refine my search I am able to see how the website is functioning, and with burp I can see that even with the "all" link there are (at least sequentially) some product id's missing:

![image](https://user-images.githubusercontent.com/83407557/164745854-ffca9653-bda7-4cbf-b213-45de995ad48f.png)


I can also see that there is a GET request for the specific catagory, in this case Gifts

![image](https://user-images.githubusercontent.com/83407557/164746079-de7c7fba-d3aa-4b3d-91f9-807fb3c61e60.png)

# Hidden product id

Our end goal is to veiw all products, not just the ones that are being returned to us with the web browser normally. One way to check products that aren't normally displayed, now that the application has been mapped out, is by editing the get requests when viewing product id pages:

Burp intruder can be used in this way to enumerate all products with a sniper attack going through numbers 1-25:
![image](https://user-images.githubusercontent.com/83407557/164749907-b4e8cfd6-9cd1-497c-87e8-628994452a8f.png)


For example, even with the view all option before there were no product ids under 6. with this attack it can be seen that while id 5 is indeed missing, 1-4 are infact still on the server:

![image](https://user-images.githubusercontent.com/83407557/164750357-4ff0555c-a42a-4bdc-9a8d-e5b5f6c99115.png)

# Exploiting SQLi

Having verified the existance of hidden products, the next step is to see if an sqli vulnerability exists that can display all of these products on the main page. We are given this hint as to what the source code looks like for this filter function:


```sql
SELECT * FROM products WHERE category = 'Gifts' AND released = 1
```
We say also that Gifts is actually submitted as a GET request, something we have control over. So let's try and break the logic using a single quote to make that actual input the server is trying to execute:


```sql
SELECT * FROM products WHERE category = ''Gifts' AND released = 1
```

This should error, unless we comment out our string with --

```sql
SELECT * FROM products WHERE category = ''--Gifts' AND released = 1
```

If this last step doesn't return a server error, it could be possible to add a conditionally true statement, such as 1=1 to break the logic and return all the data:

```sql
SELECT * FROM products WHERE category = ''1=1--Gifts' AND released = 1
```


This can be done using burp repeater, first a normal request (akin to clicking on the gifts hyperlink)

![image](https://user-images.githubusercontent.com/83407557/164751517-bb6967f3-20b5-41d6-a90e-366e767640df.png)

And then with adding a single quote to our request

![image](https://user-images.githubusercontent.com/83407557/164751825-6df5036f-d931-4c69-b4c4-65494878f2f1.png)

commenting out to see if error goes away

![image](https://user-images.githubusercontent.com/83407557/164752873-5a688161-5100-454a-9de2-9d39264120cc.png)

Sending a conditionally true statement

![image](https://user-images.githubusercontent.com/83407557/164752956-8184b4e6-3a89-40f9-9d89-cc79f6b2cf79.png)

After getting a protocol error from the server, Url encoding the GET request and solving the lab:

![image](https://user-images.githubusercontent.com/83407557/164753150-9466cd5e-f408-4b26-9e2d-e01fff03068e.png)
