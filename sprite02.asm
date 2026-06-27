; Affiche un sprite 48x48 en mode 1
; Le sprite est un fichier BIN raw créé à partir d'un GIF 
; en 4 couleurs en utilisant convert.sh et ABASC
;
    org #8000
Start
    call SetPalette     ; initialise la palette de couleur

PositionSprite
    ld de,160-24        ; position x du sprite
    ld hl,100+24        ; position y du sprite

    call &bc1d          ; retourne dans HL l'adresse réelle d'un 
                        ; point graphique en fonction de ses coordonnées

    ld de, sprite       ; mémoire du sprite
    ld b,48             ; hauteur du sprite en pixels

SpriteNextLine
    push hl             ; sauvegarde HL, l'adresse du pixel
    ld c,12             ; largeur du pixel en bytes = 2 bits par pixel * 48 = 96 bits / 8 = 12
SpriteNextByte
    ld a,(de)           ; charge la ligne de pixels pointée par DE
    ld (hl),a           ; envoie la ligne à l'adresse écran

    inc de              ; avance à la ligne suivante du sprite
    inc hl              ; incrémente le pointeur sur la mémoire vidéo

    dec c               ; décrémente C le compteur de ligne
    jr nz, SpriteNextByte 
    pop hl              ; restaure l'adresse du pixel en mémoire écran
    
    call &bc26          ; calcule l'adresse du pixel en dessous de celui pointé par HL
    djnz SpriteNextLine ; décrément B et remonte si pas = 0   
    
WaitKey
    call &BB06    
    ret

SetPalette
    ld a,1              ; mode 1
    CALL #BC0E

    ld b, 0             ; border 0,0
    ld c, 0
    call #bc38

    ld a, 0             ; ink 0,0
    ld b, 0
    ld c, 0
    call #bc32

    ld a, 1             ; ink 1,14
    ld b, 14
    ld c, 14
    call #bc32

    ld a, 2             ; ink 2,7
    ld b, 7
    ld c, 7
    call #bc32

    ld a, 3             ; ink 3,20
    ld b, 20
    ld c, 20
    call #bc32    

    ret
; ---------------------------------------------------------
sprite
    incbin 'akuna.bin'  ; fait 576 bytes, soit 48 ligne de 12 bytes

save "sprite02.bin", Start, $-Start
