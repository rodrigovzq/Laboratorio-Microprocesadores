.include "./m328Pdef.inc"
.equ EOL = $FF
.def MAX_TEMP = r16
.def AUX = r17

ldi r20, $FF
sts 0x103, r20
ldi XH, HIGH($0100) ;cargo el registro X con la posicion en memoria de los datos
ldi XL, LOW($0100) ;cargo el registro X con la posicion en memoria de los datos
call MAX
ldi r21, 99


MAX:
  ld MAX_TEMP, X
  AGAIN:
    ld AUX, X+ ; carga la temperatura leida en AUX
    cpi AUX, EOL      ; compara lo leido con el fin de linea
    breq DONE_MAX     ; salta a rutina de fin si es EOL
    cp AUX, MAX_TEMP ; compara AUX con el MAXimo actual
    brsh NEW_MAX      ; si AUX >= MAX salta a la rutina actualizar AMX
    rjmp AGAIN        ; vuelve
  NEW_MAX:
    mov MAX_TEMP, AUX
    rjmp AGAIN
DONE_MAX:
  ;pop AUX
  ;pop AUX
  ret
;resulta que los breq no me cambian el stack pointer, entonces puedo ret tranque
