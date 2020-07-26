.include "m328Pdef.inc"

.equ LED_PORT = PORTB
.equ LED_DDR = DDRB
.equ LED1 = PB3
.equ BTN_PORT = PIND
.equ BTN_DDR = DDRD
.equ BTN1 = PD2
.equ BTN2 = PD3
.equ input_mask = 0b00001100
.equ cs_mask =    0b11111000

.org 0
  jmp Reset
.org OVF1addr
  jmp Toggle_LED

Reset:
  ;Inizializador de stack
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  ;#################################
  call INIT_HARDW
  call INIT_TIMER1
  jmp main

main:
  call read_BTN
  cpi r16, 0
  breq LED_FIJO
  cpi r16, 1
  breq BLINK_64
  cpi r16, 2
  breq BLINK_256
  cpi r16, 3
  breq BLINK_1024
  jmp main
read_BTN:
  in r16, BTN_PORT      ; r16 = xxxxabxx
  andi r16, input_mask  ; r16 = 0000ab00
  ror r16
  ror r16                ; r16 = 000000ab -> puede valer {0,1,2,3}
  ret
LED_FIJO:
  push r16
  call INIT_TIMER1
  lds r16, TCCR1B
  andi r16, cs_mask
  ori r16, (0<<CS12)|(0<<CS11)|(0<<CS10)
  sts TCCR1B, r16
  sbi LED_PORT, LED1
  pop r16
  jmp main

BLINK_64:
  call debounceBTN1 ; si BTN2!=high vuelve al main
  push r16
  lds r16, TCCR1B
  andi r16, cs_mask
  ori r16, (0<<CS12)|(1<<CS11)|(1<<CS10); clk/64
  sts TCCR1B, r16
  pop r16
  jmp main
BLINK_256:
  call debounceBTN2 ; si BTN1!=high vuelve al main
  push r16
  lds r16, TCCR1B
  andi r16, cs_mask
  ori r16, (1<<CS12)|(0<<CS11)|(0<<CS10) ; clk/256
  sts TCCR1B, r16
  pop r16
  jmp main
BLINK_1024:
  call debounceBTN1 ; si BTN1!=high vuelve al main
  call debounceBTN2 ; si BTN2!=high vuelve al main
  push r16
  lds r16, TCCR1B
  andi r16, cs_mask
  ori r16, (1<<CS12)|(0<<CS11)|(1<<CS10) ; clk/1024
  sts TCCR1B, r16
  pop r16
  jmp main
;###############################################################################
;###################RUTINA SERVICIO DE INTERRUPCION#############################
Toggle_LED:
  push r16
  call INIT_TIMER1
  sbis LED_PORT, LED1
  jmp turnon_LED
  jmp turnoff_LED
turnon_LED:
  sbi LED_PORT, LED1
  pop r16
  reti
turnoff_LED:
  cbi LED_PORT, LED1
  pop r16
  ret
;###############################################################################
;###################CONFIGURACION###############################################
INIT_HARDW:
  push r16
  ldi r16, (1<<LED1)
  out LED_DDR, r16
  ldi r16, (0<<BTN1)|(0<<BTN2)
  out BTN_DDR, r16
  pop r16
  ret
INIT_TIMER1:
  push r16
  ldi r16, (0<<WGM11)|(0<<WGM10)
  sts TCCR1A, r16
  ldi r16, (0<<WGM13)|(0<<WGM12)
  sts TCCR1B, r16
  ldi r16, (1<<TOIE1)
  sts TIMSK1, r16
  sei
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
debounceBTN1:
  call DELAY_1ms
  sbis BTN_PORT, BTN1
  jmp main
  ret
;#################################
debounceBTN2:
  call DELAY_1ms
  sbis BTN_PORT, BTN2
  jmp main
  ret
;##############################################################################
