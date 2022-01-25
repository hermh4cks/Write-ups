#!/bin/bash

# A script showing examples of operators with if statement

#variables

# a pretty linebreak

li='__________'
li=$li$li$li$li

## this file
script=$0


## some strings

string1=apple
string2=grape

## some integers

int1=1
int2=2


#if statements
echo $li




# -n

if [ -n $string1 ]
then
	echo "$string1 has a number of letters greater than zero"
fi
echo $li



# -z 

if [ -z $string1 ]
then
	echo "$string1 has zero letters"
else
	echo "$string1 does not have zero letters"
fi
echo $li


# not equals

if [ $string1 != $string2 ]
then
	echo "$string1 and $string2 are not the same"
fi
echo $li



# equals
if [ $sting1 = $sting1 ]
then
	echo "$string1 and $string1 are the same"
fi

echo $li

if [ 1 -eq 2 ]
then
	echo "1 equals 2"
elif [ 1 -ne 2 ]
then
	echo "1 does not equal 2"
fi
