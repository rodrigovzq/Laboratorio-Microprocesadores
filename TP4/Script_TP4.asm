.include "m328Pdef.inc"

.equ BTN = 2    ;PD2
.equ LED_1 = 2   ;PB2
.equ LED_2 = 3   ;PB3
.equ LED_PORT = PORTB
.equ BTN_PIN = PIND
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

  sbi LED_PORT, LED_1
;;##########################################

;;###############Main Loop##################
main:
  nop
  rjmp main
;;###########################################

;;#############Interrupt Service Routine####################
parpadeo:
  call debounceINT0
  cbi LED_PORT, LED_1
  ldi COUNTER, 5
  loop:
    sbi LED_PORT, LED_2
    call DELAY_500ms
    cbi LED_PORT, LED_2
    call DELAY_500ms
    dec COUNTER
    brne loop
  sbi LED_PORT, LED_1
  reti

debounceINT0:
  call DELAY_1ms
  sbis BTN_PIN, BTN
  reti
  ret
;;#########################################################

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
  sbr r16, (1<<LED_1)|(1<<LED_2)
  out DDRB, r16
  sbr r16, (1<<BTN)
  out DDRD, r16
  pop r16
  ret

;;#################DELAYS###########################
DELAY_1ms:
  push r17
  push r18
  ldi r18, 21
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
DELAY_500ms:
  push r16
  push r17
  push r18
  ldi r18, 41
LOOP3:           ; repite LOOP2 9 veces = 1,00045 s
  ldi r17, 255
LOOP2:           ; repite LOOP1 por 89 veces x 1249us= 111.16 ms
  ldi r16, 255
LOOP1:           ; (5x250)-1 =1249us
  dec r16
  brne LOOP1
  dec r17
  brne LOOP2
  dec r18
  brne LOOP3
  pop r18
  pop r17
  pop r16
  ret
