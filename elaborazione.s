.section .data

strApri:
	.ascii "COMANDO TENDE: APRI\n"
strApriLen:
	.long . - strApri
.section .text
.global asm_main
.type asm_main, @function

/* riceve il valore in eax */
asm_main:
	if0:
	 	movl 4(%esp), %ecx
		cmp  $5, %ecx
		leal strApri, %ecx
		movl strApriLen, %edx
		jmp  stampa_stringa
	
	stampa_stringa:
		movl $4, %eax
		movl $1, %ebx
		int  $0x80
	stampa_end:
ret
