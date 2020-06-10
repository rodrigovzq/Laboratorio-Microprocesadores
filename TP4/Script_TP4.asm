.include "m328Pdef.inc"

.equ BTN_PIN = 2    ;PD2
.equ LED1_PIN = 2   ;PB2
.equ LED2_PIN = 3   ;PB3
.def COUNTER = r20

.org 0
  rjmp reset
.org INT0addr
  rjmp parpadeo

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
main:
  sbi PORTB, LED1_PIN
  rjmp main

parpadeo:
  call debounceINT0
  cbi PORTB, LED1_PIN
  ldi COUNTER, 5
  loop:
    sbi PORTB, LED2_PIN
    call DELAY_1s
    cbi PORTB, LED2_PIN
    call DELAY_1s
    dec COUNTER
    brne loop
  sbi PORTB, LED1_PIN
  reti

debounceINT0:
  call DELAY_10ms
  sbis PIND, BTN_PIN
  reti
  ret
;;#################################
INIT_INT0:
  ;Habilita a INT0 a ser interrupcion
  ldi r16, (1<<INT0)
  out EIMSK, r16
  ;Establece que la interrupcion es por flanco asc de INT0
  ldi r16, (1<<ISC01)|(1<<ISC00) ; 11 es flanco asc
  sts EICRA, r16
  sei
  ret

INIT_HARDW:
  ;Pone unos en las posiciones de los pines declarados
  sbr r16, (1<<LED1_PIN)|(1<<LED2_PIN)
  out DDRB, r16
  sbr r16, (1<<BTN_PIN)
  out DDRD, r16
  ret
DELAY_10ms:
  push r17
  push r18
  ldi r18, 209
L2:
  ldi r17, 255
L1:
  dec r17
  brne L1
  dec r18
  brne L2
  pop r18
  pop r17
  ret
;;#################################
DELAY_1s:
  ldi r18, 9
LOOP3:           ; repite LOOP2 9 veces = 1,00045 s
  ldi r17, 89
LOOP2:           ; repite LOOP1 por 89 veces x 1249us= 111.16 ms
  ldi r16, 250
LOOP1:           ; (5x250)-1 =1249us
  nop
  nop
  dec r16
  brne LOOP1
  dec r17
  brne LOOP2
  dec r18
  brne LOOP3
  ret
