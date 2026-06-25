#!/bin/sh
clear

ASM=tuto09
LDR=loader
DSK=z80tutos

./../../rasm/rasm.exe $ASM.asm

if [ -f "$ASM.bin" ]; then
    iDSK $DSK.dsk -n
    iDSK $DSK.dsk -t 0 -i $LDR.bas -f
    iDSK $DSK.dsk -t 1 -i $ASM.bin -f
    
    rm -f $ASM.bin
    
    caprice32.launcher $DSK.dsk --autocmd=run\"loader
else
    echo "❌ Compilation failed"
fi