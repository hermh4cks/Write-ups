# Lab: Web shell upload via extension blacklist bypass

## Description

 This lab contains a vulnerable image upload function. Certain file extensions are blacklisted, but this defense can be bypassed due to a fundamental flaw in the configuration of this blacklist.

To solve the lab, upload a basic PHP web shell, then use it to exfiltrate the contents of the file /home/carlos/secret. Submit this secret using the button provided in the lab banner.

You can log in to your own account using the following credentials: wiener:peter 

## Hint


You need to upload two different files to solve this lab.

## Tips

### Overriding the server configuration

As we discussed in the previous section, servers typically won't execute files unless they have been configured to do so. For example, before an Apache server will execute PHP files requested by a client, developers might have to add the following directives to their /etc/apache2/apache2.conf file:

```
LoadModule php_module /usr/lib/apache2/modules/libphp.so
AddType application/x-httpd-php .php
```

Many servers also allow developers to create special configuration files within individual directories in order to override or add to one or more of the global settings. Apache servers, for example, will load a directory-specific configuration from a file called .htaccess if one is present.

Similarly, developers can make directory-specific configuration on IIS servers using a web.config file. This might include directives such as the following, which in this case allows JSON files to be served to users:

```
<staticContent>
    <mimeMap fileExtension=".json" mimeType="application/json" />
</staticContent>
```

Web servers use these kinds of configuration files when present, but you're not normally allowed to access them using HTTP requests. However, you may occasionally find servers that fail to stop you from uploading your own malicious configuration file. In this case, even if the file extension you need is blacklisted, you may be able to trick the server into mapping an arbitrary, custom file extension to an executable MIME type. 

---

# 1 Map out image upload functionality

I can upload an image without a server error (I take note that is an apache server running on ubuntu)

![image](https://user-images.githubusercontent.com/83407557/171209252-a4d0035b-4a74-4af1-902f-e66a59d7db2a.png)

However I get the following error when trying to upload my php file:

![image](https://user-images.githubusercontent.com/83407557/171209460-d0231dd8-071a-4f8c-985e-479e3f463f8b.png)

# Step 2 upload a new .htaccess file to load a directory-specific configuration for /files/avatars/

I will create a new file on the server and call it .htaccess and it will contain the following directive to execute any .hacked file exetensions as PHP files.

```
AddType application/x-httpd-php .hacked
```

I then use the upload image funtion to upload my php webshell again, but this time changing the values

filename to .htaccess
content-type to text/plain
content from my php code to the above line

![image](https://user-images.githubusercontent.com/83407557/171211721-c68e7077-3138-49d9-a419-98cdc0f4e509.png)

![image](https://user-images.githubusercontent.com/83407557/171211857-f6831e39-47c5-450f-a679-b9f77e0ffad9.png)

# Step 3 upload getsecret.php but change the extension to .hacked

get this response

![image](https://user-images.githubusercontent.com/83407557/171212322-0dfac8cc-8274-4cd7-a6aa-a248931ae2bc.png)

# Step 4 Execute PHP code at /files/avatars/get_secret.hacked

![image](https://user-images.githubusercontent.com/83407557/171212554-e7c992fb-c7bb-423b-9868-0f58b41dcfb8.png)

# Step 5 Submit secret

![image](https://user-images.githubusercontent.com/83407557/171212658-f27db8d4-d86d-4ea6-b4a1-f3729cbf5397.png)

![image](https://user-images.githubusercontent.com/83407557/171212726-aafe97c1-bb7b-4472-b425-eaa51945eaa2.png)
