; STARTER.BIN movie switch, file $3D94, runtime $ED94.
; Word at 4(sp) is 0: save the caller's pointers, install two BIOS
; vectors, and call FilmOpen ($F336).
; Word is 1: FilmTask. Any other value: FilmClose, then restore the vectors.
; See docs/segacd_film.md.

X_ECE8	equ	$ECE8
X_ECB8	equ	$ECB8
X_F118	equ	$F118
X_F73A	equ	$F73A
X_F58C	equ	$F58C
X_F336	equ	$F336
X_F0FE	equ	$F0FE
X_ECD4	equ	$ECD4
X_ECBC	equ	$ECBC
X_ECC0	equ	$ECC0

	org	$ED94

	tst.w	$4(sp)
	bne.b	LEDF6
	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	lea.l	X_ECC0(pc),a0
	move.l	$12(a6),(a0)
	lea.l	X_ECBC(pc),a0
	move.l	$E(a6),(a0)
	lea.l	X_ECD4(pc),a0
	move.l	$22(a6),(a0)+
	move.l	$1E(a6),(a0)+
	move.l	$1A(a6),(a0)+
	move.l	$16(a6),(a0)+
	move.l	$26(a6),(a0)+
	move.l	$2A(a6),(a0)+
	movea.l	#$FF8000,a5
	ori.w	#$4,$2(a5)
	jsr	LEE64(pc)
	jsr	X_F0FE(pc)
	move.l	$A(a6),-(sp)
	jsr	X_F336(pc)
	addq.w	#$4,sp
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
LEDF6	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	move.w	$8(a6),d0
	subq.w	#$1,d0
	bne.b	LEE0C
	jsr	X_F58C(pc)
	bra.b	LEE1A
LEE0C	jsr	X_F73A(pc)
	jsr	LEE7E(pc)
	jsr	X_F118(pc)
	moveq	#$0,d0
LEE1A	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
	move.w	$0.w,d0
LEE28	addq.w	#$1,$0.w
	cmp.w	$0.w,d0
	beq.b	LEE28
	move.w	d0,$0.w
	clr.l	$8.w
	clr.l	$C.w
	clr.l	$10.w
	clr.l	$14.w
	clr.l	$18.w
	clr.l	$1C.w
	clr.l	$20.w
	clr.l	$24.w
	move.l	#$208008,$80.w
	rts
LEE60	ori.b	#$0,d0
LEE64	lea.l	LEE60(pc),a0
	move.l	$5F36.w,(a0)
	lea.l	LEE90(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
LEE7E	movea.l	LEE60(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
LEE90	movem.l	d0/a0,-(sp)
	lea.l	X_ECB8(pc),a0
	addq.l	#$1,(a0)
	move.l	X_ECE8(pc),d0
	beq.b	LEEA4
	movea.l	d0,a0
	jsr	(a0)
LEEA4	movem.l	(sp)+,d0/a0
	rts
