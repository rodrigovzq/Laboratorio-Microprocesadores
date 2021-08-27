.include "m328Pdef.inc"
;#################################
;Seteo de hardware
.equ tope_ida =     0b00100000
.equ tope_vuelta =  0b00000001
.equ led_mask = 0b00111111
.def LED_reg = r20
.equ LED_PORT = PORTB
ldi r16, led_mask
out DDRB, r16
;#################################

inicio:
  ldi LED_reg, tope_vuelta
  call output
ida:
  lsl LED_reg
  call output
  cpi LED_reg, tope_ida
  brne ida
vuelta:
  lsr LED_reg
  call output
  cpi LED_reg, tope_vuelta
  brne vuelta
  jmp ida
output:
  out LED_PORT, LED_reg
  ldi r16, SREG
  call delay
  out SREG, r16
  ret
;DELAY de 25ms
delay:
  push r16
  push r17
  push r18
  ldi r16, 8
L3:
  ldi r18, 255
L2:
  ldi r17, 255
L1:
  dec r17
  brne L1
  dec r18
  brne L2
  dec r16
  brne L3
  pop r18
  pop r17
  pop r16
  ret
;;#################################
