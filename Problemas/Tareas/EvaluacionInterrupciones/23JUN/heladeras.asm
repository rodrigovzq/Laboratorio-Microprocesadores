.include "m328Pdef.inc"

.equ temp_min = 7
.equ temp_max = 9
.equ mask_tempa = 0b00001111
.equ mask_tempb = 0b11110000
.def TEMPA = r17
.def TEMPB = r18
.org 0
  rjmp Reset
.org INT0addr
  rjmp Luz_A
.org INT1addr
  rjmp Luz_B

Reset:
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  call INIT_HARDW
  call INIT_INT
main:
  call turnoff_lights
  call read_temp_A
  call read_temp_B
  cpi TEMPA, temp_min ; if TEMPA< 7 
  brlt on_comp_A
  cpi TEMPB, temp_min ; if TEMPB< 7
  brlt on_comp_B
  cpi TEMPA, temp_max ; if TEMPA>= 9
  brge off_comp_A
  cpi TEMPB, temp_max ; if TEMPB>= 9
  brge off_comp_B
  jmp main
on_comp_A:  ;enciende compresor A
  sbi PORTC, PC0
  jmp main
on_comp_B:  ;enciende compresor B
  sbi PORTC, PC2
  jmp main
off_comp_A: ;apaga compresor A
  cbi PORTC, PC0
  jmp main
off_comp_B: ;apaga compresor A
  cbi PORTC, PC2
  jmp main
turnoff_lights: ;apaga las luces
  cbi PORTC, PC1
  cbi PORTC, PC3
  ret
read_temp_A:  ;lee temperatura y la ubica en TEMPA
  in r16, PORTB
  mov TEMPA, r16
  andi TEMPA, mask_tempa
  ret
read_temp_B:  ;lee temperatura y la ubica en TEMPB
  in r16, PORTB
  mov TEMPB, r16
  andi TEMPB, mask_tempb
  swap TEMPB
  ret

;######ISR######
Luz_A:
  sbi PORTC, PC1
  reti
Luz_B:
  sbi PORTC, PC3
  reti

;###############Configurar puertos##############################################
INIT_HARDW:
  ;Pone unos en las posiciones de los pines declarados
  push r16
  ldi r16, $00 ;TempB:TempA
  out DDRB, r16
  ldi r16, (1<<PC3)|(1<<PC2)|(1<<PC1)|(1<<PC0) ; LuzB,ComprB,LuzA,ComprA
  out DDRC, r16
  ldi r16, (0<<PD2)|(0<PD3) ;IntB,IntA
  out DDRD, r16
  pop r16
  ret
;###############################################################################
;##################Configurar INT###############################################
INIT_INT:
  push r16
  ;Establece que la interrupcion es por flanco asc de INT0
  ldi r16, (0<<ISC11)|(0<<ISC10)|(0<<ISC01)|(0<<ISC00) ; asumo estado bajo=puerta abierta
  sts EICRA, r16
  ;Habilita a INT0 e INT1 a ser interrupcion
  ldi r16, (1<<INT1)|(1<<INT0)
  out EIMSK, r16
  pop r16
  sei
  ret
;###############################################################################
