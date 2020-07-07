#program = Script_TP5_FR

port = /dev/cu.wchusbserial1420 #1420 izquierda & 1421 derecha
device = m328p
programmer = stk500v1
baudrate= 115200


%.hex: %.asm
	avra $<
	rm *.eep.hex *.obj
	
SC: upload1
FR: upload2
intSC: upload3
intFR: upload4



upload1: Script_TP5_SC.hex
		avrdude -p $(device) -c $(programmer) -b $(baudrate) -F  -P $(port) -U flash:w:$<
		rm *.hex
upload2: Script_TP5_FR.hex
		avrdude -p $(device) -c $(programmer) -b $(baudrate) -F  -P $(port) -U flash:w:$<
		rm *.hex
upload3: Script_TP5_intSC.hex
		avrdude -p $(device) -c $(programmer) -b $(baudrate) -F  -P $(port) -U flash:w:$<
		rm *.hex
upload4: Script_TP5_intFR.hex
		avrdude -p $(device) -c $(programmer) -b $(baudrate) -F  -P $(port) -U flash:w:$<
		rm *.hex
assemblySC:Script_TP5_SC.hex
	avra Script_TP5_SC.asm
	rm *.eep.hex *.obj
assemblyFR:Script_TP5_FR.hex
	avra Script_TP5_FR.asm
	rm *.eep.hex *.obj
assemblyintSC:Script_TP5_intSC.hex
	avra Script_TP5_intSC.asm
	rm *.eep.hex *.obj
assemblyintFR:Script_TP5_intFR.hex
	avra Script_TP5_intFR.asm
	rm *.eep.hex *.obj
