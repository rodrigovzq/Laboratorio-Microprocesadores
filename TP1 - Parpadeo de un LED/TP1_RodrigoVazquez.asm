.include "m328Pdef.inc"
.org $00
.equ LED_PIN = 3
;conecto led en PB3
sbi DDRB, LED_PIN ; declaro a PB3 como salida


LOOP:
  sbi PORTB, LED_PIN ; enciendo LED
  call DELAY_200
  cbi PORTB, LED_PIN ;apago LED
  call DELAY_200
  rjmp LOOP

DELAY_200:
  ldi r18, 16
L3:             ; repite L2 16 veces x 20k = 3.2M
  ldi r19, 157
L2:             ; repite L1 por 157 veces x 1274us = 20k
  ldi r20,255
L1:             ; (5x255)-1 =1274
  nop
  nop
  dec r20
  brne L1
  dec r19
  brne L2
  dec r18
  brne L3
  ret
