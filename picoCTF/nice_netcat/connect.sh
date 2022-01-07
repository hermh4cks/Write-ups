#!/bin/bash
nc mercury.picoctf.net 43239>/tmp/my_output;
sleep 1;
cat /tmp/my_output;
