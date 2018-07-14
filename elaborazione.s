.section .data
# rappresentano i cicli di overload, vanno settate a runtime
current_OL: .int 0 				# valore del OL corrente
is_ON: .int 0					# indica se il sistema è spento
total_watt: .int 0				# indica i watt totati per ogni riga
conta_dw: .int 1					# rappresenta res_dw per ogni riga
conta_wm: .int 1					# rappresenta res_wm per ogni riga
# rappresentano i watt di ogni elettrodomestico
forno:	.int 2000
frigo:	.int 300
aspirapolvere:	.int 1200
phon:	.int 1000
lavastoviglie:	.int 2000
lavatrice:	.int 1800
lamp460w:	.int 240
lamp4100w:	.int 400
hifi:	.int 200
tv:	.int 400

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
	    jmp controllo_3_bit

	fine_controllo_3_bit:
		inc %ecx
		inc %ecx
		jmp controllo_forno

	fine_controllo_forno:
		inc %ecx
		jmp controllo_frigo

	fine_controllo_frigo:
		inc %ecx
		jmp fine_controllo_X_bit

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
		
		# cmp $4, current_OL
		# jne fine_controllo_2_bit
		# siamo al 4 ciclo, mento conta_dw a 0
		# leal conta_dw, %eax
		# movl $0, (%eax) 
	    
		# se res_dw è a 1, metto conta_dw a 1
		cmpb $0x031, (%ecx)
		jne fine_controllo_2_bit
	    leal conta_dw, %eax
		movl $1, (%eax) 
		
		jmp fine_controllo_2_bit
	
	# controllo res_wm ( 3 bit della stringa)
	controllo_3_bit:
		# se res_wm è a 1, metto conta_wm a 1
		cmpb $0x031, (%ecx)
		jne fine_controllo_3_bit
		leal  conta_wm, %eax
		movl $1, (%eax)

		jmp fine_controllo_3_bit
	# se il bit del forno è a 1, aggiungo i watt del forno al current_ol
	controllo_forno:
		cmpb $0x031, (%ecx)
		jne fine_controllo_forno
		
		leal current_OL, %eax			# carico l'indirizzo di memoria di current_ol in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal forno, %ebx				# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal current_OL, %eax
		movl %edx, (%eax) 
		
		jmp fine_controllo_forno

	# se il bit del frigo è a 1, aggiungo i watt del forno al current_ol
	controllo_frigo:
		cmpb $0x031, (%ecx)
		jne fine_controllo_frigo
		
		leal current_OL, %eax			# carico l'indirizzo di memoria di current_ol in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal frigo, %ebx				# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal current_OL, %eax
		movl %edx, (%eax) 
		jmp fine_controllo_frigo

	controllo_X_bit:
	    jmp fine_controllo_X_bit

	fine_main:
		#mov %ecx, %eax
		movl %ebp, %esp
		popl %ebp
		#leave
		ret
