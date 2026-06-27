; Tuto 11 - Afficher un point en mode 1
; adresse = #C000 + largeur x (numeroLigne / 8) + (numeroLigne % 8) x #800 + colonne
;
    org #8000
Start
    ld A, 1                         ; mode 1
    call #BC0E

    ld bc,160 : ld e,100            ; en plein milieu de l'écran
    call GetPixelAddress

    ld (hl), c                      ; écrire le pixel
    jr $                            ; boucle infinie

GetPixelAddress
    ; BC=coordonnée X (0-319)
    ; E=coordonnée Y (0-199)
    ld a,e                          ; on copie le Y dans A
    srl a : srl a : srl a           ; décaler 3 fois à droite = division par 8 (résultat entre 0 et 24)
    ld h,0 : ld l,a                 ; pour multiplier par 64 on va avoir besoin d'un registre 16 bits (24 x 64 = 1536)
    ld a,e                          ; on copie à nouveau le Y dans A
    add hl,hl : add hl,hl : 
    add hl,hl : add hl,hl : ld de,hl; HL = DE = Y x 16
    add hl,hl : add hl,hl           ; HL = Y x 64
    add hl,de                       ; HL = Y x 64 + Y x 16 = Y x 80
    and 7                           ; A = Y modulo 8
    
    ; on doit multiplier le numéro de bloc par 2048 / #800
    ld d,a : ld e,0                 ; DE = A x 256
    ex hl,de                        ; permuter HL et DE
    add hl,hl : add hl,hl
    add hl,hl                       ; HL = A x 2048
    add hl,de                       ; HL = (Y % 8) x 2048 + (Y / 8) x 80
    ld a,c                          ; on sauvegarde le X avant de diviser par 4
    srl bc : srl bc                 ; diviser le X par 4 pour avoir l'octet en mode 1
    add hl,bc
    ld bc,#C000                     ; adresse de la page écran
    add hl,bc
    ld c,%10000000                  ; encre 1 pour le pixel mode 1 le plus à gauche dans l'octet
    and 3                           ; avec le modulo 4 on va savoir quel est le pixel en partant de la gauche
    jr z,.noShift
    .Shift
    srl c
    dec a
    jr nz,.Shift
    .noShift
    ret                             ; HL=adresse écran aux coordonnées X/Y données et C est le pixel d'encre 1
; ---------------------------------------------------------

save "tuto11.bin", Start, $-Start
