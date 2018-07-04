#!/bin/sh
set -e
make
gcc -c -o controllore.o controllore.c
gcc -o ESEGUIBILE elaborazione.o controllore.o
ESEGUIBILE