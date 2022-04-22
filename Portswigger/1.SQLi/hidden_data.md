# Lab: SQL injection vulnerability in WHERE clase allowing retrieval of hidden data.

## Description.

*This lab contains an SQL injection vulnerability in the product category filter. When the user selects a category, the application carries out an SQL query like the following: *

```sql
SELECT * FROM products WHERE category = 'Gifts' AND released = 1
```

*To solve the lab, perform an SQL injection attack that causes the application to display details of all products in any category, both released and unreleased. *
