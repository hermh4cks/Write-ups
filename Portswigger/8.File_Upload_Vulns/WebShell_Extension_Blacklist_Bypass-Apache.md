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

# 1 Map out image upload functionality

I can upload an image without a server error (I take note that is an apache server running on ubuntu)

![image](https://user-images.githubusercontent.com/83407557/171209252-a4d0035b-4a74-4af1-902f-e66a59d7db2a.png)

However I get the following error when trying to upload my php file:

![image](https://user-images.githubusercontent.com/83407557/171209460-d0231dd8-071a-4f8c-985e-479e3f463f8b.png)

# 2 upload a new .htaccess file to load a directory-specific configuration for /files/avatars/

I will create a new file on my computer and call it .htaccess and it will contain the following directive to execute any .hacked file exetensions as PHP files.

```
AddType application/x-httpd-php .hacked
```

![image](https://user-images.githubusercontent.com/83407557/171210402-d115c52f-cadc-416d-aba3-99b5ec95bff4.png)

I then use the upload image funtion to upload it
