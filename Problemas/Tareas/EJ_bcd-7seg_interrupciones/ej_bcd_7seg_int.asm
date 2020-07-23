.include "m328Pdef.inc"

.equ DDR_BCD = DDRB
.equ PORT_BCD = PINB
.equ PCI_BCD = PCIE0
.equ PCMSK_BCD = PCMSK0
.equ BCD0 = PCINT0  ;= PB0
.equ BCD1 = PCINT1  ;= PB1
.equ BCD2 = PCINT2  ;= PB2
.equ BCD3 = PCINT3  ;= PB3
.equ bcd_mask = $0F
.equ DISPLAY_DDR = DDRD
.equ DISPLAY_PORT = PORTD
.equ DISPLAY_PINOUT = 0b01111111 ; Unos en cada pin del display 7-segmentos
.equ ERROR_DISPLAY = 15 ; 'E' en 7seg codificado en BCD
.equ INIT_VALUE = 0

.org 0
  rjmp Reset
.org PCI0addr
  rjmp Display

Reset:
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  call INIT_PCI
  call INIT_HARDW

;;###############Main Loop##################
main:
  ldi r21, INIT_VALUE   ; Inicia el display con 0
  call BCDto7seg
  call Output
zzz:
  sleep          ; Micro en modo sleep
  jmp zzz
;;###########################################

;;#############Interrupt Service Routine####################
Display:
  call Read
  call BCDto7seg
  call Output
  reti
Read:
  in r20, PORT_BCD
  andi r20, bcd_mask
  cpi r20, 9
  brge out_of_range ; si la lectura > 9, muestra caracter de error en el display
  ret
BCDto7seg:
  push r20
  ldi ZL, LOW(table<<1) ;inicializa en puntero Z en la posicion de 'table'
  ldi ZH, HIGH(table<<1)
  add ZL, r20  ;se ubica al puntero Z en la posicion leida
  clr r20
  adc ZH, r20
  lpm r21, Z  ; se carga a r21 con el dato de la tabla (conversion)
  pop r20
  ret
Output:
  out DISPLAY_PORT, r21
  ret
out_of_range:
  ldi r21, ERROR_DISPLAY
  ret

;;###########################################

;;########################Hardware Config##################
INIT_PCI:
  push r16
  ldi r16, (1<<PCI_BCD)   ; Activa vector de interrup PCI0
  sts PCICR, r16
  ldi r16, (1<<BCD3)|(1<<BCD2)|(1<<BCD1)|(1<<BCD0)
  sts PCMSK_BCD, r16       ; Activa primeros 4 pines de PCI0=PORTB
  sei
  ret
INIT_HARDW:
  push r16
  ldi r16, (0<<BCD3)|(0<<BCD2)|(0<<BCD1)|(0<<BCD0)
  out DDRB, r16 ; declara 4 pines como entradas
  ldi r16, DISPLAY_PINOUT
  out DISPLAY_DDR, r16
  pop r16
  ret
;;#########################################################

;;###################TABLA BCD A 7SEG########################
table:
  .db 0b01111110, 0b00110000, 0b01101101, 0b01111001
  ;       0     ,     1     ,     2     ,     3
  .db 0b00110011, 0b01011011, 0b01011111, 0b01110000
  ;       4     ,      5     ,     6     ,     7
  .db 0b01111111, 0b01111011, 0b01110111, 0b01111100
  ;        8     ,     9     ,     A     ,     B
  .db 0b00111001, 0b01011110, 0b01111001, 0b01110001
  ;        C     ,     D     ,     E     ,     F
;;############################################################
