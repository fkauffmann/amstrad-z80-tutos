; Tuto 10 - Multiple la valeur stockée dans le registre HL par 10
; x*10 = x*8 + x*2, on peut donc additionner deux décalages binaires
;
    org #8000
Start
    ; mode 1
    ld a, 1
    call #bc0e

    ld de, (value)
    call MultiplyBy10
    call PrintInt

    ret
; ---------------------------------------------------------
PrintInt
; HL : valeur 16 bit (WORD) à afficher sur 5 digits
    ld bc, 10000
    call PrintDigit

    ld bc, 1000
    call PrintDigit

    ld bc, 100
    call PrintDigit

    ld c, 10
    call PrintDigit
    
    ld c, 1
PrintDigit
    ld a, '0'-1
    .loop
    inc a
    sbc hl, bc
    jr nc, .loop    ; Jump relatif si pas de retenue

    adc hl,bc
    call #bb5a
    ret
; ---------------------------------------------------------  
MultiplyBy10  
; DE=valeur à multiplier par 10
; Résultat dans HL
    ld hl,0
    sla de          ; DE = DE x 2
    add hl,de       ; HL = DE x 2
    sla de          ; DE = DE x 2 (donc x 4 rapport à la valeur de départ)
    sla de          ; DE = DE x 2 (donc x 8 rapport à la valeur de départ)
    add hl,de       ; HL = DE x 2 + DE x 8
    ; HL = DE x 10
    ret
; ---------------------------------------------------------
value DW 6128
; ---------------------------------------------------------

save "tuto10.bin", Start, $-Start
