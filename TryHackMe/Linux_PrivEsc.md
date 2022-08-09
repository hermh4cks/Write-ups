# Linux Privilege Escalation room

[1. Intro](#Intro)

[2. Service Exploits](#service-exploits)

[3. Weak File Permissions - Readable /etc/shadow](#weak-file-permissions---readable-etcshadow)

[4. Weak File Permissions - Writeable /etc/shadow](#weak-file-permissions---writeable-etcshadow)

[5. Weak File Permissions - Writeable /etc/passwd](#weak-file-permisions---writeable-etcpasswd)

[6. Sudo - Shell Escape Sequences](#sudo---shell-escape-sequences)

[7. Sudo - Environment Variables](#sudo---environment-variables)

[8. Cron Jobs - File Permissions](#cron-jobs---file-permissions)

[9. Cron Jobs - PATH Environment Variables](#cron-jobs---path-environment-variables)

[10. Cron Jobs - Wildcards](#cron-jobs---wildcards)

[11. SUID/SGID Executables - Know Exploits](#suidsgid-executables---know-exploits)

[12. SUID/SGID Executables - Shared Object Injection](#suidsgid-executables---shared-object-injection)

[13. SUID/SGID Executables - Environment Variables](#suidsgid-executables---environment-variables)

[14. SUID/SGID Executables - Abusing Shell Features 1](suidsgid-executables---abusing-shell-features-1)

[15. SUID/SGID Executables - Abusing Shell Features 1](suidsgid-executables---abusing-shell-features-2)

[16. Passwords & Keys - History Files](#passwords--keys---history-files)

[17. Passwords & Keys - Config Files](#passwords--keys---config-files)

[18. Password & Keys - SSH Keys](#passwords--keys---ssh-keys)

[19. NFS](#nfs)

[20. Kernel Exploits](#kernel-exploits)

[21. Privilege Escalation Scripts](#privilege-escalation-scripts)


## Intro

![image](https://user-images.githubusercontent.com/83407557/183507502-83e1552c-3506-41c3-a521-78ce3ab0764b.png)


The above method does not work if you are using the VPN. You will get the following error.

![image](https://user-images.githubusercontent.com/83407557/183533330-cf27195b-086c-4bb3-9a88-b6110f9364ba.png)

![image](https://user-images.githubusercontent.com/83407557/183533390-b949b0bf-ad63-4af7-94e0-e721c91185d1.png)


The fix is to run the ssh command with the following added flag:

`ssh -oHostKeyAlgorithms=+ssh-dss user@10.10.197.141`

I am going to load in LinPEAs at the onset, just to get an idea of what will get picked up from the vulns in this room. First I will check that I have wget and python on the target to transfer files. Then I will spin up a python server on my local kali instance to transfer LinPEAs.

![image](https://user-images.githubusercontent.com/83407557/183534243-f43ef0fc-51c4-4ad2-856a-983291535954.png)

With this script from carlospolop, I can easily spot low hanging fruit, as well as scan for things I may have overlooked with just manual enumeration. 

## Service Exploits

mysql is found to be running as root, and the root "user" has no password set

![image](https://user-images.githubusercontent.com/83407557/183534783-306f8b45-9031-4660-aa30-ecf1dc58aaa4.png)


 Verifying I can log in as root via mysql
 
 ![image](https://user-images.githubusercontent.com/83407557/183534914-171ca9bf-7def-4406-929b-284f03d15262.png)


### Exploit

There is an exploit that uses User Defined Functions(UDFs) and lets me run system commands as root via the MySQL service.
https://www.exploit-db.com/exploits/1518

![image](https://user-images.githubusercontent.com/83407557/183535466-9d94dd62-0f25-45b2-9fd0-b9f55d03a6f8.png)

I can grab this exploit locally and send it again with python and wget

![image](https://user-images.githubusercontent.com/83407557/183535960-9186e6b2-9857-4e95-8ce8-fa8d98792c42.png)


Then compile it on target and use MySQL to create UDF "do_system" then use the function to copy /bin/bash to /tmp/rootbash.

![image](https://user-images.githubusercontent.com/83407557/183536636-304c82e2-3f03-4bfb-82d7-898f829fb5b1.png)


## Weak File Permissions - Readable /etc/shadow

## Weak File Permissions - Writeable /etc/shadow

## Weak File Permissions - Writeable /etc/passwd

## Sudo - Shell Escape Sequences

## Sudo - Environment Variables

## Cron Jobs - File Permissions

## Cron Jobs - PATH Environment Variables

## Cron Jobs - Wildcards

## SUID/SGID Executables - Know Exploits

## SUID/SGID Executables - Shared Object Injection

## SUID/SGID Executables - Environment Variables

## SUID/SGID Executables - Abusing Shell Features 1

## SUID/SGID Executables - Abusing Shell Features 2

## Passwords & Keys - History Files

## Passwords & Keys - Config Files

## Password & Keys - SSH Keys

## NFS

## Kernel Exploits

## Privilege Escalation Scripts
