# elaborato assemby
Si ottimizzi un codice in linguaggio C che controlla un dispositivo per la gestione intelligente del consumo
di energia elettrica all’interno di un sistema domotico mediante l’uso di Assembly inline. Il dispositivo
riceve in ingresso lo stato acceso/spento di un numero finito di dispositivi di cui è noto il consumo
istantaneo a priori, e fornisce in uscita la fascia di consumo ad ogni ciclo di clock. Qualora l’assorbimento
istantaneo sia superiore al limite di 4.5kW per più di 5 cicli di clock consecutivi, il sistema deve disattivare
l’interruttore generale. Al fine di prevenire questa situazione, il dispositivo può disattivare la lavatrice e la
lavastoviglie (in questo ordine di priorità).
Inizialmente il sistema è sempre spento (INT_GEN=0) e gli interruttori della lavatrice (INT_WM) e della
lavastoviglie (INT_DW) sono sempre non-armati (entrambi posti a 0). Fintanto che INT_GEN=0, il sistema
rimane spento ed il dispositivo deve restituire 0 per tutti i bit di output. Dal momento in cui RES_GEN
assume il valore 1: INT_GEN, INT_DW e INT_WM commutano a 1, il sistema si accende ed il dispositivo
inizia a leggere lo stato acceso/spento di tutti i carichi (LOAD). Il dispositivo deve restituire in uscita la
fascia di consumo istantaneo: F1<=1.5kW, 1.5kW<F2<=3kW, 3kW<F3<=4.5kW, OL>4.5kW. Nel caso in cui
il sistema rimanga in overload (OL) per almeno 4 cicli di clock, il dispositivo commuta INT_DW a 0 e,
fintanto che non viene riarmato (RES_DW=1), il carico relativo alla lavastoviglie deve essere ignorato;
qualora ciò non sia sufficiente a uscire dallo stato OL, al ciclo di clock successivo (5° ciclo in OL) il dispositivo
commuta INT_WM a 0 e, fintanto che non viene riarmato (RES_WM=1), il carico relativo alla lavatrice
deve essere ignorato. Nel caso in cui il sistema permanga in OL, al successivo ciclo di clock (6° ciclo in OL)
il dispositivo commuta INT_GEN a 0 ed il sistema si spegne.
Il programma deve essere lanciato da riga di comando con due stringhe come parametri, la prima stringa
identifica il nome del file .txt da usare come input, la seconda quello da usare come output:
$ ./controller testin.txt testout.txt
Il programma deve leggere il contenuto di testin.txt contenente in ogni riga i seguenti valori:
RESET-LOAD
• RESET [3]: contiene la sequenza dei comandi di riarmo degli interruttori; nell’ordine RES_GEN,
RES_DW e RES_WM (senza spazi)
• LOAD [10]: stato di accensione (1=ON, 0=OFF) dei carichi elettrici. Ogni carico ha un suo consumo
istantaneo associato. Il carico complessivo del circuito è dato dalla somma di tutti i carichi accesi
contemporaneamente. L’ordine ed il consumo di ogni carico è come da tabella:
Forno Frigo Aspirapolvere
Phon Lavastoviglie
Lavatrice
4xlamp
60W
4xlamp
100W
HI-FI TV
2 kW 300 W 1200 W 1 kW 2 kW 1800 W 240 W 400 W 200 W 400 W
Laboratorio di Architettura degli Elaboratori
A.A. 2017/18
Il programma deve restituire i risultati del calcolo in testout.txt in cui ogni riga contiene:
INT-TH
• INT [3]: indica lo stato di attivazione (1=ON, 0=OFF) degli interruttori; in ordine INT_GEN, INT_DW
e INT_WM (senza spazi)
• TH [2]: indica la fascia di consumo istantanea secondo la seguente codifica:
o F1 <= 1.5kW
o 1.5kW < F2 <= 3kW
o 3kW < F3 <= 4.5kW
o OL > 4.5kW
Nel caso in cui la macchina sia spenta, il controllore deve restituire la stringa “000-00”.
Assieme al presente documento sono forniti:
• un file controller.c contenente il sorgente C che dovrà essere editato per inserire la parte
assembly. Il file può essere modificato solo nelle parti segnalate tramite commento! Files
contenenti modifiche esterne a queste sezioni saranno penalizzati e potranno comportare anche
un voto insufficiente. È possibile utilizzare assembly inline o funzioni assembly richiamate da C, in
quest’ultimo caso i files creati devono essere consegnati all’interno della cartella principale.
• un file testin.txt di esempio. In fase di valutazione sarà utilizzato un file di test diverso.
• un file trueout.txt da utilizzare per verifica del corretto funzionamento del programma. Sarà
sufficiente usare il comando diff testout.txt trueout.txt per vedere eventuali
differenze tra i due files (quello generato dal programma e quello corretto).
In fase di correzione, saranno valutati meglio progetti che ottimizzeranno meglio il codice, ovvero
programmi che dimostreranno un minore tempo di esecuzione (a parità di hardware). Durante l’esame
orale è possibile che venga richiesto di operare delle modifiche al codice sul momento.
