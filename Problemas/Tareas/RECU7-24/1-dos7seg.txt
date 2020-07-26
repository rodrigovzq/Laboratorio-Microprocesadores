.include "m328Pdef.inc"

.equ DDR_BCD = DDRB
.equ BCD_PORT = PINB
.equ input_mask = 0b00001111
.equ DISPLAY_DDR = DDRD
.equ DISPLAY_PORT = PORTD
.def UNI = r20
.def DEC = r21
.def AUX = r22
.def 7S_OUTPUT = r23
.equ ERROR_DISPLAY = 15 ; 'E' en 7seg codificado en BCD


.org 0
  jmp Reset
.org INT0addr
  jmp Re_Unidad
.org INT1addr
  jmp Re_Decena

Reset:
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  call INIT_HARDW
  call INIT_INT
  jmp main

main:
  ldi UNI, 0
  ldi DEC, 0
  cbi DISPLAY_PORT, PB4 ; apaga display unidades
  cbi DISPLAY_PORT, PB5 ; apaga display decenas
refresh:
  mov AUX, UNI        ; la interrupcion carga a UNI
  call BCDto7seg      ; conversion unidades (carga 7S_OUTPUT)
  call Output_Display ; muestra el dato por puerto (usa 7S_OUTPUT)
  sbi DISPLAY_PORT, PB4 ; habilita display
  call delay            ; lo mantiene encendido por un tiempo
  cbi DISPLAY_PORT, PB4 ; apaga el display
  mov AUX, DEC          ; la interrupcion carga a DEC
  call BCDto7seg          ; conversion decenas (carga 7S_OUTPUT)
  call Output_Display     ; muestra decenas por display (usa 7S_OUTPUT)
  sbi DISPLAY_PORT, PB5   ; habilita el display
  call delay              ; lo mantiene encendido por un tiempo
  cbi DISPLAY_PORT, PB5   ; apaga el display
  jmp refresh



; como la conversion usa un registro comun, antes de llamar a la subrutina copio
; el dato que quiero convertir (UNI o DEC) para reutilizar la rutina
BCDto7seg:
  push AUX
  ldi ZL, LOW(table<<1) ;inicializa en puntero Z en la posicion de tabla conversion
  ldi ZH, HIGH(table<<1)
  add ZL, AUX  ;se ubica al puntero Z en la posicion leida
  clr AUX
  adc ZH, AUX
  lpm 7S_OUTPUT, Z  ; se carga al registro con el dato de la tabla (conversion)
  pop AUX
  ret
Output_Display:
  com 7S_OUTPUT ; cambio uno por ceros para que sea compatible con display anodo comun
  out DISPLAY_PORT, 7S_OUTPUT
  ret
delay:
  push r17
  push r18
  ldi r18, 94
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
;###############################################################################
;##############RUTINAS DE INTERRUPCION###########################################
Re_Unidad:
  in UNI, BCD_PORT
  andi UNI, input_mask
  cpi UNI, 9
  brge UNI_out_of_range ; si la lectura > 9, muestra caracter de error en el display
  reti  ; la interrupcion termina con el nuevo dato en UNI
Re_Decena:
  in DEC, BCD_PORT
  andi DEC, input_mask
  cpi DEC, 9
  brge DEC_out_of_range ; si la lectura > 9, muestra caracter de error en el display
  reti  ; la interrupcion termina con el nuevo dato en DEC

UNI_out_of_range:
  ldi UNI, ERROR_DISPLAY
  reti
DEC_out_of_range:
  ldi DEC, ERROR_DISPLAY
  reti
;#############CONFIGURACION######################################################
INIT_HARDW:
  push r16
  ldi r16, 0b11110000;Defino PORTB=dato BCD con entradas en los primeros 4 bits
  out DDR_BCD, r16;  defino los bits PB4 y PB5 como salidas de habilitacion de display
  ldi r16, $FF
  out DISPLAY_DDR, r16;  Defino al puerto de display como salida
  ret
INIT_INT:
  push r16
  ;Establece que la interrupcion es flanco ascendente
  ldi r16, (1<<ISC11)|(1<<ISC10)|(1<<ISC01)|(1<<ISC00)
  sts EICRA, r16
  ;Habilita a INT0 e INT1 a ser interrupcion
  ldi r16, (1<<INT1)|(1<<INT0)
  out EIMSK, r16
  pop r16
  sei ;  Habilitacion global de interrupcion

  ret
;###############################################################################
;;###################TABLA BCD A 7SEG########################
table:
  .db 0b01111110, 0b00110000, 0b01101101, 0b01111001
  ;       0     ,     1     ,     2     ,     3
  .db 0b00110011, 0b01011011, 0b01011111, 0b01110000
  ;       4     ,      5     ,     6     ,     7
  .db 0b01111111, 0b01111011, 0b01110111, 0b01111100
  ;        8     ,     9     ,     A     ,     B
  .db 0b00111001, 0b01011110, 0b01111001, 0b01110001
  ;        C     ,     D     ,     E     ,     F
;;############################################################
