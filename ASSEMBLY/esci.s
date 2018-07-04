.section .text
.global esci
.type esci, @function

esci:
	movl $1,   %eax
	xorl %ebx, %ebx
	int	 $0x80
ret
