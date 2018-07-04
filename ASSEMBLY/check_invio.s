.section .text
.global check_invio
.type check_invio, @function
# ckeck_invio: controlla se il carattere %bl e' un invio \10
# parametri: %bl
# ritorno:   %eax 0 false, 1 true
check_invio:
	pushl %ebp
	movl  %esp, %ebp
	
	cmp   $10, %bl				# se il carattere e' un invio
	je    ret1					# vai a return 1
	ret0:						# altrimenti return 0
		movl  $0, %eax
		jmp fine
	
	ret1:
		movl  $1, %eax
		jmp fine
	
	fine:
	
	movl  %ebp, %esp
	popl  %ebp
ret
