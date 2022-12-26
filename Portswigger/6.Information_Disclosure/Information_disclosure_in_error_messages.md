# Lab: Information disclosure in error messages

This lab's verbose error messages reveal that it is using a vulnerable version of a third-party framework. To solve the lab, obtain and submit the version number of this framework.

# Step 1 Manually inspect the application:

![image](https://user-images.githubusercontent.com/83407557/209574098-79cddf0c-64b4-404d-be63-acc187297862.png)

Viewing the /product directory, the appliaction passes the products view a productid parameter; example 

`/product?productId=20`

![image](https://user-images.githubusercontent.com/83407557/209574337-9b6885ef-2f28-42b8-8499-b333b90f5f15.png)

entering a product that doesn't exist I get json data:


![image](https://user-images.githubusercontent.com/83407557/209574396-56a47719-e9a3-42ba-a42b-c8e3a80fba7d.png)

![image](https://user-images.githubusercontent.com/83407557/209574405-b04fee2b-085d-479d-a9d3-dfd47a6fbc90.png)

Entering a single quote `'` I get the following error msg, which leaks the service version:

![image](https://user-images.githubusercontent.com/83407557/209574466-a5d77567-fb7f-4c4f-8cd1-5dd49c337b8b.png)


# Step 2 submit version

![image](https://user-images.githubusercontent.com/83407557/209574515-dc8897b1-9181-44c8-8971-4654f3834e47.png)

doing so solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209574534-0f50136a-3f3b-4a0b-8964-093b2be9f530.png)

