#!/bin/bash
echo "Nombre del archivo asm sin extension"
read archivo
avra $archivo.asm
avrdude -p m328p -c stk500v1 -b 115200 -F  -P /dev/cu.wchusbserial1410 -U flash:w:$archivo.hex
