#!/bin/bash

# Showing the AND boolean logical operation using hostname and user via the &&

if [ $USER == 'root' ] && [ $HOSTNAME == 'kali' ]
then
	echo "You are not root@kali"
else
	echo "You are not root@kali"
fi
