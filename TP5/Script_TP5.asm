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
main:
	call read
	call output
	jmp main


read:
  push r16
  lds r16, ADCSRA
  sbr r16, 1<<ADSC
  sts ADCSRA, r16 ; arranca la conversion
check_done:
	lds r16, ADCSRA
  sbrs r16, ADIF ;chequea si finalizo, finaliza cuando ADIF=1
	jmp check_done
  sbr r16, ADIF ; el fabricante indica que se debe anunciar el fin de lectura
  sts ADCSRA, r16
  pop r16
	ret
output:
	push r16
	lds r16, ADCH
  lsr r16
  lsr r16
  out LED_PORT,r16
  call delay10ms
  pop r16
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
	ldi r16, (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0) ; enciende ADC y setea prescaler
	sts ADCSRA, r16
  clr r16
  sts ADCSRB, r16
	ldi r16, (0<<REFS1)|(1<<REFS0)|(1<<ADLAR)|(0<<MUX3)|(0<<MUX2)|(0<<MUX1)|(0<<MUX0)
	sts ADMUX, r16
	pop r16
	ret
;###################################################################
delay10ms:
  push r18
  push r19
  ldi  r18, 208
  ldi  r19, 202
  L1:
  dec  r19
  brne L1
  dec  r18
  brne L1
  nop
  pop r19
  pop r18
  ret
