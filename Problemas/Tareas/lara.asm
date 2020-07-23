;LDI R16,0b00000000    ;
;OUT DDRD,R16          ;defino todos los bits del puerto D como entrada
;IN R16,PORTD
;EJEMPLO
.include "m328Pdef.inc"
.org $00
LDI R16,0b010001100

LDI R19,0b00100001 ;
OUT DDRB,R19       ;defino el bit 0 y 5 del puerto B como salidas

LDI R17,0b11000000    ;mascara para variables de control
AND R17,R16           ;guardo en R17 C0,C1,0,0,0,0,0,0.

CPI R17,0b00000000    ;comparo si mi control es 0
BRNE one              ;si no es 0, pruebo con la otra posibilidad de control
LDI R18,0b00000001    ;máscara para E0
AND R18,R16           ;guardo en R18 0,0,0,0,0,0,0,E0.
CPI R18,0b00000001    ;comparo entrada E0 con 1
BRNE nothing          ;si no es 1, no hago nada
CALL led              ;si es 1 llamo a subrutina led

one:
    CPI R17,0b01000000    ;comparo si mi control es 1
     BRNE two              ;si no es 1, pruebo con la otra posibilidad de control
     LDI R18,0b00000100    ;máscara para E2
     AND R18,R16           ;guardo en R18 0,0,0,0,0,E2,0,0.
     CPI R18,0b00000100    ;comparo entrada E2 con 1
     BRNE nothing          ;si no es 1, no hago nada
     CALL led              ;si es 1 llamo a subrutina led

two:
    CPI R17,0b10000000    ;comparo si mi control es 2
     BRNE three            ;si no es 2, pruebo con la ult posibilidad de control
     LDI R18,0b00000010    ;máscara para E1
     AND R18,R16           ;guardo en R18 0,0,0,0,0,0,E1,0.
     CPI R18,0b00000010    ;comparo entrada E1 con 1
     BRNE nothing          ;si no es 1, no hago nada
     CALL led              ;si es 1 llamo a subrutina led


three:
      CPI R17,0b11000000    ;comparo si mi control es 3
       BRNE error            ;si no es 3, como ya probé con las otras, hay un problema de lectura
       LDI R18,0b00001000    ;máscara para E3
       AND R18,R16           ;guardo en R18 0,0,0,0,E3,0,0,0.
       CPI R18,0b00001000    ;comparo entrada E3 con 1
       BRNE nothing          ;si no es 1, no hago nada
       CALL led              ;si es 1 llamo a subrutina led


nothing:
    RET      ;no hace nada

error:
      LDI R19,0b00000001
      OUT PORTB,R19      ;pongo en HIGH al bit 0 del puerto B (conectaría un led rojo en el pin como para señalar un error)
      ret
led:
    LDI R19,0b00100000
     OUT PORTB,R19          ;pongo en HIGH al bit 5 del puerto B (built in led amarillo en el ardiuno)
     ret
