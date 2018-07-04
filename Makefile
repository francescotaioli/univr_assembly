AS= as --32
LD= ld -m elf_i386

elaborazione.out: elaborazione.o
	$(LD) elaborazione.o -o elaborazione.out

elaborazione.o: elaborazione.s
	$(AS) elaborazione.s -o elaborazione.o

