.include "m328Pdef.inc"
.equ EOL = $0F
.equ msg = $100 ;asumo una direccion
.equ MAX_LENGTH = 255
.def COUNT = r21
.def CHAR = r20

OUTPUT_TEXT:
ldi ZL, LOW(msg) ;inicializa en puntero Z en la posicion de 'msg'
ldi ZH, HIGH(msg)
clr COUNT
read:
inc COUNT
sbic PORTA, PA0 ;detecta el flanco en PA0
jmp read
ld CHAR, Z+ ; lee y carga en CHAR
out PORTB, CHAR ; sale CHAR por PORTB
cpi CHAR, EOL ; compara si CHAR es el ultimo caracter
breq end  ; si es termina
cpi COUNT, MAX_LENGTH ; compara si se llego al ultimo caracter
breq end  ; si es termina
jmp read  ; lee proximo
end:  ; si fuera una subrutina, esta etiqueta tendria un ret
jmp end
