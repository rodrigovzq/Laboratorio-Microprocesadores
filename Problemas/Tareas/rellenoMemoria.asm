.include "m328Pdef.inc"
.org $00
ldi r16, HIGH(RAMEND)
out SPH, r16
ldi r16, LOW(RAMEND)
out spl, r16

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
