.include "m328Pdef.inc"
.equ table_dir = $0100
.equ table_length = 16
.def COUNTER = r16
.org 0
stack_ini:
ldi r16, HIGH(RAMEND)
out SPH, r16
ldi r16, LOW(RAMEND)
out spl, r16 ;inicializa el stack al fondo de la memoria
main:
call INIT_HARDW
call fill
call INIT_TABLE

loop:
  call read
  call promedio
  call save
  cpi COUNTER, table_length
  breq restart_table
  jmp loop

;###############################################################################
read:
  in r16, PINB
  st X+, r16
  inc COUNTER
  ret
promedio:
  adc r20, r16<<4
  ret
save:
  out PORTC, r20
  ret
restart_table:
  call INIT_TABLE
  jmp loop
;###############################################################################

;###############Configurar puertos##############################################
INIT_HARDW:
  ;Pone unos en las posiciones de los pines declarados
  push r16
  ldi r16, 0 ;puertob como entrada
  out DDRB, r16
  ldi r16, $FF; puerto c como salida
  out DDRC, r16
  pop r16
  ret
;###############################################################################
INIT_TABLE:
  ldi XL, LOW(table_dir)
  ldi XH, HIGH(table_dir)
  clr COUNTER
  ret
;###############################################################################
fill:
ldi XH, HIGH($0100) ;cargo el registro X con la posicion en memoria de los datos
ldi XL, LOW($0100)

ldi r16, 128
st X+, r16
ldi r16, 60
st X+, r16
ldi r16, 255
st X+, r16
ldi r16, 38
st X+, r16
ldi r16, 98
st X+, r16
ldi r16, 4
st X+, r16
ldi r16, 147
st X+, r16
ldi r16, 111
st X+, r16
ldi r16, 216
st X+, r16
ldi r16, 191
st X+, r16
ldi r16, 76
st X+, r16
ldi r16, 187
st X+, r16
ldi r16, 129
st X+, r16
ldi r16, 213
st X+, r16
ldi r16, 222
st X+, r16
ldi r16, 234
st X+, r16
ret
