;* "div8u" - 8/8 Bit Unsigned Division
;*
;* This subroutine divides the two register variables "dividendo" (dividend) and
;* "divisor" (divisor). The result is placed in "resultado" and the remainder in
;* "resto".
;*
;* Number of words	:14
;* Number of cycles	:97
;* Low registers used	:1 (resto)
;* High registers used  :3 (resultado/dividendo,divisor,contador)
;*
;***************************************************************************

;***** Subroutine Register Variables

.def	resto	=r15		;remainder
.def	resultado	=r16		;result
.def	dividendo	=r16		;dividend
.def	divisor	=r17		;divisor
.def	contador	=r18		;loop counter

;***** Code

div8u:
  sub	resto,resto	;clear remainder and carry
	ldi	contador,9	;init loop counter
d8u_1:
  rol	dividendo		;shift left dividend
	dec	contador		;decrement counter
	brne	d8u_2		;if done
	ret			;    return
d8u_2:
  rol	resto		;shift dividend into remainder
	sub	resto,divisor	;remainder = remainder - divisor
	brcc	d8u_3		;if result negative
	add	resto,divisor	;    restore remainder
	clc			;    clear carry to be shifted into result
	rjmp	d8u_1		;else
d8u_3:
  sec			;    set carry to be shifted into result
	rjmp	d8u_1
