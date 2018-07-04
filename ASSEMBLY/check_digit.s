.section .text
.global check_digit
.type check_digit, @function
# ckeck_digit: controlla se il carattere %bl e' 0..9
# parametri: %bl carattere
# ritorno:   %eax 0 false, 1 true
check_digit:
	pushl %ebp
	movl  %esp, %ebp
	
	cmp   $48, %bl				# se il carattere e' < 48 (0)
	jl    ret0
	cmp   $57, %bl				# o > 57
	jg    ret0					# vai a return 0
	jmp   ret1					# altrimenti vai a return 1
	ret0:
		movl  $0, %eax
		jmp fine
	
	ret1:
		movl  $1, %eax
		jmp fine
	
	fine:
	
	movl  %ebp, %esp
	popl  %ebp
ret
