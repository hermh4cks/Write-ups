#!/usr/bin/env python3

import threading
import time


# example of threading used to build a network ping sweep script


# simulate the ping sweep by using  a time delay
def simulate_ping(n):
	time.sleep(2)
	print("192.168.1." + str(n))

# start a loop to go through the last octet in our ipv4 network range 
for i in range(1, 255):
    # create a thread for each call of our function with whatever iteration of this loop we are on as an argument
	x = threading.Thread(target=simulate_ping, args=(i,))
	# start the thread and go back to top of the loop
	x.start()
	#uncomment line 20 to see script run without threading as join waits for each thread to finish 
    #x.join()
