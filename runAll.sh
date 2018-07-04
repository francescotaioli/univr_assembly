#!/bin/sh
set -e
rm -f *.o
gcc -c -o controllore.o controllore.c
gcc -c -m32 -o elaborazione.o elaborazione.s
gcc -c -m32  -o ESEGUIBILE controllore.o elaborazione.o
ESEGUIBILE