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
		cmpb  $55, %ecx
		je fine_main
		                 #scorro di 1 lettera quello che ho letto
		
		movl $4, %eax          			#syscall print
		movl $1, %ebx
		movl riga_len, %edx     		#metto la lunghezza in edx
		int $0x80 
		  					
		jmp increment    				
	increment:
		addl $1, %ecx 
		jmp check

	fine_main:
		movl %ebp, %esp
		popl %ebp
		ret