.include "./m328Pdef.inc"
.equ PWD=0x100
ldi r20, 0b00010010 ; cargo 1,2
ldi r21, 0b00110100 ; cargo 3,4
sts PWD, r20
sts PWD+1, r21
nop
MODE:
  lds r16,PWD
  lds r18,PWD+1
