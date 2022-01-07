# Tab, Tab, Attack

prompt: *Using tabcomplete in the Terminal will add years to your life, esp. when dealing with long rambling directory structures and filenames: Addadshashanammu.zip*

hint: *After `unzip`ing, this problem can be solved with 11 button-presses...(mostly Tab)...*


First thing is to gather the .zip file with wget

```bash
└─# wget https://mercury.picoctf.net/static/659efd595171e4c40378be6a2e9b7298/Addadshashanammu.zip
--2022-01-06 20:46:50--  https://mercury.picoctf.net/static/659efd595171e4c40378be6a2e9b7298/Addadshashanammu.zip
Resolving mercury.picoctf.net (mercury.picoctf.net)... 18.189.209.142
Connecting to mercury.picoctf.net (mercury.picoctf.net)|18.189.209.142|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4520 (4.4K) [application/octet-stream]
Saving to: ‘Addadshashanammu.zip’

Addadshashanammu.zip         100%[=============================================>]   4.41K  --.-KB/s    in 0s      

2022-01-06 20:46:55 (70.5 MB/s) - ‘Addadshashanammu.zip’ saved [4520/4520]
```

Then let's see about unzipping it:

```bash
└─# unzip Addadshashanammu.zip 
Archive:  Addadshashanammu.zip
   creating: Addadshashanammu/
   creating: Addadshashanammu/Almurbalarammi/
   creating: Addadshashanammu/Almurbalarammi/Ashalmimilkala/
   creating: Addadshashanammu/Almurbalarammi/Ashalmimilkala/Assurnabitashpi/
   creating: Addadshashanammu/Almurbalarammi/Ashalmimilkala/Assurnabitashpi/Maelkashishi/
   creating: Addadshashanammu/Almurbalarammi/Ashalmimilkala/Assurnabitashpi/Maelkashishi/Onnissiralis/
   creating: Addadshashanammu/Almurbalarammi/Ashalmimilkala/Assurnabitashpi/Maelkashishi/Onnissiralis/Ularradallaku/
  inflating: Addadshashanammu/Almurbalarammi/Ashalmimilkala/Assurnabitashpi/Maelkashishi/Onnissiralis/Ularradallaku/fang-of-haynekhtnamet  
                           
```


Using the `-R` flag with the `ls` command I can recursively list the sub-directories

```bash
└─# ls -R Addadshashanammu 
Addadshashanammu:
Almurbalarammi

Addadshashanammu/Almurbalarammi:
Ashalmimilkala

Addadshashanammu/Almurbalarammi/Ashalmimilkala:
Assurnabitashpi

Addadshashanammu/Almurbalarammi/Ashalmimilkala/Assurnabitashpi:
Maelkashishi

Addadshashanammu/Almurbalarammi/Ashalmimilkala/Assurnabitashpi/Maelkashishi:
Onnissiralis

Addadshashanammu/Almurbalarammi/Ashalmimilkala/Assurnabitashpi/Maelkashishi/Onnissiralis:
Ularradallaku

Addadshashanammu/Almurbalarammi/Ashalmimilkala/Assurnabitashpi/Maelkashishi/Onnissiralis/Ularradallaku:
fang-of-haynekhtnamet
```


Lets take a look at the file with the `file` command

```bash
└─# file fang-of-haynekhtnamet 
fang-of-haynekhtnamet: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=e34ce4e4ee2f7ce7fb251c8f5ab036da9882bc55, not stripped
```

And checking with strings

```bash
└─# strings fang-of-haynekhtnamet                                                                                  
/lib64/ld-linux-x86-64.so.2                                                                                        
libc.so.6                                                                                                          
puts                                                                                                               
__cxa_finalize                                                                                                     
__libc_start_main                                                                                                  
GLIBC_2.2.5                                                                                                        
_ITM_deregisterTMCloneTable                                                                                        
__gmon_start__                                                                                                     
_ITM_registerTMCloneTable                                                                                          
AWAVI                                                                                                              
AUATL                                                                                                              
[]A\A]A^A_                                                                                                         
*ZAP!* picoCTF{l3v3l_up!_t4k3_4_r35t!_524e3dc4}     
```

and bingo! ...but that left a bad taste in my mouth....


lets run it and see what happens....

```bash
└─# ./fang-of-haynekhtnamet
*ZAP!* picoCTF{l3v3l_up!_t4k3_4_r35t!_524e3dc4}
```

well okay, we just win I guess
