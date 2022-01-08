# Conti

## prompt: 

*Some employees from your company reported that they can’t log into Outlook. The Exchange system admin also reported that he can’t log in to the Exchange Admin Center. After initial triage, they discovered some weird readme files settled on the Exchange server.*  

*Below is a copy of the ransomware note.*

![image](https://user-images.githubusercontent.com/83407557/148626131-54c740c8-ad65-48cf-9738-fd23501a73e6.png)

Connect to OpenVPN or use the AttackBox to access the attached Splunk instance. 

Splunk Interface Credentials:

Username: `bellybear`

Password: `password!!!`

Splunk URL: http://MACHINE_IP:8000


## Exchange Server Compromised

Below are the error messages that the Exchange admin and employees see when they try to access anything related to Exchange or Outlook.

### Exchange Control Panel:

![image](https://user-images.githubusercontent.com/83407557/148626243-b11dcd03-c345-4f2c-916d-abbb9c9ea63c.png)

### Outlook Web Access:

![image](https://user-images.githubusercontent.com/83407557/148626261-f3b394cb-d452-46ca-9033-95dd3329cf5b.png)


Task: You are assigned to investigate this situation. Use Splunk to answer the questions below regarding the Conti ransomware. 


## Questions

1) Can you identify the location of the ransomware? 

Using splunk we can search the datasets for file creation events. Since I know that Conti created a readme.txt, lets start by searching for that:

![image](https://user-images.githubusercontent.com/83407557/148628585-3ef7a429-4542-451b-8562-40bad2171044.png)

We can see that cmd.exe is being run from an odd place, and that happens to also be the answer to the first question.

2) What is the Sysmon event ID for the related file creation event?

expanding the info I can see that eventcode is 11

![image](https://user-images.githubusercontent.com/83407557/148628671-16e7fb26-62a1-40eb-8dac-ae9b15666a63.png)


3) Can you find the MD5 hash of the ransomware?

![image](https://user-images.githubusercontent.com/83407557/148628913-93448241-6a78-4c67-8758-2b1c542eacd8.png)

`290C7DFB01E50CEA9E19DA81A781AF2C`
 
4) What file was saved to multiple folder locations?

From my search during question 1 I already saw readme.txt 22 times being saved in various local directories.

5) What was the command the attacker used to add a new user to the compromised system

searching for the add user command I can see the attacker adding accounts and then adding them to different groups on the local machine. 

![image](https://user-images.githubusercontent.com/83407557/148629253-3a6569fd-c7a2-439b-a530-7a84f6a1a2a0.png)

the origional command is:

`net  user /add securityninja hardToHack123$`

6) The attacker migrated the process for better persistence. What is the migrated process image (executable), and what is the original process image (executable) when the attacker got on the system?

per the hint we can search for EventCode=8 to check for the migration:

![image](https://user-images.githubusercontent.com/83407557/148629543-c0061b58-631d-460b-8f6b-ba883921202f.png)

7) The attacker also retrieved the system hashes. What is the process image used for getting the system hashes?

![image](https://user-images.githubusercontent.com/83407557/148629636-5ae91a2e-7272-41b7-8e93-d3ed7fb444ba.png)

8) What is the web shell the exploit deployed to the system?

By searching the IIS post logs and removing the results that I know aren't what I want I find this:

![image](https://user-images.githubusercontent.com/83407557/148630793-c1ebf504-c4a5-4452-9c19-9183c085bfca.png)

9) What is the command line that executed this web shell?

![image](https://user-images.githubusercontent.com/83407557/148630927-d0e2691b-380f-425a-89c6-757a9019e806.png)

10) What three CVEs did this exploit leverage?

https://support.microsoft.com/en-gb/topic/description-of-the-security-update-for-microsoft-exchange-server-2019-and-2016-october-12-2021-kb5007012-de43d01b-d54f-4b40-91d1-93525a29437c

https://motasem-notes.net/how-to-test-if-your-exchange-server-is-compromised-and-vulnerable/
