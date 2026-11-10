;	MAIN.BIN $34B8-$35A7 (runtime $FF34B8-$FF35A7).
;
;	The Sierra C run-time helpers after maintext.asm: 32-bit multiply and the divide / modulo
;	entries with their jump table (the same code as STARTER.BIN crt.asm).


	org	$FF34B8

DoDrawTextCommand
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.LFF34CC(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.LFF34CC
	bra.s	.LFF34D4
	dc.w	$4C41
	dc.w	$0801
	rts
.LFF34D4
	jsr	.LFF34FA(pc)
	move.l	d1,d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.LFF34F0(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.LFF34F0
	bra.s	.LFF34FA
	dc.w	$4C41
	dc.w	$0801
	dc.w	$C340
	rts
.LFF34FA
	tst.l	d0
	bmi.s	.LFF3512
	tst.l	d1
	bmi.s	.LFF3508
	jsr	.LFF354A(pc)
	rts
.LFF3508
	neg.l	d1
	jsr	.LFF354A(pc)
	neg.l	d1
	rts
.LFF3512
	neg.l	d0
	tst.l	d1
	bmi.s	.LFF3522
	jsr	.LFF354A(pc)
	neg.l	d0
	neg.l	d1
	rts
.LFF3522
	neg.l	d1
	jsr	.LFF354A(pc)
	neg.l	d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.LFF3540(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.LFF3540
	bra.s	.LFF354A
	dc.w	$4C41
	dc.w	$0001,$C340
	rts
.LFF354A
	move.w	d1,-(sp)
	swap	d1
	tst.w	d1
	bne.s	.LFF356E
	move.l	d0,d1
	clr.w	d1
	swap	d1
	beq.s	.LFF3564
	divu.w	(sp),d1
	swap	d1
	swap	d0
	move.w	d1,d0
	swap	d0
.LFF3564
	divu.w	(sp)+,d0
	move.w	d0,d1
	dc.b	'B@H@Nu'
.LFF356E
	swap	d1
	move.w	d2,(sp)
	move.l	d3,-(sp)
	move.w	d0,d2
	move.l	d1,d3
	moveq	#$1,d1
	clr.w	d0
	swap	d0
	bne.s	.LFF358C
	swap	d0
	move.w	d2,d0
	moveq	#$0,d1
	bra.s	.LFF359E
.LFF3588
	add.w	d1,d1
	bcs.s	.LFF359E
.LFF358C
	add.w	d2,d2
	addx.l	d0,d0
	cmp.l	d3,d0
	bcs.s	.LFF3588
	sub.l	d3,d0
	add.w	d1,d1
	bset	#$0,d1
	bcc.s	.LFF358C
.LFF359E
	move.l	(sp)+,d3
	move.w	(sp)+,d2
	rts
	ori.b	#$0,d0
