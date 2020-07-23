;Esta contraseña se almacena en R1 y R2 en formato BCD y si coincide con la que
;está almacenada en la variable “PWD” de la EPROM,

;asumo que la constante PWD esta declarada con la posicion de memoria

.include "./m328Pdef.inc"
.equ MODE_STATUS=0x200
MODE:
  lds r16,PWD
  lds r17,PWD+1
  cp r16,r1
  brne PASS_NOK
  cp r17, r2
  brne PASS_NOK
  call PASS_OK
  ret
PASS_NOK:
  ldi r20, 0
  sts MODE_STATUS, r20
  ret
PASS_NOK:
  ldi r20, 1 
  sts MODE_STATUS, r20
  ret
