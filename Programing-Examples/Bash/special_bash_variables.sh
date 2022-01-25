#!/bin/bash

# Showing some special variables in bash
line='---------------------------------------------------------------'
line=$line$line

echo $line$line
echo '$0 '"bash script name: $0"
echo $line
echo '$1-$9' "arguements 1-9: $1 $2 $3 $4 $5 $6 $7 $8 $9"
echo $line
echo '$#' "Number of args passed to script: $#"
echo $line
echo '$@' "All args passed to the script: $@"
echo $line
echo '$?' "Exit status of most recent process: $?"
echo $line
echo '$$' "The process ID of current script: $$"
echo $line
echo '$USER' "The username of the user running the script: $USER"
echo $line
echo '$HOSTNAME' "The hostname of the machine: $HOSTNAME"
echo $line
echo '$RANDOM' "A random number: $RANDOM"
echo $line
echo '$LINENO' "Current line number in the script: $LINENO"
