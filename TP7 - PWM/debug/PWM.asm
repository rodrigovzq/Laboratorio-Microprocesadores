.include "m328pdef.inc"
.def TEMP = R16

.def COUNTER = R19

INIT:
	LDI TEMP, 0xFF
	OUT DDRB, TEMP

	LDI TEMP, (1<<COM2A1)|(1<<WGM20)|(1<<WGM21)
	sts TCCR2A, TEMP

	LDI TEMP, 1<<CS21
	sts TCCR2B, TEMP

	LDI TEMP, 20
	sts OCR2A, TEMP

LOOP:
	RJMP LOOP
