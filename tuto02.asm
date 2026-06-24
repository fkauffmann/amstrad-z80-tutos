; Tuto 02 - Changer le mode d'écran
;
; https://www.youtube.com/watch?v=5CLGTqo_-y0&list=PLnpak17jeo9fDUE1zZSxsDkCAX6H-ejhp

    ORG #8000
start:
    LD      A, 2                ; met 2 dans le registre A    
    CALL    #BC0E             ; change de mode écran

    RET 

save "tuto02.bin", start, $-start