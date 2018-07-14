#AS= as --32
#LD= ld -m elf_i386

#elaborazione.out: elaborazione.o
#	$(LD) elaborazione.o -o elaborazione.out

#elaborazione.o: elaborazione.s
#	$(AS) elaborazione.s -o elaborazione.o

compile: elaborazione.s controllore.c
	gcc -m32 -g -o exe elaborazione.s controllore.c
	./exe testin.txt prova_OUT
