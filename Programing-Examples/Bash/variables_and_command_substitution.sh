#!/bin/bash

#Command substitution can be done using two methods

# Newer with () and $ using the whoami command:

method_one=$(whoami)
echo $method_one

# Older version of the same thing using back-ticks `:

method_two=`whoami`
echo $method_two
