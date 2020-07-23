.include "./m328Pdef.inc"
.org 0
ldi r19,5
call DELAY
rjmp VOID
DELAY:
    ;toma valor de r19 en minutos
LOOP4:
    ldi r18, 188
LOOP3:                ; repite LOOP2 188 veces = 59.877 s
    ldi r17, 255
LOOP2:           ; repite LOOP1 por 255 veces x 1249us= 318.495 ms
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
    dec r19
    brne LOOP4
    ret
VOID:
    sleep
