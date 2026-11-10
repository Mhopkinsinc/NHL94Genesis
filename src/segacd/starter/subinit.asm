;	STARTER.BIN $4C84-$4D9D (runtime $25F84-$2609D).
;
;	InitWorld (prints SUBCPU is alive), GetTicks, WaitIODone.


X_24FB4	equ	$24FB4
aprint	equ	$25BC4
InitHeap	equ	$25F10

	org	$25F84

InitWorld
	link	a6,#$0
	move.l	d7,-(sp)
	clr.w	$FF8020.l
	pea	.L26052(pc)
	jsr	aprint(pc)
	lea	X_24FB4(pc),a0
	moveq	#$F,d7
	and.l	$8(a0),d7
	tst.l	d7
	addq.w	#$4,sp
	beq.s	.L25FB2
	pea	.L26046(pc)
	jsr	aprint(pc)
	addq.w	#$4,sp
.L25FB2
	lea	X_24FB4(pc),a0
	move.l	$8(a0),d0
	moveq	#$F,d1
	add.l	d1,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea	X_24FB4(pc),a0
	move.l	d2,$8(a0)
	lea	X_24FB4(pc),a0
	move.l	$C(a0),d0
	sub.l	d7,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea	X_24FB4(pc),a0
	move.l	d2,$C(a0)
	lea	X_24FB4(pc),a0
	move.l	$8(a0),-(sp)
	pea	.L26036(pc)
	jsr	aprint(pc)
	lea	X_24FB4(pc),a0
	move.l	$C(a0),-(sp)
	pea	.L26026(pc)
	jsr	aprint(pc)
	lea	X_24FB4(pc),a0
	tst.l	$C(a0)
	lea	$10(sp),sp
	beq.s	.L26012
	jsr	InitHeap(pc)
.L26012
	move.l	-$4(a6),d7
	unlk	a6
	rts
	dc.b	$89,'InitWorld'
	dc.w	$003C
.L26026
	dc.b	'Heap Size : %x'
	dc.w	$0000
.L26036
	dc.b	'Heap Start: %x'
	dc.w	$0000
.L26046
	dc.b	'Fixing Heap'
	dc.b	$00
.L26052
	dc.b	'SUBCPU is alive'
	dc.b	$00
GetTicks
	link	a6,#$0
	lea	X_24FB4(pc),a0
	move.l	$4(a0),d0
	unlk	a6
	rts
	dc.b	$88,'GetTicks',0,0,0
WaitIODone
	link	a6,#$0
.L26082
	lea	X_24FB4(pc),a0
	tst.l	$10(a0)
	bne.s	.L26082
	unlk	a6
	rts
	dc.b	$8A,'WaitIODone',0,0,0
