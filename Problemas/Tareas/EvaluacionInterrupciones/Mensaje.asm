.include "m328Pdef.inc"
.equ CLOCK = 2
.equ DATA = 1
.equ COM_PORT = PIND
.equ data_mask = 0b00000010
.def COUNTER = r31
.def DATA_REG = r30
.def AUX_REG = r20
.equ byte_size = 8
;#################################
.org 0
  rjmp Reset
.org INT0addr
  rjmp init_rx

Reset:
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  call INIT_INT
  call INIT_HARDW
main:
  ldi COUNTER, 0
  ldi XH, HIGH($0100) ;cargo el registro X con la posicion en memoria de los datos
  ldi XL, LOW($0100)
void:
  jmp void

;#################Interrupt Service Routine#######################
init_rx:
  in AUX_REG, COM_PORT
  andi AUX_REG, data_mask
  or DATA_REG, AUX_REG
  rol DATA_REG
  inc COUNTER
  cpi COUNTER, byte_size
  breq output
  reti
output:
  st X+, DATA_REG
  clr DATA_REG
  reti

;;####################Interrupt Config###########################
INIT_INT:
  push r16
  ;Establece que la interrupcion es por flanco asc de INT0
  ldi r16, (1<<ISC01)|(0<<ISC00) ; 11 es flanco asc
  sts EICRA, r16
  ;Habilita a INT0 a ser interrupcion
  ldi r16, (1<<INT0)
  out EIMSK, r16
  pop r16
  sei
  ret
INIT_HARDW:
  ;Pone unos en las posiciones de los pines declarados
  push r16
  sbr r16, (0<<CLOCK|0<<DATA)
  out DDRD, r16
  pop r16
  ret
