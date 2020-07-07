.include "m328Pdef.inc"

.equ LED_PORT = PORTB
.equ LED_DDR = DDRB
.equ POT_BIT = PC0
.equ POT_PIN = PINC
.equ POT_DDR = DDRC

.org 0
  rjmp reset

reset:
  ;Inizializador de stack
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  ;#################################
  call INIT_HARDW
  call INIT_ADC
  call start_conversion
main:
	call read
	call output
	jmp main
start_conversion:
  push r16
  lds r16, ADCSRA
  sbr r16, (1<<ADSC)
  sts ADCSRA, r16 ; arranca la conversion
  pop r16
  ret

read:
  lds r16, ADCH
  ret
output:
  lsr r16
  lsr r16
  out LED_PORT,r16
  ret

;######################HARDWARE-SETTINGS############################
INIT_HARDW:
	push r16
	ldi r16, $FF
	out LED_DDR, r16
	ldi r16, 0<<POT_BIT
	out POT_DDR, r16
	pop r16
	ret
INIT_ADC:
	push r16
	ldi r16, (1<<ADEN)|(1<<ADATE)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0) ; enciende ADC y setea prescaler
	sts ADCSRA, r16 ; activa ADATE = free running mode
  clr r16
  sts ADCSRB, r16
	ldi r16, (0<<REFS1)|(1<<REFS0)|(1<<ADLAR)|(0<<MUX3)|(0<<MUX2)|(0<<MUX1)|(0<<MUX0)
	sts ADMUX, r16
	pop r16
	ret
;###################################################################
