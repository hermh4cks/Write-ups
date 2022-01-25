#!/usr/bin/env python3

# Very slow python ping scanner

import subprocess
import os
import multiprocessing
import sys

subnet = input("What is the subnet?, example: 192.168.1\n")

for i in range(1, 254):
    address = subnet + '.' +  str(i)
    res = subprocess.call(['ping', '-c', '1', '-w', '3', address])
if res == 0:
    print (address) 
else:
    pass
