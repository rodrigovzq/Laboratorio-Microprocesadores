program = escalerita
test = debug
port = /dev/cu.wchusbserial1420 #1420 izquierda & 1421 derecha
device = m328p
programmer = stk500v1
baudrate= 115200


%.hex: %.asm
	avra $<
	rm *.eep.hex *.obj

all: upload
debug: upload1
upload: ${program}.hex
	avrdude -p $(device) -c $(programmer) -b $(baudrate) -F  -P $(port) -U flash:w:$<
	rm *.hex

assembly:${program}.hex
	avra $(program).asm
	rm *.eep.hex *.obj

upload1: ${test}.hex
	avrdude -p $(device) -c $(programmer) -b $(baudrate) -F  -P $(port) -U flash:w:$<
	rm *.hex

assembly1:${test}.hex
	avra $(program).asm
	rm *.eep.hex *.obj
