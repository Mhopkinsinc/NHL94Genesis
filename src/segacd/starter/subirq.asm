;	STARTER.BIN $40FA-$4335 (runtime $253FA-$25635).
;
;	After pcmchip.asm: a long that keeps the BIOS vector at $5F90 (the first line, decoded as an
;	ori.b #0), code that hooks that vector with its own handler and puts it back, then the C function Wait.


X_24FC4	equ	$24FC4
X_24FC8	equ	$24FC8
X_24FCC	equ	$24FCC
X_24FEC	equ	$24FEC
GetTicks	equ	$26062
GetSectDst	equ	$261FC
PeekSectDst	equ	$26258

	org	$253FA

.L253FA
	ori.b	#$0,d0
	lea	.L253FA(pc),a0
	move.l	$5F90.w,(a0)
	lea	.L2542E(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
	movea.l	.L253FA(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
.L2542A
	ori.b	#$0,d0
.L2542E
	movem.l	d0-d3/a0-a2/a5,-(sp)
	pea	.L2543E(pc)
	move.w	sr,-(sp)
	movea.l	.L253FA(pc),a2
	jmp	(a2)
.L2543E
	movea.l	#$FF8000,a5
	move.l	X_24FC4(pc),d3
	beq.w	.L2551C
	bgt.s	.L254C6
	andi.w	#$F8FF,$4(a5)
	ori.w	#$300,$4(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.w	.L2551C
	move.l	X_24FC8(pc),d0
	bne.s	.L25476
	bsr.w	PeekSectDst
	tst.l	d0
	beq.w	.L25522
.L25476
	movea.l	d0,a0
	lea	.L2542A(pc),a1
	move.w	#$8C,d0
	jsr	$5F22.w
	bcs.w	.L2551C
	move.w	#$8D,d0
	jsr	$5F22.w
	move.l	.L2542A(pc),d0
	andi.l	#$FFFFFF00,d0
	bsr.w	.L255BA
	move.l	X_24FCC(pc),d1
	cmp.l	d0,d1
	bne.s	.L2551C
	lea	X_24FC8(pc),a1
	tst.l	(a1)
	beq.s	.L254B6
	addi.l	#$800,(a1)
	bra.s	.L254BA
.L254B6
	bsr.w	GetSectDst
.L254BA
	neg.l	d3
	subq.w	#$1,d3
	lea	X_24FC4(pc),a1
	move.l	d3,(a1)
	bra.s	.L2551C
.L254C6
	movea.l	#$FF8000,a5
	andi.w	#$F8FF,$4(a5)
	ori.w	#$500,$4(a5)
	move.l	X_24FC8(pc),d0
	bne.s	.L254E6
	bsr.w	GetSectDst
	tst.l	d0
	beq.s	.L25522
.L254E6
	lsr.l	#$3,d0
	move.w	d0,$A(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.s	.L2552A
.L254F6
	btst.b	#$7,$4(a5)
	beq.s	.L254F6
	bcs.s	.L2552A
	move.w	#$8D,d0
	jsr	$5F22.w
	lea	X_24FC8(pc),a1
	tst.l	(a1)
	beq.s	.L25516
	addi.l	#$800,(a1)
.L25516
	lea	X_24FC4(pc),a1
	subq.l	#$1,(a1)
.L2551C
	movem.l	(sp)+,d0-d3/a0-a2/a5
	rte
.L25522
	lea	X_24FC4(pc),a1
	clr.l	(a1)
	bra.s	.L2551C
.L2552A
	lea	X_24FEC(pc),a1
	move.l	#$FFFFFFFF,(a1)
	bra.s	.L2551C
	lea	X_24FC4(pc),a1
	clr.l	(a1)
	move.w	#$8,d0
	jsr	$5F22.w
	rts
	link	a6,#$FFFC
	movem.l	d1-d7/a0-a5,-(sp)
	movea.l	#$FF8000,a5
	lea	X_24FEC(pc),a1
	clr.l	(a1)
	moveq	#$5,d4
	moveq	#-1,d5
	subq.l	#$1,d4
	beq.s	.L25598
	moveq	#$0,d0
	move.w	#$96,d0
	jsr	$5F22.w
	move.l	$8(a6),d3
	move.l	$C(a6),d2
	lea	$8(a6),a0
	move.w	#$17,d0
	jsr	$5F22.w
	lea	X_24FC8(pc),a1
	move.l	$10(a6),(a1)
	lea	X_24FC4(pc),a1
	neg.l	d2
	move.l	d2,(a1)
	lea	X_24FCC(pc),a1
	move.l	d3,(a1)
	moveq	#$0,d5
.L25598
	move.l	d5,d0
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	rts
.L255A2
	move.l	d1,-(sp)
	move.b	d0,d1
	andi.w	#$FF,d1
	lsr.w	#$4,d1
	mulu.w	#$A,d1
	andi.w	#$F,d0
	add.w	d1,d0
	move.l	(sp)+,d1
	rts
.L255BA
	movem.l	d1-d2,-(sp)
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	.L255A2(pc)
	move.b	d0,d2
	andi.l	#$FF,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	.L255A2(pc)
	andi.l	#$FF,d0
	mulu.w	#$4B,d0
	add.l	d0,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	jsr	.L255A2(pc)
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
.L25618
	jsr	GetTicks(pc)
	move.l	d7,d1
	add.l	d6,d1
	cmp.l	d0,d1
	bgt.s	.L25618
	movem.l	-$8(a6),d6-d7
	unlk	a6
	rts
	dc.b	$84,'Wait',0,0,0
