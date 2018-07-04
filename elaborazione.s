# filename: num2str.s
#
# converts an integer into a string

.section .data

	numstr: .ascii "00000000000"     # string output

	numtmp: .ascii "00000000000"     # temporary string


.section .text
	.global _start

_start:

	movl $12345, %eax          # carica il valore da convertire in EAX

	movl $10, %ebx             # carica 10 in EBX (usato per le divisioni)
	movl $0, %ecx              # azzera il contatore ECX

	leal numtmp, %esi          # carica l'indirizzo di 'numtmp' in ESI


continua_a_dividere:

	movl $0, %edx              # azzera il contenuto di EDX
	divl %ebx                  # divide per 10 il numero ottenuto

	addb $48, %dl              # aggiunge 48 al resto della divisione
	movb %dl, (%ecx,%esi,1)    # sposta il contenuto di DL in numtmp

	inc %ecx                   # incrementa il contatore ECX

	cmp $0, %eax               # controlla se il contenuto di EAX è 0

	jne continua_a_dividere


	movl $0, %ebx              # azzera un secondo contatore in EBX

	leal numstr, %edx          # carica l'indirizzo di 'numstr' in EDX

ribalta:

	movb -1(%ecx,%esi,1), %al  # carica in AL il contenuto dell'ultimo byte di 'numtmp'
	movb %al, (%ebx,%edx,1)    # carica nel primo byte di 'numstr' il contenuto di AL

	inc %ebx                   # incrementa il contatore EBX

	loop ribalta


stampa:

	movb $10, (%ebx,%edx,1)    # aggiunge il carattere '\n' in fondo a 'numstr'

	inc %ebx
	movl %ebx, %edx            # carica in EDX la lunghezza della stringa 'numstr'
	movl $4, %eax              # carica in EAX il codice della syscall WRITE
	movl $1, %ebx              # carica in EBX il codice dello standard output
	leal numstr, %ecx          # carica in ECX l'indirizzo della stringa 'numstr'
	int $0x80                  # esegue la syscall

	movl $1, %eax              # carica in EAX il codice della syscall EXIT
	movl $0, %ebx              # carica in EBX il codice di uscita 0
	int $0x80                  # esegue la syscall
