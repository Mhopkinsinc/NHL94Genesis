;	MAIN.BIN $7154-$76C7 (runtime $FF7154-$FF76C7).
;
;	Zeros, then a dispatch on d0 into the module after z80load.asm (mainmod.asm); z80load.asm follows.


X_FF76C8	equ	$FF76C8
X_FF77B8	equ	$FF77B8
X_FF7A34	equ	$FF7A34
X_FF7ADE	equ	$FF7ADE
X_FF7B36	equ	$FF7B36
X_FF7B90	equ	$FF7B90
X_FF819C	equ	$FF819C
X_FF81B0	equ	$FF81B0
X_FF81FA	equ	$FF81FA
X_FF82F8	equ	$FF82F8

	org	$FF7154

	dcb.b	768,0
	dc.w	$FF00
	dcb.b	511,0
	dc.b	$FF
	dc.w	$FE03
	dc.w	$00C0
	dc.w	$0000,$4A40
	bne.s	.LFF7664
	bra.w	X_FF76C8
.LFF7664
	subi.w	#$1,d0
	bne.s	.LFF766E
	bra.w	X_FF77B8
.LFF766E
	subi.w	#$1,d0
	bne.s	.LFF7678
	bra.w	X_FF7A34
.LFF7678
	subi.w	#$1,d0
	bne.s	.LFF7682
	bra.w	X_FF7ADE
.LFF7682
	subi.w	#$1,d0
	bne.s	.LFF768C
	bra.w	X_FF7B36
.LFF768C
	subi.w	#$1,d0
	bne.s	.LFF7696
	bra.w	X_FF7B90
.LFF7696
	subi.w	#$1,d0
	bne.s	.LFF76A0
	bra.w	X_FF819C
.LFF76A0
	subi.w	#$1,d0
	bne.s	.LFF76AA
	bra.w	X_FF81B0
.LFF76AA
	subi.w	#$1,d0
	bne.s	.LFF76B4
	bra.w	X_FF81FA
.LFF76B4
	subi.w	#$1,d0
	bne.s	.LFF76BE
	bra.w	X_FF82F8
.LFF76BE
	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
