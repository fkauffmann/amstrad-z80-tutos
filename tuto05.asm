; Tuto 05 - Gestion des couleurs
;
    ORG #8000
start

    ; MODE 1
    LD A, 1 
    CALL #BC0E

    ; BORDER 3,6
    LD B, 3                     ; couleur 1
    LD C, 6                     ; couleur 2 
    CALL #BC38

    ; INK 0,5
    LD A, 0
    LD B, 5
    LD C, 5
    CALL #BC32

    ; INK 1,23
    LD A, 1
    LD B, 23
    LD C, 23
    CALL #BC32

    ; INK 2,25
    LD A, 2
    LD B, 25
    LD C, 25
    CALL #BC32

    ; INK 3,7
    LD A, 3
    LD B, 7
    LD C, 7
    CALL #BC32

    ; PAPER 2
    LD A,0
    CALL #BB96

    ; CLS
    CALL #BB6C

    ; PEN 1
    LD A, 2
    CALL #BB90

    ; PRINT "*"
    LD A, "*"
    CALL #BB5A

    ; PEN 1
    LD A, 1
    CALL #BB90

    RET                         ; rend la main


save "tuto05.bin", start, $-start