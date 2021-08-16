# Buffer Over Flows For the OSCP Exam

*The following are notes I have taken from the Cyber Mentor https://www.youtube.com/watch?v=qSnPayW6F7U* 

Being Used in this write-up are:
- Immunity Debugger https://www.immunityinc.com/products/debugger/index.html
- VulnServer(thegreycorner)https://github.com/stephenbradshaw/vulnserver
- mona.py plugin for immunity debugger https://github.com/corelan/mona
- Python3
- MSFVenom

## Steps
1. **Spiking** Trying to determin if a funtion of the program is vulnerable to bof
2. **Fuzzing** Sending lots of a single character (AAA) to see if we can crash the program
3. **Finding the Offset** Find where fuzzing caused the crash
4.  **Overwrite the EIP Register** Using the offset
5.  **Find Bad Character** So exploit executes as intended 
6.  **Find the Right Module** Need one without memory protection
7.  **Generating shell code** Using MSFVenom

## Spiking


