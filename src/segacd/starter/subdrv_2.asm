;	STARTER.BIN $3A8A-$3D93 (runtime $EA8A-$ED93).
;
;	The end of the sub CPU driver module, between cdcwait.asm and filmrun.asm.


X_E118	equ	$E118
X_E416	equ	$E416
X_E430	equ	$E430
X_ED94	equ	$ED94

	org	$EA8A

	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$2,$FFFF8024.w
	beq.w	.LEAA0
	bsr.w	.LEAAC
	bsr.w	.LEAD0
.LEAA0
	addq.w	#$1,$10AE0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.LEAAC
	btst.b	#$1,$10912.l
	beq.w	.LEAC6
	bsr.w	X_E430
	bset.b	#$0,$10912.l
	rts
.LEAC6
	bclr.b	#$0,$10912.l
	rts
.LEAD0
	btst.b	#$0,$10912.l
	beq.w	.LEAE0
	bsr.w	X_E416
.LEAE0
	rts
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	a1,-(sp)
	jsr	$E320.l
	dc.w	$0000,$FC00
	asr.b	#$8,d0
	and.b	d0,d0
	cmp.b	d0,d0
	ori.b	#$20,d6
	dc.w	$0008
	dc.w	$0000,$4CDF
	dc.w	$0200,$6100
	dc.w	$F806
	move.l	#$4000400,-(sp)
	jsr	$10540.l
	move.w	#$1,d0
	bsr.w	X_E118
	jsr	$1055C.l
	jsr	$EA76.l
	bsr.w	.LEC80
	jsr	$EA0C.l
	move.l	$EC92.l,d1
	beq.w	.LEC78
	movem.l	d1,-(sp)
	move.w	$FFFF8004.w,$EC8E.l
	lea	(.LECA2).l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	#$0,d1
	move.w	#$96,d0
	jsr	$5F22.w
	jsr	$EA76.l
	bclr.b	#$2,$FFFF8024.w
	move.l	$602C.w,$ECB0.l
	moveq	#$1B,d0
	jsr	$E370.l
	jsr	$E3BC.l
	movem.l	(sp)+,d1
	movea.l	#$FF8000,a5
	move.w	#$0,$BC6E8.l
	jsr	$EA00.l
	move.l	#$EAE2,-(sp)
	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	#$E000,-(sp)
	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	$EC9E.l,-(sp)
	move.l	$EC9A.l,-(sp)
	move.l	d1,-(sp)
	move.w	#$0,-(sp)
	jsr	(.LECB4).l
	adda.w	#$26,sp
	tst.w	d0
	bmi.w	.LEC7E
.LEBE6
	jsr	$E298.l
	btst	#$7,d1
	bne.w	.LEC04
	move.w	#$1,-(sp)
	jsr	(.LECB4).l
	addq.l	#$2,sp
	tst.w	d0
	bge.s	.LEBE6
.LEC04
	move.w	#$2,-(sp)
	jsr	(.LECB4).l
	addq.l	#$2,sp
	jsr	$E3BC.l
	jsr	$E3F8.l
	jsr	$E3EE.l
	jsr	$E416.l
	lea	(.LECA2).l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	$EC8E.l,d1
	andi.b	#$F8,d1
	ori.b	#$3,d1
	move.w	#$96,d0
	jsr	$5F22.w
	jsr	$EA76.l
	move.w	#$0,$BC6E8.l
	move.l	#$0,$BC6EC.l
	move.l	$ECB0.l,$602C.w
	bset.b	#$2,$FFFF8024.w
	bset.b	#$2,$FFFF8033.w
.LEC78
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.LEC7E
	bra.s	.LEC7E
.LEC80
	moveq	#$1A,d0
	jsr	$E370.l
	rts
	dcb.b	24,0
.LECA2
	dc.w	$01FF
	dc.b	'HOCKEY.SEG'
	ori.b	#$0,d0
	dc.w	$0000
.LECB4
	bra.w	X_ED94
	ori.b	#$0,d0
	ori.b	#$0,d1
	ori.b	#$0,d6
	dcb.b	208,0
