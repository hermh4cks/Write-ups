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

![image](https://user-images.githubusercontent.com/83407557/183640155-c03f3a9f-2d5b-46ff-aa19-8bfc5e0d1ef9.png)

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

![image](https://user-images.githubusercontent.com/83407557/183643562-91a4787a-eae7-44de-9b5e-d0c8911e3c3b.png)


The /etc/shadow file is where linux stores user's password hashes. If readable, it is possible to extract the hashes and crack them.

![image](https://user-images.githubusercontent.com/83407557/183640988-96e68159-991b-47d8-b9e4-ed8e2b158e69.png)

Using the rockyou.txt wordlist and hashcat, both extracted hashes are crackable 

![image](https://user-images.githubusercontent.com/83407557/183641879-31adcf4c-349d-4865-a012-478dfedb6d80.png)

Now on the target system I can use the su command to become the root user

![image](https://user-images.githubusercontent.com/83407557/183642307-7d715767-5883-403c-82dd-ab030e15d7f9.png)


## Weak File Permissions - Writeable /etc/shadow

As can be seen by the yellow, /etc/shadow being world-writeable is a low hanging fruit privilege escalation. 

![image](https://user-images.githubusercontent.com/83407557/183643893-9be50e0e-7668-4ccf-a7a8-912352d6aa6b.png)

For this privesc cracking the hashes is not required, and you lock the actual root user out of their own account. Simply create a hash of a password you know and replace the hash you dont know. Then su to root:

![image](https://user-images.githubusercontent.com/83407557/183647823-6d26b77a-7387-4a88-9f5b-5fa565215a17.png)

Checking that I can write to the file, and making a copy (always make a copy)

![image](https://user-images.githubusercontent.com/83407557/183648088-7fafe26d-a2be-43cc-8a89-10efe9b9459a.png)

Making my own hash with `mkpasswd -m sha-512 mypassword`

![image](https://user-images.githubusercontent.com/83407557/183648523-e01e6f9f-a8f7-498a-a925-d5a3b3c6808e.png)

Using sed to edit the file

`sed -i 's#find#replace#g file'`

`sed -i 's#$6$Tb/euwmK$OXA.dwMeOAcopwBl68boTG5zi65wIHsc84OWAIye5VITLLtVlaXvRDJXET..it8r.jbrlpfZeMdwD3B0fGxJI0#$6$QGZ7v32ukVS6Y$3cx2VP4LESpvEBto4jj2evGx1uOb.ghTU2Y8PTmsIMLeIZpTogPa09rkBDCxOs8lUyDTvLg/qzX276syveGNV0#g' /tmp/shadow`

![image](https://user-images.githubusercontent.com/83407557/183652382-dad34534-983b-477f-a69b-d2c67618c84d.png)



I then switch it back to continue on with the lab

![image](https://user-images.githubusercontent.com/83407557/183652623-4190198b-6186-4bf6-82c4-5016200ba42e.png)

## Weak File Permissions - Writeable /etc/passwd

![image](https://user-images.githubusercontent.com/83407557/183643893-9be50e0e-7668-4ccf-a7a8-912352d6aa6b.png)

Before there was a shadow file the system hashes were stored on the passwd file. If this is writeable, the shadow file can be bypassed altogether. The attack works in almost the same way as a writeable shadow file, but with this we can also add a new root user.

As can be seen the X indicates that linux check the shadow file for the password hash.

![image](https://user-images.githubusercontent.com/83407557/183653444-cb813421-a7f9-4f80-b184-fc96ba3065fe.png)

Changing the root password

![image](https://user-images.githubusercontent.com/83407557/183655779-6ffc90f8-4f36-4674-bebe-3684c1bdf21f.png)

alternatively I can take that same password that I made, and create my own new root user with echo and piping it to /etc/passwd

`echo 'newroot:wikA5rxUytB.I:0:0:root:/root:/bin/bash'>>/etc/passwd`

![image](https://user-images.githubusercontent.com/83407557/183656753-fe9ace82-00ad-4ed9-9844-c0a568038482.png)


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
