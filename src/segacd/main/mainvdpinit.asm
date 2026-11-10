;	MAIN.BIN $57E8-$640B (runtime $FF57E8-$FF640B).
;
;	After the second copy of the C handlers and of the run-time (maincrt_2.asm): VDP set-up and
;	vectors ($70, $A12006), then zeros. Not named yet.


X_FF0006	equ	$FF0006
X_FF3622	equ	$FF3622
X_FF3996	equ	$FF3996
X_FF39A2	equ	$FF39A2
X_FF3DE4	equ	$FF3DE4
X_FF765C	equ	$FF765C

	org	$FF57E8

	lea	$FF481C.l,a0
	move.w	#$FFFF,$70.l
	move.w	a0,$A12006.l
	move.w	#$8A00,$C00004.l
	move.w	#$8014,$C00004.l
	rts
	move.w	#$8004,$C00004.l
	rts
	bset.b	#$6,$A1200E.l
.LFF5820
	btst.b	#$6,$A1200F.l
	bne.s	.LFF5820
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	jsr	$FF4918.l
	movea.l	#$FFFC00,sp
	bra.w	X_FF3622
	move.w	#$0,d0
	lea	$FF6E0C.l,a0
	move.w	#$184F,d1
	movea.l	$A12022.l,a1
	bsr.w	X_FF765C
	lea	$FF963C.l,a0
	move.w	#$0,d1
	move.w	#$6,d0
	bsr.w	X_FF765C
	lea	$FFA0C6.l,a0
	move.w	#$7,d0
	bsr.w	X_FF765C
	jsr	$FF67E8.l
	rts
	move.w	#$0,d0
	lea	$FF6E0C.l,a0
	move.w	#$184F,d1
	movea.l	$A12022.l,a1
	bsr.w	X_FF765C
	jsr	$FF67E8.l
	rts
	move.w	#$0,$A11200.l
	move.b	#$40,$A10009.l
	move.b	#$43,$A1000B.l
	nop
	move.b	#$7C,$A10005.l
	nop
	move.b	#$7F,$A1000B.l
	nop
	move.b	#$7C,$A10005.l
	nop
	move.b	$A10003.l,d0
	andi.b	#$3,d0
	cmpi.b	#$0,d0
	bne.s	.LFF58FC
	move.w	#$1,$A12010.l
	bra.s	.LFF590C
.LFF58FC
	move.w	#$0,$A12010.l
	move.b	#$40,$A1000B.l
.LFF590C
	move.w	#$100,$A11200.l
	rts
.LFF5916
	lea	$FF485E.l,a0
	move.l	a0,$FFFD08.l
	rts
	lea	$FF4854.l,a0
	move.l	a0,$FFFD08.l
	rts
	move.w	#$0,$FF6CFA.l
	rts
	move.l	$A12028.l,$C00004.l
	rts
	move.w	$A12028.l,$C00000.l
	rts
	move.l	$A12028.l,$C00000.l
	rts
	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.w	#$2,d0
	move.w	$A12028.l,d1
	move.w	#$100,d4
	bsr.w	X_FF765C
	move.w	(sp)+,sr
	rts
	move.b	$A12028.l,$A10003.l
	rts
	move.b	$A12028.l,$A10005.l
	rts
	move.b	$A10003.l,$A12018.l
	rts
	move.b	$A10005.l,$A12018.l
	rts
	move.w	$A12028.l,$C00004.l
	rts
	move.w	sr,-(sp)
	move.w	#$2700,sr
	movea.l	#$C00000,a0
	move.l	#$20,$C00004.l
	move.l	#$3F,d0
	lea	$FF6D04.l,a1
.LFF59DA
	move.w	(a0),(a1)+
	dbf	d0,.LFF59DA
	move.w	(sp)+,sr
	rts
.LFF59E4
	tst.w	$FF6D84.l
	bne.w	.LFF59F8
	move.w	#$1,$FF6D84.l
	rts
.LFF59F8
	movem.l	d0-d7/a0-a2,-(sp)
	st.b	$FF6D8A.l
	bsr.w	.LFF5AC8
	lea	.LFF5D8C(pc),a0
	moveq	#$3F,d1
.LFF5A0C
	move.w	#$0,(a0)+
	dbf	d1,.LFF5A0C
	move.w	#$18,$FF6D8A.l
.LFF5A1C
	tst.w	$FF6D8A.l
	bpl.w	.LFF5A1C
	bsr.w	X_FF3DE4
	bsr.w	.LFF5AD4
	movea.l	#$C00000,a0
	move.w	#$8C81,$4(a0)
	move.w	#$9001,$4(a0)
	move.w	#$8230,$4(a0)
	move.w	#$8406,$4(a0)
	movea.l	$FF6D86.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	#$20,d1
	move.w	d1,d5
	lsr.w	#$5,d5
	lea	$4(a1),a0
	jsr	$FF6BD0.l
	add.w	d2,d2
	lea	$4(a1,d2.w),a0
	lea	.LFF5D8C(pc),a1
	moveq	#$1F,d0
.LFF5A78
	move.l	(a0)+,(a1)+
	dbf	d0,.LFF5A78
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	dc.b	'$HSASB6'
	dc.b	$01
	move.w	#$80,d7
	moveq	#$0,d4
	move.w	#$C000,d4
.LFF5A94
	move.l	d4,d0
	bsr.w	.LFF5AF2
.LFF5A9A
	move.w	(a2)+,d6
	add.w	d5,d6
	move.w	d6,(a0)
	dbf	d1,.LFF5A9A
	move.w	d3,d1
	add.w	d7,d4
	dbf	d2,.LFF5A94
	move.w	#$18,$FF6D8A.l
.LFF5AB4
	tst.w	$FF6D8A.l
	bpl.w	.LFF5AB4
	bsr.w	.LFF5916
	movem.l	(sp)+,d0-d7/a0-a2
	rts
.LFF5AC8
	lea	.LFF5B0C(pc),a0
	move.l	a0,$FFFD08.l
	rts
.LFF5AD4
	movea.l	#$C00000,a1
	move.l	#$27,d0
	move.l	#$40000010,$4(a1)
.LFF5AE8
	move.w	#$0,(a1)
	dbf	d0,.LFF5AE8
	rts
.LFF5AF2
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
	move.l	d0,$4(a0)
	rts
.LFF5B0C
	movem.l	d0-d7/a0-a4,-(sp)
	tst.w	$FF6D8A.l
	bmi.w	.LFF5BA4
	cmpi.w	#$64,$FF6D8A.l
	beq.w	.LFF5BAA
	subq.w	#$1,$FF6D8A.l
	bmi.w	.LFF5BA4
	clr.l	d0
	move.w	$FF6D8A.l,d0
	cmpi.w	#$18,d0
	bgt.w	.LFF5BA4
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	lea	.LFF5D8C(pc),a1
	movea.l	#$C00000,a0
	clr.w	d6
.LFF5B60
	move.w	d3,d2
	move.w	d6,d0
	swap	d0
	move.w	#$20,d0
	move.l	d0,$4(a0)
	move.w	(a0),d7
	move.w	d7,d0
	and.w	d5,d0
	move.w	(a1)+,d1
	and.w	d5,d1
	cmp.w	d1,d0
	beq.w	.LFF5B9A
	blt.w	.LFF5B84
	neg.w	d2
.LFF5B84
	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,$4(a0)
	move.w	d7,(a0)
.LFF5B9A
	addq.w	#$2,d6
	cmpi.w	#$80,d6
	bne.w	.LFF5B60
.LFF5BA4
	movem.l	(sp)+,d0-d7/a0-a4
	rte
.LFF5BAA
	lea	$FF6D8C.l,a1
	movea.l	#$C00000,a0
	move.l	#$C0000000,$4(a0)
	moveq	#$1F,d0
.LFF5BC0
	move.l	(a1)+,(a0)
	dbf	d0,.LFF5BC0
	st.b	$FF6D8A.l
	bra.w	.LFF5BA4
	movem.l	d2-d7/a1-a2,-(sp)
	moveq	#$0,d7
	lea	$C00004.l,a1
	move.w	#$8154,(a1)
	move.w	#$8F02,(a1)
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,(a1)
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,(a1)
	cmpa.l	#$240000,a0
	ble.w	.LFF5C04
	bra.w	.LFF5C10
.LFF5C04
	moveq	#$1,d7
	move.w	d1,d6
	move.l	(a0),d5
	adda.l	#$2,a0
.LFF5C10
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
	move.l	d0,$FF6CE8.l
	move.w	$FF6CEA.l,(a1)
	move.w	$FF6CE8.l,(a1)
.LFF5C56
	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.LFF5C56
	move.w	#$8164,$C00004.l
	tst.w	d7
	beq.w	.LFF5C80
	moveq	#$0,d0
	move.w	d6,d0
	bsr.w	.LFF5AF2
	move.l	d5,(a0)
.LFF5C80
	movem.l	(sp)+,d2-d7/a1-a2
	rts
	bsr.w	X_FF3996
	movea.l	#$C00004,a0
	move.w	#$8B00,(a0)
	move.w	#$9100,(a0)
	move.w	#$9200,(a0)
	move.w	#$8578,(a0)
	move.w	#$8D3D,(a0)
	movea.l	#$200000,a0
	move.l	a0,$FF6D86.l
	move.w	#$1,$FF6D84.l
	bsr.w	.LFF59E4
	lea	X_FF0006(pc),a1
	movea.l	#$205BC8,a0
	move.l	#$C5A,d0
.LFF5CCC
	move.l	(a0)+,(a1)+
	dbf	d0,.LFF5CCC
	move.l	#$FF1006,$FF6D86.l
	bsr.w	X_FF39A2
	clr.w	$FF6D84.l
	rts
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	dc.w	$0000,$FFFF
	dcb.b	148,0
.LFF5D8C
	dcb.b	128,0
	abcd.b	d0,d1
	dc.w	$0600,$C351
	move.b	d0,d0
	and.w	d1,(a1)
	move.b	d0,d0
	and.w	d1,(a1)
	move.b	d0,d0
	and.w	d1,(a1)
	move.b	d0,d0
	and.w	d1,(a1)
	move.b	d0,d0
	and.w	d1,(a1)
	move.b	d0,d0
	and.w	d1,(a1)
	move.b	d0,d0
	dc.w	$184F
	dc.w	$184F
	dc.w	$1448
	dc.w	$1649
	dc.w	$184B
	dcb.b	1494,0
