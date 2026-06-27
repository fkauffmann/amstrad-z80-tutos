; Affiche un sprite 8x8 en mode 1    
; Voir readme.md pour l'organisation de la mémoire écran et l'interlacement des couleurs
;
    org #8000
Start
    ld a,1          ; mode 1
    CALL #BC0E

    ld de,156       ; position x du sprite
    ld hl,104       ; position y du sprite

    call &bc1d      ; retourne dans HL l'adresse réelle d'un 
                    ; point graphique en fonction de ses coordonnées

    ld de, sprite   ; mémoire du sprite
    ld b,8          ; nombre de lignes

ShowSprite
    push hl         ; sauvegarde HL, l'adresse du pixel
    ld a,(de)       ; charge la ligne de pixels pointée par DE
    ld (hl),a       ; envoie la ligne à l'adresse écran

    inc de          ; avance à la ligne suivante du sprite
    inc hl          ; incrémente le pointeur sur la mémoire vidéo
    ld a,(de)
    ld (hl),a       ; recopie la ligne du sprite 
    inc de
    inc hl
    pop hl
    
    call &bc26      ; calcule l'adresse du pixel en dessous de celui pointé par HL
    djnz ShowSprite ; décrément B et remonte si pas = 0   
    ret


; ---------------------------------------------------------
sprite
    db %00110000,%11000000
    db %01110000,%11100000
    db %11110010,%11110100
    db %11110000,%11110000
    db %11110000,%11110000
    db %11010010,%10110100
    db %01100001,%01101000
    db %00110000,%11000000

save "sprite01.bin", Start, $-Start
