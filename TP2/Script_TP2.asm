.include "m328Pdef.inc"
.org $00
;#################################
;Seteo de hardware
.equ LED_PIN = 3  ;conecto led en PB3
.equ BTN_PIN = 2  ; conecto boton en PD2
sbi DDRB, LED_PIN ; declaro a PB3 como salida
cbi DDRD, BTN_PIN ; declaro a PD2 como entrada
;#################################
;Inizializador de stack
stack_ini:
ldi r16, HIGH(RAMEND)
out SPH, r16
ldi r16, LOW(RAMEND)
out spl, r16        ;inicializa el stack al fondo de la memoria
clr r16
;#################################
;runtinas de chequeo del boton
check_press:
  sbis PIND, BTN_PIN
  rjmp check_press
  call turnon_led
  rjmp check_release
check_release:
  sbic PIND, BTN_PIN
  rjmp check_release
  call turnoff_led
  rjmp check_press
;#################################
;rutinas de encendido y apagado del LED
turnon_led:
  sbi PORTB, LED_PIN
  call delay
  ret
turnoff_led:
  cbi PORTB, LED_PIN
  call delay
  ret
;;#################################
;DELAY de 10ms
delay:
  ldi r18, 209
L2:
  ldi r17, 255
L1:
  dec r17
  brne L1
  dec r18
  brne L2
  ret
