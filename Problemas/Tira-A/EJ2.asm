; Ejercicio A2
;a)
.equ TOT = 0x120  ;defino posicion de memoria como constante
mov r16, r2          ; copio primero operando a r16
mul r16, r3          ; multiplico r3 por r16 y lo guardo en r16
sts TOT, r16    ; copio el resultado a memoria

;b)

mov r16, r0
mul r16, r1
sts TOT, r16


;d) :020000020000FC
;   :10000000022D039D00932001002D019D00932001EE
;   :00000001FF
