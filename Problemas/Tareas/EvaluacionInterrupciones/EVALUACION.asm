.include "m328Pdef.inc"

.org 0
  rjmp Reset
.org INT0addr
  rjmp interrupcionINT0
.org PCI0addr
  rjmp interrupcionPCI0

Reset:
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  call INIT_INT
  call INIT_PCI
  call INIT_HARDW

;######ISR######
interrupcionPCI0:

interrupcionINT0:
