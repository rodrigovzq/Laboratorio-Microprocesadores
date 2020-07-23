; Ejercicio 4

;a)
;Una central telefónica que está programada para ofrecer dos menús en cascada
;(con opciones entre 0 y 9) guarda la selección del usuario en dos registros (R20 y R21).
;Los 4 bits menos significativos (LSB) retienen la primera selección y los 4 bits más
;significativos (MSB) la segunda. ¿Qué operación debería hacer para filtrar sólo
; la primera selección en R21?

    ; Supongo que r20 y r21 tienen la misma info (ambos tienen la primera en LSB y
    ;la segunda en MSB)

.equ mask_lsb = 0x0F    ; defino mascaras
.equ mask_hsb = 0xF0
.equ first = 0x101
andi r21, mask_lsb       ; le aplico la mascara r21 y resulta un byte con los primeros 4 bits en cero
sts first, r21          ; guardo ese digito resultante en memoria

;b). ¿Qué operación debería hacer para filtrar sólo la segunda selección en el
; acumulador R20?
.equ second = 0x108
andi r20, mask_hsb       ; aplico mascara de 4 bits mas significativos y resulta un byte con los ultimos 4 bits en 0
swap r20                ; swap invierte los nibbles resultando en un byte de un digito
sts second, r20

;c)  comentado
;d) :020000020000FC
;   :0E0000005F7050930101407F429540930801CC
;   :00000001FF
