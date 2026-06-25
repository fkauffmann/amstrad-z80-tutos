; Tuto 07 - Détection des collisions et découverte de push/pop
;
    ORG #8000
start

    ; MODE 0
    LD A, 0
    CALL #BC0E

    ; SYMBOL REDEFINITION
    LD A,253
    LD HL, key
    CALL #BBA8    

    ; SPEEDKEY 5,3
    LD H,5
    LD L,3
    CALL #BB3F

    CALL showPlayer
    CALL showEnnemy
    CALL showKey
    CALL showBonus
gameLoop
    ; INKEY$
    CALL #BB1B      ; place le code de la touche enfoncée dans le registre A

    ; Si flèche gauche
    CP 242
    JP Z,moveLeft   ; si égalité, appelle moveLeft

    ; Si flèche droite
    CP 243
    JP Z,moveRight

    ; Si flèche haut
    CP 240
    JP Z,moveUp 

    ; Si flèche bas
    CP 241
    JP Z,moveDown

    ; FRAME
    CALL #BB19

    JP gameLoop
    RET
; ---------------------------------------------------------
showPlayer
    ; LOCATE xplayer, yplayer
    LD A, (xplayer): LD H,A
    LD A, (yplayer): LD L,A
    PUSH HL                 ; sauvegarde les coordonnées sur la pile
    CALL #BB75


    ; COPYCHR$
    CALL #BB60
    CALL C, detectCollision ; si CARRY = 1, un caractère se trouve sous le curseur

    ; LOCATE xplayer, yplayer
    POP HL
    CALL #BB75

    ; PRINT CHR$(224)
    LD A, 224
    CALL #BB5A
    RET
; ---------------------------------------------------------
removePlayer
    ; LOCATE xplayer, yplayer
    LD A, (xplayer): LD H,A
    LD A, (yplayer): LD L,A
    CALL #BB75

    ; PRINT " "
    LD A, " "
    CALL #BB5A
    RET
; ---------------------------------------------------------
moveLeft
    ; diminue xplayer si > 1
    CALL removePlayer
    LD A, (xplayer)
    CP 1
    JP Z, skipMoveLeft
    DEC A
    LD (xplayer), A
skipMoveLeft
    CALL showPlayer
    JP gameLoop
; ---------------------------------------------------------
moveRight
    ; augmente xplayer si < 20
    CALL removePlayer
    LD A, (xplayer)
    CP 20
    JP Z,skipMoveRight
    INC A
    LD (xplayer), A
skipMoveRight
    CALL showPlayer
    JP gameLoop
; ---------------------------------------------------------
moveUp
    ; diminue yplayer si > 1
    CALL removePlayer
    LD A, (yplayer)
    CP 1
    JP Z, skipMoveUp
    DEC A
    LD (yplayer), A
skipMoveUp
    CALL showPlayer
    JP gameLoop
; ---------------------------------------------------------
moveDown
    ; augmente yplayer si < 25
    CALL removePlayer
    LD A, (yplayer)
    CP 25
    JP Z,skipMoveDown
    INC A
    LD (yplayer), A
skipMoveDown
    CALL showPlayer
    JP gameLoop
; ---------------------------------------------------------
showEnnemy
    ; LOCATE xennemy, yennemy
    LD A, (xennemy): LD H,A
    LD A, (yennemy): LD L,A
    CALL #BB75    
    LD A, 253

    ; PRINT CHR$(225)
    LD A, 225
    CALL #BB5A
    RET
; ---------------------------------------------------------
showBonus
    ; LOCATE
    LD A, (xbonus): LD H,A
    LD A, (ybonus): LD L,A
    CALL #BB75

    ; PRINT
    LD A, 228
    CALL #BB5A
    RET
; ---------------------------------------------------------
showKey
    ; LOCATE
    LD A, (xkey): LD H,A
    LD A, (ykey): LD L,A
    CALL #BB75

    ; PRINT
    LD A, 253
    CALL #BB5A
    RET
; ---------------------------------------------------------
detectCollision
    ; Le registre A contient le code ASCII du caractère
    ; sous le curseur
    CP 225                      ; si enemmi, le flag Z du registre F contient 1 
    CALL Z, showCollision   

    CP 228                      ; bonus
    CALL Z, showCollision

    CP 253                      ; clé
    CALL Z, showCollision

    RET
; ---------------------------------------------------------
showCollision
    PUSH AF                     ; sauvegarde A qui est écrasé par CALL #BB75

    ; LOCATE 1,1
    LD H,1
    LD L,1
    CALL #BB75

    POP AF                      ; restaure A

    ; PRINT caractère détecté par detectCollision
    CALL #BB5A  
    RET
; ---------------------------------------------------------

xplayer DB 10
yplayer DB 12

xennemy DB 15
yennemy DB 10

xbonus DB 5
ybonus DB 5

xkey DB 15
ykey DB 5

key DB 0,64,160,191,165,69,0,0

save "tuto07.bin", start, $-start