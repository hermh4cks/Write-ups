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

# Exploiting SQLi

Our end goal is to veiw all products, not just the ones that are being returned to us with the web browser normally. One way to check products that aren't normally displayed, now that the application has been mapped out, is by editing the get requests when viewing product id pages:

Burp intruder can be used in this way to enumerate all products with a sniper attack going through numbers 1-25:
![image](https://user-images.githubusercontent.com/83407557/164749907-b4e8cfd6-9cd1-497c-87e8-628994452a8f.png)



