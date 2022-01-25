#!/bin/bash

# and example of how a function can store and return value with the $? global var


return_me() {
	echo "I am returning a random value"
	return $RANDOM
}

return_me

echo "The previous function returned a value of $?"
