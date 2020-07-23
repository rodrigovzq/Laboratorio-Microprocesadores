;Ejercicio B.1:

;a. Un sistema embebido basado en la familia AVR opera con un cristal de 1 MHz.
;¿Cómo implementaría una función de retardo de 0,05 ms? ¿Qué instrucciones
;condicionales podría utilizar? ¿Cuáles son las entradas y salidas (y su función)?
.include "./m328Pdef.inc"
.org 0
.equ MASK_TGL_PB3=0b00001100 ;mascara para encender o apagar pbr con xor

sbi DDRB, 3             ;setea portb3 y portb5 en salida
sbi PortB, 0               ;limpio el contendio de PortB
.equ DTIME=50               ;tiempo en micro segundos(hasta 255)


BACK:
    ldi r16, DTIME
    rcall DELAY
    rcall TOGGLE_LED
    rcall TURNON_LED
    rjmp VOID

DELAY:
    nop
    nop
    subi r16, 3              ;resto los micro segundos que toma 'DELAY'
    brpl DELAY
    ret
TURNON_LED:
    ldi r17, MASK_TGL_PB3
    out PortB, r17
    ret
TOGGLE_LED:
    lds r17, Portb
    ldi r18, MASK_TGL_PB3
    eor r17, r18
    out PortB,r17
    ret
VOID:
    rcall VOID
;b. ¿Y un retardo de 10 ms?

;c. ¿Y de 1 segundo?
