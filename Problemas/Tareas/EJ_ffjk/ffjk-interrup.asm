.include "m328Pinc.def"
.equ FF_PORT = PORTD
.equ FF_PIN = PIND
.equ FF_DDR = DDRD
.equ iJ = 0
.equ iK = 1
.equ iC = 2
.equ oQ = 3
.equ oQn = 4
.equ INIT_VALUE = 0
.equ out_mask = 0b00011000
.equ in_mask = 0b000000011

.org $00
  jmp reset
.org INT0addr
  jmp FFJK

reset:
  ;Inizializador de stack
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  ;#################################
  call INIT_INT0
  call INIT_HARDW
;;###############Main Loop##################
initial_state:
  cbr r20, oQ
  sbr r20, oQn
  andi r20, out_mask
  out FF_PORT, r20
zzz:
  sleep          ; Micro en modo sleep
  jmp zzz
;;###########################################
;;#############Interrupt Service Routine####################
FFKJ:
 in r20, FF_PIND    ; leo entradas JK
 andi r20, in_mask
 cpi r20, 1         ; si J=0 & K=1
 breq Out_zero      ; Q <- 0
 cpi r20, 2         ; si J=1 & K=0
 breq Out_one       ; Q <- 1
 cpi r20, 3         ; si J=1 & K=1
 breq ToggleQ       ; Q <- !Q
 reti               ; si J=0 & K=0 => nada
ToggleQ:
  sbis FF_PORT, oQ
  call Out_one
  call Out_zero
Out_one:
  sbr r20, oQ
  cbr r20, oQn
  andi r20, out_mask
  out FF_PORT, r20
  reti
Out_zero:
  cbr r20, oQ
  sbr r20, oQn
  andi r20, out_mask
  out FF_PORT, r20
  reti

;;###########################################

;;########################Hardware Config##################
INIT_INT0:
  push r16
  ;Establece que la interrupcion es por flanco asc de INT0
  ldi r16, (1<<ISC01)|(1<<ISC00) ; 11 es flanco asc
  sts EICRA, r16
  ;Habilita a INT0 a ser interrupcion
  ldi r16, (1<<INT0)
  out EIMSK, r16
  pop r16
  sei
  ret

INIT_HARDW:
  ;Pone unos en las posiciones de los pines declarados
  push r16
  ldi r16, (0<<iJ)|(0<<iK)|(0<<iC)|(1<<oQ)|(1<<oQn)
  out FF_DDR, r16
  pop r16
  ret
