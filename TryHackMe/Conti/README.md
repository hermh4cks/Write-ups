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
 
