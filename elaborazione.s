.section .data

riga:
    .ascii "0"
riga_len:
    .long . - riga

.section .text
.global asm_main
.type asm_main, @function

asm_main:

    pushl %ebp
	movl %esp, %ebp

    movl $4, %eax      				#syscall print
    movl $1, %ebx      				#scelgo il terminale
    movl 8(%esp), %ecx      		#mette la stringa in ecx
    movl riga_len, %edx     		#metto la lunghezza in edx

    int  $0x80 						#interrupt print
	movl  %ebp, %esp
 	popl  %ebp
 ret