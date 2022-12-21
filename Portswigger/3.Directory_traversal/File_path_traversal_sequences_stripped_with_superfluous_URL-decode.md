# Lab: File path traversal, traversal sequences stripped with superfluous URL-decode

 This lab contains a file path traversal vulnerability in the display of product images.

The application blocks input containing path traversal sequences. It then performs a URL-decode of the input before using it.

To solve the lab, retrieve the contents of the /etc/passwd file. 

# Walk the application

The first step is to see if the application will block our input containing a path traversal sequence:

## Open a product image in a new tab

![image](https://user-images.githubusercontent.com/83407557/208803323-455d3016-49a1-4d7e-96a6-a95957d4fac7.png)

## Try to modify the filename with a path traversal

![image](https://user-images.githubusercontent.com/83407557/208803512-4906878f-69e8-4e60-a402-2a9c5acf6327.png)

## Try to see if my input for the image will get URL-decoded:

![image](https://user-images.githubusercontent.com/83407557/208803867-b855b657-b7bc-46a2-be4f-65e7eee77d0e.png)

![image](https://user-images.githubusercontent.com/83407557/208803939-f432bba1-7432-4faa-a25b-e7dfa44cb68f.png)

Sending this still gets the same image

![image](https://user-images.githubusercontent.com/83407557/208804016-e1e70143-e3fa-4542-b1d5-7756f1f42b99.png)


## Creating a burp intruder attack

position:

![image](https://user-images.githubusercontent.com/83407557/208805166-7fb9e542-9b78-4c25-bfd1-f93eb847afe3.png)

Payload

![image](https://user-images.githubusercontent.com/83407557/208806790-40a0a5c9-0e0c-4c50-ab40-e88e6f2a0247.png)

with a match/replace regex for the word {FILE}

![image](https://user-images.githubusercontent.com/83407557/208806854-61467733-4791-4d70-8bca-eaaa551776ff.png)

With this I find that many of the payload bypass the restriction:

![image](https://user-images.githubusercontent.com/83407557/208807080-ba1b58e0-bc87-40bb-a2b9-27b6bad5abb9.png)

![image](https://user-images.githubusercontent.com/83407557/208807165-f0ce444d-881c-4f81-8551-8b7fb89cec47.png)

![image](https://user-images.githubusercontent.com/83407557/208807400-597b2621-e511-4b7a-b0d6-2eb439849e43.png)

With this the lab is solved:

![image](https://user-images.githubusercontent.com/83407557/208807463-b4ca32dd-5911-4ea4-99ee-57284bee1cca.png)



