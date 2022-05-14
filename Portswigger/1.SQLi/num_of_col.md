# Lab: SQL injection UNION attack, determining the number of columns returned by the query

## Description

*This lab contains an SQL injection vulnerability in the product category filter. The results from the query are returned in the application's response, so you can use a UNION attack to retrieve data from other tables. The first step of such an attack is to determine the number of columns that are being returned by the query. You will then use this technique in subsequent labs to construct the full attack.*

*To solve the lab, determine the number of columns returned by the query by performing an SQL injection UNION attack that returns an additional row containing null values.*

## Mapping the product category filter

My first step is to see the product category working as intened and then I will use burp to try and create a server error.
