;	HOCKEY.BIN names: the sub CPU RAM map (where each cartridge variable lives on the disc) and the
;	cartridge constants the HOCKEY.BIN fragments use. tools/segacd_port.py adds to this file.

; RAM
puckx	equ	$17B80
pucky	equ	$17B94
puckvx	equ	$17BA8
puckvy	equ	$17BAA
puckvz	equ	$17BAC
puckc	equ	$17BE0
Crowdlevel	equ	$17CD2
CwdExciteLvl	equ	$17CD8
PadControlBits	equ	$17DC8
PadControlBits34	equ	$17DD6
passdir	equ	$17E2C
passReceiverPlayerNum	equ	$17E30
onetimerplayer	equ	$17EBC
onetimerclock	equ	$17EBE
onetimerflags	equ	$17EC6
gmode	equ	$17F68
sflags6	equ	$17F76
sflags8	equ	$17F7C
c1playernum	equ	$17F9E
c2playernum	equ	$17FA0
c3playernum	equ	$17FA2
c4playernum	equ	$17FA4
cont1team	equ	$17FA6
cont2team	equ	$17FA8
cont3team	equ	$17FAA
cont4team	equ	$17FAC
tmstruct	equ	$1834C
PalMode	equ	$18C20
onetimertargetx	equ	$19376
onetimertargety	equ	$19378
onetimerheight	equ	$1937A
inputjoy	equ	$1AD7A
TmpJoyPuckCarrier	equ	$1AD7C

; constants
attribute	equ	$4
facedir	equ	$54
gmclock	equ	$0
pf2aip	equ	$1
pf3onetimer	equ	$3
pfalock	equ	$5
pfgoal	equ	$7
pfjoycon	equ	$3
pflags	equ	$62
pflags2	equ	$63
pflags3	equ	$64
pfna	equ	$1
pfteam	equ	$6
pnum	equ	$66
position	equ	$34
SCnum	equ	$52
SPAcnt	equ	$5C
SPAnum	equ	$5A
SPAshotb	equ	$92E
SPAshotf	equ	$7FC
tmOneTimers	equ	$35E		;the cartridge has $35C
tmsize	equ	$366		;the cartridge has $364
tmtouch1	equ	$18
tmtouch2	equ	$1A
tmtouch3	equ	$1C
Ypos	equ	$14
