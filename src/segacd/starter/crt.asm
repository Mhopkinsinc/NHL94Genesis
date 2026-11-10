;	STARTER.BIN $5304-$54F5 (runtime $26604-$267F5).
;
;	The Sierra C run-time helpers after AudioBusy: 32-bit multiply ($26604) and the divide /
;	modulo entries with their jump table. No name tags here; cdfade.asm follows.


	org	$26604

	move.l	$4(sp),d0
	move.l	$8(sp),d1
	move.l	d0,-(sp)
	mulu.w	d1,d0
	movea.l	d0,a0
	move.l	d1,d0
	mulu.w	(sp)+,d1
	clr.w	d0
	swap	d0
	beq.s	.L2661E
	mulu.w	(sp),d0
.L2661E
	addq.l	#$2,sp
	add.w	d1,d0
	swap	d0
	clr.w	d0
	add.l	a0,d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.L2663E(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.L2663E
	bra.s	.L26646
	dc.w	$4C41
	dc.w	$0801
	rts
.L26646
	jsr	.L2666C(pc)
	move.l	d1,d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.L26662(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.L26662
	bra.s	.L2666C
	dc.w	$4C41
	dc.w	$0801
	dc.w	$C340
	rts
.L2666C
	tst.l	d0
	bmi.s	.L26684
	tst.l	d1
	bmi.s	.L2667A
	jsr	.L266BC(pc)
	rts
.L2667A
	neg.l	d1
	jsr	.L266BC(pc)
	neg.l	d1
	rts
.L26684
	neg.l	d0
	tst.l	d1
	bmi.s	.L26694
	jsr	.L266BC(pc)
	neg.l	d0
	neg.l	d1
	rts
.L26694
	neg.l	d1
	jsr	.L266BC(pc)
	neg.l	d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.L266B2(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.L266B2
	bra.s	.L266BC
	dc.w	$4C41
	dc.w	$0001,$C340
	rts
.L266BC
	move.w	d1,-(sp)
	swap	d1
	tst.w	d1
	bne.s	.L266E0
	move.l	d0,d1
	clr.w	d1
	swap	d1
	beq.s	.L266D6
	divu.w	(sp),d1
	swap	d1
	swap	d0
	move.w	d1,d0
	swap	d0
.L266D6
	divu.w	(sp)+,d0
	move.w	d0,d1
	dc.b	'B@H@Nu'
.L266E0
	swap	d1
	move.w	d2,(sp)
	move.l	d3,-(sp)
	move.w	d0,d2
	move.l	d1,d3
	moveq	#$1,d1
	clr.w	d0
	swap	d0
	bne.s	.L266FE
	swap	d0
	move.w	d2,d0
	moveq	#$0,d1
	bra.s	.L26710
.L266FA
	add.w	d1,d1
	bcs.s	.L26710
.L266FE
	add.w	d2,d2
	addx.l	d0,d0
	cmp.l	d3,d0
	bcs.s	.L266FA
	sub.l	d3,d0
	add.w	d1,d1
	bset	#$0,d1
	bcc.s	.L266FE
.L26710
	move.l	(sp)+,d3
	move.w	(sp)+,d2
	rts
	bset.b	d2,(a2)
	dc.w	$0000,$48E7
	dc.w	$FFFE
	moveq	#$0,d0
	move.w	$40(sp),d2
	move.w	$42(sp),d1
	move.w	$44(sp),d0
	bmi.w	.L2675E
	move.w	d0,$10ADA.l
	cmpi.w	#$FFFF,d0
	beq.w	.L2675E
	cmpi.w	#$1,d0
	bge.w	.L2675E
	lea	$104EC.l,a0
	mulu.w	#$A,d0
	adda.l	d0,a0
	move.b	$0(a0),d0
	cmpi.b	#$2,d0
	beq.w	.L2676A
.L2675E
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),$6(sp)
	addq.l	#$6,sp
	rts
.L2676A
	tst.w	d1
	bne.w	.L267BC
	tst.w	d2
	bne.w	.L267BC
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	beq.w	.L26788
	jsr	$E488.l
.L26788
	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	$8(a0),d0
	sub.w	$6(a0),d0
	beq.w	.L267A6
	jsr	$E488.l
.L267A6
	add.w	$6(a0),d0
	move.w	d0,d3
	move.w	#$3,d0
	move.w	#$FFFF,d4
	jsr	$C4BC.l
	bra.s	.L2675E
.L267BC
	move.w	d1,d3
	move.w	d2,d4
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	beq.w	.L267D2
	jsr	$E488.l
.L267D2
	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	#$3,d0
	jsr	$C4BC.l
	bra.w	.L2675E
	dc.w	$0200,$05A9
	bclr.b	d2,$FF(a1)
	dc.w	$00FF
