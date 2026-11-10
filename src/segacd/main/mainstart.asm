;	MAIN.BIN $35A8-$3B3B (runtime $FF35A8-$FF3B3B).
;
;	Main CPU start-up: the stack at $FFFC00, the communication words $A12010-$A12018 cleared, then
;	the set-up before the command loop. Not named yet; hwread.asm follows.


X_FF765C	equ	$FF765C

	org	$FF35A8

	movea.l	#$FFFC00,sp
	move.w	#$0,$A12010.l
	move.w	#$0,$A12012.l
	move.w	#$0,$A12014.l
	move.w	#$0,$A12016.l
	move.w	#$0,$A12018.l
	move.w	#$0,$A1201A.l
	move.w	#$0,$A1201C.l
	move.w	#$0,$A1201E.l
	move.b	#$0,$A1200E.l
	move.w	#$0,$FF6CEE.l
	bsr.w	.LFF3918
	bsr.w	.LFF3962
	bsr.w	.LFF39A2
	move.l	#$0,$FF6D00.l
	move.l	#$0,$FF6CFC.l
	bra.w	.LFF3622
.LFF3622
	btst.b	#$7,$A1200F.l
	bne.s	.LFF3622
	btst.b	#$6,$A1200F.l
	beq.s	.LFF3622
	bset.b	#$7,$A1200E.l
	move.w	$A12020.l,d0
	lsl.w	#$2,d0
	lea	$FF471C.l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	bset.b	#$6,$A1200E.l
.LFF365A
	btst.b	#$6,$A1200F.l
	bne.s	.LFF365A
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	bra.w	.LFF3622
.LFF3678
	btst.b	#$7,$A1200F.l
	bne.s	.LFF3678
	btst.b	#$6,$A1200F.l
	beq.s	.LFF3678
	bset.b	#$7,$A1200E.l
	move.w	$A12020.l,d0
	bset.b	#$6,$A1200E.l
.LFF36A2
	btst.b	#$6,$A1200F.l
	bne.s	.LFF36A2
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	rts
.LFF36BE
	btst.b	#$7,$A1200F.l
	bne.s	.LFF36BE
	move.w	d0,$A12010.l
	bset.b	#$6,$A1200E.l
.LFF36D6
	btst.b	#$6,$A1200F.l
	beq.s	.LFF36D6
	bset.b	#$7,$A1200E.l
	bclr.b	#$6,$A1200E.l
.LFF36F0
	btst.b	#$6,$A1200F.l
	bne.s	.LFF36F0
	bclr.b	#$7,$A1200E.l
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	lsl.w	#$2,d0
	lea	$FF471C.l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$00FF
	dc.w	$496E
	dc.w	$00FF
	dc.w	$49DA
	dc.w	$00FF
	tst.b	$FF(a6)
	tst.w	(a6)
	dc.w	$00FF
	tst.w	$FF.w
	tst.l	d2
	dc.w	$00FF
	dc.w	$4A8C
	dc.w	$00FF
	tst.l	(a2)
	dc.w	$00FF
	dc.w	$4B3C
	dc.w	$00FF
	dc.w	$4B48
	dc.w	$00FF
	dc.w	$4B54
	dc.w	$00FF
	dc.w	$4B60
	dc.w	$00FF
	dc.w	$4B6C
	dc.w	$00FF
	dc.w	$4B78
	dc.w	$00FF
	chk.w	d4,d5
	dc.w	$00FF
	chk.w	(a0),d5
	dc.w	$00FF
	chk.w	(a4)+,d5
	dc.w	$00FF
	chk.w	$FF(a0),d5
	chk.w	-$1(a4,d0.w),d5
	dc.w	$4BC0
	dc.w	$00FF
	dc.w	$4BCC
	dc.w	$00FF
.LFF3772
	dc.w	$4BD8
	dc.w	$00FF
	dc.w	$4C14
.LFF3778
	dc.w	$00FF
	dc.w	$4C22
	dc.w	$00FF
	dc.w	$4C30
	dc.w	$00FF
	lea	-$1(a0,d0.w),a5
	dc.w	$4BFC
	dc.w	$00FF
	dc.w	$4C08
.LFF378C
	dc.w	$00FF
	dc.w	$4C3E
	dc.w	$00FF
	movem.w	$4D8E(a4),d0-d7
	dc.w	$00FF
	dc.w	$4DE4
.LFF379C
	dc.w	$00FF
.LFF379E
	dc.w	$4E02
.LFF37A0
	dc.w	$00FF
	dc.w	$4E24
	dc.w	$00FF
.LFF37A6
	dc.w	$4E30
	dc.w	$00FF
	dc.w	$4E84
.LFF37AC
	dc.w	$00FF
	dc.w	$4FC8
	dc.w	$00FF
	unlk	a2
	dc.w	$00FF
	beq.s	.LFF37A0
	dc.w	$00FF
	bvc.s	.LFF37D4
	dc.w	$00FF
	bvc.s	.LFF380A
	dc.w	$00FF
	bvc.s	.LFF37D2
.LFF37C4
	dc.w	$00FF
	bvc.s	.LFF3772
	dc.w	$00FF
	dc.w	$4D38
	dc.w	$00FF
	bvs.s	.LFF37E6
	dc.w	$00FF
.LFF37D2
	bvs.s	.LFF37F8
.LFF37D4
	dc.w	$00FF
	bvs.s	.LFF380A
	dc.w	$00FF
	bvs.s	.LFF3818
	dc.w	$00FF
	bvs.s	.LFF3828
	dc.w	$00FF
	tst.l	(a2)
	dc.w	$00FF
.LFF37E6
	bvs.s	.LFF383C
	dc.w	$00FF
	bvs.s	.LFF384C
	dc.w	$00FF
	bvs.s	.LFF3778
	dc.w	$00FF
	bvs.s	.LFF3870
.LFF37F4
	dc.w	$00FF
	bvs.s	.LFF378C
.LFF37F8
	dc.w	$00FF
	bvs.s	.LFF379C
	dc.w	$00FF
	bvs.s	.LFF37AC
	dc.w	$00FF
	movem.w	$4D8E(a4),d0-d7
	dc.w	$00FF
.LFF380A
	bvs.s	.LFF37C4
	dc.w	$00FF
	bvs.s	.LFF37F4
	dc.w	$00FF
	dc.w	$500C
	dc.w	$00FF
	bge.s	.LFF379E
.LFF3818
	dc.w	$00FF
	bvc.s	.LFF37A6
	move.w	d0,-(sp)
	move.b	$C00008.l,d0
	cmpi.b	#$64,d0
.LFF3828
	bcc.s	.LFF3834
	move.w	#$0,$FF6CF8.l
	bra.s	.LFF383C
.LFF3834
	tst.w	$FF6CF8.l
	beq.s	.LFF3840
.LFF383C
	move.w	(sp)+,d0
	rte
.LFF3840
	move.w	#$1,$FF6CF8.l
	move.w	#$1,d0
.LFF384C
	bsr.w	X_FF765C
	move.w	(sp)+,d0
	rte
	bset.b	#$0,$A12000.l
	rte
	movem.l	d0-d1/a0-a1,-(sp)
	bset.b	#$5,$A1200E.l
	dc.w	$08F9
	ori.b	#$A1,d0
.LFF3870
	move.l	d0,d0
	move.w	#$1,$FF6CFA.l
	move.l	#$32,d0
.LFF3880
	btst.b	#$2,$A1200F.l
	bne.s	.LFF38AE
	dbf	d0,.LFF3880
	bclr.b	#$5,$A1200E.l
	move.l	#$19,d0
.LFF389C
	btst.b	#$2,$A1200F.l
	bne.s	.LFF38AE
	dbf	d0,.LFF389C
	bra.w	.LFF390A
.LFF38AE
	btst.b	#$4,$A1200F.l
	bne.s	.LFF38AE
	btst.b	#$3,$A1200F.l
	beq.s	.LFF38AE
	bset.b	#$4,$A1200E.l
	move.w	$A12026.l,d0
	lsl.w	#$2,d0
	lea	$FF471C.l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	bset.b	#$3,$A1200E.l
.LFF38E6
	btst.b	#$3,$A1200F.l
	bne.s	.LFF38E6
	bclr.b	#$3,$A1200E.l
	bclr.b	#$4,$A1200E.l
	tst.w	$FF6CFA.l
	bne.w	.LFF38AE
.LFF390A
	bclr.b	#$5,$A1200E.l
	movem.l	(sp)+,d0-d1/a0-a1
	rte
.LFF3918
	btst.b	#$7,$A1200F.l
	bne.s	.LFF3918
.LFF3922
	btst.b	#$6,$A1200F.l
	bne.s	.LFF3922
	bset.b	#$6,$A1200E.l
.LFF3934
	btst.b	#$6,$A1200F.l
	beq.s	.LFF3934
	bset.b	#$7,$A1200E.l
	bclr.b	#$6,$A1200E.l
.LFF394E
	btst.b	#$6,$A1200F.l
	bne.s	.LFF394E
	bclr.b	#$7,$A1200E.l
	rts
.LFF3962
	btst.b	#$2,$A12003.l
	bne.s	.LFF3962
	rts
	move.l	d0,-(sp)
	move.w	#$4000,$C00004.l
	move.w	#$0,$C00004.l
	move.l	#$8000,d0
.LFF3986
	move.w	#$0,$C00000.l
	dbf	d0,.LFF3986
	move.l	(sp)+,d0
	rts
.LFF3996
	btst.b	#$1,$A12003.l
	bne.s	.LFF3996
	rts
.LFF39A2
	bset.b	#$1,$A12003.l
.LFF39AA
	btst.b	#$0,$A12003.l
	bne.s	.LFF39AA
	rts
.LFF39B6
	movem.w	d0,-(sp)
	andi.w	#$3FFF,d0
	ori.w	#$4000,d0
	move.w	d0,$C00004.l
	movem.w	(sp)+,d0
	rol.w	#$2,d0
	andi.w	#$3,d0
	move.w	d0,$C00004.l
	rts
	movem.l	d0-d1/a0,-(sp)
	bsr.w	.LFF39A2
	bsr.w	.LFF3996
	bsr.w	.LFF3678
	move.w	d0,d1
	bsr.w	.LFF3678
	bsr.w	.LFF39B6
	lea	$200000.l,a0
.LFF39FA
	move.w	(a0)+,$C00000.l
	dbf	d1,.LFF39FA
	movem.l	(sp)+,d0-d1/a0
	rts
.LFF3A0A
	movem.w	d0,-(sp)
	andi.w	#$3FFF,d0
	ori.w	#$C000,d0
	move.w	d0,$C00004.l
	movem.w	(sp)+,d0
	rol.w	#$2,d0
	andi.w	#$3,d0
	move.w	d0,$C00004.l
	rts
	bsr.w	.LFF39A2
	bsr.w	.LFF3996
	bsr.w	.LFF3678
	move.w	d0,d1
	bsr.w	.LFF3678
	bsr.w	.LFF3A0A
	lea	$200000.l,a0
.LFF3A4A
	move.w	(a0)+,$C00000.l
	dbf	d1,.LFF3A4A
	rts
	move.w	$A12022.l,d0
	move.w	#$0,$A12010.l
	btst.b	d0,$A11100.l
	bne.w	.LFF3A76
	move.w	#$4,$A12010.l
.LFF3A76
	rts
	movea.l	$A12022.l,a0
	clr.b	(a0)
	rts
	movea.l	$A12022.l,a0
	clr.w	(a0)
	rts
	bsr.w	.LFF39A2
	rts
	bsr.w	.LFF3996
	move.w	$23BC88.l,$C00004.l
	move.w	$23BC8A.l,$C00004.l
	move.w	$23BC8C.l,$C00004.l
	move.w	$23BC8E.l,$C00004.l
	move.w	$23BC90.l,$C00004.l
	move.w	$23BC92.l,$C00004.l
	move.w	$23BC94.l,$C00004.l
	lea	$C00004.l,a1
	move.l	$23BC9E.l,$FF6CE8.l
	move.w	$FF6CEA.l,(a1)
	move.w	$FF6CE8.l,(a1)
.LFF3AF8
	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.LFF3AF8
	move.w	#$8164,$C00004.l
	lea	$C00000.l,a1
	move.l	$23BC9A.l,d4
	asl.l	#$2,d4
	lsr.w	#$2,d4
	ori.w	#$4000,d4
	swap	d4
	andi.w	#$3,d4
	move.l	d4,$4(a1)
	move.l	$23BC96.l,(a1)
	bsr.w	.LFF39A2
	rts
