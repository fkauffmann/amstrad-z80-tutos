; memcopy : Charge deux écrans en mémoire et les affiche en alternance
;
org #1800         ; on veut mettre notre programme au début de la mémoire

Start
    ld a, 1         ; mode 1
    call #bc0e      

    ld b, 0         ; border 0,0
    ld c, 0
    call #bc38

    ld a, 0         ; ink 0,0
    ld b, 0
    ld c, 0
    call #bc32

    call SetPalette1

    ld hl,page1     ; charge l'adresse de la page 1
    ld de,#C000     ; adresse par défaut de la mémoire graphique
    ld bc,16384     ; notre écran fait la taille de la page vidéo
    ldir            ; lancer la copie de HL vers DE sur BC octets

    call WaitKey

    call SetPalette2

    ld hl,page2
    ld de,#C000     ; adresse par défaut de la mémoire graphique
    ld bc,16384     ; notre écran fait la taille de la page vidéo
    ldir            ; lancer la copie de HL vers DE sur BC octets

    call WaitKey

    jr Start        ; et on revient au début du programme

; ---------------------------------------------------------
SetPalette1
    ld a, 1         ; ink 1,13
    ld b, 24
    ld c, 24
    call #bc32

    ld a, 2         ; ink 2,26
    ld b, 26
    ld c, 26
    call #bc32
    ret
SetPalette2
    ld a, 1         ; ink 1,13
    ld b, 13
    ld c, 13
    call #bc32

    ld a, 2         ; ink 2,26
    ld b, 26
    ld c, 26
    call #bc32

    ld a, 3         ; ink 3,24
    ld b, 24
    ld c, 24
    call #bc32
    ret
WaitKey
    call &BB06
    ret
; ---------------------------------------------------------
org #2000 : page1 incbin 'screen1.scn'
org #6000 : page2 incbin 'screen2.scn'

save "scrswap.bin", Start, $-Start

