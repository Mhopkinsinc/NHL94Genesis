;	STARTER.BIN $40FA-$4335 (runtime $F0FA-$F335).
;
;	After pcmchip.asm: a long that keeps the BIOS vector at $5F90 (the first line, decoded as an
;	ori.b #0), code that hooks that vector with its own handler and puts it back, then the C function Wait.


X_ECC4	equ	$ECC4
X_ECC8	equ	$ECC8
X_ECCC	equ	$ECCC
X_ECEC	equ	$ECEC
GetTicks	equ	$FD62
GetSectDst	equ	$FEFC
PeekSectDst	equ	$FF58

	org	$F0FA

.LF0FA
	ori.b	#$0,d0
	lea	.LF0FA(pc),a0
	move.l	$5F90.w,(a0)
	lea	.LF12E(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
	movea.l	.LF0FA(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
.LF12A
	ori.b	#$0,d0
.LF12E
	movem.l	d0-d3/a0-a2/a5,-(sp)
	pea	.LF13E(pc)
	move.w	sr,-(sp)
	movea.l	.LF0FA(pc),a2
	jmp	(a2)
.LF13E
	movea.l	#$FF8000,a5
	move.l	X_ECC4(pc),d3
	beq.w	.LF21C
	bgt.s	.LF1C6
	andi.w	#$F8FF,$4(a5)
	ori.w	#$300,$4(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.w	.LF21C
	move.l	X_ECC8(pc),d0
	bne.s	.LF176
	bsr.w	PeekSectDst
	tst.l	d0
	beq.w	.LF222
.LF176
	movea.l	d0,a0
	lea	.LF12A(pc),a1
	move.w	#$8C,d0
	jsr	$5F22.w
	bcs.w	.LF21C
	move.w	#$8D,d0
	jsr	$5F22.w
	move.l	.LF12A(pc),d0
	andi.l	#$FFFFFF00,d0
	bsr.w	.LF2BA
	move.l	X_ECCC(pc),d1
	cmp.l	d0,d1
	bne.s	.LF21C
	lea	X_ECC8(pc),a1
	tst.l	(a1)
	beq.s	.LF1B6
	addi.l	#$800,(a1)
	bra.s	.LF1BA
.LF1B6
	bsr.w	GetSectDst
.LF1BA
	neg.l	d3
	subq.w	#$1,d3
	lea	X_ECC4(pc),a1
	move.l	d3,(a1)
	bra.s	.LF21C
.LF1C6
	movea.l	#$FF8000,a5
	andi.w	#$F8FF,$4(a5)
	ori.w	#$500,$4(a5)
	move.l	X_ECC8(pc),d0
	bne.s	.LF1E6
	bsr.w	GetSectDst
	tst.l	d0
	beq.s	.LF222
.LF1E6
	lsr.l	#$3,d0
	move.w	d0,$A(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.s	.LF22A
.LF1F6
	btst.b	#$7,$4(a5)
	beq.s	.LF1F6
	bcs.s	.LF22A
	move.w	#$8D,d0
	jsr	$5F22.w
	lea	X_ECC8(pc),a1
	tst.l	(a1)
	beq.s	.LF216
	addi.l	#$800,(a1)
.LF216
	lea	X_ECC4(pc),a1
	subq.l	#$1,(a1)
.LF21C
	movem.l	(sp)+,d0-d3/a0-a2/a5
	rte
.LF222
	lea	X_ECC4(pc),a1
	clr.l	(a1)
	bra.s	.LF21C
.LF22A
	lea	X_ECEC(pc),a1
	move.l	#$FFFFFFFF,(a1)
	bra.s	.LF21C
	lea	X_ECC4(pc),a1
	clr.l	(a1)
	move.w	#$8,d0
	jsr	$5F22.w
	rts
	link	a6,#$FFFC
	movem.l	d1-d7/a0-a5,-(sp)
	movea.l	#$FF8000,a5
	lea	X_ECEC(pc),a1
	clr.l	(a1)
	moveq	#$5,d4
	moveq	#-1,d5
	subq.l	#$1,d4
	beq.s	.LF298
	moveq	#$0,d0
	move.w	#$96,d0
	jsr	$5F22.w
	move.l	$8(a6),d3
	move.l	$C(a6),d2
	lea	$8(a6),a0
	move.w	#$17,d0
	jsr	$5F22.w
	lea	X_ECC8(pc),a1
	move.l	$10(a6),(a1)
	lea	X_ECC4(pc),a1
	neg.l	d2
	move.l	d2,(a1)
	lea	X_ECCC(pc),a1
	move.l	d3,(a1)
	moveq	#$0,d5
.LF298
	move.l	d5,d0
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	rts
.LF2A2
	move.l	d1,-(sp)
	move.b	d0,d1
	andi.w	#$FF,d1
	lsr.w	#$4,d1
	mulu.w	#$A,d1
	andi.w	#$F,d0
	add.w	d1,d0
	move.l	(sp)+,d1
	rts
.LF2BA
	movem.l	d1-d2,-(sp)
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	.LF2A2(pc)
	move.b	d0,d2
	andi.l	#$FF,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	.LF2A2(pc)
	andi.l	#$FF,d0
	mulu.w	#$4B,d0
	add.l	d0,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	jsr	.LF2A2(pc)
	andi.l	#$FF,d0
	mulu.w	#$1194,d0
	add.l	d0,d2
	subi.l	#$96,d2
	move.l	d2,d0
	movem.l	(sp)+,d1-d2
	rts
Wait
	link	a6,#$0
	movem.l	d6-d7,-(sp)
	move.l	$8(a6),d6
	jsr	GetTicks(pc)
	move.l	d0,d7
.LF318
	jsr	GetTicks(pc)
	move.l	d7,d1
	add.l	d6,d1
	cmp.l	d0,d1
	bgt.s	.LF318
	movem.l	-$8(a6),d6-d7
	unlk	a6
	rts
	dc.b	$84,'Wait',0,0,0
