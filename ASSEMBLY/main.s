.section .data
aperte:
	.byte 0
chiuse:
	.byte 0
lum_vol:
	.byte 0
lum_eff:
	.byte 0
cApri:
	.long 0
cChiudi:
	.long 0

.section .text
.global _start
_start:
	
	step0:		# Acquisizione degli input
		
		# Copia tutti i parametri per la funzione leggi nello stack
		leal  aperte, %eax
		pushl %eax
	
		leal  chiuse, %eax
		pushl %eax
	
		leal  lum_vol, %eax
		pushl %eax
	
		leal  lum_eff, %eax
		pushl %eax
		
		call  leggi					# chiamata alla funzione leggi
		
		addl  $16, %esp				# elimina i parametri passati con lo stack
		
		cmp   $1, %eax
		je    step1					# se la lettura ha dato risultato positivo, vai al prossimo step
		
		movl  $6, %eax
		call  stampa				# altrimenti stampa ERRORE INPUT
		jmp step0					# e ricomincia
	
	
	step1:		# Controllo dei sensori aperte-chiuse

		cmpb  $1, aperte			# se APERTE = 1
		jne   step2
		cmpb  $1, chiuse			# e CHIUSE = 1
		jne   step2
	
		movl  $5, %eax
		call  stampa				# stampa ERRORE SENSORI
		jmp   step0
	
	step2:		# Scelgo l'azionde da intraprendere
		movb  lum_vol, %al
		cmpb  lum_eff, %al
		jg    apri					# se lum_vol > lum_eff, vai ad apri
		jl    chiudi				# se lum_vol < lum_eff, vai a chiudi
		je    standby				# se lum_vol = lum_eff, vai a standby
		
		apri:
			cmpb $1, aperte			# se aperte = 1
			je  apri_standby		# vai ad apri_standby
			
			movl $0, %eax
			call stampa				# altrimenti stampa APRI
			
			apri_ciclo_standby_apri:	# ciclo per stampare tutti gli STANDBY PER APRI arretrati
				cmpb $0, cApri
				je   apri_ciclo_standby_chiudi
				movl $3, %eax
				call stampa
				subb $1, cApri
			jmp apri_ciclo_standby_apri
			
			apri_ciclo_standby_chiudi:	# ciclo per stampare tutti gli STANDBY PER CHIUDI arretrati
				cmpb $0, cChiudi
				je   step0
				movl $4, %eax
				call stampa
				subb $1, cChiudi
			jmp apri_ciclo_standby_chiudi
			
			jmp step0				# ricomincia il ciclo esterno
			
			apri_standby:			# se aperte era 1, 
				incl cApri			# incremento il contatore degli STANDBY PER APRI
				movl $2, %eax
				call stampa			# e stampo STANDBY
				jmp  step0			# e ricomincio il ciclo esterno
		
		chiudi:
			cmpb $1, chiuse			# se chiuse = 1
			je  chiudi_standby		# vai a chiudi_standby
			
			movl $1, %eax
			call stampa				# altrimenti stampa CHIUDI
			
			chiudi_ciclo_standby_apri:		# ciclo per stampare tutti gli STANDBY PER APRI arretrati
				cmpb $0, cApri
				je   chiudi_ciclo_standby_chiudi
				movl $3, %eax
				call stampa
				subb $1, cApri
			jmp  chiudi_ciclo_standby_apri
			
			chiudi_ciclo_standby_chiudi:	# ciclo per stampare tutti gli STANDBY PER CHIUDI arretrati
				cmpb $0, cChiudi
				je   step0
				movl $4, %eax
				call stampa
				subb $1, cChiudi
			jmp  chiudi_ciclo_standby_chiudi
			
			jmp  step0				# ricomincio il ciclo esterno
			
			chiudi_standby:			# se chiuse era 1,
				incl cChiudi		# incremento il contatore degli STANDBY PER CHIUDI
				movl $2, %eax
				call stampa			# e stampo STANDBY
				jmp step0			# ricomincio il ciclo esterno
		
		standby:
			movl $2, %eax
			call stampa				# stampo STANDBY
			jmp  step0				# ricomincio il ciclo esterno
	
	
	jmp step0
	call esci
