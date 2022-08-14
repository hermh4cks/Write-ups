# Hacking FTP

[**BACK** to Service Scanning](/Methodology/Network/Services.md#service-scanning)

| Protocol | Default Port | Description |
| :-: | :-: | --- |
| tcp | 21 | client-server based service used to transfer files on a network |

From Hacktricks

*It is a plain-text protocol that uses as new line character `0x0d` `0x0a` so sometimes you need to connect using `telnet` or `nc -C`.*

Can Connect anonymously on some servers. Using:
```
anonymous : anonymous
anonymous :
ftp : ftp
```


## Usefull commands

```bash
ftp <IP>
>anonymous
>anonymous
>ls -a # List all files (even hidden)
>binary #Set transmission to binary instead of ascii
>ascii #Set transmission to ascii instead of binary
>bye #exit
```

![image](https://user-images.githubusercontent.com/83407557/184520784-41c1211d-4a69-43d7-8f47-a4c327a8ce1a.png)
