CMASK EQU &B6A3         ;   color mask (MODE 0)
ORG &7000

; ------------------------------------------------------------
; ENTRY
; ------------------------------------------------------------
start
    cp 4
    jr z, okk
    ret                 ; 4 paramètres uniquement

okk
    di

    ; sauvegarde SP pour restauration
    ld hl, 0
    add hl, sp
    ld (exith+1), hl

; ------------------------------------------------------------
; LOAD PARAMETERS
; ------------------------------------------------------------
    ld l, (ix+6) : ld h, (ix+7) : ld (x1+1), hl   ; x1
    ld e, (ix+4) : ld d, (ix+5) : ld (y1+1), de   ; y1
    ld l, (ix+2) : ld h, (ix+3) : ld (x2+1), hl   ; x2
    ld l, (ix+0) : ld h, (ix+1) : ld (y2+1), hl   ; y2

; ------------------------------------------------------------
; DY = y2 - y1 (ABS + signed version)
; ------------------------------------------------------------
    or a
    sbc hl, de              ; HL = y2 - y1

    bit 7, h
    jr z, gnp0

    ; ABS(HL)
    xor a
    sub l : ld l, a
    sbc a, a
    sub h : ld h, a

gnp0:
    ld (dy+1), hl           ; DY = ABS

    ; HL = -DY / 2 (er initial)
    ld a, h
    cpl : ld h, a
    ld a, l
    cpl : ld l, a
    inc hl

    srl h : rr l
    set 7, h
    ld (er+1), hl

; ------------------------------------------------------------
; SY = direction Y
; ------------------------------------------------------------
    ex de, hl
    ld de, (y2+1)
    or a
    sbc hl, de

    ld a, &34
    jr c, $+4
    ld a, &35
    ld (sy), a

; ------------------------------------------------------------
; DX = x2 - x1
; ------------------------------------------------------------
    ld de, (x1+1)
    ld hl, (x2+1)
    or a
    sbc hl, de

    bit 7, h
    jr z, gnp1

    ; ABS(DX)
    xor a
    sub l : ld l, a
    sbc a, a
    sub h : ld h, a

gnp1:
    ld sp, hl
    ld b, h
    ld c, l                 ; BC = DX (stack trick)

; ------------------------------------------------------------
; SX = direction X
; ------------------------------------------------------------
    ex de, hl
    ld de, (x2+1)
    or a
    sbc hl, de

    ld a, &34
    jr c, $+4
    ld a, &35
    ld (sx), a

; ------------------------------------------------------------
; ER INITIALISATION
; ------------------------------------------------------------
    ld h, b
    ld l, c
    ld de, (dy+1)
    or a
    sbc hl, de

    jr c, nex0

    ld h, b
    ld l, c
    srl h : rr l
    ld (er+1), hl

nex0:

; ------------------------------------------------------------
; MAIN LOOP
; ------------------------------------------------------------
DRLOOP:

x1  ld de, 1
y1  ld hl, 1

; ------------------------------------------------------------
; FAST PLOT MODE 0
; ------------------------------------------------------------
FPLOT:
    ld a, l
    and %00000111
    ld h, a
    xor l
    ld l, a

    ld c, a
    ld b, &60

    add hl, hl
    add hl, hl
    add hl, bc
    add hl, hl

    srl e
    ld c, %10101010
    jr nc, NSHIFT
SHIFT:
    ld c, %01010101

NSHIFT:
    add hl, de
    ld a, (CMASK)
    xor (hl)
    and c
    xor (hl)
    ld (hl), a

; ------------------------------------------------------------
; END CONDITION
; ------------------------------------------------------------
    ld hl, (x1+1)
x2  ld de, 0
    or a
    sbc hl, de
    jr nz, nex1

    ld hl, (y1+1)
y2  ld de, 0
    or a
    sbc hl, de
    jr z, exith

nex1:

; ------------------------------------------------------------
; BRESENHAM CORE
; ------------------------------------------------------------
er  ld hl, 0
    ld b, h
    ld c, l

dy  ld de, 0

    add hl, sp
    bit 7, h
    jr nz, nex2

    ld h, b
    ld l, c
    or a
    sbc hl, de
    ld (er+1), hl

    ld hl, x1+1
sx  DEFB 0

nex2:
    ld h, b
    ld l, c
    or a
    sbc hl, de

    bit 7, h
    jr z, nex3

    ld hl, (er+1)
    add hl, sp
    ld (er+1), hl

    ld hl, y1+1
sy  DEFB 0

nex3:
    jp DRLOOP

; ------------------------------------------------------------
; EXIT
; ------------------------------------------------------------
exith:
    ld sp, 0
    ei
    ret

save "fastdraw.bin", start, $-start