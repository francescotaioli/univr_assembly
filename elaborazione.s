.section .data

strApri:
	.ascii "COMANDO TENDE: APRI\n"
strApriLen:
	.long . - strApri

strChiudi:
	.ascii "COMANDO TENDE: CHIUDI\n"
strChiudiLen:
	.long . - strChiudi

strStandby:
	.ascii "COMANDO TENDE: STAND-BY\n"
strStandbyLen:
	.long . - strStandby

strStandbyApri:
	.ascii "STAND-BY per APRI\n"
strStandbyApriLen:
	.long . - strStandbyApri

strStandbyChiudi:
	.ascii "STAND-BY per CHIUDI\n"
strStandbyChiudiLen:
	.long . - strStandbyChiudi

strErroreSensori:
	.ascii "COMANDO TENDE: ERRORE SENSORI\n"
strErroreSensoriLen:
	.long . - strErroreSensori

strErroreInput:
	.ascii "COMANDO TENDE: ERRORE INPUT\n"
strErroreInputLen:
	.long . - strErroreInput

.section .text
.global stampa
.type stampa, @function

/* riceve il valore in eax */
stampa:
	if0:
	 	movl 4(%esp), %ecx
		cmp  $5, %ecx
		jne  if1
		leal strApri, %ecx
		movl strApriLen, %edx
		jmp  stampa_stringa
	if1:
		cmp  $1, %eax
		jne  if2
		leal strChiudi, %ecx
		movl strChiudiLen, %edx
		jmp  stampa_stringa
	if2:
		cmp  $2, %eax
		jne  if3
		leal strStandby, %ecx
		movl strStandbyLen, %edx
		jmp  stampa_stringa
	if3:
		cmp  $3, %eax
		jne  if4
		leal strStandbyApri, %ecx
		movl strStandbyApriLen, %edx
		jmp  stampa_stringa
	if4:
		cmp  $4, %eax
		jne  if5
		leal strStandbyChiudi, %ecx
		movl strStandbyChiudiLen, %edx
		jmp  stampa_stringa
	if5:
		cmp  $5, %eax
		jne  if6
		leal strErroreSensori, %ecx
		movl strErroreSensoriLen, %edx
		jmp  stampa_stringa
	if6:
		cmp  $6, %eax
		jne  stampa_end
		leal strErroreInput, %ecx
		movl strErroreInputLen, %edx
		jmp  stampa_stringa

	stampa_stringa:
		movl $4, %eax
		movl $1, %ebx
		int  $0x80
	stampa_end:
ret
