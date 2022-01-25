#!/bin/bash

#conditional if something than something

read -p "What is your number between 1 and 10: " variable

if [ $variable -lt 10 ]
then
	echo "Your number is $variable"
elif [ $variable -eq 10 ]
then
	echo "You found the secret number!"
else
	echo "Your number is higher than 10"
fi
