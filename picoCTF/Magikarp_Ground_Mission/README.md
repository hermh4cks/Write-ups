# Magikarp Ground Mission


promt: *Do you know how to move between directories and read files in the shell? Start the container, `ssh` to it, and then `ls` once connected to begin. Login via `ssh` as `ctf-player` with the password, `6d448c9c`
*


hint: Finding a cheatsheet for bash would be really helpful!

`ssh ctf-player@venus.picoctf.net -p 56150`


After loggin in let's start with some basic recon of the surroundings

```bash
ctf-player@pico-chall$ whoami
ctf-player
ctf-player@pico-chall$ uname -r
5.4.0-1041-aws
ctf-player@pico-chall$  cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04.5 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.5 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
ctf-player@pico-chall$ pwd
/home/ctf-player/drop-in
ctf-player@pico-chall$ ls -la
total 16
drwxr-xr-x 1 ctf-player ctf-player 4096 Mar 16  2021 .
drwxr-xr-x 1 ctf-player ctf-player 4096 Jan  7 17:34 ..
-rw-r--r-- 1 ctf-player ctf-player   14 Mar 16  2021 1of3.flag.txt
-rw-r--r-- 1 ctf-player ctf-player   56 Mar 16  2021 instructions-to-2of3.txt
ctf-player@pico-chall$ 

```

I see that we are on a Ubuntu box
Lets get the flag, and cat out the next instructions

```bash
ctf-player@pico-chall$ cat 1of3.flag.txt 
picoCTF{xxsh_
ctf-player@pico-chall$ cat instructions-to-2of3.txt 
Next, go to the root of all things, more succinctly `/`
ctf-player@pico-chall$ 
```


Okay, so I have part of the flag, lets see what I can look at in the root directory.

```bash
ctf-player@pico-chall$ 
ctf-player@pico-chall$ cd /
ctf-player@pico-chall$ ls -la
total 92
drwxr-xr-x   1 root root 4096 Jan  7 17:33 .
drwxr-xr-x   1 root root 4096 Jan  7 17:33 ..
-rwxr-xr-x   1 root root    0 Jan  7 17:33 .dockerenv
-rw-r--r--   1 root root   17 Mar 16  2021 2of3.flag.txt
drwxr-xr-x   1 root root 4096 Mar 16  2021 bin
drwxr-xr-x   2 root root 4096 Apr 24  2018 boot
drwxr-xr-x   5 root root  340 Jan  7 17:33 dev
drwxr-xr-x   1 root root 4096 Jan  7 17:33 etc
drwxr-xr-x   1 root root 4096 Mar 16  2021 home
-rw-r--r--   1 root root   51 Mar 16  2021 instructions-to-3of3.txt
drwxr-xr-x   1 root root 4096 Mar 16  2021 lib
drwxr-xr-x   2 root root 4096 Feb 22  2021 lib64
drwxr-xr-x   2 root root 4096 Feb 22  2021 media
drwxr-xr-x   2 root root 4096 Feb 22  2021 mnt
drwxr-xr-x   1 root root 4096 Mar 16  2021 opt
dr-xr-xr-x 213 root root    0 Jan  7 17:33 proc
drwx------   2 root root 4096 Feb 22  2021 root
drwxr-xr-x   1 root root 4096 Jan  7 17:34 run
drwxr-xr-x   1 root root 4096 Mar 16  2021 sbin
drwxr-xr-x   2 root root 4096 Feb 22  2021 srv
dr-xr-xr-x  13 root root    0 Jan  7 17:33 sys
drwxrwxrwt   1 root root 4096 Mar 16  2021 tmp
drwxr-xr-x   1 root root 4096 Feb 22  2021 usr
drwxr-xr-x   1 root root 4096 Feb 22  2021 var
ctf-player@pico-chall$ cat 2of3.flag.txt instructions-to-3of3.txt 
0ut_0f_\/\/4t3r_
Lastly, ctf-player, go home... more succinctly `~`

```

Now I have the middle portion of the flag, lets go to my home directory:

```bash
ctf-player@pico-chall$ cd ~
ctf-player@pico-chall$ ls -la
total 32
drwxr-xr-x 1 ctf-player ctf-player 4096 Jan  7 17:34 .
drwxr-xr-x 1 root       root       4096 Mar 16  2021 ..
drwx------ 2 ctf-player ctf-player 4096 Jan  7 17:34 .cache
-rw-r--r-- 1 ctf-player ctf-player   80 Mar 16  2021 .profile
drw------- 1 ctf-player ctf-player 4096 Mar 16  2021 .ssh
-rw-r--r-- 1 ctf-player ctf-player   10 Mar 16  2021 3of3.flag.txt
drwxr-xr-x 1 ctf-player ctf-player 4096 Mar 16  2021 drop-in
ctf-player@pico-chall$ cat 3of3.flag.txt 
5190b070}

```


And with that I have the entire flag:


picoCTF{xxsh_0ut_0f_\/\/4t3r_5190b070}