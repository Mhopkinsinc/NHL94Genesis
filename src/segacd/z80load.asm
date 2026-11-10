; MAIN.BIN Z80 loader, $FF86C8-$FF87B7.
; Accepts a block whose first bytes are $C3,$00, copies it to $A00000,
; and clears the eight $FFFFFFFF sound slots. See docs/segacd_film.md.

X_FF955E	equ	$FF955E
X_FF954A	equ	$FF954A
X_FF8E1E	equ	$FF8E1E
X_FF945C	equ	$FF945C
X_FF943C	equ	$FF943C
X_FF941C	equ	$FF941C
X_FF95EC	equ	$FF95EC
X_FF93B0	equ	$FF93B0
X_FF93FC	equ	$FF93FC
X_FF935C	equ	$FF935C
X_FF955A	equ	$FF955A

	org	$FF86C8

	movem.l	d1/a0-a2,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	lea.l	X_FF955A(pc),a2
	adda.l	#$4,a1
	move.l	a1,(a2)
	move.w	#$100,$A11100.l
	move.w	#$100,$A11200.l
	cmpi.b	#$C3,(a0)
	bne.b	LFF871A
	cmpi.b	#$0,$1(a0)
	bne.b	LFF871A
	move.l	a0,-(sp)
	bsr.w	X_FF935C
	bsr.w	X_FF93FC
	lea.l	$A00000.l,a1
LFF870C	move.b	(a0)+,(a1)+
	dbra	d1,LFF870C
	movea.l	(sp)+,a0
	bsr.w	X_FF93B0
	bra.b	LFF8722
LFF871A	move.w	#$6,d0
	bra.w	LFF87AC
LFF8722	move.w	#$0,$A11200.l
	move.w	#$0,$A11100.l
	move.w	#$1F4,d0
LFF8736	dbra	d0,LFF8736
	move.w	#$100,$A11200.l
	lea.l	X_FF95EC(pc),a0
	move.w	#$4,d0
LFF874A	move.l	#$FFFFFFFF,(a0)+
	dbra	d0,LFF874A
	lea.l	X_FF941C(pc),a0
	move.w	#$7,d0
LFF875C	move.l	#$FFFFFFFF,(a0)+
	dbra	d0,LFF875C
	lea.l	X_FF943C(pc),a0
	move.w	#$7,d0
LFF876E	move.l	#$0,(a0)+
	dbra	d0,LFF876E
	lea.l	X_FF945C(pc),a0
	move.w	#$7,d0
LFF8780	move.w	#$FFFF,(a0)+
	dbra	d0,LFF8780
	bsr.w	X_FF8E1E
	lea.l	X_FF954A(pc),a0
	move.w	#$7,d0
LFF8794	move.w	#$0,(a0)+
	dbra	d0,LFF8794
	lea.l	X_FF955E(pc),a0
	move.w	#$0,(a0)
	andi.b	#$FE,ccr
	clr.w	d0
	bra.b	LFF87B0
LFF87AC	ori.b	#$1,ccr
LFF87B0	move.w	(sp)+,sr
	movem.l	(sp)+,d1/a0-a2
	rts
