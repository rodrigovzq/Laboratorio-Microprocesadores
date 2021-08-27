;			                    Facultad de Ingenieria
;				                 Universidad de Buenos Aires
;
;				                       Rodrigo Vazquez
;
;                         TP8-86.07: Puerto Serie

.include "m328Pdef.inc"
;###################DEFINICIONES################################################
.equ LED_1 = PB5
.equ LED_2 = PB4
.equ LED_3 = PB3
.equ LED_4 = PB2
.equ LED_DDR = DDRB
.equ LED_PORT = PORTB
.equ BRATE = 103 ; 9600bps segun clk 16M
.equ EOM = '$'
.equ EOL = $A ; LF
.equ OPT1 = '1'
.equ OPT2 = '2'
.equ OPT3 = '3'
.equ OPT4 = '4'

;###############################################################################
;###################MACROS######################################################
.macro init_stack ; [auxGPR]
	ldi @0, low(RAMEND)
	out SPL, @0
	ldi @0, high(RAMEND)
	out SPH, @0
.endm
;###############################################################################
;###################DATOS#######################################################
.org $600
msg_welcome:
.db EOL,"***Hola Labo de Micros***",EOL
;.db "Escriba 1, 2,3 o 4 para controlar los leds", EOM
.db "Escriba ", OPT1,$20 , OPT2,$20, OPT3,$20, "o ", OPT4,
.db " para controlar los LEDs",EOL,EOM


;###############################################################################
;###################PROGRAMA####################################################
.org 0
  jmp onReset
onReset:
  init_stack r16
  call INIT_HARDW
  call INIT_USART
  call DELAY_5s
  jmp main

main:
  call welcome_msg
again:
	call read_opt
	call DELAY_5s
  rjmp again

welcome_msg:
	push r16
  push r17
  ldi ZH, HIGH(msg_welcome<<1)	; apunto a tabla del mensaje
  ldi ZL, LOW(msg_welcome<<1)
  next_char:
  lpm r17, Z+
  cpi r17, EOM  ; si llega al fin del mensaje, finaliza transmision
  breq end_msg
	call ready_TX
  sts UDR0, r17
  jmp next_char
end_msg:
	pop r17
	pop r16
  ret
ready_TX:
  lds r16, UCSR0A
  sbrs r16, UDRE0
  jmp ready_TX  ; Espera hasta que el buffer se encuentre vacio
  ret

ready_RX:
	lds r16, UCSR0A
	sbrs r16, RXC0
	jmp ready_RX
	ret

read_opt:
	push r16
	push r18
	call ready_RX
	lds r18, UDR0
	cpi r18, OPT1
	breq toggle_1
	cpi r18, OPT2
	breq toggle_2
	cpi r18, OPT3
	breq toggle_3
	cpi r18, OPT4
	breq toggle_4
	jmp wrong_opt

toggle_1:
	sbis LED_PORT, LED_1
	jmp turnon_LED1
	jmp turnoff_LED1
	turnon_LED1:
	  sbi LED_PORT, LED_1
		pop r18
		pop r16
		ret
	turnoff_LED1:
	  cbi LED_PORT, LED_1
		pop r18
		pop r16
		ret
toggle_2:
	sbis LED_PORT, LED_2
	jmp turnon_LED2
	jmp turnoff_LED2
	turnon_LED2:
	  sbi LED_PORT, LED_2
		pop r18
		pop r16
		ret
	turnoff_LED2:
	  cbi LED_PORT, LED_2
		pop r18
		pop r16
		ret
toggle_3:
	sbis LED_PORT, LED_3
	jmp turnon_LED3
	jmp turnoff_LED3
	turnon_LED3:
	  sbi LED_PORT, LED_3
		pop r18
		pop r16
		ret
	turnoff_LED3:
	  cbi LED_PORT, LED_3
		pop r18
		pop r16
		ret
toggle_4:
	sbis LED_PORT, LED_4
	jmp turnon_LED4
	jmp turnoff_LED4
	turnon_LED4:
	  sbi LED_PORT, LED_4
		pop r18
		pop r16
		ret
	turnoff_LED4:
	  cbi LED_PORT, LED_4
		pop r18
		pop r16
		ret

wrong_opt:
	call ready_TX
	sts UDR0, r18
	pop r18
	pop r16
	ret
;###############################################################################
;###################CONFIGURACION###############################################
INIT_HARDW:
  push r16
  ldi r16, (1<<LED_4)|(1<<LED_3)|(1<<LED_2)|(1<<LED_1)
  out LED_DDR, r16
  pop r16
  ret
INIT_USART:
  push r16
  ; Habilita transmision y recepcion
  ldi r16, (1<<RXEN0)|(1<<TXEN0)|(0<<UCSZ02)
  sts UCSR0B, r16
  ; Setea data frame de 8 bits y un bit de stop
  ldi r16, (1<<UCSZ01)|(1<<UCSZ00) ;
  sts UCSR0C, r16
  ; Setea baudrate
  clr r16
  sts UBRR0H, r16
  ldi r16, BRATE
  sts UBRR0L, r16
	pop r16
  ret
;###############UTILIDADES######################################################
DELAY_5s:
  push r16
  push r17
  push r18
  ldi r16, 20
L3:
  ldi r18, 255
L2:
  ldi r17, 255
L1:
  dec r17
  brne L1
  dec r18
  brne L2
  dec r16
  brne L3
  pop r18
  pop r17
  pop r16
  ret
;#################################
