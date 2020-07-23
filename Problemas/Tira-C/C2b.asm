.include "./m328Pdef.inc"\
.def TEMP_POS = X
.equ EOL = $FF
.def MAX_TEMP = r16
.def MIN_TEMP = r17
.def AVG_TEMP = r18
.def AMP_TEMP = r20
.def AUX = r19


call MAX
call MIN
adc AVG_TEMP, MAX_TEMP>>1 ; sumo la mitad de la maxima temperatura
adc AVG_TEMP, MIN_TEMP>>1 ; sumo la mitad de la minima temperatura
out PORTB, AVG_TEMP       ; pongo la temperatura maxima en puerto B
mov AMP_TEMP, MAX_TEMP
sub AMP_TEMP, MIN_TEMP
out PORTA, AMP_TEMP
