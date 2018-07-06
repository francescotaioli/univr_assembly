
.section .data

riga:
    .ascii "000-1011001000\n"
riga_len:
    .long . - riga
.section .text
.global asm_main
.type asm_main, @function

asm_main:

    movl $4, %eax						#syscall print
    movl $1, %ebx						#scelgo il temrminale
    movl 4(%esp), %ecx 					#mette la stringa in ecx
    movl riga_len, %edx 				#metto la linghezza in edx

    int  $0x80 #interupt print
    ret