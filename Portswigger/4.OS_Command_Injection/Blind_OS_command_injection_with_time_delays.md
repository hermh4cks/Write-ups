# Lab: Blind OS command injection with time delays

 This lab contains a blind OS command injection vulnerability in the feedback function.

The application executes a shell command containing the user-supplied details. The output from the command is not returned in the response.

To solve the lab, exploit the blind OS command injection vulnerability to cause a 10 second delay. 


# Step 1 Walk the application

I want to capture the request to the vulnerable feedback function:

![image](https://user-images.githubusercontent.com/83407557/209042880-92fa2fdf-a02f-4667-b087-f078a3cddabc.png)

![image](https://user-images.githubusercontent.com/83407557/209043034-5f097060-f824-44ea-95c1-8bb6cb9b3945.png)

It takes these form values and uses a POST request to send the values to the server:

![image](https://user-images.githubusercontent.com/83407557/209043167-91791ba0-205b-4d34-ab58-7bbce3540d68.png)

I see that it uses `&` between each parameter.

# Step 2 Make the server sleep for 10 seconds

The first test is to just add a sleep command:

![image](https://user-images.githubusercontent.com/83407557/209173094-585f9e58-06a4-4d22-b733-60d74be798fa.png)

I am going to URL encode this:

![image](https://user-images.githubusercontent.com/83407557/209173188-66738ee8-53cc-481c-82aa-35ea841e93d9.png)

This does not work, so next I try the same thing but with a 10 count ping to the localhost of the server:

![image](https://user-images.githubusercontent.com/83407557/209173597-aa1f7662-6add-4b03-af34-a331f43ca986.png)

This also doesn't work, so lets try a different command seperator:

![image](https://user-images.githubusercontent.com/83407557/209174194-a96104a7-2af7-477d-be69-77dfe558bd93.png)

Next I try a different parameter (the email), using a sleep command this successfully causes the server to sleep for 10 seconds:

![image](https://user-images.githubusercontent.com/83407557/209174828-393802a2-af12-45ef-97b2-885770f65d61.png)

Doing so solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209174949-01d72d3e-e62a-4d95-a0a8-49d8677831e8.png)
