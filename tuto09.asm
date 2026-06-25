; Tuto 09 - Affiche un nombre entier 16 bits non-signé 
;
    ORG #8000
start
    ; MODE 1
    LD A, 1
    CALL #BC0E

    LD HL, (score)
    CALL printHL

    RET
; ---------------------------------------------------------
printHL
    LD BC, 10000
    CALL printDigit

    LD BC, 1000
    CALL printDigit

    LD BC, 100
    CALL printDigit

    LD C, 10
    CALL printDigit
    
    LD C, 1
printDigit
    LD A, '0'-1
nextChar
    INC A
    SBC HL, BC
    JR NC, nextChar ; Jump relatif si pas de retenue

    ADC HL,BC
    CALL #BB5A
    RET
; ---------------------------------------------------------
score DW 65535
; ---------------------------------------------------------

save "tuto09.bin", start, $-start
