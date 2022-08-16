# Buffer Overflow Prep from tryhackme.

This series of write-ups was to help me prep for a potential buffer overflow box for the revised OSCP exam.

Following the guide from [Tib3rius](https://github.com/Tib3rius/Pentest-Cheatsheets/blob/master/exploits/buffer-overflows.rst) (who also happens to be a co-author of this series.

This write-up containts the following machines, as well as a template for exploitation written bellow.

- [The SLMail installer](/TryHackMe/Buffer_Overflow_Prep/slmail.md)

- [The brainpan binary](/TryHackMe/Buffer_Overflow_Prep/brainpan.md)

- [The dostackbufferoverflowgood binary](/TryHackMe/Buffer_Overflow_Prep/dostackbufferoverflowgood.md)

- [The vulnserver binary](/TryHackMe/Buffer_Overflow_Prep/vulnserver.md)

- [custom written "oscp" binary 1](/TryHackMe/Buffer_Overflow_Prep/1.md)

- [custom written "oscp" binary 2](/TryHackMe/Buffer_Overflow_Prep/2.md)

- [custom written "oscp" binary 3](/TryHackMe/Buffer_Overflow_Prep/3.md)

- [custom written "oscp" binary 4](/TryHackMe/Buffer_Overflow_Prep/4.md)

- [custom written "oscp" binary 5](/TryHackMe/Buffer_Overflow_Prep/5.md)

- [custom written "oscp" binary 6](/TryHackMe/Buffer_Overflow_Prep/6.md)

- [custom written "oscp" binary 7](/TryHackMe/Buffer_Overflow_Prep/7.md)

- [custom written "oscp" binary 8](/TryHackMe/Buffer_Overflow_Prep/8.md)

- [custom written "oscp" binary 9](/TryHackMe/Buffer_Overflow_Prep/9.md)

- [custom written "oscp" binary 10](/TryHackMe/Buffer_Overflow_Prep/10.md)


===

# BUFFER OVERFLOW METHODOLOGY.

A buffer overflow happens when the amount of data being placed into memory is greater than the buffer(or area) that was provided, causing the extra data to "overflow" into neighboring memory-space. This can allow an attacker to craft target specific data that can end up controlling the execution flow of the program, once they have broken free of the buffer prison. This is a template for discovering and exploiting buffer overflows on windows 32 bit systems.

### Tools being used

On the target system we will be using a debugger to view and pause the execution flow of the vulnerable applications, as well as search through system memory in order to craft our attack. The debugger being used in these examples is immunity debugger.

### IMMUNITY TIPS

- If at all possible, run as Administrator

- If target application is already running `File -> Attach`

- If target application is not running `File -> Open`

- If target application is a windows service may have to use `sc`

- To stop/start a windows service with sc `sc stop/start "service name"`

- `CTR F2` Restarts target application

- `F9` Runns the program (starts paused)

