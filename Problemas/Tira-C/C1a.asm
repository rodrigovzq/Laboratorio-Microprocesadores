;Una empresa de seguridad está diseñando un equipo para el control de accesos.
;En los puertos PORTA y PORTB se pueden conectar hasta 16 detectores de apertura
; de puerta (P) y en el puerto PORTC hasta 8 detectores de movimiento (M).
;Los sensores P operan normalmente cerrados: generan un “1” lógico en operación
;normal y un “0” cuando se abre la puerta (o se le corta el cable).
;Los sensores M operan normalmente abiertos: generan un “0” lógico en operación
;normal y un “1” cuando se detecta movimiento. Además el usuario puede activar o
;desactivar el sistema; esta señal está almacenada en el bit 0 del dato en RAM
;denominado “CTR_ALARM”.
;El Líder del Proyecto le pide que desarrolle la rutina STATUS para determinar el
;estado del sistema: ARMED-OK (sistema activo y seguro: todos los P en “1” y M en
;“0”), ARMED- NOK (sistema activo y seguridad violada), y STAND-BY (sistema
;inhibido). ¿Cómo lo haría? ¿Cómo definiría el prototipo de función (listado de
;entradas y salidas, y tipos de datos)?

;PORTA+PORTB => P: puerta, normalmente 1
;PORTC => M: movimiento, norm 0
;CTR_ALARM es una posicion en memoria con 0 o 1 para activar o desactivar
;ARMED-OK: porta y portb con unos y portc con ceros y CTR_ALARM 1
;ARMED-NOK; CTR_ALARM 1 y lo demas violado
;STANDBY: CTR_ALARM 0

; asumo que la posicion en memoria de CRT-ALARM es declarada como constante
; devuelvo los estados guardando valores en memoria ARMED-OK => 0,
;ARMED-NOK => 1, STANDBY => 2
.include "./m328Pdef.inc"
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
