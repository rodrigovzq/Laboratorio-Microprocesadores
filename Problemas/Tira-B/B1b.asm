;b. ¿Y un retardo de 10 ms?
.include "./m328Pdef.inc"
.org 0

DELAY:
    ldi r16,8
HIGH_LOOP:          ; repite LOW_LOOP por 8 veces x 1249us= 99.9 ms
    ldi r17,250
LOW_LOOP:           ; (5x250)-1 =1249us
    nop
    nop
    dec r17
    brne LOW_LOOP
    dec r16
    brne HIGH_LOOP
    ret
