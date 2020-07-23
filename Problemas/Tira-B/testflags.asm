.include "./m328Pdef.inc"
.org 0
.equ H_READ=0x100
.equ H_WARN=220
.equ H_MAX=200
.equ H_MIN=50

ldi r20,240
cpi r20, H_WARN
