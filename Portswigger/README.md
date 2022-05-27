https://portswigger.net/

Portswigger Academy is split into three sections. Server side attacks, Client side attacks, and advanced attacks. The entire course is focused on webapp hacking. It is designed to be completed using burp suite web proxy, however as at the time of writing this I am also preparing for my OSCP exam, I am going to be trying to do the labs using python after each completion as an appended section of the write-up. Each of those write-ups can be found linked within this readme file. 

# Server side Attacks
---
## 1. [SQL injection](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi)

[Cheatsheat: SQL injection](https://portswigger.net/web-security/sql-injection/cheat-sheet)

[Lab: SQL injection vulnerability in WHERE clause allowing retrieval of hidden data](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/hidden_data.md)

[Lab: SQL injection vulnerability allowing login bypass](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/login_bypass.md)

[Lab: SQL injection UNION attack, determining the number of columns returned by the query](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/num_of_col.md)

[Lab: SQL injection UNION attack, finding a column containing text](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/column_with_txt.md)


[Lab: SQL injection UNION attack, retrieving data from other tables](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/data_from_other_tables.md)

[Lab: SQL injection UNION attack, retrieving multiple values in a single column](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/mult_values_single_column.md)

[Lab: SQL injection attack, querying the database type and version on Oracle](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/database_type_and_version_Oracle.md)

[Lab: SQL injection attack, querying the database type and version on MySQL and Microsoft](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/database_type_and_version_MySQL_and_Microsoft.md)

[Lab: SQL injection attack, listing the database contents on non-Oracle databases](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/list_tables_non_Oracle.md)

[Lab: SQL injection attack, listing the database contents on Oracle](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/database_content_Oracle.md)

[Lab: Blind SQL injection with conditional responses](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/Blind_with_conditional_responses.md)

[Lab: Blind SQL injection with conditional errors](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/1.SQLi/Blind_with_conditional_errors.md)

## 2. Authentication

### 2.1 Authentication: Password-based login

[Lab: Username enumeration via different responses](https://github.com/hermh4cks/Write-ups/tree/main/Portswigger/2.authentication)

[Lab: Username enumeration via subtly different responses](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/username_enumeration_via_subtly_different_responses.md)

[Lab: Username enumeration via response timing](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/2.authentication/username_enumeration_via_response_timing.md)

### 2.2 Authentication: Multi-factor


## 3. Directory traversal 
## 4. Command injection
## 5. Business logic vulnerabilities
## 6. Information disclosure
## 7. Access control
## 8. File upload vulnerabilities
## 9. Server-side request forgery(SSRF)
## 10 XXE injection

# Client side attacks
---
## 11. Cross-site scripting (XSS)

[Lab: Reflected XSS into HTML context with nothing encoded](https://github.com/hermh4cks/Write-ups/blob/main/Portswigger/11.XSS/Reflected_XSS_no_encoding.md)

## 12. Cross-site request forgery(CSRF)
## 13. Cross-origin resource sharing(CORS)
## 14. Clickjacking
## 15. DOM-based vulnerabilities
## 16. WebSockets

# Advanced Topics
---
## 17. Insecure deserialization
## 18. Server-side template injection
## 19. Web cache poisoning
## 20. HTTP Host header attacks
## 21. HTTP reuest smuggling
## 22. OAuth authentication

