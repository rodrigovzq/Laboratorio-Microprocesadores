DELAY_10s:
  push r16
  push r17
  push r18
  push r19
  ldi r19, 4
L4:
  ldi r16, 205
L3:
  ldi r18, 255
L2:
  ldi r17, 255
L1:
  dec r17
  brne L1
  dec r18
  brne L2
  dec r16
  brne L3
  dec r19
  brne L4
  pop r19
  pop r18
  pop r17
  pop r16
  ret
