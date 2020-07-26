.include "m328Pdef.inc"

.equ temp_min = 7
.equ temp_max = 9
.equ mask_tempa = 0b00001111
.equ mask_tempb = 0b11110000
.def TEMPA = r17
.def TEMPB = r18

.org 0
  jmp Reset
.org INT0addr
  jmp Luz_A
.org INT1addr
  jmp Luz_B

Reset:
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  call INIT_HARDW
  call INIT_INT
  jmp main

;###############################################################################

main:
  in r16, PINB
  mov TEMPA, r16
  andi TEMPA, mask_tempa
  mov TEMPB, r16
  andi TEMPB, mask_tempb
  swap TEMPB  ; Aca termina la lectura
check_lower_A:
  cpi TEMPA, temp_min
  brlo turnoff_A
check_higher_A:
  cpi TEMPA, temp_max
  breq turnon_A
check_lower_B:
  cpi TEMPB, temp_min
  breq turnoff_B
check_higher_B:
  cpi TEMPB, temp_max
  breq turnon_A
  jmp main

turnoff_A:
  cbi PORTC, PC0
  jmp check_higher_A
turnon_A:
  sbi PORTC, PC0
  jmp check_lower_B
turnoff_B:
  cbi PORTC, PC2
  jmp check_higher_B
turnon_B:
  sbi PORTC, PC2
  jmp main


#############Interrupt Service Routines#######################################
Luz_A:
  sbis PIND, PD2 ; si pulsador de luz A esta encendido (normalmente encendido)
  jmp turnon_LA
  jmp turnoff_LA

turnon_LA:
  debounceH_A:
    call DELAY_1ms
    sbis PIND, PD2
    reti
  on_LA:
    sbi PORTC, PC1
    reti

turnoff_LA:
  debounceL_A:
    call DELAY_1ms
    sbic PIND, PD2
    reti
  off_LA:
    cbi PORTC, PC1
    reti


Luz_B:
  sbis PIND, PD3 ; si pulsador de luz A esta encendido (normalmente encendido)
  jmp turnon_LB
  jmp turnoff_LB

turnon_LB:
  debounceH_B:
    call DELAY_1ms
    sbis PIND, PD3
    reti
  on_LB:
    sbi PORTC, PC3
    reti

turnoff_LB:
  debounceL_B:
    call DELAY_1ms
    sbic PIND, PD3
    reti
  off_LB:
    cbi PORTC, PC3
    reti

###############################################################################
#############CONFIGURATION######################################################
INIT_HARDW:
  push r16
  ldi r16, $00
  out DDRB, r16;  Defino PORTB (sensores temperatura) como entradas
  ldi r16, (1<<PC0)|(1<<PC2)|(1<<PC1)|(1<<PC3)
  out DDRC, r16; Defino compresor y luminarias como salida
  ldi r16, (1<<PD2)|(1<<PD3)
  out DDRD, r16;  Defino a los pulsadores como entrada
  pop r16
  ret
INIT_INT:
  push r16
  ;Establece que la interrupcion es algun flanco
  ldi r16, (0<<ISC11)|(1<<ISC10)|(0<<ISC01)|(1<<ISC00)
  sts EICRA, r16
  ;Habilita a INT0 e INT1 a ser interrupcion
  ldi r16, (1<<INT1)|(1<<INT0)
  out EIMSK, r16
  pop r16
  sei
  ret
###############################################################################
;;#################DELAYS###########################
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
;;#################################
