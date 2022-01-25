#!/bin/bash

# variable scope example

num1="1"
num2="2"

namber_change() {
	local num1="3"
	echo "Inside of this function, A is $num1 and B is $num2"
	num2="4"
}

echo "Before the function call, A is $num1 and B is $num2"

namber_change

echo "After the function call, A  is $num1 and B is $num2"


