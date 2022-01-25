#!/bin/bash -x

echo "This script uses debugging because of the -x flag in shebang"

# This makes it so we can see commands executed in current shell have *
# Whereas commands executed in a subshell have **

variable_one=value_one
echo $variable_one

variable_two=value_two
echo $variable_two

# This can then show the diff in how $() vs `` for Com Sub

$(variable_one=new_variable)
echo $variable_one

`variable_two=newer_variable`
echo $variable_two
