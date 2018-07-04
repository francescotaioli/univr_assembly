#!/bin/sh
set -e
rm -f *.o
gcc -m32 -o EXE elaborazione.S controllore.c
./EXE testin.txt trueout.txt