#questo file si occupa di ricevere come input 'bufferin' e deve restituire una variabile stringa 'bufferout_asm'
#qui verrà tutta l'esecuzione del programma che chiamera anche altri file

.data
.text
    .global pot_asm # funzione deve essere globale
pot_asm:
    pushl %ebp # event. chiamate nidificate
    movl %esp, %ebp # imposto %ebp
    movl 8(%ebp), %ebx # leggo la base
    movl 12(%ebp), %ecx # leggo l’esponente
    xorl %edx, %edx # azzero %edx
    movl $1, %eax # imposto accumulatore

ciclo:
    mull %ebx # %eax = %eax*%ebx
    loopl ciclo # ciclo %ecx volte
    # al termine il ris si trova in %eax o in
    popl %ebp # ripristino %ebp precedente
ret
