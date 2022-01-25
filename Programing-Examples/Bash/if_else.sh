#!/bin/bash

#conditional if something than something

read -p "What is your number between 1 and 10: " variable

if [ $variable -lt 11 ]
then
	echo "Your number is $variable"
else
	echo "Your number is higher than 10"
fi
