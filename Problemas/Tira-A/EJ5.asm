; Ejercicio A.5:
;a. ¿Cómo inicializaría el R6 en 0 con una instrucción lógica solamente?
andi r6,0

;b. ¿Cómo implementaría la función COM si esta no existiera?
;COM r0:
ldi r1, 0xFF
sub r1,r0
mov r0,r1

;c. ¿Cómo implementaría la función SWAP si esta no existiera?
;SWAP r0:
.equ MSB = r1
.equ LSB = r2
.equ mask_lsb = 0x0F    ; defino mascaras
.equ mask_hsb = 0xF0
mov LSB, r0
mov HSB, r0
andi HSB, mask_hsb
lsr HSB
lsr HSB
lsr HSB
lsr HSB
lsl LSB
lsl LSB
lsl LSB
lsl LSB
or HSB, LSB
mov r0, HSB

;d. ¿Cómo implementaría la siguiente operación: (((NOT R2 AND R0) AND R1) OR
;R3) XOR R4?
com r2
and r0, r2
and r1, r0
or r3, r1
eor r4, r3

;e. ¿Qué instrucciones pueden usarse para bits? ¿Podría explicar la sintaxis de cada una
;e indicar todas las entradas y salidas?
lsl Rd     ; logital shift left: corre un bit a la izquierda y guarda en Rd
lsr Rd     ; logital shift right: corre un bit a la derecha y guarda en Rd
rol Rd     ; lsl pero incluye al carry
ror Rd     ; lsr pero incluye al carry
asr Rd     ; le suma uno a cada bit por separado salvo al mas significativo
swap Rd    ; intercambia los nibbles del registro
sbi A, b   ; enciende el bit b del registro I/O llamado A
cbi A, b   ; apaga el bit b del registro I/O llamado A
bst Rr, b  ; carga el bit T del registro de status con Rr(b)
bld Rd, b  ; guarda el bit T del registro de status en Rd(b)
bset s     ; setea el bit s del registro de status SREG(s)
bclr s     ; pone en 0 el SREG(s)
sec        ; setea el bit de carry
clc        ; pone en cero el bit de carry
sen        ; setea el bit de negative
cln        ; pone en cero el bit de negative
sez        ; setea el bit de zero
clz        ; pone en cero el bit de zero
sei        ; setea el bit de interrumpciones
cli        ; pone en cero el bit de interrumpciones
ses        ; setea el bit de signo
cls        ; pone en cero el bit de signo
sev        ; setea el bit de overflow de complemento a 2
clv        ; pone en cero el bit de overflow de complemento a 2
set        ; setea el bit de T
clt        ; pone en cero el bit de T
seh        ; setea el bit de half carry
clh        ; pone en cero el bit de half carry
