.include "m328Pdef.inc"
.org $00

DELAY_200:
  ldi  r18, 17
  ldi  r19, 60
  ldi  r20, 204
L1:
  dec  r20
  brne L1
  dec  r19
  brne L1
  dec  r18
  brne L1
  ret
