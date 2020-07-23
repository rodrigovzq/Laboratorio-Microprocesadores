;Ejercicio B.3:
;a. Si quisiéramos hacer analogías entre Assembly y lenguajes de alto nivel
;como C, ¿cómo construiría la estructura del do-while?

; usando r16 y r17 para las condiciones
DO:
    nop
    nop

WHILE:
    cp r16, r17
    breq DO
    rjmp WHILE

;b. ¿Y la del for?

;cargando contador en r16

ldi r20,0

FOR:
    cp r20,r16
    brlo LOOP
    ret

LOOP:
    nop
    nop
    inc r20
    rjmp FOR

;c. ¿Y el if-then-else?

; usando r16 y r17 para las condiciones
IF:
    cpse r16, r17
    rjmp DO
    rjmp ELSE
DO:
    nop
    nop
    rjmp CONTINUE
ELSE:
    nop
    nop
CONTINUE:
