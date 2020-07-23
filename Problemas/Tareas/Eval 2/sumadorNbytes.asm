
ld r22, X+
ld r23, Y+
adc r22, r23
sumador:
  ld r22, X+
  ld r23, Y+
  adc r22, r23
  st Y, r22
  dec r16
  brne sumador
