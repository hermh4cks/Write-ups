# Lab: Low-level logic flaw

 This lab doesn't adequately validate user input. You can exploit a logic flaw in its purchasing workflow to buy items for an unintended price. To solve the lab, buy a "Lightweight l33t leather jacket".

You can log in to your own account using the following credentials: wiener:peter 

**Hint**
*You will need to use Burp Intruder (or Turbo Intruder) to solve this lab.
To make sure the price increases in predictable increments, we recommend configuring your attack to only send one request at a time. In Burp Intruder, you can do this from the resource pool settings using the Maximum concurrent requests option.*

# Step 1 Walk the application

I will login with the provided account, and capture the requests for purchasing a l33t jacket:

![image](https://user-images.githubusercontent.com/83407557/209258790-16455beb-9a42-4845-aa13-beb240b0ef76.png)

![image](https://user-images.githubusercontent.com/83407557/209258810-24deafd8-6467-4604-81f4-c056b707f0e1.png)

# Step 2 Use intruder to add an increasing number of jackets

The idea behind this is to add a higher number of jackest then the backend can handle:

I capture the request to add a jacket:

![image](https://user-images.githubusercontent.com/83407557/209259668-863f0866-661e-41c1-967f-405eb907e236.png)

I send this to an intruder attack and change the quantity to 99 (after finding I can only add a two digit number:

![image](https://user-images.githubusercontent.com/83407557/209259804-a00f3a8e-e59e-4a9c-b17d-74581efa07e9.png)

I change the resource pool to only send one request at a time:

![image](https://user-images.githubusercontent.com/83407557/209259915-82275471-e0f8-464c-9603-250603a02c86.png)

I set the payload to null payloads that continue indefinitely:

![image](https://user-images.githubusercontent.com/83407557/209260030-9060e8ec-9c96-40e8-88c8-75b8fccb51ed.png)

# Step 3 Launch the attack and check my cart (refreshing frequently)

![image](https://user-images.githubusercontent.com/83407557/209260248-5e79dc15-522b-4c23-867a-2eeef7ca8e1b.png)

![image](https://user-images.githubusercontent.com/83407557/209260299-20ce536d-9f81-403d-835b-f7acfd2d195c.png)

After a certain quantity the price goes negative, and then starts going back towards zero

![image](https://user-images.githubusercontent.com/83407557/209260497-f8326c45-b48e-431d-a732-70f7124bd98e.png)


I also see that this began happening around 160-189 requests

![image](https://user-images.githubusercontent.com/83407557/209260622-c93ea979-730b-41dd-a4c6-7c3cddef3c8f.png)


# Step 4 launch enough attacks to get the price where I can offset it with another item:

First I clear out the items from my cart

![image](https://user-images.githubusercontent.com/83407557/209260788-998f56e6-9a0b-4baf-8afa-7f478e4af781.png)

Then I relaunch the same attack with a set number of payloads (this is a guess to try and get as close to $0 as possible)

![image](https://user-images.githubusercontent.com/83407557/209261155-e24731c8-82e2-4d77-9f87-2ff858e96939.png)


However this was too many payloads as the price is no longer negative:

![image](https://user-images.githubusercontent.com/83407557/209261536-e9b10317-4bf3-4666-81dd-f2470da76c78.png)

I clear my cart and try again with 320 payloads:

![image](https://user-images.githubusercontent.com/83407557/209261618-9feb4213-f8cb-445f-b737-c1296646cd19.png)

This is still too far away from zero:

![image](https://user-images.githubusercontent.com/83407557/209265990-a9cfae64-f0d9-4e7c-bca3-d9d73b1903c9.png)

So I send the attack to repeater and manually start adding to the quantity:

![image](https://user-images.githubusercontent.com/83407557/209266055-4a2c7640-2618-454a-afb1-4c90385ea531.png)

after each request I check to make sure I don't loop back around to positive numbers:

![image](https://user-images.githubusercontent.com/83407557/209266130-c7e81bed-a53e-49c9-beb0-aae639d21c06.png)

![image](https://user-images.githubusercontent.com/83407557/209266171-602ee60e-afa4-4b76-b193-54169bb20eab.png)

![image](https://user-images.githubusercontent.com/83407557/209266229-ada0ca9d-043f-417d-b856-7e06d73186d3.png)

After three more request to add 99 units, I get to a number I can offset with another item.

# Step 5 offset the negative total with another item:

I need to look at the other items to see what would be the best to offset this negative number with and I decide to use the paddling pool shoes at 96.62

![image](https://user-images.githubusercontent.com/83407557/209266507-0878dd09-cba7-4aba-bb96-d1b4be5ec3f4.png)


again doing some math, I find that I need to add 664 of them to make a positive number:

```bash
└─$ python -c 'print(64060.96/96.62)'
663.0196646657006
```

I find that if I do another intruder attack with a quantity of 83, I will need 8 requests to get to 664:

```bash
└─$ python -c 'print(664/8)' 
83.0
```

I capture the request to add it to my cart:

![image](https://user-images.githubusercontent.com/83407557/209267043-fa1a8c7f-cbad-4027-8638-03a02658a029.png)

and then relaunch the intruder attack after changeing the item ID and number of requests to send:

![image](https://user-images.githubusercontent.com/83407557/209267123-947ade20-c7e2-4075-8ac0-7103b449479e.png)

![image](https://user-images.githubusercontent.com/83407557/209267565-b2a0178e-8624-45b7-8288-ae9f38dfec70.png)


After getting to 664 quantity, I have a price that I can afford with my store credit(that is also positive)

![image](https://user-images.githubusercontent.com/83407557/209267660-20e4bd78-c6f8-4250-81a7-19f8f8283846.png)

Now on checkout I get lots of jackets and shoes, and also solve the lab:

![image](https://user-images.githubusercontent.com/83407557/209267778-453d9d2c-0a5a-4040-91ad-8d157b6817ee.png)


