#!/usr/bin/env python3

import time 
import multiprocessing

# square root function with an artificial time delay to simulate a resource intensive process

def calc_square(numbers):
    for i in numbers:
        time.sleep(3) # the artificial time delay
        print('square: ', str(i * i))


# Cube root function

def calc_cube(numbers):
    for i in numbers:
        time.sleep(3)
        print('cube: ', str(i * i * i))

if __name__=="__main__":
    arr = [2, 3, 8, 9]
    # creating two processes called p1 and p2
    p1 = multiprocessing.Process(target=calc_square, args=(arr,))
    p2 = multiprocessing.Process(target=calc_cube, args=(arr,))
    # Starting processes here parallel with the start function.
    p1.start()
    p2.start()
    # this join() will wait until the calc_square is finished
    p1.join()
    # this join() will wait until the calc_cube function is finished
    print("Successes!")
