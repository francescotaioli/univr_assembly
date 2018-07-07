.section .data


riga:
   .ascii "0"
riga_len:
    .long . - riga

#riga_len: .long 271                #altro metodo più elegante per scrivere lunghezza(max len = 270)

.section .text
.global asm_main
.type asm_main, @function

asm_main:

    pushl %ebp
 	movl %esp, %ebp
    movl 8(%ebp), %ecx       		#mette la stringa in ecx
	check:
		cmpb  $0x00, (%ecx)				#$55 è il 7
		jne increment
		jmp fine_main
		            				
	increment:
		movl $4, %eax          			
		movl $1, %ebx
		movl riga_len, %edx     		
		int $0x80 
		addl $1, %ecx 
		jmp check

	fine_main:
		#mov %ecx, %eax
        
		movl %ebp, %esp
		popl %ebp
		#leave
		ret
