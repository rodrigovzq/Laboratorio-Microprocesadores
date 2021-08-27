.include "m328Pdef.inc"

.equ LED_PORT = PORTB
.equ LED_DDR = DDRB
.equ LED1 = PB3
.equ BTN_PORT = PIND
.equ BTN_DDR = DDRD
.equ BTNDOWN = PD2
.equ BTNUP = PD3
.def BRGHT = r20
.equ DTYCCL = OCR2A
.equ STEP = 51 ; ajuste del brillo (0%, 20%, 40%, 60%, 80%, 100%)
.def AUX = r21
.org 0
  jmp Reset
.org INT0addr
  ;jmp BRIGHT_DOWN
.org INT1addr
  ;jmp BRIGHT_UP


Reset:
  ;Inizializador de stack
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out SPL, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  ;#################################
  call INIT_HARDW
  ;call INIT_INT
  call INIT_TIMER2
  call INIT_STATE
  jmp main
INIT_STATE:
  clr BRGHT
  ;ldi BRGHT, 255
  sts DTYCCL, BRGHT ; inicia con brillo 0%
main:
  sbic BTN_PORT, BTNUP
  call BRIGHT_UP
  sbic BTN_PORT, BTNDOWN
  call BRIGHT_DOWN
  jmp main
;###################RUTINA SERVICIO DE INTERRUPCION#############################
BRIGHT_DOWN:
  ;call debounceBTNDOWN
  cpi BRGHT, 0  ; si el registro de brillo esta en 0, no lo baja mas
  breq min_brightness
  lds BRGHT, DTYCCL ; carga valor actual del brillo a modificar
  ldi AUX, STEP
  sub BRGHT, AUX
  sts DTYCCL, BRGHT ; guarda el nuevo valor del brillo
  ret
min_brightness:
  ret
;#################################
BRIGHT_UP:
  ;call debounceBTNUP
  cpi BRGHT, 255 ; si el registro de brillo esta en 255 (100%), no lo sube mas
  breq max_brightness
  lds BRGHT, DTYCCL ; carga valor actual del brillo a modificar
  ldi AUX, STEP
  add BRGHT, AUX
  sts DTYCCL, BRGHT ; guarda el nuevo valor del brillo
  sbic BTN_PORT, BTNUP
  jmp BRIGHT_UP
  ret
max_brightness:
  ret

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
  ;Habilita a INT0 a ser interrupcion
  ldi r16, (1<<INT0)|(1<<INT1)
  out EIMSK, r16
  pop r16
  sei
  ret
INIT_TIMER2:
  push r16
  ldi r16, (1<<WGM21)|(1<<WGM20)|(1<<COM2A1)|(0<<COM2A0)
  sts TCCR2A, r16; modo fast PWM y non-inverting mode
  ldi r16, (1<<WGM22)|(0<<CS22)|(0<<CS21)|(1<<CS20) ; sin prescaler
  sts TCCR2B, r16
  pop r16
  ret
;###############################################################################
;###############UTILIDADES######################################################
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
;#################################
debounceBTNDOWN:
  call DELAY_1ms
  sbis BTN_PORT, BTNDOWN
  jmp main
  ret
;#################################
debounceBTNUP:
  call DELAY_1ms
  sbis BTN_PORT, BTNUP
  jmp main
  ret
;##############################################################################
