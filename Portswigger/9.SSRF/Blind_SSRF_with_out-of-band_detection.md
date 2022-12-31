# Lab: Blind SSRF with out-of-band detection

 This site uses analytics software which fetches the URL specified in the Referer header when a product page is loaded.

To solve the lab, use this functionality to cause an HTTP request to the public Burp Collaborator server. 

**Note**

*To prevent the Academy platform being used to attack third parties, our firewall blocks interactions between the labs and arbitrary external systems. To solve the lab, you must use Burp Collaborator's default public server.*

# Step 1 Walk the application

I want to see what is happening with the referer header what I load a product page:

![image](https://user-images.githubusercontent.com/83407557/210152494-a1ed97e9-d3a7-4e47-b190-d6808511d9d7.png)

# Step 2 Get collaborator URL:

![image](https://user-images.githubusercontent.com/83407557/210152533-67972953-1b0d-4610-90bf-8fee4dbf22a2.png)

copied URL = md3ypcg909in99lglgmolk4p7gd71xpm.oastify.com

# Step 3 use colllaborator URL in referer header:

![image](https://user-images.githubusercontent.com/83407557/210152601-a4e17305-3db2-438a-9ad6-84c671bfb92d.png)

polling the data from my collaborator server I see that the site made a DNS lookup and HTTP request

![image](https://user-images.githubusercontent.com/83407557/210152649-2e8db931-6886-4530-b2a9-9d145ad2137b.png)

which solves the lab

![image](https://user-images.githubusercontent.com/83407557/210152673-6c918040-e9ca-4f8e-8b80-1704dfd21b56.png)


