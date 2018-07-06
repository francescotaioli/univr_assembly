
.section .data

riga:
    .ascii "000-1011001000\n"
riga_len:
    .long . - riga
.section .text
.global asm_main
.type asm_main, @function

asm_main:

    movl $4, %eax
    movl $1, %ebx
    #mette mega stringona in ecx
    movl 4(%esp), %ecx
    #stampa la mega stringona per la lunghezza di riga
    movl riga_len, %edx

    int  $0x80
    ret