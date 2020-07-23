.include "./m328Pdef.inc"
.equ CTR_ALARM = 0x101
.equ MODE_STATUS=0x200

call MODE

WATCH:
  call STATUS
  call DELAY_1s
  rjmp WATCH

MODE:
  lds r16,PWD
  lds r17,PWD+1
  cp r16,r1
  brne PASS_NOK
  cp r17, r2
  brne PASS_NOK
  call PASS_OK
  ret
PASS_NOK:
  ldi r20, 0
  sts MODE_STATUS, r20
  ret
PASS_NOK:
  ldi r20, 1
  sts MODE_STATUS, r20
  ret

.equ STATUS = 0x100
STATUS:
  lds r18, CTR_ALARM
  cpi r18,0
  brne STANDBY
  in r19, porta
  in r20, portb
  in r21, portc
  cpi r19, $FF
  brne ARMED-NOK
  cpi r20, $FF
  brne ARMED-NOK
  cpi r21, $00
  brne ARMED-NOK
  call ARMED
  ret
STANDBY:
  sts STATUS, 2
  ret
ARMED-NOK:
  sts STATUS, 1
  ret
ARMED-OK:
  sts STATUS, 0
  ret

DELAY_1s:              ;
  ldi r18, 9
LOOP3:                ; repite LOOP2 9 veces = 1,00045 s
  ldi r17, 89
LOOP2:           ; repite LOOP1 por 89 veces x 1249us= 111.16 ms
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
  ret
