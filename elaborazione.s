.section .data
# rappresentano i cicli di overload, vanno settate a runtime
total_watt: .int 0 					# indica i watt totati per ogni riga
is_ON: .int 0						# indica se il sistema è spento
current_OL:	.int 0					# valore del OL corrente
conta_dw: .int 1					# rappresenta res_dw per ogni riga
conta_wm: .int 1					# rappresenta res_wm per ogni riga
load_dw: .int 0
load_wm: .int 0
fascia: .int 0                      # 0=spento 1=F1 2=F2 3=F3 4=OL

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

        mov is_ON, %al
        cmp $0, %al
        je controllo_1_bit
        jmp fine_controllo_1_bit

    controllo_1_bit:
        # se il primo bit è a 1 metto is_on a 1

        cmpb $0x031, (%ecx)				# compare fra ecx e 1
        jne scrivo_0_e_fine_1_bit        # se ecx è zero salta

        # se is_on è 0 e primo bit a 1 metto i conta a 1 altrimenti no

        leal is_ON, %eax				# prendo l'indirizzo di memoria di is_0N e lo salvo in eax
        movl $1, (%eax)					# aggiorno il valore di is_ON

        movl $1, conta_dw               # all'accensione rimette i conta a 1
        movl $1, conta_wm

        jmp fine_controllo_1_bit

    scrivo_0_e_fine_1_bit:
        movl $0, fascia
    fine_controllo_1_bit:
        inc %ecx
        jmp controllo_2_bit

    controllo_2_bit:

        cmpb $0x031, (%ecx)
        je metto_conta_dw_1
        jmp fine_controllo_2_bit

    metto_conta_dw_1:
        movl $1, conta_dw
        jmp fine_controllo_2_bit

	fine_controllo_2_bit:
        inc %ecx
        jmp controllo_3_bit

    controllo_3_bit:

        cmpb $0x031, (%ecx)
        je metto_conta_wm_1
        jmp fine_controllo_3_bit

    metto_conta_wm_1:
        movl $1, conta_wm
        jmp fine_controllo_3_bit

    fine_controllo_3_bit:
        inc %ecx
        inc %ecx
        jmp controllo_forno

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

    fine_controllo_forno:
        inc %ecx
        jmp controllo_frigo

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

    fine_controllo_frigo:
        inc %ecx
        jmp controllo_aspirapolvere

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

    fine_controllo_aspirapolvere:
        inc %ecx
        jmp controllo_phon

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

    fine_controllo_phon:
        inc %ecx
        jmp controllo_lavastoviglie

    controllo_lavastoviglie:

        # setto il valore di load_dw
		cmpb $0x031, (%ecx)
		je metto_1_in_load_dw
		movl $0, load_dw
		jmp fine_controllo_lavastoviglie
    metto_1_in_load_dw:
        movl $1, load_dw
        jmp continuo_dw
    continuo_dw:
        mov conta_dw, %al
        cmp $1, %al
        jne fine_controllo_lavastoviglie
        # conta è a 1, il load è a 1 => devo contare la lavastoviglie
        leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
        movl (%eax),%edx				# ebx ha il valore di current ol
        leal lavastoviglie, %ebx		# carico l'indirizzo di memoria di lavastoviglie in ebx
        movl (%ebx), %eax				# eax ha il valore 2000 = forno

        addl %eax, %edx					# contiene la somma
        leal total_watt, %eax
        movl %edx, (%eax)

    jmp fine_controllo_lavastoviglie

    fine_controllo_lavastoviglie:
        inc %ecx
        jmp controllo_lavatrice

    controllo_lavatrice:

        # setto il valore di load_wm
        cmpb $0x031, (%ecx)
        je metto_1_in_load_wm
        movl $0, load_wm
        jmp fine_controllo_lavatrice
    metto_1_in_load_wm:
        movl $1, load_wm
        jmp continuo_wm
    continuo_wm:
        mov conta_wm, %al
        cmp $1, %al
        jne fine_controllo_lavatrice
        # conta è a 1, il load è a 1 => devo contare la lavatrice
        leal total_watt, %eax			# carico l'indirizzo di memoria di total_watt in eax
        movl (%eax),%edx				# ebx ha il valore di current ol
        leal lavatrice, %ebx		    # carico l'indirizzo di memoria di lavastoviglie in ebx
        movl (%ebx), %eax				# eax ha il valore 2000 = forno

        addl %eax, %edx					# contiene la somma
        leal total_watt, %eax
        movl %edx, (%eax)

        jmp fine_controllo_lavatrice


    fine_controllo_lavatrice:
        inc %ecx
        jmp controllo_lamp460w

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

    fine_controllo_lamp460w:
        inc %ecx
        jmp controllo_4lamp100w

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

    fine_controllo_4lamp100w:
        inc %ecx
        jmp controllo_hifi

    fine_controllo_hifi:
        inc %ecx
        jmp controllo_tv

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

    fine_controllo_tv:
        inc %ecx
        jmp controllo_fascia

    controllo_fascia:
        cmpl $0, is_ON
        je macchina_spenta              # la macchina è spenta
        movl total_watt, %eax           # guardo se sono in OL
        cmpl $4500,%eax
        jg sono_in_ol
        cmpl $3000, %eax
        jg sono_in_f3
        cmpl $1500, %eax
        jg sono_in_f2
        cmpl $1500, %eax
        jle sono_in_f1

        jmp fine_controllo_fascia



    sono_in_ol:
        movl $4, fascia                 #salvo codice fascia
        addl $1, current_OL
        cmpl $4, current_OL
        je quarto_ciclo_ol
        cmpl $5, current_OL
        je quinto_ciclo_ol
        cmpl $6, current_OL
        je sesto_ciclo_ol
        jmp fine_controllo_fascia


    quarto_ciclo_ol:
        #printo sec bit 0, metto conta dw a 0 e guardo load dw e ricalcolo la fascia
        movl $0, conta_dw

        movl load_dw, %eax
        cmpl $1, %eax
        je tolgo_dw_dal_totale
        jmp ricalcolo_fascia

    tolgo_dw_dal_totale:
        leal total_watt, %ebx
        subl lavastoviglie, %ebx
        movl %ebx, total_watt
        jmp ricalcolo_fascia

    ricalcolo_fascia:
        movl total_watt, %eax           # guardo se sono in OL
        cmpl $4500,%eax
        jg recheck_ol
        cmpl $3000, %eax
        jg recheck_f3
        cmpl $1500, %eax
        jg recheck_f2
        cmpl $1500, %eax
        jle recheck_f1
        jmp fine_controllo_fascia

    recheck_ol:
        movl $4, fascia
        jmp fine_controllo_fascia

    recheck_f3:
        movl $3, fascia
        movl $0, current_OL             # metto a 0 il ciclo di ol
        jmp fine_controllo_fascia

    recheck_f2:
         movl $2, fascia
         movl $0, current_OL             # metto a 0 il ciclo di ol
         jmp fine_controllo_fascia

    recheck_f1:
         movl $1, fascia
         movl $0, current_OL             # metto a 0 il ciclo di ol
         jmp fine_controllo_fascia

    quinto_ciclo_ol:
        #printo terzo bit 0, metto conta wm a 0 e guardo load wm e ricalcolo fascia
        movl $0, conta_wm

        movl load_wm, %eax
        cmpl $1, %eax
        je tolgo_wm_dal_totale
        jmp ricalcolo_fascia

    tolgo_wm_dal_totale:
        leal total_watt, %ebx
        subl lavatrice, %ebx
        movl %ebx, total_watt
        jmp ricalcolo_fascia

    sesto_ciclo_ol:
        movl $0, is_ON
        movl $0, fascia
        movl $0, total_watt
        movl $0, current_OL
        movl $1, conta_wm
        movl $1, conta_dw
        jmp fine_controllo_fascia

    sono_in_f3:
        #cod in fascia e scrivo f3, metto current_ol 0
        movl $3, fascia
        movl $0, current_OL             # metto a 0 il ciclo di ol

        cmpl $1, conta_dw               # decido se scrivere 0 o 1 nel secondo bit di out
        je scrivo_1_dw
        jmp continuo_f3

    scrivo_1_dw:
        jmp continuo_f3

    continuo_f3:

        cmpl $1, conta_wm               # decido se scrivere 0 o 1 nel terzo bit di out
        je scrivo_1_wm
        jmp ricontinuo_f3
    scrivo_1_wm:

        jmp ricontinuo_f3

    ricontinuo_f3:
        jmp fine_controllo_fascia

    sono_in_f2:
        #cod fascia , scrivo f2 e current ol 0
        movl $2, fascia
        movl $0, current_OL             # metto a 0 il ciclo di ol

        cmpl $1, conta_dw               # decido se scrivere 0 o 1 nel secondo bit di out
        je scrivo_1_dw_2
        jmp continuo_f2

    scrivo_1_dw_2:
        jmp continuo_f2

    continuo_f2:

        cmpl $1, conta_wm               # decido se scrivere 0 o 1 nel terzo bit di out
        je scrivo_1_wm_2
        jmp ricontinuo_f2
    scrivo_1_wm_2:
        jmp ricontinuo_f2

    ricontinuo_f2:
        jmp fine_controllo_fascia

    sono_in_f1:
        #cod fascia, scrivo f1 curr ol a 0
        movl $1, fascia
        movl $0, current_OL             # metto a 0 il ciclo di ol

        cmpl $1, conta_dw               # decido se scrivere 0 o 1 nel secondo bit di out
        je scrivo_1_dw_1
        jmp continuo_f1

    scrivo_1_dw_1:
        jmp continuo_f1

    continuo_f1:

        cmpl $1, conta_wm               # decido se scrivere 0 o 1 nel terzo bit di out
        je scrivo_1_wm_1
        jmp ricontinuo_f1
    scrivo_1_wm_1:
        jmp ricontinuo_f1

    ricontinuo_f1:
        jmp fine_controllo_fascia

    macchina_spenta:
        movl $0, is_ON
        movl $0, current_OL
        movl $0, fascia
        movl $0, total_watt
        movl $1, conta_wm
        movl $1, conta_dw
        jmp fine_controllo_fascia

    fine_controllo_fascia:
        jmp scrittura_su_file

    scrittura_su_file:
        cmp $0, fascia
        je out_f0
        cmp $1, fascia
        je out_f1
        cmp $2, fascia
        je out_f2
        cmp $3, fascia
        je out_f3
        cmp $4, fascia
        je out_ol

        jmp fase_finale

    out_f0: # scrive 000-00
        movb $48, (%edi)
        movb $48, 1(%edi)
        movb $48, 2(%edi)
        movb $45, 3(%edi)
        movb $48, 4(%edi)
        movb $48, 5(%edi)
        jmp fase_finale

    out_f1: # scrive 1 conta-dw conta-wm - F1
        movb $49, (%edi)
        movl conta_dw, %eax
        cmpl $1, %eax
        je scr_1_f1_dw
        movb $48, 1(%edi)
        jmp cont
    scr_1_f1_dw:
        movb $49, 1(%edi)
    cont:
        movl conta_wm, %eax
        cmpl $1, %eax
        je scr_1_f1_wm
        movb $48, 2(%edi)
        jmp cont_1
    scr_1_f1_wm:
        movb $49, 2(%edi)
    cont_1:
        movb $45, 3(%edi)
        movb $70, 4(%edi)
        movb $49, 5(%edi)
        jmp fase_finale

    out_f2: # scrive 1 conta-dw conta-wm - F2
            movb $49, (%edi)
            movl conta_dw, %eax
            cmpl $1, %eax
            je scr_1_f2_dw
            movb $48, 1(%edi)
            jmp cont_2
        scr_1_f2_dw:
            movb $49, 1(%edi)
        cont_2:
            movl conta_wm, %eax
            cmpl $1, %eax
            je scr_1_f2_wm
            movb $48, 2(%edi)
            jmp cont_3
        scr_1_f2_wm:
            movb $49, 2(%edi)
        cont_3:
            movb $45, 3(%edi)
            movb $70, 4(%edi)
            movb $50, 5(%edi)
            jmp fase_finale

    out_f3: # scrive 1 conta-dw conta-wm - F3
            movb $49, (%edi)
            movl conta_dw, %eax
            cmpl $1, %eax
            je scr_1_f3_dw
            movb $48, 1(%edi)
            jmp cont_4
        scr_1_f3_dw:
            movb $49, 1(%edi)
        cont_4:
            movl conta_wm, %eax
            cmpl $1, %eax
            je scr_1_f3_wm
            movb $48, 2(%edi)
            jmp cont_5
        scr_1_f3_wm:
            movb $49, 2(%edi)
        cont_5:
            movb $45, 3(%edi)
            movb $70, 4(%edi)
            movb $51, 5(%edi)
            jmp fase_finale

    out_ol: # scrive 1 conta-dw conta-wm - OL
                movb $49, (%edi)
                movl conta_dw, %eax
                cmpl $1, %eax
                je scr_1_ol_dw
                movb $48, 1(%edi)
                jmp cont_6
            scr_1_ol_dw:
                movb $49, 1(%edi)
            cont_6:
                movl conta_wm, %eax
                cmpl $1, %eax
                je scr_1_ol_wm
                movb $48, 2(%edi)
                jmp cont_7
            scr_1_ol_wm:
                movb $49, 2(%edi)
            cont_7:
                movb $45, 3(%edi)
                movb $79, 4(%edi)
                movb $76, 5(%edi)
                jmp fase_finale

    fase_finale:
        cmpb $0x0A, (%ecx)                  # controlla se a fine riga c'è \n
        je reset_var_e_restart
        jmp fine_main

    reset_var_e_restart:
        # scrivo nel file di out il caporiga e incremento per continuare a scrivere
        movb $10, 6(%edi)
        #movb $45, 3(%edi)
        addl $7, %edi
        movl $0, total_watt
        inc %ecx
        jmp increment

    fine_main:
        # gestione parametro output
        movb $0, 7(%edi)
        movl %ebp, %esp
        popl %ebp
        ret



















