# Buffer Over Flows For the OSCP Exam

*The following are notes I have taken from the Cyber Mentor https://www.youtube.com/watch?v=qSnPayW6F7U* 

Being Used in this write-up are:
- Immunity Debugger https://www.immunityinc.com/products/debugger/index.html
- VulnServer(thegreycorner)https://github.com/stephenbradshaw/vulnserver
- mona.py plugin for immunity debugger https://github.com/corelan/mona
- Python3
- MSFVenom

## Steps
0. **Settup** Setting up vulnserver and our linux and windows boxes
1. **Spiking** Trying to determin if a funtion of the program is vulnerable to bof
2. **Fuzzing** Sending lots of a single character (AAA) to see if we can crash the program
3. **Finding the Offset** Find where fuzzing caused the crash
4.  **Overwrite the EIP Register** Using the offset
5.  **Find Bad Character** So exploit executes as intended 
6.  **Find the Right Module** Need one without memory protection
7.  **Generating shell code** Using MSFVenom

## Setup


## Spiking

For the purpose of this write-up the spiking program that I will be using is called spike, however there are others that will be used in other write-ups (buffas). 

### Spike

Pre-installed in kali, spike is invoked via the various functions it provides:

`generic` + *Tab-autocomplete* will show the options for spike:

```bash
generic_chunked           generic_send_tcp          generic_web_server_fuzz                           
generic_listen_tcp        generic_send_udp          generic_web_server_fuzz2
```
All of the options are going to need some form of host and port, as well as a .spk file that you create prior to running spike.

```bash
└─$ generic_send_tcp                                                                                         
argc=1
Usage: ./generic_send_tcp host port spike_script SKIPVAR SKIPSTR
./generic_send_tcp 192.168.1.100 701 something.spk 0 0
```
### Creating your .spk file

`nano spike.spk` to create our file (make sure you are making this in the same directory that you will run spike)

Most of the commands that spike will read need to be prefaced with an `s_` and **MUST* end in `;`

`s_readline();` to grab the input (or read the banner)
`s_string("TRUN ");` to input the literal string for the potentially vuln command with an added space
`s_string_variable("SPIKE");` sending a string but stating it is a variable (called anything) that will be dynamic

Save each of the above lines in your file and for use in the next step.

### Spiking the server

From the previous step, we take our .spk script and fuzz the app

`generic_send_tcp <ip> <port> spike.spk 0 0` we have the double zeros because we aren't using the skip variable or skip string options.

The output should look something like this, if not make sure the server is still up (nc back into it)



