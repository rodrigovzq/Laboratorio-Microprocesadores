.include "m328Pdef.inc"
.equ ram_buffer = $100
.def COUNTER = r21
.def tolower = r22
.org 0
  jmp Reset
Reset:
  ldi r16, HIGH(RAMEND)
  out SPH, r16
  ldi r16, LOW(RAMEND)
  out spl, r16        ;inicializa el stack al fondo de la memoria
  clr r16
  ldi r16, (1<<PB1) ; habilito a PB1 como salida
  out DDRB, r16
  call set_tables
  ldi tolower, 20;   cargo registro con la diferencia entre mayusculas y minus
  jmp main
set_tables:
  ldi ZH, HIGH(data<<1) ; inicia puntero Z en ROM de data
  ldi ZL, LOW(data<<1)
  ldi XH, HIGH(ram_buffer) ; inicia X en ram_buffer
  ldi XL, LOW(ram_buffer)
  ret

main:
  clr r20
read_process_loop:
  lpm r20, Z+ ; lee de rom
  cpi r20, '/'  ; chequea que no haya llegado al final
  breq done_reading ; termina si llega al final
  add r20 , tolower  ;sumarle 20 a un caracter ascii mayuscula, lo convierte en minuscula
  st X+, r20        ; guarda el caracter convertido en ram
  jmp read_process_loop ; siguiente caracter

done_reading:
  st X, r20 ; escribe el caracter de fin de cadena que quedo en r20
  ldi XH, HIGH(ram_buffer)  ; reinicia la posicion donde esta la cadena convertida
  ldi XL, LOW(ram_buffer)
  call output_array ; salida de datos
  jmp main  ; al finalizar reinicia
;### aca temrina el punto a

;## comienza punto b
output_array:
  clr r20 ; Limpio datos
output_char:
  call delay
  cpi r20, '/'  ; me fijo si el caracter leido es / y termino en caso que sea
  breq endit  ; limpio r20 para que la primera vez no de 'verdadero'
  ldi COUNTER, 8  ; inicio contador para mostrar bit a bit de a 8
  ld r20, X+  ; cargo  valor de ram = letra minuscula
  lsr r20 ; ubica al bit menos significativo en la ubicacion de PB1
  out PORTB, r20  ; salida del primer bit, el menos significativo
  dec COUNTER ; quedan 7
next_bit:
  lsl r20 ; ubica al siquiente bit en posicion de PB1
  out PORTB, r20  ; transmite siguiente bit
  dec COUNTER
  breq output_char  ; si COUNTER = 0, pasa al siguiente caracter
  jmp next_bit

endit:
  ret

delay:  ;asumo clock de 16MHz
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
data:
  ; .db "EJEMPLO\"
  ;aca va a estar la informacion
