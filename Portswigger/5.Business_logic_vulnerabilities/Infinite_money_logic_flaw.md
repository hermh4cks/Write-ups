# Lab: Infinite money logic flaw

 This lab has a logic flaw in its purchasing workflow. To solve the lab, exploit this flaw to buy a "Lightweight l33t leather jacket".

You can log in to your own account using the following credentials: wiener:peter 

# step 1 check functionality

I see that I can enter gift cards, have an email client, and can update my email:

![image](https://user-images.githubusercontent.com/83407557/209450167-c0647733-c976-4fcd-8276-5b032322eb47.png)

I find that I can sign up to the newsletter:

![image](https://user-images.githubusercontent.com/83407557/209450176-ec1af995-e96c-4936-be23-172acedbea2f.png)

![image](https://user-images.githubusercontent.com/83407557/209450197-e5456888-4849-4b34-ac0b-06150304068c.png)

I get a coupon

![image](https://user-images.githubusercontent.com/83407557/209450207-761db1d4-9b18-47b3-826e-9ce12390493f.png)

![image](https://user-images.githubusercontent.com/83407557/209450233-abe5e693-0f4f-4a0f-9bd6-5c05fb79fcd1.png)

# Step 2 buy gift cards with coupon

![image](https://user-images.githubusercontent.com/83407557/209450271-e1a39b3e-c3c5-4f85-bac3-5fffcbbc68ef.png)

I see that the coupon is taking a percentage of the total price:

![image](https://user-images.githubusercontent.com/83407557/209450294-467e7557-e290-44b6-956b-a62181ddabf6.png)

In buying a gift card I get plus a net gain of $3

![image](https://user-images.githubusercontent.com/83407557/209450382-bcd0a680-de25-48ed-accf-2079e7cc6bbc.png)

![image](https://user-images.githubusercontent.com/83407557/209450388-9a0c2882-ca2b-4c86-a3f4-f26927c40a54.png)

![image](https://user-images.githubusercontent.com/83407557/209450392-e2d1565b-1b10-4ff4-b5a7-d6769caa538d.png)

![image](https://user-images.githubusercontent.com/83407557/209450410-35e54584-99c6-4cbb-b8d2-33d43b5ad03a.png)

# Step 3 Create a macro to add $3 over and over

In the settings menu I add a new session handling rule:

![image](https://user-images.githubusercontent.com/83407557/209450555-9dc28988-9da0-4578-90fe-2630413fc302.png)

I call my rul Gift Cards:

![image](https://user-images.githubusercontent.com/83407557/209450565-4e3c1cbd-7634-48a3-806e-146811a6bd9e.png)

I inclue all URLs in scope:

![image](https://user-images.githubusercontent.com/83407557/209450599-f4956348-81ba-46cb-b7c8-9ff1246ac833.png)

I add a run-macro for Rule Actions

![image](https://user-images.githubusercontent.com/83407557/209450624-2011c5cf-f5a4-49a3-a2cf-8ecea8c88bab.png)

I hit add to start recording a macro:

![image](https://user-images.githubusercontent.com/83407557/209450645-92b8a26c-1e29-4e29-a516-cd9e97003fb8.png)

I add the following five requests from my history:

![image](https://user-images.githubusercontent.com/83407557/209472819-6931168d-6a88-4d2c-b3e5-e2bc5308eee1.png)


Next I need to configure a parameter that grabs the coupon code from the /cart/order-confirmation GET request:

![image](https://user-images.githubusercontent.com/83407557/209472911-3c7a42a4-a7f9-4b50-857d-1ac0622dddb7.png)

![image](https://user-images.githubusercontent.com/83407557/209472927-fc2cf588-4dd3-4be1-9e5b-54882d96e1f9.png)

I name the new custom parameter coupon-code and select the code from the request:

![image](https://user-images.githubusercontent.com/83407557/209472977-cf6a4340-9663-46c1-b60c-6c3d27c5d97f.png)

Then I configure the /gift-card POST request and add the parameter I just made:

![image](https://user-images.githubusercontent.com/83407557/209473060-f3ff5461-ae96-4313-936f-c32d02372c4b.png)

![image](https://user-images.githubusercontent.com/83407557/209473094-c2a2d478-b37c-482a-bb14-bd10838c5419.png)

Then I test the macro:

![image](https://user-images.githubusercontent.com/83407557/209473719-e30e6765-9c0b-45f7-ab51-044b6a4f852d.png)

After the test I see that I have $106 now in store credit.

# Make an intruder attack with the macro I just made:

I send the get request for /my-account to intruder and select a sniper attack with now payload positions

![image](https://user-images.githubusercontent.com/83407557/209473821-cb3bef38-991c-48f5-abb4-cb9a6bd3bc1e.png)

I select null payloads, and set it to generate 500 payloads:

![image](https://user-images.githubusercontent.com/83407557/209473837-9a2f2260-d17b-4dff-b5d4-11cc26f0d1fb.png)

I also set it to only send 1 request at a time:

![image](https://user-images.githubusercontent.com/83407557/209474000-c4529787-ea3f-4344-8fc8-ab2cc1fe903a.png)

Due to this the attack will take some time to complete, but checking my account while it is running, I can see that I am getting infinite money:

![image](https://user-images.githubusercontent.com/83407557/209474019-aea10f33-cf67-4e06-9cbe-3f6243b5d742.png)

Once finished, I have more than enough money to buy the jacket:

![image](https://user-images.githubusercontent.com/83407557/209474614-da0a2dd4-b39f-4889-94c6-5e4399e3f275.png)

![image](https://user-images.githubusercontent.com/83407557/209474625-0ed93ccd-cfbb-4b6c-8828-b8730e52f8d6.png)

Buying it solves the lab:

![image](https://user-images.githubusercontent.com/83407557/209474638-8afb3def-29c3-46af-94a2-f0b2655711c2.png)
