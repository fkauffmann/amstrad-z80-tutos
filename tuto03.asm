; Tuto 03 - Afficher du texte
;
    ORG #8000
start

    ; afficher un caractère
    LD      A, 45               ; code ASCII du caractère "-" à afficher
    CALL    #BB5A./
    LD      A, ">"              ; ou bien, directement le caractère
    CALL    #BB5A

    ; afficher un texte
    LD      HL, message         ; charge l'adresse du MESSAGE dans HL
print_message
    LD      A, (HL)             ; charge dans A la valeur pointée par HL
    CP      0                   ; compare A avec 0

    RET     Z                   ; sort si flag Z à 1 (CP a levé une égalité)
    CALL    #BB5A
    INC     HL                  ; avance au byte suivant du message
    JP     print_message        ; recommence la boucle

    RET                         ; rend la main

message DB "HELLO Z80 WORLD", 0

save "tuto03.bin", start, $-start