.section .data
# rappresentano i cicli di overload, vanno settate a runtime
is_OL_4: .int 0 				# mi dice se devo contare la lavastoviglie
is_OL_5: .int 0 				# mi dice se devo spegnere la lavatrice
is_OL_6: .int 0 				# devo staccare tutto
current_OL: .int 0 				# valore del OL corrente
is_ON: .int 0					# indica se il sistema è spento
# rappresentano i watt di ogni elettrodomestico
loads:
	.value 2000
	.value 300
	.value 1200
	.value 1000
	.value 2000
	.value 1800
	.value 240
	.value 400
	.value 200
	.value 400

riga:
   .ascii "0"
riga_len:
    .long . - riga

# riga_len: .long 271                # altro metodo più elegante per scrivere lunghezza(max len = 270)

.section .text
.global asm_main
.type asm_main, @function

asm_main:

    pushl %ebp
 	movl %esp, %ebp
    movl 8(%ebp), %ecx       		# mette la stringa in ecx
	check:
		cmpb  $0x00, (%ecx)				# check se la lettera analizzata è '\0' ($0x00)
		jne increment                   # se non  uguale salta all'incremento
		jmp fine_main                   # salta a fine main
	#scorre una riga in input	            				
	increment:
		movl $4, %eax          			
		movl $1, %ebx
		movl riga_len, %edx     		
		int $0x80

		# se il primo bit è a 0 e is_ON è a zero vado a controllo_1_bit
		mov is_ON, %al
		cmp $0, %al
		jz controllo_1_bit
	fine_controllo_1_bit:
		cmpb $0x0A, (%ecx)              # confronta lettera analizzata con '\n
		je random_per_ora               # se trovo '\n' salta a 'random_per_ora'

    fine_increment:                     # punto di aggancio per tornare indietro e continuare
		addl $1, %ecx                   # a scorrere la stringa
		jmp check

    random_per_ora:                     # al momento questa funzione stampa un altra volta
        movl $4, %eax                   # quello che c'è in ecx, quindi il caporiga
        movl $1, %ebx
        movl riga_len, %edx
        int $0x80
        jmp fine_increment              # salta a fine ciclo principale per incrementare ecx e continuare a scorrere

	controllo_1_bit:
		# todo: mettere una riga a 0 nella stringa
		#mov 1, (is_ON)
		jmp fine_controllo_1_bit
	
	controllo_2_bit:

	fine_main:
		#mov %ecx, %eax
        
		movl %ebp, %esp
		popl %ebp
		#leave
		ret
