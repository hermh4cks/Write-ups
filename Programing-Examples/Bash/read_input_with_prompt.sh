#!/bin/bash

#An example of how the -p for prompt and -s for silent with read command

read -p 'Username: ' username
read -sp 'Password: ' password

echo "Thanks, your creds are: $username and $password"
