#!/bin/bash
nc mercury.picoctf.net 43239| awk '{printf("%c",$1)}'
