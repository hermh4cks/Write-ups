#!/bin/bash
echo "[+] using awk to convert decimal to ascii"
cat output | awk '{printf("%c",$1)}'
