;c. ¿Y de 1 segundo?
; como cada ciclo no puede tener mas de 250 iteraciones,
;para dos ciclos (con dos nop)=1249us , el maximo de tiempo es 318.5 ms
;1s = 800 ciclos de 1249us


.include "./m328Pdef.inc"
.org 0

DELAY:              ;
    ldi r18, 9
LOOP3:                ; repite LOOP2 9 veces = 1,00045 s
    ldi r17, 89
    LOOP2:           ; repite LOOP1 por 89 veces x 1249us= 111.16 ms
        ldi r16, 250
        LOOP1:           ; (5x250)-1 =1249us
            nop
            nop
            dec r16
            brne LOOP1
        dec r17
        brne LOOP2
    dec r18
    brne LOOP3
    ret
