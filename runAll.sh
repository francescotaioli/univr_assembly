#!/bin/sh
set -e
rm -f *.o
gcc -m32 -g -o exe elaborazione.s controllore.c
./exe testin.txt prova_OUT