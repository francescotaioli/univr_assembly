.section .text
.global check_spazio
.type check_spazio, @function
# ckeck_spazio: controlla se il carattere bl e' uno spazio " "
# parametri: %bl
# ritorno:   %eax 0 false, 1 true
check_spazio:
	pushl %ebp
	movl  %esp, %ebp
	
	cmp   $32, %bl				# se il carattere e' uno spazio
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
