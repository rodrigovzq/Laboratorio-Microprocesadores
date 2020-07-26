.include "m328Pdef.inc"

;### CONSTANTES NECESARIAS A DEFINIR##########
.equ palabra = $100
.equ EOC = '%' ; creo un caracter de fin de comparacion
.def RESULT = r22
;###############################################
;########subrutina -> detector_palindromos############
detector_palindromos:
  ldi r20, EOC
  push r20  ; cargo primero al stack el caracter de fin de conversion
  ldi XH, HIGH(palabra)
  ldi XL, LOW(palabra)
  call read_save  ; lee de memoria y guarda en stack (la palabra queda invertida)
  call compare  ; compara de a caracter entre memoria y stack
  call output ; se muestra el bit de RESULT que contiene un 1 si es palindromoc
  ret
;############################
read_save:
  ld r20, X+
  push r20 ; voy guardando los caracteres en el stack
  cpi r20, '/'  ; si encuentra fin de linea, finaliza, sino sigue
  breq reset_table
  jmp read_save
  ;a esta altura tengo la palabra guardada en el stack y el primer dato que
  ;obtengo con pop es la ultima letra
reset_table:
  ldi XH, HIGH(palabra)
  ldi XL, LOW(palabra)
  ret ; reinicio la tabla
;#############################
compare:
  ldi RESULT, 1 ;asumo que la palabra es palindromo hasta que detecte que no
  continue:
  ld r21, X+
  pop r20 ; comparo la lectura ascendente de ram contra descendente del stack
  cpi r20, EOC ; si obtuve EOC del stack es que termino la palabra
  breq end_compare
  cp r20, r21
  breq continue  ; si son iguales, sigo con la lectura
  ldi RESULT, 0   ; si son distintos, no es palindromo
  jmp continue ; continuo la lectura (aunque no sea palindromo) para limpiar stack
end_compare:
  ret
;#############################
output:
  out PORTB, RESULT; solo contiene informacion en la posicion de PB0
  ret
