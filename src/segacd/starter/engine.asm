;	STARTER.BIN $4ECE-$4FA7 (runtime $261CE-$262A7).
;
;	DisposeEngine, GetSectDst, PeekSectDst: the CD read engine (InitEngine is in filmbuf.asm,
;	EngineIdle and GetData in subheap.asm).


X_24FB4	equ	$24FB4
ffree	equ	$25CFA
X_26656	equ	$26656

	org	$261CE

DisposeEngine
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	tst.l	(a4)
	beq.s	.L261E4
	move.l	(a4),-(sp)
	jsr	ffree(pc)
	addq.w	#$4,sp
.L261E4
	movea.l	-$4(a6),a4
	unlk	a6
	rts
	dc.b	$8D,'DisposeEngine',0,0
GetSectDst
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	lea	X_24FB4(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	bge.s	.L2623E
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	jsr	X_26656(pc)
	move.l	d0,d7
	add.l	(a4),d7
	addq.l	#$1,$10(a4)
	addi.l	#$800,$8(a4)
.L2623E
	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$8A,'GetSectDst',0,0,0
PeekSectDst
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	lea	X_24FB4(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	bge.s	.L2628E
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	jsr	X_26656(pc)
	move.l	d0,d7
	add.l	(a4),d7
.L2628E
	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$8B,'PeekSectDst',0,0
