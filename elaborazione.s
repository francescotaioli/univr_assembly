.section .data
.comm	result_array,100,32
# rappresentano i cicli di overload, vanno settate a runtime
total_watt: .int 0 					# indica i watt totati per ogni riga
is_ON: .int 0						# indica se il sistema è spento
current_OL:	.int 1					# valore del OL corrente
conta_dw: .int 1					# rappresenta res_dw per ogni riga
conta_wm: .int 1					# rappresenta res_wm per ogni riga
load_dw: .int 0
load_wm: .int 0

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
    movl 12(%ebp), %edi             # mette stringa di output in edi
    xorl %edx, %edx                 # azzera i registri per partire pulito
    xorl %eax, %eax
    xorl %ebx, %ebx

	# scorre una riga in input	            				
	increment:

		# se is_ON è a zero vado a controllo_1_bit
		mov is_ON, %al
		cmp $0, %al
		jz controllo_1_bit
		movb $49, (%edi)
		jmp fine_controllo_1_bit

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
		jmp controllo_aspirapolvere

	fine_controllo_aspirapolvere:
		inc %ecx
		jmp controllo_phon
	
	fine_controllo_phon:
		inc %ecx
		jmp controllo_lavastoviglie

	fine_controllo_lavastoviglie:
		inc %ecx
		jmp controllo_lavatrice

	fine_controllo_lavatrice:
		inc %ecx
		jmp controllo_lamp460w

	fine_controllo_lamp460w:
		inc %ecx
		jmp controllo_4lamp100w

	fine_controllo_4lamp100w:
		inc %ecx
		jmp controllo_hifi

	fine_controllo_hifi:
		inc %ecx
		jmp controllo_tv

	fine_controllo_tv:
		inc %ecx
		jmp scrittura_primi_3_bit
	
	fine_controllo_fascia:
		jmp fine_controllo_X_bit

	fine_controllo_X_bit:
	    #inc %ecx
		# aggiorna tutte le variabili temporane al loro valore origniale ( tranne ol )
        cmpb $0x0A, (%ecx)                  # controlla se a fine riga c'è \n
        je reset_var_e_restart
        #cmpb $0x00, (%ecx)                  # controlla se a fine riga c'è \0
        jmp fine_main

    scrittura_primi_3_bit:
        mov is_ON, %al                          # se is_ON è a 0 metto primo bit a 0 altrimenti a 1
        cmp $0, %al
        je primo_bit_0
        movb $49, (%edi)
        jmp secondo_bit

    primo_bit_0:
        movb $48, (%edi)                        # se macchina è spenta metto i primi 3 bit a zero
        movb $48, 1(%edi)
        movb $48, 2(%edi)
        jmp controllo_fascia

    secondo_bit:
        mov conta_dw, %al                      # se conta_dw è a 0 metto secondo bit a 0 altrimenti a 1
        cmp $0, %al
        je secondo_bit_0
        movb $49, 1(%edi)
        jmp terzo_bit

    secondo_bit_0:
        movb $48, 1(%edi)

    terzo_bit:
        mov conta_wm, %al                      # se conta_wm è a 0 metto terzo bit a 0 altrimenti a 1
        cmp $0, %al
        je terzo_bit_0
        movb $49, 2(%edi)
        jmp controllo_fascia

    terzo_bit_0:
        movb $48, 2(%edi)

        jmp controllo_fascia

    reset_var_e_restart:
        # scrivo nel file di out il caporiga e incremento per continuare a scrivere
        movb $10, 6(%edi)
        addl $7, %edi
        movl $0, total_watt
        inc %ecx
        jmp increment                        # salta a inizio ciclo


	controllo_1_bit:
		# se il primo bit è a 1 metto is_on a 1
		cmpb $0x031, (%ecx)					# compare fra ecx e 1
		jne fine_controllo_1_bit         # se ecx è zero salta
		leal is_ON, %eax				# prendo l'indirizzo di memoria di is_0N e lo salvo in eax
		movl $1, (%eax)					# aggiorno il valore di is_ON
		movb $49, (%edi)                 #

		movl $1, conta_dw               # all'accensione rimette i conta a 1
        movl $1, conta_wm

		jmp fine_controllo_1_bit

	# controllo res_dw ( 2 bit della stringa)
	controllo_2_bit:
	    # se siamo al 4 ciclo di ol conta_dw va a 0
		
		# cmp $4, total_watt
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
	# se il bit del forno è a 1, aggiungo i watt del forno al total_watt
	controllo_forno:
		cmpb $0x031, (%ecx)
		jne fine_controllo_forno
		
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal forno, %ebx				# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 				# update di total_watt
		
		jmp fine_controllo_forno

	# se il bit del frigo è a 1, aggiungo i watt del forno al total_watt
	controllo_frigo:
		cmpb $0x031, (%ecx)
		jne fine_controllo_frigo
		
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal frigo, %ebx				# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 
		jmp fine_controllo_frigo		# update di total_watt

	# se il bit del aspirapolvere è a 1, aggiungo i watt del forno al total_watt
	controllo_aspirapolvere:
		cmpb $0x031, (%ecx)
		jne fine_controllo_aspirapolvere
		
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal aspirapolvere, %ebx				# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 				# update di total_watt
		jmp fine_controllo_aspirapolvere

	# se il bit del phon è a 1, aggiungo i watt del forno al total_watt
	controllo_phon:
		cmpb $0x031, (%ecx)
		jne fine_controllo_phon
		
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal phon, %ebx					# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 				# update di total_watt

		jmp fine_controllo_phon

	controllo_lavastoviglie:

		# setto il valore di load_wm
		leal load_dw, %eax
		movl (%ecx), %eax

		# se la macchina è spenta int dw è a 0
		mov is_ON, %al
        cmp $0, %al
        je fine_controllo_lavastoviglie

		mov conta_dw, %al
		cmp $1, %al
		jne fine_controllo_lavastoviglie


		# conta_dw è a 1, verifico che il load della lavastoviglie sia a 1
		cmpb $0x031, (%ecx)
		jne fine_controllo_lavastoviglie

		# conta è a 1, il load è a 1 => devo contare la lavastoviglie
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal lavastoviglie, %ebx		# carico l'indirizzo di memoria di lavastoviglie in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 				# update di total_watt


		jmp fine_controllo_lavastoviglie

	controllo_lavatrice:

		# setto il valore di load_wm
		leal load_wm, %eax
		movl (%ecx), %eax

		mov conta_wm, %al
		cmp $1, %al
		jne fine_controllo_lavatrice

		# conta_dw è a 1, verifico che il load della lavastoviglie sia a 1
		cmpb $0x031, (%ecx)
		jne fine_controllo_lavatrice

		# conta è a 1, il load è a 1 => devo contare la lavastoviglie
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal lavatrice, %ebx					# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 				# update di total_watt


		jmp fine_controllo_lavatrice

	controllo_lamp460w:
		cmpb $0x031, (%ecx)
		jne fine_controllo_lamp460w
		
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal lamp460w, %ebx					# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 				# update di total_watt

		jmp fine_controllo_lamp460w

	controllo_4lamp100w:
		cmpb $0x031, (%ecx)
		jne fine_controllo_4lamp100w
		
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal lamp4100w, %ebx					# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 
		jmp fine_controllo_4lamp100w


	controllo_hifi:
		cmpb $0x031, (%ecx)
		jne fine_controllo_hifi
		
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal hifi, %ebx					# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 
		
		jmp fine_controllo_hifi

		
	controllo_tv:
		cmpb $0x031, (%ecx)
		jne fine_controllo_tv
		
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx				# ebx ha il valore di current ol
		leal tv, %ebx					# carico l'indirizzo di memoria di forno in ebx
		movl (%ebx), %eax				# eax ha il valore 2000 = forno
		
		addl %eax, %edx					# contiene la somma
		leal total_watt, %eax
		movl %edx, (%eax) 

		jmp fine_controllo_tv

	# qui si controlla total_watt
	# nel caso la macchina fosse in ol, si setta is_ON a 0
	controllo_fascia:
	    #stampo nel file di out in modo costante il trattino che c'è sempre
	    movb $45, 3(%edi)

		# F1 <= 1.5kW
		# 1.5kW < F2 <= 3kW
		# 3kW < F3 <= 4.5kW
		# OL > 4.5kW

		# controllo se la macch è acc, se è spenta scrivo 00 nella fascia
		mov is_ON, %al
        cmp $0, %al
        je scrive_00

		# DEBUG
		leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
		movl (%eax),%edx
		# DEBUG
		jmp controllo_F1
		jmp fine_controllo_fascia
	controllo_F1:
		# F1 <= 1.5kW
		movl total_watt, %eax
		cmpl $1500,%eax
		jg controllo_F2

		# altrimenti sono in fascia 1
		movl $1, current_OL             # metto a 0 il ciclo di ol
        movb $70, 4(%edi)               # scrivo "F1"
        movb $49, 5(%edi)
		jmp fine_controllo_fascia
	controllo_F2:
		# 1.5kW < F2 <= 3kW
		movl total_watt, %eax
		cmp $3000, %eax
		jg controllo_F3

		# altrimenti sono in f2
		movl $1, current_OL             # metto a 0 il ciclo di ol
		movb $70, 4(%edi)               # scrivo "F2"
        movb $50, 5(%edi)
		jmp fine_controllo_fascia
	
	controllo_F3:
		# 3kW < F3 <= 4.5kW
		movl total_watt, %eax
		cmp $4500,%eax
		jg OL

		# altrimenti sono in f3
		movl $1, current_OL             # metto a 0 il ciclo di ol
		movb $70, 4(%edi)               # scrivo "F3"
        movb $51, 5(%edi)
		jmp fine_controllo_fascia
		
	# sono in OL, devo 
	# incrementare current_OL
	OL:
		# todo : fare i tramacci
		
		movb $79, 4(%edi)                   # scrivo "OL"
        movb $76, 5(%edi)

		# 4 cicli di clock, il dispositivo commuta conta_dw a 0
		movl current_OL, %eax
		cmp $4,%eax
		je conta_dw_a_0

		# (5° ciclo in OL) il dispositivo commuta INT_WM a
		movl current_OL, %eax
		cmp $5,%eax
		je conta_wm_a_0

		# (6° ciclo in OL)il dispositivo commuta INT_GEN a 0 ed il sistema si spegne.
		movl current_OL, %eax
		cmp $6,%eax
		je is_ON_a_0

		jmp incrementa_OL

	scrive_00:
	    movb $48, 4(%edi)
        movb $48, 5(%edi)
        jmp incrementa_OL
	
	conta_dw_a_0:
		# se load_dw è a 1 e conta_dw a 1, sottraggo il valore dei watt di dw
		# leal conta_dw, %eax
		# leal load_dw, %edx
		# andl %eax, %edx
		# cmp $1, (%edx)

		movl $0, conta_dw			# setto conta_dw a 0 
		jmp incrementa_OL

	conta_wm_a_0:
		movl $0, conta_wm			# setto conta_wm a 0 
		jmp incrementa_OL
	
	is_ON_a_0:
		movl $0, is_ON			# setto is_ON a 0 
		jmp incrementa_OL

	incrementa_OL:
		leal current_OL, %eax				# prendo l'indirizzo di memoria di current_OL e lo salvo in eax
		addl $1, (%eax)
		movl (%eax), %edx
		jmp fine_controllo_fascia

	fine_main:
	    # gestione parametro output
		#mov %ecx, %eax
		movb $0, 7(%edi)
		movl %ebp, %esp
		popl %ebp
		#leave
		ret
