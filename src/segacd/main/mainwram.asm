;	MAIN.BIN $3C3E-$40CF (runtime $FF3C3E-$FF40CF).
;
;	After hwread.asm: copies from word RAM ($23BC88 ...) to the VDP ($C00000). Not named yet. The
;	second copy of maindisp.asm (main/maindisp_2.asm) follows.


X_FF0006	equ	$FF0006
X_FF35A8	equ	$FF35A8
X_FF3996	equ	$FF3996
X_FF39A2	equ	$FF39A2
X_FF40D0	equ	$FF40D0
X_FF580E	equ	$FF580E
X_FF765C	equ	$FF765C

	org	$FF3C3E

	bsr.w	X_FF3996
	move.l	$23BC88.l,d3
	move.l	$23BC8C.l,d4
	move.l	$23BC90.l,d5
	movea.l	#$23BCB0,a1
	movea.l	#$C00000,a0
	clr.w	d6
.LFF3C62
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
	beq.w	.LFF3C9C
	blt.w	.LFF3C86
	neg.w	d2
.LFF3C86
	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,$4(a0)
	move.w	d7,(a0)
.LFF3C9C
	addq.w	#$2,d6
	cmpi.w	#$80,d6
	bne.w	.LFF3C62
	bsr.w	X_FF39A2
	rts
	bsr.w	X_FF3996
	move.l	$23BC88.l,d0
	move.l	$23BC8C.l,d1
	move.l	$23BC90.l,d2
	lea	$C00004.l,a1
	move.w	#$8154,(a1)
	move.w	#$8F01,(a1)
	move.w	#$9300,d3
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9400,d3
	lsr.w	#$8,d0
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9500,d3
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$9600,d3
	lsr.w	#$8,d2
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$97C0,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	swap	d0
	ori.w	#$C0,d0
	move.l	d0,$FF6CE8.l
	move.w	$FF6CE8.l,(a1)
	move.w	$FF6CEA.l,(a1)
.LFF3D18
	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.LFF3D18
	move.w	#$8164,(a1)
	move.w	#$8F02,(a1)
	bsr.w	X_FF39A2
	rts
	bsr.w	X_FF3996
	lea	$C00004.l,a1
	movea.l	#$23C000,a0
	move.w	(a0)+,d0
	move.w	(a0)+,(a1)
.LFF3D4C
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.l	(a0)+,$FF6CE8.l
	move.w	$FF6CE8.l,(a1)
	move.w	$FF6CEA.l,(a1)
.LFF3D6A
	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.LFF3D6A
	move.w	#$8164,(a1)
	dbf	d0,.LFF3D4C
	move.w	#$8F02,(a1)
	bsr.w	X_FF39A2
	rts
	bsr.w	X_FF3996
	move.l	$23BC88.l,d0
	move.l	$23BC8C.l,d1
	move.l	$23BC90.l,d2
	movea.l	#$C00000,a1
	andi.l	#$FFFF,d1
	asl.l	#$2,d1
	lsr.w	#$2,d1
	ori.w	#$4000,d1
	swap	d1
	move.l	d1,$4(a1)
	move.w	d2,d3
	swap	d3
	move.w	d2,d3
	lsr.w	#$1,d0
	subq.w	#$1,d0
.LFF3DC8
	move.l	d3,$FF6CE8.l
	move.w	$FF6CE8.l,(a1)
	move.w	$FF6CEA.l,(a1)
	dbf	d0,.LFF3DC8
	bsr.w	X_FF39A2
	rts
	move.l	#$40000000,$C00004.l
	move.w	#$3FFF,d0
	movea.l	#$C00000,a0
	clr.l	d1
.LFF3DFA
	move.l	d1,(a0)
	dbf	d0,.LFF3DFA
	rts
	bsr.w	X_FF3996
	lea	$C00000.l,a0
	lea	$23C002.l,a1
	move.w	$23C000.l,d0
.LFF3E18
	move.w	(a1)+,(a0)
	dbf	d0,.LFF3E18
	bsr.w	X_FF39A2
	rts
	move.w	$A12022.l,$A11200.l
	rts
	tst.w	$FF6CF8.l
	bne.w	.LFF3E58
	moveq	#$0,d1
	move.w	$A12022.l,d1
	move.l	d1,d0
	asl.w	#$1,d0
	lea	$FF4E76.l,a0
	adda.l	d0,a0
	move.w	(a0),d2
	move.w	#$4,d0
	bsr.w	X_FF765C
.LFF3E58
	rts
	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.w	#$2,d0
	move.w	$A12022.l,d1
	move.w	#$100,d4
	bsr.w	X_FF765C
	move.w	(sp)+,sr
	rts
	ori.b	#$6B,d0
	ori.w	#$75,$7C(a2)
	ori.w	#$74,$3C(a3,d3.w)
	dc.w	$0001,$6100
	dc.w	$37D2
	rts
.LFF3E8E
	movem.l	d1/a0,-(sp)
	bsr.w	.LFF3EB8
	move.b	d0,$FF4F84.l
	bsr.w	.LFF3EAC
	move.b	d0,$FF4F85.l
	movem.l	(sp)+,d1/a0
	rts
.LFF3EAC
	movem.l	d1/a0,-(sp)
	lea	$A10005.l,a0
	bra.s	.LFF3EC2
.LFF3EB8
	movem.l	d1/a0,-(sp)
	lea	$A10003.l,a0
.LFF3EC2
	moveq	#$0,d0
	move.b	#$0,(a0)
	nop
	nop
	move.b	(a0),d0
	move.b	#$40,(a0)
	nop
	nop
	move.b	(a0),d1
	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea	.LFF3F00(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.LFF3F00
	dc.w	$0001,$0201
	dc.w	$0405,$0606
	dc.w	$0809
	dc.w	$0A0A
	dc.w	$0809
	dc.w	$0A00
.LFF3F10
	move.b	$FF4F84.l,d0
	bsr.w	.LFF3F4C
	move.w	$FF4F7C.l,d2
	move.w	d1,$FF4F7C.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.LFF3F2E
	move.b	$FF4F85.l,d0
	bsr.w	.LFF3F4C
	move.w	$FF4F7E.l,d2
	move.w	d1,$FF4F7E.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.LFF3F4C
	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea	$FF4F6C.l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
	dc.w	$0800
	dc.w	$0408
	dc.w	$0607,$0508
	dc.w	$0201,$0308
	dc.w	$0808
	dc.w	$0808
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$0,$A1200F.l
	beq.w	.LFF3FC0
	bclr.b	#$1,$A1200E.l
	bsr.w	.LFF3E8E
	bsr.w	.LFF3F10
	move.w	d1,d5
	bsr.w	.LFF3F2E
	or.w	d1,d5
	cmpi.b	#$80,d5
	bne.w	.LFF3FC0
	bset.b	#$1,$A1200E.l
.LFF3FC0
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	rte
	bset.b	#$6,$A1200E.l
.LFF3FD0
	btst.b	#$6,$A1200F.l
	bne.s	.LFF3FD0
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	move.b	#$0,$A1200E.l
	bsr.w	X_FF580E
	move.l	#$FF4F88,-(sp)
	bsr.w	.LFF4040
	adda.l	#$4,sp
	bra.w	X_FF35A8
	rts
	bset.b	#$6,$A1200E.l
.LFF4014
	btst.b	#$6,$A1200F.l
	bne.s	.LFF4014
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	move.b	#$0,$A1200E.l
	bsr.w	X_FF0006
	bra.w	X_FF35A8
	rts
.LFF4040
	bra.w	X_FF40D0
	dcb.b	140,0
