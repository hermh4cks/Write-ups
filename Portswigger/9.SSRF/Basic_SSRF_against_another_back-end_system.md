# Lab: Basic SSRF against another back-end system

 This lab has a stock check feature which fetches data from an internal system.

To solve the lab, use the stock check functionality to scan the internal 192.168.0.X range for an admin interface on port 8080, then use it to delete the user carlos. 

# Step 1 Walk the application

When I check stock:

![image](https://user-images.githubusercontent.com/83407557/210022821-15b75ebb-a5ff-4046-9b3e-f40e67fb9937.png)

I find a POST request that is potentially vulnerable to SSRF:

![image](https://user-images.githubusercontent.com/83407557/210022842-8f6975aa-6aa4-4c70-93f6-4da0d0efb8aa.png)

# Step 2 create an intruder attack

I want to try and find the admin panel at http://192.168.0.x:8080/admin, so I send the POST request to intruder:

![image](https://user-images.githubusercontent.com/83407557/210023363-44a6261c-1b07-46c9-9b77-dca095ab50ce.png)

I add a payload position on the last octet of the ipv4 address

![image](https://user-images.githubusercontent.com/83407557/210023384-642c6582-caa8-4ab1-85ec-550d26d71faf.png)

And add numbers 1-255 for the payload

![image](https://user-images.githubusercontent.com/83407557/210023408-960d68bb-faf3-4ede-8fec-b60e3a8eb721.png)

One of the results gives a 200 response

![image](https://user-images.githubusercontent.com/83407557/210023528-67f0885c-d3fa-4267-9071-84d1af281c20.png)

# Step 3 use found internal ipv4 address to reach server

Capturing the request where I found SSRF I use the payload that gave a 200 response:

![image](https://user-images.githubusercontent.com/83407557/210023632-2fa21628-3e26-4a3c-9648-27a9398b3f11.png)

This gives me access to the admin panel:

![image](https://user-images.githubusercontent.com/83407557/210023653-2d8349d7-7f1e-461b-b5e5-ca38882f3b36.png)


# Step 4 capture the delete request:

I capture the request to find what parameters I need to send via the SSRF, I then drop the request:

![image](https://user-images.githubusercontent.com/83407557/210023695-667e7574-4ad8-4c24-84ae-d33b5374aecd.png)

I save the request `http://192.168.0.45:8080/admin/delete?username=carlos` and send it with the SSRF

![image](https://user-images.githubusercontent.com/83407557/210023774-73063610-515e-486c-8e03-692ca0d41061.png)

This deletes carlos and solves the lab

![image](https://user-images.githubusercontent.com/83407557/210023787-598e22a6-2a6a-4368-af7b-a247f96eb358.png)
