.section .data
# rappresentano i cicli di overload, vanno settate a runtime
current_OL: .int 0 				# valore del OL corrente
is_ON: .int 0					# indica se il sistema è spento
total_watt: .int 0				# indica i watt totati per ogni riga
conta_dw: .int 1					# rappresenta res_dw per ogni riga
conta_wm: .int 1					# rappresenta res_wm per ogni riga
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
	# scorre una riga in input	            				
	increment:
		movl $4, %eax          			
		movl $1, %ebx
		movl riga_len, %edx     		
		int $0x80

		# se is_ON è a zero vado a controllo_1_bit
		mov is_ON, %al
		cmp $0, %al
		jz controllo_1_bit

	fine_controllo_1_bit:
		inc %ecx
	    jmp controllo_2_bit

	fine_controllo_2_bit:
	    inc %ecx
	    jmp controllo_X_bit

	fine_controllo_X_bit:
	    inc %ecx
		# aggiorna tutte le variabili temporane al loro valore origniale ( tranne ol )
	    #.
	    #.
	    #.
	    #qui avrò controllato tutti e 13 i bit, faccio un compare con \n se è uguale salto a fine programma
	    #se è diverso vuol dire che ho un altra riga e salto a inizio del ciclio di incremento e studio la nuova riga
        jmp fine_main


	controllo_1_bit:
		# todo: mettere una riga a 0 nella stringa
		# se il primo bit è a 1 metto is_on a 1
		cmpb $0x031, (%ecx)					# compare fra ecx e 1
		jne fine_controllo_1_bit
		leal is_ON, %eax				# prendo l'indirizzo di memoria di is_0N e lo salvo in eax
		movl $1, (%eax)					# aggiorno il valore di is_ON
		jmp fine_controllo_1_bit
	# controllo res_dw ( 2 bit della stringa)
	controllo_2_bit:
	    # se siamo al 4 ciclo di ol conta_dw va a 0
		cmp $4, current_OL
		jne fine_controllo_2_bit
		# siamo al 4 ciclo, mento conta_dw a 0
		leal conta_dw, %eax
		movl $0, (%eax) 
	    jmp fine_controllo_2_bit

	controllo_X_bit:
	    jmp fine_controllo_X_bit

	fine_main:
		#mov %ecx, %eax
		movl %ebp, %esp
		popl %ebp
		#leave
		ret
