.include "m328Pdef.inc"
.org $00
.def DATA = r20
.equ MAX = 100
.equ MIN = 10

stack_ini:
ldi r16, HIGH(RAMEND)
out SPH, r16
ldi r16, LOW(RAMEND)
out spl, r16        ;inicializa el stack al fondo de la memoria

call relleno_mem


set_buffer:
  mov YL, XL
  mov YH, XH
  inc YH    ; le sumo dos al byte mas significativo, sumo 2.16^2=64posiciones*8bits
  inc YH
main:
  call next
  ld DATA, X    ; leo datos y cargo en DATA
  cpi DATA, MAX
  brcc sat_max
  cpi DATA, MIN
  brlo sat_min
  jmp main

next:
  inc XL
  brmi carry_X
  ret
  carry_X:
    ldi XL,0
    nop
    inc XH
    cp XH, YH
    breq check_LSB
    ret
check_LSB:
  cp XL, YL
  breq reset_memory
  ret
reset_memory:
  subi XH, 2
  mov XL, YL
  ret

sat_max:
  ldi DATA, MAX
  st X, DATA
  jmp main
sat_min:
  ldi DATA, MIN
  st X, DATA
  jmp main
relleno_mem:
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
ldi XH, HIGH($0100) ;cargo el registro X con la posicion en memoria de los datos
ldi XL, LOW($0100)
ret
