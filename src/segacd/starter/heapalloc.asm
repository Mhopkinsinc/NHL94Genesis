;	STARTER.BIN $49FA-$4C83 (runtime $25CFA-$25F83).
;
;	The heap: ffree, findSmallestBlock, MaxFree, mmalloc, InitHeap.


X_24FB4	equ	$24FB4
aprint	equ	$25BC4

	org	$25CFA

ffree
	link	a6,#$0
	movem.l	a3-a4,-(sp)
	movea.l	$8(a6),a3
	movea.l	a3,a4
	lea	-$10(a4),a4
	move.l	a3,d0
	beq.s	.L25D1E
	moveq	#$48,d0
	cmp.b	(a4),d0
	bne.s	.L25D1E
	moveq	#$42,d0
	cmp.b	$1(a4),d0
	beq.s	.L25D2C
.L25D1E
	move.l	a4,-(sp)
	pea	.L25DAE(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
	bra.s	.L25D7C
.L25D2C
	tst.w	$2(a4)
	bne.s	.L25D40
	move.l	a4,-(sp)
	pea	.L25D8E(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
	bra.s	.L25D7C
.L25D40
	tst.l	$4(a4)
	beq.s	.L25D62
	movea.l	$4(a4),a0
	tst.w	$2(a0)
	bne.s	.L25D62
	move.l	$8(a4),$8(a0)
	movea.l	$4(a4),a4
	movea.l	$8(a4),a0
	move.l	a4,$4(a0)
.L25D62
	movea.l	$8(a4),a0
	tst.w	$2(a0)
	bne.s	.L25D78
	movea.l	$8(a0),a0
	move.l	a0,$8(a4)
	move.l	a4,$4(a0)
.L25D78
	clr.w	$2(a4)
.L25D7C
	movem.l	-$8(a6),a3-a4
	unlk	a6
	rts
	dc.b	$85,'ffree'
	dc.w	$0040
.L25D8E
	dc.b	'Tried to ffree a free block: %x'
	dc.b	$00
.L25DAE
	dc.b	'Tried to ffree a bad block: %x'
	dc.w	$0000
findSmallestBlock
	link	a6,#$0
	movem.l	d5-d7/a3-a4,-(sp)
	move.l	$8(a6),d5
	lea	X_24FB4(pc),a0
	movea.l	$8(a0),a4
	moveq	#$0,d0
	movea.l	d0,a3
	move.l	#$7FFFFFFF,d6
	bra.s	.L25E10
.L25DEE
	tst.w	$2(a4)
	bne.s	.L25E0C
	move.l	$8(a4),d0
	sub.l	a4,d0
	move.l	d0,d7
	moveq	#$10,d0
	sub.l	d0,d7
	cmp.l	d7,d5
	bge.s	.L25E0C
	cmp.l	d7,d6
	ble.s	.L25E0C
	move.l	d7,d6
	movea.l	a4,a3
.L25E0C
	movea.l	$8(a4),a4
.L25E10
	move.l	a4,d0
	bne.s	.L25DEE
	move.l	a3,d0
	movem.l	-$14(a6),d5-d7/a3-a4
	unlk	a6
	rts
	dc.b	$91,'findSmallestBlock',0,0
MaxFree
	link	a6,#$0
	movem.l	d6-d7/a4,-(sp)
	lea	X_24FB4(pc),a0
	movea.l	$8(a0),a4
	moveq	#-1,d6
	bra.s	.L25E64
.L25E48
	tst.w	$2(a4)
	bne.s	.L25E60
	move.l	$8(a4),d0
	sub.l	a4,d0
	move.l	d0,d7
	moveq	#$10,d0
	sub.l	d0,d7
	cmp.l	d7,d6
	bge.s	.L25E60
	move.l	d7,d6
.L25E60
	movea.l	$8(a4),a4
.L25E64
	move.l	a4,d0
	bne.s	.L25E48
	move.l	d6,d0
	movem.l	-$C(a6),d6-d7/a4
	unlk	a6
	rts
	dc.b	$87,'MaxFree',0,0
mmalloc
	link	a6,#$0
	movem.l	d6-d7/a3-a4,-(sp)
	move.l	$8(a6),d7
	move.l	d7,d0
	addq.l	#$7,d0
	moveq	#-8,d1
	and.l	d0,d1
	move.l	d1,d7
	move.l	d7,-(sp)
	jsr	findSmallestBlock(pc)
	movea.l	d0,a3
	move.l	a3,d0
	addq.w	#$4,sp
	bne.s	.L25EA6
	moveq	#$0,d0
	bra.s	.L25EFC
.L25EA6
	move.l	$8(a3),d0
	sub.l	a3,d0
	move.l	d0,d6
	moveq	#$10,d0
	sub.l	d0,d6
	move.l	d7,d1
	moveq	#$18,d2
	add.l	d2,d1
	cmp.l	d6,d1
	bge.s	.L25EF0
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
	movea.l	d0,a4
	adda.l	d7,a4
	move.b	#$48,(a4)
	move.b	#$42,$1(a4)
	clr.w	$2(a4)
	move.l	a3,$4(a4)
	move.l	$8(a3),$8(a4)
	moveq	#$0,d0
	move.l	d0,$C(a4)
	movea.l	$8(a4),a0
	move.l	a4,$4(a0)
	move.l	a4,$8(a3)
.L25EF0
	move.w	#$1,$2(a3)
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
.L25EFC
	movem.l	-$10(a6),d6-d7/a3-a4
	unlk	a6
	rts
	dc.b	$87,'mmalloc',0,0
InitHeap
	link	a6,#$0
	movem.l	a3-a4,-(sp)
	lea	X_24FB4(pc),a0
	movea.l	$8(a0),a3
	lea	X_24FB4(pc),a0
	lea	X_24FB4(pc),a1
	move.l	$C(a1),d0
	add.l	$8(a0),d0
	movea.l	d0,a4
	lea	-$10(a4),a4
	move.b	#$48,(a3)
	move.b	#$42,$1(a3)
	clr.w	$2(a3)
	moveq	#$0,d0
	move.l	d0,$4(a3)
	move.l	a4,$8(a3)
	move.l	d0,$C(a3)
	move.b	#$48,(a4)
	move.b	#$45,$1(a4)
	move.w	#$2,$2(a4)
	move.l	a3,$4(a4)
	move.l	d0,$8(a4)
	move.l	d0,$C(a4)
	movem.l	-$8(a6),a3-a4
	unlk	a6
	rts
	dc.b	$88,'InitHeap',0,0,0
