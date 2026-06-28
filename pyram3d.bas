10 ' PYRAMIDE 3D - 100% ENTIERS (VIRGULE FIXE)
20 ' Echelles : monde x64, sinus x64, vue x8
30 ' Fleches G/D : translation laterale
40 ' Fleches H/B : avancer / reculer
50 ' W / S : monter / descendre
60 ' A / D : pivoter le regard
65 MEMORY &8FFF
70 LOAD "FASTDRAW.BIN", &9000
80 MODE 0:ORIGIN 320,200
90 DIM X%(4),Y%(4),Z%(4),PX%(4),PY%(4),OX%(4),OY%(4),E%(7,1),S%(63)
100 ' ---- TABLE DE SINUS ENTIERE (sin x 64), 64 pas = 1 tour ----
110 FOR I%=0 TO 63:READ S%(I%):NEXT
120 FOR I%=0 TO 4:READ X%(I%),Y%(I%),Z%(I%):NEXT
130 FOR I%=0 TO 7:READ E%(I%,0),E%(I%,1):NEXT
140 CX%=0:CZ%=-512:H%=64:A%=0:F%=0
150 M%=1 ' premiere image : forcer le dessin
160 ' ---- BOUCLE PRINCIPALE ----
170 ' cosinus = sinus decale d'un quart de tour
180 SA%=S%(A%):CA%=S%((A%+16) MOD 64)
190 ' translations : pas de 16 (= 0.25 unite monde)
200 IF INKEY(8)<>-1 THEN CX%=CX%-CA%\4:CZ%=CZ%+SA%\4:M%=1
210 IF INKEY(1)<>-1 THEN CX%=CX%+CA%\4:CZ%=CZ%-SA%\4:M%=1
220 IF INKEY(0)<>-1 THEN CX%=CX%+SA%\4:CZ%=CZ%+CA%\4:M%=1
230 IF INKEY(2)<>-1 THEN CX%=CX%-SA%\4:CZ%=CZ%-CA%\4:M%=1
240 IF INKEY(59)<>-1 THEN H%=H%+16:M%=1
250 IF INKEY(60)<>-1 THEN H%=H%-16:M%=1
260 IF INKEY(69)<>-1 THEN A%=(A%+63) MOD 64:M%=1
270 IF INKEY(61)<>-1 THEN A%=(A%+1) MOD 64:M%=1
280 ' bornes : evite tout debordement 16 bits plus loin
290 IF CX%>1600 THEN CX%=1600 ELSE IF CX%<-1600 THEN CX%=-1600
300 IF CZ%>1600 THEN CZ%=1600 ELSE IF CZ%<-1600 THEN CZ%=-1600
310 IF H%>1000 THEN H%=1000 ELSE IF H%<-1000 THEN H%=-1000
320 ' rien n'a bouge -> on ne redessine pas
330 IF M%=0 THEN 160
340 M%=0
350 ' transformation de vue + projection (tout entier)
360 FOR I%=0 TO 4
370 DX%=(X%(I%)-CX%)\8:DY%=(Y%(I%)-H%)\8:DZ%=(Z%(I%)-CZ%)\8
380 XV%=(DX%*CA%-DZ%*SA%)\64
390 ZV%=(DX%*SA%+DZ%*CA%)\64
400 IF ZV%<4 THEN ZV%=4
410 IF XV%>150 THEN XV%=150 ELSE IF XV%<-150 THEN XV%=-150
420 IF DY%>150 THEN DY%=150 ELSE IF DY%<-150 THEN DY%=-150
430 PX%(I%)=XV%*200\ZV%:PY%(I%)=DY%*200\ZV%
440 NEXT
450 ' effacer l'ancienne image (encre 0)
460 IF F%=1 THEN FOR I%=0 TO 7:MOVE OX%(E%(I%,0)),OY%(E%(I%,0)):DRAW OX%(E%(I%,1)),OY%(E%(I%,1)),0:NEXT
470 ' dessiner la nouvelle (encre 1)
480 FOR I%=0 TO 7:MOVE PX%(E%(I%,0)),PY%(E%(I%,0)):DRAW PX%(E%(I%,1)),PY%(E%(I%,1)),1:NEXT
490 FOR I%=0 TO 4:OX%(I%)=PX%(I%):OY%(I%)=PY%(I%):NEXT
500 F%=1
510 GOTO 160
520 ' ---- SINUS x64, 64 valeurs (un tour complet) ----
530 DATA 0,6,12,19,24,30,36,41,45,49,53,56,59,61,63,64
540 DATA 64,64,63,61,59,56,53,49,45,41,36,30,24,19,12,6
550 DATA 0,-6,-12,-19,-24,-30,-36,-41,-45,-49,-53,-56,-59,-61,-63,-64
560 DATA -64,-64,-63,-61,-59,-56,-53,-49,-45,-41,-36,-30,-24,-19,-12,-6
570 ' ---- PYRAMIDE BASE CARREE, echelle x64 ----
580 DATA -64,-64,-64, 64,-64,-64, 64,-64,64, -64,-64,64
590 DATA 0,64,0
600 ' ---- 8 ARETES ----
610 DATA 0,1, 1,2, 2,3, 3,0
620 DATA 0,4, 1,4, 2,4, 3,4
