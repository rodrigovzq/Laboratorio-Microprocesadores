.include "./m328Pdef.inc"

ldi r20, HIGH(RAMEND)
out SPH, r20
ldi r20, LOW(RAMEND)
out SPL, r20          ; inicializa el stack

ldi r20, $20
ldi r21, $31
ldi r22, $42
ldi r23, $53
ldi r24, $64

push r20
push r21
push r22
push r23
push r24

VOID:
  rjmp VOID
