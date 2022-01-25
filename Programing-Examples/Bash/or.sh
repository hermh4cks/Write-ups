#!/bin/bash

# Showing the OR the same way as AND but detecting if I am root 

# The OR symbol in bash is ||


if [ $USER == 'kali' ] || [ $USER == 'root' ] && [ $HOSTNAME == 'kali' ]
then
	echo "You are on kali linux"
elif [ $USER == 'root' ] && [ $HOSTNAME == 'kali']
then
	echo "But be careful! Your are ROOT!"
else
	echo "not being run as intended user or on intended system"
fi
