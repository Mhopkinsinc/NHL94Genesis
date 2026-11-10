; MAIN.BIN $272-$4FF (runtime $FF1272-$FF14FF). Emitted by tools/emit_m68k.py.
; Word-RAM blit and VDP DMA. Continues the call at the end of maincd.asm.
; Assemble with /o oz- (see tools/segacd.json; npm run build:segacd).

X_FF151C	equ	$FF151C
X_FF169C	equ	$FF169C
X_FF210E	equ	$FF210E
X_FF2912	equ	$FF2912

	org	$FF1272

	lea.l	X_FF2912(pc),a0
	clr.l	(a0)
	movem.l	d0-d1/a0,-(sp)
	movea.l	a2,a0
	move.w	d4,d1
	asl.w	#$5,d1
	move.w	(a0)+,d0
	beq.b	LFF12B0
	bmi.b	LFF12A6
	add.w	d0,d4
	asl.w	#$4,d0
	pea.l	$FF12B0.l
	tst.l	$FF2912.l
	beq.w	LFF13D2
	movea.l	$FF2912.l,a1
	bra.w	LFF12B6
LFF12A6	andi.w	#$7FFF,d0
	add.w	d0,d4
	bsr.w	X_FF210E
LFF12B0	movem.l	(sp)+,d0-d1/a0
	rts
LFF12B6	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movem.l	d0-d4/a0-a2,-(sp)
	exg.l	d0,d1
	movea.l	a0,a2
	bsr.w	X_FF169C
	subq.w	#$1,d1
LFF12D8	moveq	#$3,d0
	move.w	(a2)+,d2
	clr.w	d3
LFF12DE	move.w	d2,d4
	andi.w	#$F,d4
	lsr.w	#$1,d4
	move.b	(a1,d4.w),d4
	btst	#$0,d2
	bne.w	LFF12F4
	lsr.w	#$4,d4
LFF12F4	andi.w	#$F,d4
	or.b	d4,d3
	ror.w	#$4,d3
	ror.w	#$4,d2
	dbra	d0,LFF12DE
	move.w	d3,(a0)
	dbra	d1,LFF12D8
	movem.l	(sp)+,d0-d4/a0-a2
	move.w	(sp)+,$23C6E8.l
	move.w	(sp)+,sr
	rts
	movem.l	d0-d1/a0-a1,-(sp)
	move.w	d1,d0
	bne.w	LFF1324
	move.w	#$100,d0
LFF1324	btst	#$0,d3
	beq.w	LFF137A
	lsr.w	#$5,d0
	subq.w	#$1,d0
LFF1330	lea.l	$20(a1),a1
	move.b	(a3)+,d1
	dbne	d0,LFF1330
	beq.w	LFF13A4
	add.w	d4,d1
	subq.w	#$1,d1
	asl.w	#$5,d1
	movea.l	#$C00000,a0
	asl.l	#$2,d1
	lsr.w	#$2,d1
	ori.w	#$4000,d1
	swap	d1
	andi.w	#$3,d1
	move.l	d1,$4(a0)
	clr.w	d1
	lea.l	-$20(a1),a1
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	dbra	d0,LFF1330
	bra.w	LFF13A4
LFF137A	lsr.w	#$1,d0
	move.w	d3,d1
	add.w	d0,d3
	add.w	d0,d3
	movea.l	a1,a0
	tst.l	$FF2912.l
	beq.w	LFF139C
	movea.l	$FF2912.l,a1
	bsr.w	LFF12B6
	bra.w	LFF13A4
LFF139C	bsr.w	LFF13D2
	bra.w	LFF13A4
LFF13A4	movem.l	(sp)+,d0-d1/a0-a1
	rts
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	moveq	#$0,d0
	bsr.w	X_FF169C
	move.w	#$3FFF,d0
	clr.l	d1
LFF13C4	move.l	d1,(a0)
	dbra	d0,LFF13C4
	move.w	(sp)+,$23C6E8.l
	rts
LFF13D2	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	bsr.w	LFF1418
	move.w	(sp)+,$23C6E8.l
	rts
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	bsr.w	LFF1406
	move.w	(sp)+,$23C6E8.l
	rts
LFF1406	lea.l	$23A450.l,a1
	move.w	(a1)+,d0
	move.w	(a1)+,d1
	movea.l	(a1)+,a0
	adda.l	#$180000,a0
LFF1418	movem.l	d2-d3/a1,-(sp)
	move.w	d0,d2
	add.w	d2,d2
	add.w	a0,d2
	bcc.w	LFF144A
	beq.w	LFF144A
	lsr.w	#$1,d2
	sub.w	d2,d0
	movem.l	d0/a0,-(sp)
	bsr.w	LFF1446
	movem.l	(sp)+,d0/a0
	add.w	d0,d0
	add.w	d0,d1
	adda.w	d0,a0
	move.w	d2,d0
	bra.w	LFF144A
LFF1446	movem.l	d2-d3/a1,-(sp)
LFF144A	lea.l	$C00004.l,a1
	cmpa.l	#$200000,a0
	blt.w	LFF1466
	cmpa.l	#$240000,a0
	bge.w	LFF1466
	addq.l	#$2,a0
LFF1466	move.w	#$8154,(a1)
	move.w	#$8F02,(a1)
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,(a1)
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,(a1)
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$FF290E.l
	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.w	$FF2910.l,(a1)
	move.w	$FF290E.l,(a1)
	bsr.w	X_FF151C
	move.w	#$8164,(a1)
	cmpa.l	#$200000,a0
	blt.w	LFF14FC
	cmpa.l	#$240000,a0
	bge.w	LFF14FC
	move.l	d3,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
	move.l	d0,(a1)
	subq.l	#$2,a0
	move.l	(a0),-$4(a1)
LFF14FC	cmpa.w	#$0,a0
