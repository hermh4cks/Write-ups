#!/usr/bin/env python3

import multiprocessing
import os
import sys
import subprocess
import threading


subnet = input("Enter a subnet. Example: 192.168.1 \n")



def ping_sweep(ip):
    address = subnet + '.' + str(ip)
    result = subprocess.call(['ping', '-c', '3', '-w', '3',  address])
    if result == 0:
        print (address)
    else:
        pass


for i in range(1, 255):
    x = threading.Thread(target=ping_sweep, args=(i,))
    x.start()


### NOTES!!! need to add regex to 




