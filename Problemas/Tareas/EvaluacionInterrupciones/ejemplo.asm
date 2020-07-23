;.device ATmega328P
.include "m328Pdef.inc"
; Vector de reset
.org 0
		rjmp Reset
; Vector de INT0 (pin PD2)
.org INT0addr
		rjmp IntV0

; Vector de PCINT0 (pines PB0 y PB1, en este caso)
.org PCI0addr
		rjmp IntVC0


; Inicializa stack
Reset:
			ldi R31,low(RAMEND)
	  	out SPL,R31
      ldi R31, high(RAMEND)
      out SPH, R31

		call INIT_IRQ_INT0
		call INIT_IRQ_PIN_CHANGE

 		clr R16
		out DDRD, R17 ; PORTD como entrada
		out DDRB, R17 ; PORTB como entrada
		sei	          ; Hab. global de interrupciones

;-------------------------------------------------------
loop:
		ldi  R16,0
		nop
		nop
		nop
		cpi  R16,0
		nop
		nop
		nop
		breq igual
        nop
		nop
		nop
igual:
	rjmp loop


IntV0:

        push r16 ;****

		in   r16,sreg
		push r16 ;====

		ldi r17,1
		add R16,R17

		pop r16 ;=====
		out sreg,r16

		pop r16 ;****
		reti


IntVC0:
        ldi r17,1
		add R16,R17
		reti


; Configura PCINT0, PCINT1
INIT_IRQ_PIN_CHANGE:	;0b00000001
		ldi R16, (1<<PCIE0)
		STS PCICR, R16
		ldi R16, (1 << PCINT0) | (1 << PCINT1)
		STS PCMSK0, R16
		RET

; Configura INT0
INIT_IRQ_INT0:
		ldi R16, (1<<ISC01)|(1<<ISC00)  ;flanco ascendente
		sts EICRA, R16
		ldi R16, (1<<INT0)
		out EIMSK, R16					; Habilita máscara
		RET
