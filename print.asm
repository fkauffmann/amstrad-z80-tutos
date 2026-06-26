PrintChar       equ &BB5A
    org &8000

Start:
    ld hl, Message
    call PrintString

    call NewLine

    ld hl, Message    
    call PrintString
    ret

NewLine:
    ld a, 13            ;Carriage return
    call PrintChar
    ld a, 10            ;Line feed
    call PrintChar
    ret

PrintString:
    ld a, (hl)
    cp 255
    ret z
    inc hl
    call PrintChar
    jr PrintString
    ret

Message db 'Hello World', 255

save "print.bin", Start, $-Start