.include "m328Pdef.inc"
.org $00
.equ iC = PB0
.equ iK = PB1 ; uso r20
.equ iJ = PB2 ; uso r21
; uso r22 para Q
.equ mask_K = 0b00000010
.equ mask_J = 0b00000100
.equ mask_Q = 0b00001000

ldi r23, 0b00011000   ; uso r23 como auxiliar
out DDRB, r23

L1:
  sbic PINB, iC
  rjmp L1
L2:             ;entra a L2 cuando C=0
  sbis PINB, iC
  rjmp L2
  call read_Q
  call read_K
  call read_J
  cpi r21,0
  breq First
  rjmp Second

First:
  cpi r20,0
  breq L1
  rjmp Cero

Second:
  cpi r20,1
  breq Toggle
  rjmp Uno

Output:
  or r23, r22<<3
  com r22
  or r23, r22<<4
  out PORTB, r23
  rjmp L1

Toggle:
  cpi r22, 0
  breq Uno
  rjmp Cero
Uno:
  ldi r22, 1
  rjmp Output
Cero:
  ldi r22, 0
  rjmp Output

read_Q:
  in r22, PINB
  andi r22, mask_J
  mov r22, r22>>3
  ret
read_K:
  in r20, PINB
  andi r20, mask_K
  mov r20, r20>>1
  ret
read_J:
  in r21, PINB
  andi r21, mask_J
  mov r21, r21>>2
  ret
