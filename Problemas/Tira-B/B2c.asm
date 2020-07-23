;Cuando el Ingeniero de Procesos se enteró de todas las restricciones nos pidió
;que el sistema genere una señal READY a los procesos anteriores para avisarles
;cuándo pueden descargar en el mezclador y cuándo no. Para esta señal podría
;usarse PORTA.0. ¿Cómo cambia ahora?
;agregue funciones de READY y NOT_READY

.include "./m328Pdef.inc"
.org 0
.equ H_READ=0x100
.equ H_WARN=220
.equ H_MAX=200
.equ H_MIN=50
.equ MOTOR_OUT=0x108
.equ MOTOR_ALARM=0x116

DELAY:
    ;toma valor de r19 en minutos
LOOP4:
    ldi r18, 188
LOOP3:                ; repite LOOP2 188 veces = 59.877 s
    ldi r17, 255
LOOP2:           ; repite LOOP1 por 255 veces x 1249us= 318.495 ms
    ldi r16, 250
LOOP1:           ; (5x250)-1 =1249us
    nop
    nop
    dec r16
    brne LOOP1
    dec r17
    brne LOOP2
    dec r18
    brne LOOP3
    dec r19
    brne LOOP4
    ret
START:
    lds r20, H_READ
    cpi r20, H_WARN
    brsh ALARMA             ;if c==0
    cpi r20, H_MAX
    brsh APAGAR_MOTOR        ;if c==0
    cpi r20, H_MIN
    brsh MEZCLAR
    call APAGAR_MOTOR
    rjmp START


ALARMA:
    call NOT_READY
    sts MOTOR_ALARM,1
    sts MOTOR_OUT, 0
    ldi r19, 10
    call DELAY
    call READY
    ret

MEZCLAR:
    call NOT_READY
    sts MOTOR_ALARM,0
    sts MOTOR_OUT,1
    ldi r19, 5
    call DELAY
    call READY
    ret

APAGAR_MOTOR:
    call NOT_READY
    sts MOTOR_ALARM, 0
    sts MOTOR_OUT, 0
    ldi r19, 10
    call DELAY
    call READY
    ret

READY:
    ldi r21,1
    out porta,r21
    ret
NOT_READY:
    ldi r21,0
    out porta,r21
    ret
