.section .text
.global check01
.type check01, @function
# ckeck01: controlla se il carattere %bl e' 0 o 1
# parametri: %bl carattere
# ritorno:   %eax 0 false, 1 true
check01:
	pushl %ebp
	movl  %esp, %ebp

	cmp   $48, %bl				# se il carattere e' 0
	je    ret1
	cmp   $49, %bl				# oppure 1
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
