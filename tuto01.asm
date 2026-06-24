; Tuto 01 - Hello World
;
    ORG #8000                   ; spécifie à quelle adresse on doit assembler notre programme
start
    LD HL,message
    CALL print_message
    JR $                          ; boucle infinie

    print_message
    LD A,(HL) : INC HL            ; récupérer un octet et avancer dans le tableau
    OR A : RET Z                  ; si l'octet est nul, on sort de la routine
    CALL #BB5A                  ; afficher le caractère avec le vecteur système
    JR print_message              ; et on recommence

    message DEFB 'Hello world',0

save "tuto01.bin", start, $-start