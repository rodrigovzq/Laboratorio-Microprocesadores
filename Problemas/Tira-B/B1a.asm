;Ejercicio B.1:

;a. Un sistema embebido basado en la familia AVR opera con un cristal de 1 MHz.
;¿Cómo implementaría una función de retardo de 0,05 ms? ¿Qué instrucciones
;condicionales podría utilizar? ¿Cuáles son las entradas y salidas (y su función)?
.include "./m328Pdef.inc"
.org 0
.equ DTIME=10             ;tiempo en micro segundos(hasta 127) /5


    ldi r16, DTIME
    rcall DELAY
    rjmp VOID
DELAY:                  ;5u por cada loop
    nop
    nop
    dec r16
    brne DELAY
    ret
VOID:
