; Tuto 04 - Placer et redéfinir des caractères
;
    ORG #8000
start

    LD A, 1                     ; mode 1
    CALL #BC0E

    ; redéfinit un caractère
    LD A,240                    ; numéro du caractère à modifier
    LD HL, newchar
    CALL #BBA8

    ; locate en position xcenter, ycenter
    LD A, (xcenter): LD H, A
    LD A, (ycenter): LD L, A
    CALL #BB75

    ; affiche la maison
    LD A, 240
    CALL #BB5A


    ; exercice: afficher une ligne de maisons en 1ère ligne
 loop
    ; locate
    LD A, (counter)
    LD H, A
    LD L, 1
    CALL #BB75

    ; incrémente le compteur
    LD A, (counter)
    INC A
    LD (counter), A

    ; affiche le caractère
    LD A, 240
    CALL #BB5A

    ; compare le compteur à 40
    LD A, (counter)
    CP 40
    RET Z
    JP loop

    RET                         ; rend la main

counter DB 01
xcenter DB 20
ycenter DB 12
newchar DB 24,36,66,129,145,145,145,255

save "tuto04.bin", start, $-start