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
;.equ STEP = 51 ; ajuste del brillo (0%, 20%, 40%, 60%, 80%, 100%)
;.def AUX = r21
.org 0
  jmp Reset
.org OC2Aaddr
  jmp clearOC_flag
.org OVF2addr
  jmp clearOV_flag


Reset:
  ;Inizializador de stack
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out SPL, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  ;#################################
  call INIT_HARDW
  call INIT_TIMER2
  jmp main
main:
  ;call half
  ;call delay
  ;call full
  ;call delay
  jmp main
half:
  ldi BRGHT, 128
  sts DTYCCL, BRGHT
  ret
full:
  ldi BRGHT, 255
  sts DTYCCL, BRGHT
  ret
clearOC_flag:
  push r16

  ldi r16, (1<<OCF2A)
  sts TIFR2, r16
  pop r16
  reti
clearOV_flag:
  push r16
  ldi r16, (1<<TOV2)
  sts TIFR2, r16
  pop r16
  reti
;###############################################################################
;###################CONFIGURACION###############################################
INIT_HARDW:
  push r16
  ldi r16, $FF
  out LED_DDR, r16
  ldi r16, (0<<BTNDOWN)|(0<<BTNUP)
  out BTN_DDR, r16
  pop r16
  ret

INIT_TIMER2:
  push r16
  ldi r16, 255
  sts OCR2A, r16
  ldi r16, (1<<WGM21)|(1<<WGM20)|(1<<COM2A1)|(1<<COM2A0)
  sts TCCR2A, r16; modo fast PWM y non-inverting mode
  ldi r16, (1<<WGM22)|(0<<CS22)|(0<<CS21)|(1<<CS20) ; sin prescaler
  sts TCCR2B, r16
  ldi r16, (1<<OCIE2A)|(1<<TOIE2)
  sts TIMSK2, r16
  pop r16
  ret
;###############################################################################
;###############UTILIDADES######################################################
delay:
  push r17
  push r18
  ldi r18, 255
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
;##############################################################################
