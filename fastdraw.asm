CMASK EQU &B6A3 ;EQU &B338  change address for colormask in 464
ORG &7000
start
cp 4:jr z,okk:ret  ; 4 parameters ONLY
okk
di:ld hl,0:add hl,sp:ld (exith+1),hl  ; save SP to restore at exit..

ld l,(ix+6):ld h,(ix+7):ld (x1+1),hl  ;x1
ld e,(ix+4):ld d,(ix+5):ld (y1+1),de  ;y1
ld l,(ix+2):ld h,(ix+3):ld (x2+1),hl  ;x2
ld l,(ix+0):ld h,(ix+1):ld (y2+1),hl  ;y2
;   x1, y1 start point   0<x<159
;   x2, y2  end point    0<y<199

or a:sbc hl,de    ;  hl=y2-y1
bit 7,h:jr z,gnp0:xor a:sub l:ld l,a:sbc a,a:sub h:ld h,a     ;  ABS hl
gnp0 ld (dy+1),hl      ; =ABS(DY)
LD A,H:CPL:LD H,A:LD A,L:CPL:LD L,A:INC HL ; neg hl = -DY
srl h:rr l:set 7,h ; keep negative HL
ld (er+1),hl    ;  ER = -DY/2

ex de,hl: ld de,(y2+1) : or a:sbc hl,de   ; hl=y1-y2
ld a,&34:jr c,$+4:ld a,&35  ; sy= DEC (HL) / if y1 - y2 <0  sy= INC (HL)
ld (sy),a

ld de,(x1+1) : ld hl,(x2+1) : or a:sbc hl,de     ; hl=x2-x1
bit 7,h:jr z,gnp1:xor a:sub l:ld l,a:sbc a,a:sub h:ld h,a     ;  ABS hl
gnp1 ld sp,hl:ld b,h:ld c,l ; =ABS(DX) = BC = SP stack pointer !!!!!!

ex de,hl : ld de,(x2+1) : or a : sbc hl,de ;  HL=x1-x2
ld a,&34:jr c,$+4:ld a,&35  ; sx= DEC (HL) / if x1 - x2 <0  sx= INC (HL)
ld (sx),a

ld h,b:ld l,c ;  HL=dx
ld de,(dy+1) : or a : sbc hl,de    ; hl=dx-dy
jr c,nex0    ; if dx-dy>0 (dx>dy)  [when nc]
ld h,b:ld l,c ; HL=dx
srl h:rr l : ld (er+1),hl ; then er=dx/2

nex0

DRLOOP  ; main DRAWING loop
x1 ld de,1
y1 ld hl,1

; Fast Plot for MODE 0 by Executioner follows...
FPLOT    LD A, L            ;A = Lowbyte Y
    AND %00000111        ;isolate Bit 0..2
    LD H, A            ;= y MOD 8 to H
    XOR L            ;A = Bit 3..7 of Y
    LD L, A            ;= (Y*8 to L
    LD C, A            ;store in C
    LD B, &60        ;B = &C0\2 = Highbyte Screenstart\2
    ADD HL, HL        ;HL * 2
    ADD HL, HL        ;HL * 4
    ADD HL, BC        ;+ BC = Startaddress
    ADD HL, HL        ;of the raster line
    SRL E            ;calculate X\2, because 2 pixel per byte, Carry is X MOD 2
    LD C, %10101010            ;Bitmask for MODE 0
    JR NC, NSHIFT        ;-> = 0, no shift
SHIFT     LD C, %01010101            ;other bitmask for right pixel
NSHIFT    ADD HL, DE        ;+ HL = Screenaddress
        LD A, (CMASK)        ;get color mask
    XOR (HL)        ;XOR screenbyte
    AND C            ;AND bitmask
    XOR (HL)        ;XOR screenbyte
    LD (HL), a        ;new screenbyte

ld hl,(x1+1):x2 ld de,0:or a:sbc hl,de:jr nz,nex1  ; CHECK if we reach the end???
ld hl,(y1+1):y2 ld de,0:or a:sbc hl,de:jr z,exith  ; if x1=x2 and y1=y2 then exit!!

nex1

er ld hl,0 :ld b,h:ld c,l     ; HL=ER=E2=BC
dy ld de,0   ; DE= DY
add hl,sp    ; SP=DX
bit 7,h:jr nz,nex2    ; IF  E2+DX > 0  THEN ER = ER - DY
ld h,b:ld l,c:or a:sbc hl,de:ld (er+1),hl  ; er = er -dy
ld hl,x1+1:sx DEFB 0        ; X1 = X1 + SX

nex2
ld h,b:ld l,c  ; HL=E2   DE=dy
or a:sbc hl,de      ; IF E2 - DY < 0 THEN ER = ER + DX
bit 7,h:jr z,nex3
ld hl,(er+1)  :add hl,sp    ; SP=DX
ld (er+1),hl         ; er = er+dx
ld hl,y1+1:sy DEFB 0             ; Y1 = Y1 + SY

nex3 JP DRLOOP

exith
ld sp,0:ei:ret  ; finished OK
save "fastdraw.bin", start, $-start