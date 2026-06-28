; Tuto 12 - Déplacement d'un caractère joueur 
; Version directement exécutable (utiliser ./run.sh)
;
    ORG &200
    RUN &200
start
    ; MODE 0
    LD A, 0
    CALL &BC0E

    ; SPEEDKEY 5,3
    LD H,5
    LD L,3
    CALL &BB3F

    CALL showPlayer
gameLoop
    ; INKEY$
    CALL &BB1B      ; place le code de la touche enfoncée dans le registre A

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
    CALL &BB19

    JP gameLoop
    RET

showPlayer
    ; LOCATE xplayer, yplayer
    LD A, (xplayer): LD H,A
    LD A, (yplayer): LD L,A
    CALL &BB75

    ; PRINT CHR$(224)
    LD A, 224
    CALL &BB5A
    RET

removePlayer
    ; LOCATE xplayer, yplayer
    LD A, (xplayer): LD H,A
    LD A, (yplayer): LD L,A
    CALL &BB75

    ; PRINT " "
    LD A, " "
    CALL &BB5A
    RET

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

xplayer DB 10
yplayer DB 12

save "tuto12.bin", start, $-start, AMSDOS