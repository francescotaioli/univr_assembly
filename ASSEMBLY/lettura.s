.section .text
.global leggi
.type leggi, @function

leggi:
	# int leggi(byte* aperte, byte* chiuse, byte* lv, byte* le)
	# parametri:
	# byte* aperte = 20(%ebp)
	# byte* chiuse = 16(%ebp)
	# byte* lv     = 12(%ebp)
	# byte* le     =  8(%ebp)
	
	# variabili locali:
	# byte loc_aperte = -1(%ebp)
	# byte loc_chiuse = -2(%ebp)
	# byte loc_lv     = -3(%ebp)
	# byte loc_le     = -4(%ebp)
	# byte temp       = -5(%ebp)
	
	# valore di ritorno:
	# eax: 1 se lettura corretta
	#      0 altrimenti
	
	pushl %ebp
	movl  %esp, %ebp
	
	subl  $5, %esp							# allocazione spazio per le variabili locali
	
	movl  %ebp, %ecx
	subl  $1, %ecx							# ecx punta a loc_aperte
	
	# leggo il primo carattere (aperte)
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl						# salvo il carattere in bl
	
	call  check01
	cmp   $0, %eax							# se non è 0 o 1
	je    errore_input						# vai a errore input
	
	subb  $48, %bl							# converto il carattere in numero intero
	movb  %bl, (%ecx)						# salvo in loc_aperte il valore letto
	
	
	movl  %ebp, %ecx
	subl  $5, %ecx							# ecx punta a temp
	
	# leggo lo spazio vuoto
	
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl						# salvo il carattere in bl
	
	call  check_spazio
	cmp   $0, %eax							# se non è uno spazio
	je    errore_input						# vai a errore input
	
	movl  %ebp, %ecx
	subl  $2, %ecx							# ecx punta a loc_chiuse
	
	# leggo il terzo carattere (chiuse)
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl						# salvo il carattere in bl
	
	call  check01
	cmp   $0, %eax							# se non è 0 o 1
	je    errore_input						# vai a errore input
	
	subb  $48, %bl
	movb  %bl, (%ecx)						# salvo in loc_chiuse il valore letto
	
	movl  %ebp, %ecx
	subl  $5, %ecx							# ecx punta a temp
	
	# leggo lo spazio vuoto
	
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl
	
	call  check_spazio
	cmp   $0, %eax
	je    errore_input
	
	movl  %ebp, %ecx
	subl  $3, %ecx							# ecx punta a loc_lv
	
	# leggo lv
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl						# salvo il carattere letto in bl
	
	call  check_digit
	cmp   $0, %eax							# se non è una cifra
	je    errore_input						# vai a errore input
	
	cmp   $49, %bl							# se ho letto "1",
	je    lv_succ							# guardo il carattere successivo
	
	subb  $48, %bl							# altrimenti converto il carattere in numero,
	movb  %bl, (%ecx)						# salvo il numero in loc_lv
	jmp   pre_le							# e vado a leggere lo spazio
	
	lv_succ:
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl						# leggo il secondo carattere e lo salvo in bl
	
	call  check_spazio
	cmp   $0, %eax							# se non e' uno spazio,
	je    lv_ctrl0							# vado a controllare che sia '0'
	
	movb  $1, (%ecx)						# altrimenti loc_lv = 1
	jmp   le								# e vado a leggere luminosita' effettiva
	
	lv_ctrl0:
	cmp   $48, %bl							# se non è '0'
	jne   errore_input						# vai a errore input
	
	movb  $10, (%ecx)						# altrimenti loc_lv = 10
	

	pre_le:
	
	movl  %ebp, %ecx
	subl  $5, %ecx							# ecx punta a temp
	# leggo lo spazio vuoto
	
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl						# salvo il carattere in bl
	
	call  check_spazio
	cmp   $0, %eax							# se non e' uno spazio
	je    errore_input						# vai a errore input
	
	le:
	movl  %ebp, %ecx
	subl  $4, %ecx							# ecx punta a loc_le
	
	#leggo le
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl						# salvo il carattere in bl
	
	call  check_digit
	cmp   $0, %eax							# se non e' una cifra
	je    errore_input						# vai a errore input
	
	cmp   $49, %bl							# se ho letto '1',
	je    le_succ							# guardo il carattere successivo
	
	subb  $48, %bl							# altrimenti converto il carattere in numero,
	movb  %bl, (%ecx)						# salvo il numero in loc_le
	jmp   pre_invio							# e vado a leggere l'invio
	
	le_succ:
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl						# salvo il secondo carattere in bl
	
	call  check_invio
	cmp   $0, %eax							# se non e' un invio,
	je    le_ctrl0							# vado a controllare che sia '0'
	
	movb  $1, (%ecx)						# altrimenti loc_le = 1
	jmp   copia_valori						# vai a copiare le variabili locali negli indirizzi passati da parametro
	
	le_ctrl0:
	cmp   $48, %bl							# se il secondo carattere letto non e' '0'
	jne   errore_input						# vai a errore input
	
	movb  $10, (%ecx)						# altrimenti loc_le = 10
	
	pre_invio:
	movl  %ebp, %ecx
	subl  $5, %ecx							# ecx punta a temp
	
	# leggo invio
	movl  $3, %eax
	movl  $0, %ebx
	movl  $1, %edx
	int   $0x80
	
	movb  (%ecx), %bl						# salvo il carattere in bl
	
	call  check_invio
	cmp   $0, %eax							# se non e' un invio,
	je    errore_input						# vai a errore input
	
	
	jmp copia_valori						# se tutto e' corretto, vai a copiare i valori
	
	errore_input:
		call check_invio
		cmp  $1, %eax						# se l'ultimo carattere letto e' invio
		je   fine_errore_input				# finisco il ciclo
		
		movl  $3, %eax
		movl  $0, %ebx
		movl  $1, %edx
		int   $0x80							# altrimenti leggo un carattere
		
		movb  (%ecx), %bl					# lo salvo in bl
		jmp   errore_input					# e ricomincio il ciclo
		
		fine_errore_input:
		
		mov   $0, %eax						# salvo il valore di ritorno (0)
		jmp   fine_leggi
		
		
	copia_valori:
	# copio i valori delle variabili locali nelle celle puntate dai parametri
	movl  %ebp, %ecx
	
	dec   %ecx
	movb  (%ecx), %bl
	movl  20(%ebp), %eax
	movb  %bl, (%eax)						# *aperte = loc_aperte
	
	dec   %ecx
	movb  (%ecx), %bl
	movl  16(%ebp), %eax
	movb  %bl, (%eax)						# *chiuse = loc_chiuse
	
	dec   %ecx
	movb  (%ecx), %bl
	movl  12(%ebp), %eax
	movb  %bl, (%eax)						# *lv = loc_lv
	
	dec   %ecx
	movb  (%ecx), %bl
	movl  8(%ebp), %eax
	movb  %bl, (%eax)						# *le = loc_le
	
	mov   $1, %eax

	fine_leggi:
	
	movl  %ebp, %esp
	popl  %ebp
ret
