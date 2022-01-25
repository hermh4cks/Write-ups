#!/bin/bash

# Showing that single quotes are literal and double will execute

variable="Hello World!"
echo 'with single quotes it shows: $variable'
echo "but with double quotes it shows: $variable"
