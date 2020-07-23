.include "m328Pdef.inc"
.def MUESTRA = r19
.def MAX = r20
.def MIN = r21
.def ZEROS = r22
.def COUNT = r23

.equ table_size = 255
.equ table = $100 ;asumo una direccion
MIN_MAX_Z:
  ldi ZL, LOW(table) ;inicializa en puntero Z en la posicion de 'table'
  ldi ZH, HIGH(table)
  clr COUNT   ; COUNT <- 0
  clr ZEROS   ; ZEROS <- 0
  ld MUESTRA, Z+
  mov MIN, MUESTRA  ;la primera muestra va a ser el minimo y el maximo
  mov MAX, MUESTRA
loop:
  cpi COUNT, table_size ; chequea que no haya llegado al fin
  breq end
  ld MUESTRA, Z+  ; lee siguiente muestra
compare_min:
  cp MUESTRA, MIN ;if MUESTRA < MIN
  brlt new_min
compare_max:
  cp MUESTRA, MAX ;if MUESTRA >= MAX
  brsh new_max
compare_zero:
  cpi MUESTRA, 0 ; if MUESTRA == 0
  breq new_zero
continue:
  inc COUNT
  jmp loop
;#################################
new_min:
  mov MIN, MUESTRA
  jmp compare_max
new_max:
  mov MIN, MUESTRA
  jmp compare_zero
new_zero:
  inc ZEROS
  jmp continue

end:    ; guardo datos pedidos al final de la tabla, uso ret
  st Z+, MIN
  st Z+, MAX
  st Z, ZEROS
  ret
