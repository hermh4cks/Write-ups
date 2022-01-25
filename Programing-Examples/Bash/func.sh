#!/bin/bash

# function example with both way to define


# first way by prefacing with the word function
function my_function {
	echo "This was created with my function"
}


# another way to declare a function is with just the function name and parenthises

my_other_function () {
	echo "This was created with my other function"
}

# we can then call either or both:

my_function

my_other_function
