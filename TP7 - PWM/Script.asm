;			                    Facultad de Ingenieria
;				                 Universidad de Buenos Aires
;
;				                       Rodrigo Vazquez
;
;               TP7-86.07: Controlar brillo de LED via PWM
;
.include "m328Pdef.inc"
;###################DEFINICIONES################################################
.equ LED_DDR = DDRB
.equ LED1 = PB3
.equ BTN_PORT = PIND
.equ BTN_DDR = DDRD
.equ BTNDOWN = PD2
.equ BTNUP = PD3
.def BRGHT = r20
.equ DTYCCL = OCR2A
;###############################################################################
;###################MACROS######################################################
.macro init_stack ; [auxGPR]
	ldi @0, low(RAMEND)
	out SPL, @0
	ldi @0, high(RAMEND)
	out SPH, @0
.endm
;###############################################################################
;###################PROGRAMA####################################################
.org 0
  jmp onReset
.org INT0addr
  jmp BRIGHT_DOWN
.org INT1addr
  jmp BRIGHT_UP

onReset:
  init_stack r16
  call INIT_HARDW
  call INIT_INT
  call INIT_TIMER2
  jmp main
main:
  sleep
  jmp main
;###################RUTINA SERVICIO DE INTERRUPCION#############################
BRIGHT_DOWN:
  call debounceBTNDOWN
  lds BRGHT, DTYCCL
  cpi BRGHT, 0  ; si el registro de brillo esta en 0, no lo baja mas
  breq min_brightness
  dec BRGHT
  sts DTYCCL, BRGHT
  sbic BTN_PORT, BTNDOWN
  jmp BRIGHT_DOWN
  reti
min_brightness:
  reti
;#################################
BRIGHT_UP:
  call debounceBTNUP
  lds BRGHT, DTYCCL
  cpi BRGHT, 255 ; si el registro de brillo esta en 255 (100%), no lo sube mas
  breq max_brightness
  inc BRGHT
  ;add BRGHT, AUX
  sts DTYCCL, BRGHT
  sbic BTN_PORT, BTNUP
  jmp BRIGHT_UP
  reti
max_brightness:
  reti

;###############################################################################
;###################CONFIGURACION###############################################
INIT_HARDW:
  push r16
  ldi r16, (1<<LED1)
  out LED_DDR, r16
  ldi r16, (0<<BTNDOWN)|(0<<BTNUP)
  out BTN_DDR, r16
  pop r16
  ret
INIT_INT:
  push r16
  ;Establece que la interrupcion es por flanco asc de INT0
  ldi r16, (1<<ISC01)|(1<<ISC00)|(1<<ISC11)|(1<<ISC10) ; 11 es flanco asc
  sts EICRA, r16
  ;Habilita a INT0 e INT1 a ser interrupcion
  ldi r16, (1<<INT0)|(1<<INT1)
  out EIMSK, r16
  pop r16
  sei
  ret
INIT_TIMER2:
  push r16
  ldi r16, (1<<WGM21)|(1<<WGM20)|(1<<COM2A1)|(0<<COM2A0)
  sts TCCR2A, r16; modo fast PWM (3) y non-inverting mode
  ldi r16,  (0<<WGM22)|(0<<CS22)|(0<<CS21)|(1<<CS20);(1<<CS21); sin prescaler
  sts TCCR2B, r16;
  pop r16
  ret

;###############################################################################
;###############UTILIDADES######################################################
delay:
  push r17
  push r18
  ldi r18, 80
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
;#################################
debounceBTNDOWN:
  call delay
  sbis BTN_PORT, BTNDOWN
  reti
  ret
;#################################
debounceBTNUP:
  call delay
  sbis BTN_PORT, BTNUP
  reti
  ret
;##############################################################################
