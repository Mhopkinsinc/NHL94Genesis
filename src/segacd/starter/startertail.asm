;	STARTER.BIN $1AF0E-$1D5B7 (runtime $3C20E-$3E8B7).
;
;	After startergfx.asm to the end of the file: the credits text (read from the disc file: it names
;	real people) and small pieces of code and data, decoded as found. Not worked out yet.


X_3E4CF	equ	$3E4CF

	org	$3C20E

	dc.w	$0014,$4465
	incbin	..\cdbin\STARTER.BIN,$1AF12,16	;text, read from the disc file
	dc.w	$0010,$4D69
	incbin	..\cdbin\STARTER.BIN,$1AF26,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	ori.b	#$4,d2
	dc.w	$FF00
	dc.w	$0018,$4F72
	incbin	..\cdbin\STARTER.BIN,$1AF40,19	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AF56,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$0016,$5345
	incbin	..\cdbin\STARTER.BIN,$1AF6A,18	;text, read from the disc file
	dc.w	$0010,$5061
	incbin	..\cdbin\STARTER.BIN,$1AF80,11	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1AF8E,9	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1AF9A,10	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AFAA,12	;text, read from the disc file
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AFB8,12	;text, read from the disc file
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1AFC6,9	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$0016,$4D75
	incbin	..\cdbin\STARTER.BIN,$1AFD8,17	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AFEC,11	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AFFA,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0012,$4F72
	incbin	..\cdbin\STARTER.BIN,$1B00E,13	;text, read from the disc file
	dc.b	$00
	dc.w	$0010,$4469
	incbin	..\cdbin\STARTER.BIN,$1B020,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B032,10	;text, read from the disc file
	dc.w	$000A
	incbin	..\cdbin\STARTER.BIN,$1B03E,8	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0016,$4578
	incbin	..\cdbin\STARTER.BIN,$1B04E,17	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B062,9	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B072,12	;text, read from the disc file
	dc.w	$0010,$4D69
	incbin	..\cdbin\STARTER.BIN,$1B082,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$0016,$4173
	incbin	..\cdbin\STARTER.BIN,$1B096,17	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B0AA,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0016,$5465
	incbin	..\cdbin\STARTER.BIN,$1B0BE,18	;text, read from the disc file
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B0D2,12	;text, read from the disc file
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B0E0,10	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0016,$4465
	incbin	..\cdbin\STARTER.BIN,$1B0F2,18	;text, read from the disc file
	dc.w	$0010,$4E61
	incbin	..\cdbin\STARTER.BIN,$1B108,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$000A
	incbin	..\cdbin\STARTER.BIN,$1B11A,8	;text, read from the disc file
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B124,10	;text, read from the disc file
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B130,11	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B13E,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$001C,$506F
	incbin	..\cdbin\STARTER.BIN,$1B152,23	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B16C,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$001E,$4E48
	incbin	..\cdbin\STARTER.BIN,$1B180,25	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B19C,9	;text, read from the disc file
	dc.b	$00
	dc.w	$0010,$4A61
	incbin	..\cdbin\STARTER.BIN,$1B1AA,11	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B1B8,10	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0012,$506C
	incbin	..\cdbin\STARTER.BIN,$1B1CA,13	;text, read from the disc file
	dc.b	$00
	dc.w	$0010,$4967
	incbin	..\cdbin\STARTER.BIN,$1B1DC,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$0016,$506C
	incbin	..\cdbin\STARTER.BIN,$1B1F0,17	;text, read from the disc file
	dc.b	$00
	dc.w	$0010,$5374
	incbin	..\cdbin\STARTER.BIN,$1B206,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0012,$5370
	incbin	..\cdbin\STARTER.BIN,$1B21A,13	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B22A,12	;text, read from the disc file
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B238,10	;text, read from the disc file
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B244,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0012,$5370
	incbin	..\cdbin\STARTER.BIN,$1B258,13	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B268,10	;text, read from the disc file
	dc.w	$000A
	incbin	..\cdbin\STARTER.BIN,$1B274,8	;text, read from the disc file
	dc.w	$0012,$5269
	incbin	..\cdbin\STARTER.BIN,$1B280,14	;text, read from the disc file
	dc.w	$000A
	incbin	..\cdbin\STARTER.BIN,$1B290,8	;text, read from the disc file
	dc.w	$0004,$FF00
	ori.b	#$2,d2
	dc.w	$0004,$FF00
	dc.w	$0004,$FF00
	movea.l	#$C41C,sp
	move.w	#$0,$FF8020.l
	move.w	#$0,$FF8022.l
	move.w	#$0,$FF8024.l
	move.w	#$0,$FF8026.l
	move.w	#$0,$FF8028.l
	move.w	#$0,$FF802A.l
	move.w	#$0,$FF802C.l
	move.w	#$0,$FF802E.l
	move.b	#$0,$FF800F.l
	jsr	$2802E.l
	jsr	$280F2.l
	bclr.b	#$5,$FF800F.l
.L3C60A
	btst.b	#$7,$FF800E.l
	bne.s	.L3C60A
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C62C
	btst.b	#$6,$FF800E.l
	beq.s	.L3C62C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C646
	btst.b	#$6,$FF800E.l
	bne.s	.L3C646
	bclr.b	#$7,$FF800F.l
.L3C658
	btst.b	#$7,$FF800E.l
	bne.s	.L3C658
	move.w	#$8C00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C67A
	btst.b	#$6,$FF800E.l
	beq.s	.L3C67A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C694
	btst.b	#$6,$FF800E.l
	bne.s	.L3C694
	bclr.b	#$7,$FF800F.l
.L3C6A6
	btst.b	#$7,$FF800E.l
	bne.s	.L3C6A6
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C6C8
	btst.b	#$6,$FF800E.l
	beq.s	.L3C6C8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C6E2
	btst.b	#$6,$FF800E.l
	bne.s	.L3C6E2
	bclr.b	#$7,$FF800F.l
.L3C6F4
	btst.b	#$7,$FF800E.l
	bne.s	.L3C6F4
	move.w	#$9001,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C716
	btst.b	#$6,$FF800E.l
	beq.s	.L3C716
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C730
	btst.b	#$6,$FF800E.l
	bne.s	.L3C730
	bclr.b	#$7,$FF800F.l
.L3C742
	btst.b	#$7,$FF800E.l
	bne.s	.L3C742
	move.w	#$8238,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C764
	btst.b	#$6,$FF800E.l
	beq.s	.L3C764
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C77E
	btst.b	#$6,$FF800E.l
	bne.s	.L3C77E
	bclr.b	#$7,$FF800F.l
.L3C790
	btst.b	#$7,$FF800E.l
	bne.s	.L3C790
	move.w	#$8407,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C7B2
	btst.b	#$6,$FF800E.l
	beq.s	.L3C7B2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C7CC
	btst.b	#$6,$FF800E.l
	bne.s	.L3C7CC
	bclr.b	#$7,$FF800F.l
.L3C7DE
	btst.b	#$7,$FF800E.l
	bne.s	.L3C7DE
	move.w	#$8578,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C800
	btst.b	#$6,$FF800E.l
	beq.s	.L3C800
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C81A
	btst.b	#$6,$FF800E.l
	bne.s	.L3C81A
	bclr.b	#$7,$FF800F.l
.L3C82C
	btst.b	#$7,$FF800E.l
	bne.s	.L3C82C
	move.w	#$8D3D,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C84E
	btst.b	#$6,$FF800E.l
	beq.s	.L3C84E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C868
	btst.b	#$6,$FF800E.l
	bne.s	.L3C868
	bclr.b	#$7,$FF800F.l
.L3C87A
	btst.b	#$7,$FF800E.l
	bne.s	.L3C87A
	move.w	#$831C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C89C
	btst.b	#$6,$FF800E.l
	beq.s	.L3C89C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C8B6
	btst.b	#$6,$FF800E.l
	bne.s	.L3C8B6
	bclr.b	#$7,$FF800F.l
.L3C8C8
	btst.b	#$7,$FF800E.l
	bne.s	.L3C8C8
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C8EA
	btst.b	#$6,$FF800E.l
	beq.s	.L3C8EA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C904
	btst.b	#$6,$FF800E.l
	bne.s	.L3C904
	bclr.b	#$7,$FF800F.l
.L3C916
	btst.b	#$7,$FF800E.l
	bne.s	.L3C916
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C938
	btst.b	#$6,$FF800E.l
	beq.s	.L3C938
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C952
	btst.b	#$6,$FF800E.l
	bne.s	.L3C952
	bclr.b	#$7,$FF800F.l
.L3C964
	btst.b	#$7,$FF800E.l
	bne.s	.L3C964
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C986
	btst.b	#$6,$FF800E.l
	beq.s	.L3C986
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C9A0
	btst.b	#$6,$FF800E.l
	bne.s	.L3C9A0
	bclr.b	#$7,$FF800F.l
.L3C9B2
	btst.b	#$7,$FF800E.l
	bne.s	.L3C9B2
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C9D4
	btst.b	#$6,$FF800E.l
	beq.s	.L3C9D4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C9EE
	btst.b	#$6,$FF800E.l
	bne.s	.L3C9EE
	bclr.b	#$7,$FF800F.l
.L3CA00
	btst.b	#$7,$FF800E.l
	bne.s	.L3CA00
	move.l	#$74000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CA24
	btst.b	#$6,$FF800E.l
	beq.s	.L3CA24
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CA3E
	btst.b	#$6,$FF800E.l
	bne.s	.L3CA3E
	bclr.b	#$7,$FF800F.l
.L3CA50
	btst.b	#$7,$FF800E.l
	bne.s	.L3CA50
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CA72
	btst.b	#$6,$FF800E.l
	beq.s	.L3CA72
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CA8C
	btst.b	#$6,$FF800E.l
	bne.s	.L3CA8C
	bclr.b	#$7,$FF800F.l
.L3CA9E
	btst.b	#$7,$FF800E.l
	bne.s	.L3CA9E
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CAC0
	btst.b	#$6,$FF800E.l
	beq.s	.L3CAC0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CADA
	btst.b	#$6,$FF800E.l
	bne.s	.L3CADA
	bclr.b	#$7,$FF800F.l
.L3CAEC
	btst.b	#$7,$FF800E.l
	bne.s	.L3CAEC
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CB10
	btst.b	#$6,$FF800E.l
	beq.s	.L3CB10
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CB2A
	btst.b	#$6,$FF800E.l
	bne.s	.L3CB2A
	bclr.b	#$7,$FF800F.l
.L3CB3C
	btst.b	#$7,$FF800E.l
	bne.s	.L3CB3C
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CB5E
	btst.b	#$6,$FF800E.l
	beq.s	.L3CB5E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CB78
	btst.b	#$6,$FF800E.l
	bne.s	.L3CB78
	bclr.b	#$7,$FF800F.l
.L3CB8A
	btst.b	#$7,$FF800E.l
	bne.s	.L3CB8A
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CBAC
	btst.b	#$6,$FF800E.l
	beq.s	.L3CBAC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CBC6
	btst.b	#$6,$FF800E.l
	bne.s	.L3CBC6
	bclr.b	#$7,$FF800F.l
.L3CBD8
	btst.b	#$7,$FF800E.l
	bne.s	.L3CBD8
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CBFC
	btst.b	#$6,$FF800E.l
	beq.s	.L3CBFC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CC16
	btst.b	#$6,$FF800E.l
	bne.s	.L3CC16
	bclr.b	#$7,$FF800F.l
.L3CC28
	btst.b	#$7,$FF800E.l
	bne.s	.L3CC28
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CC4C
	btst.b	#$6,$FF800E.l
	beq.s	.L3CC4C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CC66
	btst.b	#$6,$FF800E.l
	bne.s	.L3CC66
	bclr.b	#$7,$FF800F.l
.L3CC78
	btst.b	#$7,$FF800E.l
	bne.s	.L3CC78
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CC92
	btst.b	#$6,$FF800E.l
	beq.s	.L3CC92
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CCAC
	btst.b	#$6,$FF800E.l
	bne.s	.L3CCAC
	bclr.b	#$7,$FF800F.l
	move.l	#$2,d7
	movea.l	#$29000,a0
	jsr	$6044.w
	bclr.b	#$5,$FF800F.l
	move.l	#$2746A,$C432.l
	jsr	$27A12.l
	bset.b	#$5,$FF800F.l
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.L3CCF6
	clr.l	(a0)+
	dbf	d0,.L3CCF6
	move.w	#$18,$C43E.l
.L3CD04
	tst.w	$C43E.l
	bpl.w	.L3CD04
.L3CD0E
	btst.b	#$7,$FF800E.l
	bne.s	.L3CD0E
	move.w	#$8C81,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CD30
	btst.b	#$6,$FF800E.l
	beq.s	.L3CD30
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CD4A
	btst.b	#$6,$FF800E.l
	bne.s	.L3CD4A
	bclr.b	#$7,$FF800F.l
.L3CD5C
	btst.b	#$7,$FF800E.l
	bne.s	.L3CD5C
	move.w	#$8230,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CD7E
	btst.b	#$6,$FF800E.l
	beq.s	.L3CD7E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CD98
	btst.b	#$6,$FF800E.l
	bne.s	.L3CD98
	bclr.b	#$7,$FF800F.l
.L3CDAA
	btst.b	#$7,$FF800E.l
	bne.s	.L3CDAA
	move.w	#$8407,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CDCC
	btst.b	#$6,$FF800E.l
	beq.s	.L3CDCC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CDE6
	btst.b	#$6,$FF800E.l
	bne.s	.L3CDE6
	bclr.b	#$7,$FF800F.l
.L3CDF8
	btst.b	#$7,$FF800E.l
	bne.s	.L3CDF8
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CE12
	btst.b	#$6,$FF800E.l
	beq.s	.L3CE12
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CE2C
	btst.b	#$6,$FF800E.l
	bne.s	.L3CE2C
	bclr.b	#$7,$FF800F.l
	jsr	$26DC6.l
	tst.w	$C450.l
	beq.w	.L3CEB4
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.L3CE56
	clr.l	(a0)+
	dbf	d0,.L3CE56
	move.w	#$18,$C43E.l
.L3CE64
	tst.w	$C43E.l
	bpl.w	.L3CE64
.L3CE6E
	btst.b	#$7,$FF800E.l
	bne.s	.L3CE6E
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CE88
	btst.b	#$6,$FF800E.l
	beq.s	.L3CE88
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CEA2
	btst.b	#$6,$FF800E.l
	bne.s	.L3CEA2
	bclr.b	#$7,$FF800F.l
.L3CEB4
	bclr.b	#$5,$FF800F.l
	jsr	$27A6A.l
	move.l	#$2,d7
	movea.l	#$1B000,a0
	jsr	$6044.w
	move.l	#$400,d1
	move.w	#$85,d0
	jsr	$5F22.w
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w
.L3CEEC
	btst.b	#$7,$FF800E.l
	bne.s	.L3CEEC
	move.w	#$3E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CF06
	btst.b	#$6,$FF800E.l
	beq.s	.L3CF06
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CF20
	btst.b	#$6,$FF800E.l
	bne.s	.L3CF20
	bclr.b	#$7,$FF800F.l
	move.w	#$2500,sr
	bset.b	#$2,$FF8033.l
	move.w	#$4,d0
	move.l	#$ADA,d1
	move.l	#$6038,d2
	move.l	#$29000,d3
	move.l	#$80000,d4
	sub.l	d3,d4
	bset.b	#$5,$FF800F.l
	jsr	$C4B6.l
	movea.l	#$C41C,sp
	jsr	$2802E.l
.L3CF76
	bclr.b	#$2,$FF8003.l
	bne.s	.L3CF76
	jsr	$2800E.l
	move.w	#$2000,sr
	bset.b	#$2,$FF8033.l
	movea.l	#$80000,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$5,d0
	jsr	$6044.w
	movea.l	a0,a0
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.l	$B090.l,$6038.w
.L3CFBE
	btst.b	#$7,$FF800E.l
	bne.s	.L3CFBE
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CFD8
	btst.b	#$6,$FF800E.l
	beq.s	.L3CFD8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3CFF2
	btst.b	#$6,$FF800E.l
	bne.s	.L3CFF2
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	bset.b	#$2,$FF8033.l
	bsr.w	.L3E31A
.L3D018
	btst.b	#$7,$FF800E.l
	bne.s	.L3D018
	move.w	#$3F,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D032
	btst.b	#$6,$FF800E.l
	beq.s	.L3D032
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D04C
	btst.b	#$6,$FF800E.l
	bne.s	.L3D04C
	bclr.b	#$7,$FF800F.l
	bsr.w	.L3E30E
	move.l	$B090.l,$6038.w
.L3D06A
	btst.b	#$7,$FF800E.l
	bne.s	.L3D06A
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D084
	btst.b	#$6,$FF800E.l
	beq.s	.L3D084
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D09E
	btst.b	#$6,$FF800E.l
	bne.s	.L3D09E
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	bset.b	#$2,$FF8033.l
	jmp	$B00E.l
	move.w	#$0,d0
	move.w	#$B,d7
	jsr	$6044.w
	jsr	$26EAA.l
	move.w	#$0,d0
	lea	$7D000.l,a0
	lea	$7C000.l,a1
	jsr	$5F16.w
	bcc.w	.L3D10A
	jsr	$26EBE.l
	cmpi.w	#$FFFF,$C442.l
	beq.w	.L3D16A
	move.w	#$6,d0
	jsr	$5F16.w
.L3D10A
	move.w	#$3,d0
	lea	$26E78.l,a0
	lea	$7F000.l,a1
	jsr	$5F16.w
	bcs.w	.L3D138
	jsr	$26E96.l
	cmp.l	$7FF20.l,d0
	beq.w	.L3D176
	jsr	$26EAA.l
.L3D138
	move.w	#$5,d0
	lea	$26E78.l,a0
	jsr	$5F16.w
	move.w	#$1,d0
	lea	$C452.l,a1
	jsr	$5F16.w
	cmpi.w	#$3D,d0
	bge.w	.L3D176
	move.w	#$1,$C44C.l
	jsr	$26EBE.l
.L3D16A
	move.w	#$FFFF,d0
	move.w	#$B,d7
	jsr	$6044.w
.L3D176
	incbin	..\cdbin\STARTER.BIN,$1BE76,13	;text, read from the disc file
	dc.b	$00
	ori.b	#$0,d0
	incbin	..\cdbin\STARTER.BIN,$1BE88,11	;text, read from the disc file
	dc.b	$00
	dc.w	$003D
	lea	$7F000.l,a0
	moveq	#$0,d0
	move.w	#$F1F,d1
.L3D1A2
	add.b	(a0)+,d0
	dbf	d1,.L3D1A2
	rts
	lea	$7F000.l,a0
	move.w	#$F1F,d0
	clr.l	d1
.L3D1B6
	move.b	d1,(a0)+
	dbf	d0,.L3D1B6
	rts
	movem.l	d0-d7/a0-a2,-(sp)
	move.w	#$1,$C450.l
	tst.w	$C44E.l
	bne.w	.L3D5A2
	bset.b	#$5,$FF800F.l
	movea.l	#$BBCB0,a1
	moveq	#$1F,d0
.L3D1E4
	clr.l	(a1)+
	dbf	d0,.L3D1E4
	move.w	#$64,$C43E.l
.L3D1F2
	tst.w	$C43E.l
	bpl.w	.L3D1F2
	move.l	#$2,d7
	movea.l	#$80000,a0
	jsr	$6044.w
	move.w	#$20,$C448.l
	lea	$282B4.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	$C448.l,d1
	lea	$4(a1),a0
	jsr	$2790E.l
	add.w	d2,d2
	add.w	d2,$C448.l
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$61,d0
	jsr	$6044.w
	move.l	a0,$C436.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$C436.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	$C448.l,d1
	move.w	d1,d5
	lsr.w	#$5,d5
	lea	$4(a1),a0
	jsr	$2790E.l
	add.w	d2,d2
	add.w	d2,$C448.l
	lea	$4(a1,d2.w),a0
	movea.l	#$BBCB0,a1
	moveq	#$1F,d0
.L3D28A
	move.l	(a0)+,(a1)+
	dbf	d0,.L3D28A
	move.l	#$EEE,$BBCD2.l
	move.l	#$4440666,$BBCF2.l
	move.w	#$E000,d0
	bsr.w	.L3D6AA
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	incbin	..\cdbin\STARTER.BIN,$1BFB0,7	;text, read from the disc file
	dc.b	$01
	move.w	#$80,d7
	moveq	#$0,d4
	move.w	#$E000,d4
.L3D2C2
	move.l	d4,d0
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.L3D2D8
	btst.b	#$7,$FF800E.l
	bne.s	.L3D2D8
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D2F8
	btst.b	#$6,$FF800E.l
	beq.s	.L3D2F8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D312
	btst.b	#$6,$FF800E.l
	bne.s	.L3D312
	bclr.b	#$7,$FF800F.l
.L3D324
	move.w	(a2)+,d6
	add.w	d5,d6
.L3D328
	btst.b	#$7,$FF800E.l
	bne.s	.L3D328
	move.w	d6,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D348
	btst.b	#$6,$FF800E.l
	beq.s	.L3D348
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D362
	btst.b	#$6,$FF800E.l
	bne.s	.L3D362
	bclr.b	#$7,$FF800F.l
	dbf	d1,.L3D324
	move.w	d3,d1
	add.w	d7,d4
	dbf	d2,.L3D2C2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$40,d0
	jsr	$6044.w
	move.l	a0,$C43A.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$C43A.l,a1
	move.w	$2(a1),d0
	lsl.w	#$3,d0
	move.l	#$11111111,d1
	lea	$4(a1),a1
.L3D3B0
	add.l	d1,(a1)+
	dbf	d0,.L3D3B0
	movea.l	$C43A.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	$C448.l,d1
	move.w	d1,$C44A.l
	lea	$4(a1),a0
	jsr	$2790E.l
	move.w	#$C000,d0
	bsr.w	.L3D6AA
	tst.w	$C44C.l
	bne.w	.L3D580
	moveq	#$0,d4
	move.w	#$C31A,d4
	move.w	#$20,d5
	lsr.w	#$5,d5
	bset	#$E,d5
	moveq	#$4,d1
	move.w	d1,d3
	moveq	#$2,d2
	move.w	#$80,d7
.L3D406
	move.l	d4,d0
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.L3D41C
	btst.b	#$7,$FF800E.l
	bne.s	.L3D41C
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D43C
	btst.b	#$6,$FF800E.l
	beq.s	.L3D43C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D456
	btst.b	#$6,$FF800E.l
	bne.s	.L3D456
	bclr.b	#$7,$FF800F.l
.L3D468
	btst.b	#$7,$FF800E.l
	bne.s	.L3D468
	move.w	d5,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D488
	btst.b	#$6,$FF800E.l
	beq.s	.L3D488
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D4A2
	btst.b	#$6,$FF800E.l
	bne.s	.L3D4A2
	bclr.b	#$7,$FF800F.l
	addi.w	#$1,d5
	dbf	d1,.L3D468
	move.w	d3,d1
	add.w	d7,d4
	dbf	d2,.L3D406
.L3D4C4
	btst.b	#$7,$FF800E.l
	bne.s	.L3D4C4
	move.l	#$74000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D4E8
	btst.b	#$6,$FF800E.l
	beq.s	.L3D4E8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D502
	btst.b	#$6,$FF800E.l
	bne.s	.L3D502
	bclr.b	#$7,$FF800F.l
.L3D514
	btst.b	#$7,$FF800E.l
	bne.s	.L3D514
	move.w	#$3B,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D536
	btst.b	#$6,$FF800E.l
	beq.s	.L3D536
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D550
	btst.b	#$6,$FF800E.l
	bne.s	.L3D550
	bclr.b	#$7,$FF800F.l
	move.w	#$3B,$C444.l
	lea	.L3E3FE(pc),a0
	move.w	#$5B,d0
	moveq	#$9,d1
.L3D574
	bsr.w	.L3DAF8
	addi.w	#$28,d0
	dbf	d1,.L3D574
.L3D580
	bset.b	#$5,$FF800F.l
	move.w	#$18,$C43E.l
.L3D590
	tst.w	$C43E.l
	bpl.w	.L3D590
	move.w	#$1,$C44E.l
.L3D5A2
	tst.w	$C44C.l
	bne.w	.L3D668
.L3D5AC
	clr.w	$C446.l
.L3D5B2
	tst.w	$C446.l
	beq.w	.L3D5B2
	bsr.w	.L3E25A
	cmpi.b	#$4,d1
	beq.w	.L3D5DC
	cmpi.b	#$8,d1
	beq.w	.L3D5F8
	cmpi.b	#$20,d1
	beq.w	.L3D620
	bra.w	.L3D5AC
.L3D5DC
	tst.w	$C442.l
	bpl.w	.L3D5AC
	clr.w	$C442.l
	move.w	#$FFFE,$C440.l
	bra.w	.L3D612
.L3D5F8
	tst.w	$C442.l
	bmi.w	.L3D5AC
	move.w	#$FFFF,$C442.l
	move.w	#$2,$C440.l
.L3D612
	tst.w	$C440.l
	bne.w	.L3D612
	bra.w	.L3D5AC
.L3D620
	cmpi.w	#$FFFF,$C442.l
	beq.w	.L3D664
	lea	.L3E4BC(pc),a0
	move.w	#$213,d0
	bsr.w	.L3DAF8
	moveq	#$3,d1
	moveq	#$F,d2
	move.w	d2,d3
	addi.w	#$A,d0
.L3D642
	clr.w	$C446.l
.L3D648
	tst.w	$C446.l
	beq.w	.L3D648
	dbf	d2,.L3D642
	move.w	d3,d2
	bsr.w	.L3DAF8
	addi.w	#$1,d0
	dbf	d1,.L3D642
.L3D664
	bra.w	.L3D6A4
.L3D668
	move.w	#$C000,d0
	bsr.w	.L3D6AA
	move.w	#$B,d1
	move.w	#$5B,d0
	lea	X_3E4CF(pc),a0
.L3D67C
	bsr.w	.L3DAF8
	addi.w	#$28,d0
	dbf	d1,.L3D67C
.L3D688
	clr.w	$C446.l
.L3D68E
	tst.w	$C446.l
	beq.w	.L3D68E
	bsr.w	.L3E25A
	cmpi.b	#$20,d1
	bne.w	.L3D688
.L3D6A4
	movem.l	(sp)+,d0-d7/a0-a2
	rts
.L3D6AA
	movem.l	d0-d2,-(sp)
	move.w	#$0,d1
	lsr.w	#$5,d1
	moveq	#$0,d2
	move.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.L3D6C4
	btst.b	#$7,$FF800E.l
	bne.s	.L3D6C4
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D6E4
	btst.b	#$6,$FF800E.l
	beq.s	.L3D6E4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D6FE
	btst.b	#$6,$FF800E.l
	bne.s	.L3D6FE
	bclr.b	#$7,$FF800F.l
	move.w	#$7FF,d2
.L3D714
	btst.b	#$7,$FF800E.l
	bne.s	.L3D714
	move.w	d1,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D734
	btst.b	#$6,$FF800E.l
	beq.s	.L3D734
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D74E
	btst.b	#$6,$FF800E.l
	bne.s	.L3D74E
	bclr.b	#$7,$FF800F.l
	dbf	d2,.L3D714
	movem.l	(sp)+,d0-d2
	rts
	movem.l	d0-d7/a0,-(sp)
	tst.w	$C440.l
	beq.w	.L3D99A
.L3D778
	btst.b	#$4,$FF800E.l
	bne.s	.L3D778
	move.w	#$30,$FF8026.l
	move.l	#$74000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3D79C
	btst.b	#$3,$FF800E.l
	beq.s	.L3D79C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3D7B6
	btst.b	#$3,$FF800E.l
	bne.s	.L3D7B6
	bclr.b	#$4,$FF800F.l
.L3D7C8
	btst.b	#$4,$FF800E.l
	bne.s	.L3D7C8
	move.w	#$31,$FF8026.l
	move.w	$C444.l,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3D7EC
	btst.b	#$3,$FF800E.l
	beq.s	.L3D7EC
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3D806
	btst.b	#$3,$FF800E.l
	bne.s	.L3D806
	bclr.b	#$4,$FF800F.l
	move.w	$C440.l,d0
	add.w	d0,$C444.l
	tst.w	$C440.l
	bpl.w	.L3D8E2
	cmpi.w	#$0,$C444.l
	bgt.w	.L3D99A
	clr.w	$C444.l
.L3D840
	btst.b	#$4,$FF800E.l
	bne.s	.L3D840
	move.w	#$30,$FF8026.l
	move.l	#$74000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3D864
	btst.b	#$3,$FF800E.l
	beq.s	.L3D864
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3D87E
	btst.b	#$3,$FF800E.l
	bne.s	.L3D87E
	bclr.b	#$4,$FF800F.l
.L3D890
	btst.b	#$4,$FF800E.l
	bne.s	.L3D890
	move.w	#$31,$FF8026.l
	move.w	#$0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3D8B2
	btst.b	#$3,$FF800E.l
	beq.s	.L3D8B2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3D8CC
	btst.b	#$3,$FF800E.l
	bne.s	.L3D8CC
	bclr.b	#$4,$FF800F.l
	bra.w	.L3D994
.L3D8E2
	cmpi.w	#$3B,$C444.l
	blt.w	.L3D99A
.L3D8EE
	btst.b	#$4,$FF800E.l
	bne.s	.L3D8EE
	move.w	#$30,$FF8026.l
	move.l	#$74000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3D912
	btst.b	#$3,$FF800E.l
	beq.s	.L3D912
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3D92C
	btst.b	#$3,$FF800E.l
	bne.s	.L3D92C
	bclr.b	#$4,$FF800F.l
.L3D93E
	btst.b	#$4,$FF800E.l
	bne.s	.L3D93E
	move.w	#$31,$FF8026.l
	move.w	#$3B,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3D960
	btst.b	#$3,$FF800E.l
	beq.s	.L3D960
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3D97A
	btst.b	#$3,$FF800E.l
	bne.s	.L3D97A
	bclr.b	#$4,$FF800F.l
	move.w	#$3B,$C444.l
.L3D994
	clr.w	$C440.l
.L3D99A
	tst.w	$C43E.l
	bmi.w	.L3DA3E
	cmpi.w	#$64,$C43E.l
	beq.w	.L3DA44
	subq.w	#$1,$C43E.l
	bmi.w	.L3DA3E
	clr.l	d0
	move.w	$C43E.l,d0
	cmpi.w	#$18,d0
	bgt.w	.L3DA3E
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	move.l	d3,$BBC88.l
	move.l	d4,$BBC8C.l
	move.l	d5,$BBC90.l
	bsr.w	.L3E31A
.L3D9F4
	btst.b	#$4,$FF800E.l
	bne.s	.L3D9F4
	move.w	#$1D,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3DA0E
	btst.b	#$3,$FF800E.l
	beq.s	.L3DA0E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3DA28
	btst.b	#$3,$FF800E.l
	bne.s	.L3DA28
	bclr.b	#$4,$FF800F.l
	bsr.w	.L3E30E
.L3DA3E
	movem.l	(sp)+,d0-d7/a0
	rts
.L3DA44
	movea.l	#$BBCB0,a1
.L3DA4A
	btst.b	#$4,$FF800E.l
	bne.s	.L3DA4A
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3DA6E
	btst.b	#$3,$FF800E.l
	beq.s	.L3DA6E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3DA88
	btst.b	#$3,$FF800E.l
	bne.s	.L3DA88
	bclr.b	#$4,$FF800F.l
	moveq	#$1F,d0
.L3DA9C
	btst.b	#$4,$FF800E.l
	bne.s	.L3DA9C
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3DABC
	btst.b	#$3,$FF800E.l
	beq.s	.L3DABC
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3DAD6
	btst.b	#$3,$FF800E.l
	bne.s	.L3DAD6
	bclr.b	#$4,$FF800F.l
	dbf	d0,.L3DA9C
	st.b	$C43E.l
	movem.l	(sp)+,d0-d7/a0
	rts
.L3DAF8
	movem.l	d0-d2/a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$6,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	#$E000,d2
	add.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.L3DB24
	btst.b	#$7,$FF800E.l
	bne.s	.L3DB24
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3DB44
	btst.b	#$6,$FF800E.l
	beq.s	.L3DB44
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3DB5E
	btst.b	#$6,$FF800E.l
	bne.s	.L3DB5E
	bclr.b	#$7,$FF800F.l
	bsr.w	.L3DB7A
	movem.l	(sp)+,d0-d2/a1/a5
	rts
.L3DB7A
	move.w	$C44A.l,d0
	lsr.w	#$5,d0
	bset	#$D,d0
.L3DB86
	moveq	#$0,d2
	move.b	(a0)+,d2
	beq.w	.L3DC0C
	cmpi.b	#$22,d2
	beq.w	.L3DBAA
	cmpi.b	#$5F,d2
	beq.w	.L3DBAA
	cmpi.b	#$24,d2
	beq.w	.L3DBB2
	bra.w	.L3DBB6
.L3DBAA
	move.b	#$20,d2
	bra.w	.L3DBB6
.L3DBB2
	move.b	#$22,d2
.L3DBB6
	subi.b	#$20,d2
	add.w	d0,d2
.L3DBBC
	btst.b	#$7,$FF800E.l
	bne.s	.L3DBBC
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3DBDC
	btst.b	#$6,$FF800E.l
	beq.s	.L3DBDC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3DBF6
	btst.b	#$6,$FF800E.l
	bne.s	.L3DBF6
	bclr.b	#$7,$FF800F.l
	bra.w	.L3DB86
.L3DC0C
	rts
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	.L3DC32
	move.l	d0,d3
	lsr.w	#$1,d3
	lea	$BC000.l,a2
.L3DC26
	move.l	(a0)+,(a2)+
	dbf	d3,.L3DC26
	lea	$BC000.l,a0
.L3DC32
	lea	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,$BBC90.l
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,$BBC92.l
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$BBC9E.l
	jsr	$2801A.l
.L3DCC0
	btst.b	#$7,$FF800E.l
	bne.s	.L3DCC0
	move.w	#$8,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3DCDA
	btst.b	#$6,$FF800E.l
	beq.s	.L3DCDA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3DCF4
	btst.b	#$6,$FF800E.l
	bne.s	.L3DCF4
	bclr.b	#$7,$FF800F.l
	jsr	$2800E.l
	movem.l	(sp)+,d2-d3/a1-a2
	rts
	move.l	$6038.w,$C42E.l
	move.l	#$27A74,$6038.w
.L3DD22
	btst.b	#$7,$FF800E.l
	bne.s	.L3DD22
	move.w	#$2D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3DD3C
	btst.b	#$6,$FF800E.l
	beq.s	.L3DD3C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3DD56
	btst.b	#$6,$FF800E.l
	bne.s	.L3DD56
	bclr.b	#$7,$FF800F.l
	rts
	move.l	$C42E.l,$6038.w
	rts
	btst.b	#$5,$FF800E.l
	beq.w	.L3DDF2
	move.w	#$1,$C446.l
	bset.b	#$2,$FF800F.l
	move.l	#$27A9E,-(sp)
	move.l	$C432.l,-(sp)
	rts
	jsr	$27B38.l
.L3DDA4
	btst.b	#$4,$FF800E.l
	bne.s	.L3DDA4
	move.w	#$2F,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3DDBE
	btst.b	#$3,$FF800E.l
	beq.s	.L3DDBE
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3DDD8
	btst.b	#$3,$FF800E.l
	bne.s	.L3DDD8
	bclr.b	#$4,$FF800F.l
	bclr.b	#$2,$FF800F.l
.L3DDF2
	rts
	move.l	a5,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	movem.l	d0-d7/a0-a4/a6,-(sp)
	btst.b	#$0,$FF800F.l
	beq.w	.L3DE1E
	btst.b	#$1,$FF800E.l
	beq.s	.L3DE1E
	move.w	#$A,d7
	jsr	$6044.w
.L3DE1E
	movem.l	(sp)+,d0-d7/a0-a4/a6
	movea.l	#$FF8000,a5
	move.w	(sp)+,sr
	incbin	..\cdbin\STARTER.BIN,$1CB2A,15	;text, read from the disc file
	dc.b	$E7
	negx.l	d0
	bsr.w	.L3DFAA
	move.b	d0,$2800A.l
	bsr.w	.L3DFA2
	move.b	d0,$2800B.l
	movem.l	(sp)+,d1/a0
	rts
.L3DE56
	btst.b	#$4,$FF800E.l
	bne.s	.L3DE56
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3DE78
	btst.b	#$4,$FF800E.l
	beq.s	.L3DE78
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3DE92
	btst.b	#$3,$FF800E.l
	bne.s	.L3DE92
	bclr.b	#$4,$FF800F.l
	bra.w	.L3DF9A
.L3DEA8
	btst.b	#$4,$FF800E.l
	bne.s	.L3DEA8
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3DECA
	btst.b	#$4,$FF800E.l
	beq.s	.L3DECA
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3DEE4
	btst.b	#$3,$FF800E.l
	bne.s	.L3DEE4
	bclr.b	#$4,$FF800F.l
	bra.w	.L3DF9A
.L3DEFA
	btst.b	#$4,$FF800E.l
	bne.s	.L3DEFA
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3DF1C
	btst.b	#$4,$FF800E.l
	beq.s	.L3DF1C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3DF36
	btst.b	#$3,$FF800E.l
	bne.s	.L3DF36
	bclr.b	#$4,$FF800F.l
	bra.w	.L3DF9A
.L3DF4C
	btst.b	#$4,$FF800E.l
	bne.s	.L3DF4C
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3DF6E
	btst.b	#$4,$FF800E.l
	beq.s	.L3DF6E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3DF88
	btst.b	#$3,$FF800E.l
	bne.s	.L3DF88
	bclr.b	#$4,$FF800F.l
.L3DF9A
	movem.l	d1/a0,-(sp)
	bra.w	.L3DFAE
.L3DFA2
	movem.l	d1/a0,-(sp)
	bra.w	.L3E0E8
.L3DFAA
	movem.l	d1/a0,-(sp)
.L3DFAE
	moveq	#$0,d0
.L3DFB0
	btst.b	#$4,$FF800E.l
	bne.s	.L3DFB0
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3DFD2
	btst.b	#$3,$FF800E.l
	beq.s	.L3DFD2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3DFEC
	btst.b	#$3,$FF800E.l
	bne.s	.L3DFEC
	bclr.b	#$4,$FF800F.l
.L3DFFE
	btst.b	#$4,$FF800E.l
	bne.s	.L3DFFE
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3E018
	btst.b	#$3,$FF800E.l
	beq.s	.L3E018
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3E038
	btst.b	#$3,$FF800E.l
	bne.s	.L3E038
	bclr.b	#$4,$FF800F.l
.L3E04A
	btst.b	#$4,$FF800E.l
	bne.s	.L3E04A
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3E06C
	btst.b	#$3,$FF800E.l
	beq.s	.L3E06C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3E086
	btst.b	#$3,$FF800E.l
	bne.s	.L3E086
	bclr.b	#$4,$FF800F.l
.L3E098
	btst.b	#$4,$FF800E.l
	bne.s	.L3E098
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3E0B2
	btst.b	#$3,$FF800E.l
	beq.s	.L3E0B2
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3E0D2
	btst.b	#$3,$FF800E.l
	bne.s	.L3E0D2
	bclr.b	#$4,$FF800F.l
	bra.w	.L3E222
.L3E0E8
	moveq	#$0,d0
.L3E0EA
	btst.b	#$4,$FF800E.l
	bne.s	.L3E0EA
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3E10C
	btst.b	#$4,$FF800E.l
	beq.s	.L3E10C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3E126
	btst.b	#$3,$FF800E.l
	bne.s	.L3E126
	bclr.b	#$4,$FF800F.l
.L3E138
	btst.b	#$4,$FF800E.l
	bne.s	.L3E138
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3E152
	btst.b	#$3,$FF800E.l
	beq.s	.L3E152
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3E172
	btst.b	#$3,$FF800E.l
	bne.s	.L3E172
	bclr.b	#$4,$FF800F.l
.L3E184
	btst.b	#$4,$FF800E.l
	bne.s	.L3E184
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3E1A6
	btst.b	#$4,$FF800E.l
	beq.s	.L3E1A6
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3E1C0
	btst.b	#$3,$FF800E.l
	bne.s	.L3E1C0
	bclr.b	#$4,$FF800F.l
.L3E1D2
	btst.b	#$4,$FF800E.l
	bne.s	.L3E1D2
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3E1EC
	btst.b	#$3,$FF800E.l
	beq.s	.L3E1EC
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3E20C
	btst.b	#$3,$FF800E.l
	bne.s	.L3E20C
	bclr.b	#$4,$FF800F.l
	bra.w	.L3E222
.L3E222
	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea	.L3E24A(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.L3E24A
	dc.w	$0001,$0201
	dc.w	$0405,$0606
	dc.w	$0809
	dc.w	$0A0A
	dc.w	$0809
	dc.w	$0A00
.L3E25A
	move.b	$2800A.l,d0
	bsr.w	.L3E2D2
	move.w	$28002.l,d2
	move.w	d1,$28002.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$2800B.l,d0
	bsr.w	.L3E2D2
	move.w	$28004.l,d2
	move.w	d1,$28004.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$2800C.l,d0
	bsr.w	.L3E2D2
	move.w	$28006.l,d2
	move.w	d1,$28006.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$2800D.l,d0
	bsr.w	.L3E2D2
	move.w	$28008.l,d2
	move.w	d1,$28008.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.L3E2D2
	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea	$27FF2.l,a0
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
.L3E30E
	btst.b	#$1,$FF8003.l
	beq.s	.L3E30E
	rts
.L3E31A
	bset.b	#$0,$FF8003.l
.L3E322
	btst.b	#$1,$FF8003.l
	bne.s	.L3E322
	rts
.L3E32E
	btst.b	#$7,$FF800E.l
	bne.s	.L3E32E
.L3E338
	btst.b	#$6,$FF800E.l
	beq.s	.L3E338
	bset.b	#$6,$FF800F.l
	bset.b	#$7,$FF800F.l
.L3E352
	btst.b	#$6,$FF800E.l
	bne.s	.L3E352
	bclr.b	#$6,$FF800F.l
	bclr.b	#$7,$FF800F.l
	rts
	move.w	#$7,d2
.L3E372
	move.b	d2,d3
	addi.w	#$40,d3
	move.b	d3,$FF000F.l
	move.b	#$0,$FF000D.l
	move.b	#$0,$FF000B.l
	move.b	#$0,$FF0009.l
	dbf	d2,.L3E372
	move.b	#$40,$FF000F.l
	move.b	#$80,$FF000F.l
	move.w	#$F,d2
.L3E3AE
	move.w	#$FFF,d0
	move.l	#$0,d1
	movea.l	#$FF2001,a0
	move.b	d2,$FF000D.l
.L3E3C4
	move.b	d1,$0(a0)
	adda.w	#$2,a0
	dbf	d0,.L3E3C4
	dbf	d2,.L3E3AE
	move.b	#$FF,$FF0011.l
	rts
	movem.l	d0-d1/a0-a1,-(sp)
.L3E3E2
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.s	.L3E3E2
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.L3E3F2
	bclr.b	#$2,$FF8003.l
	bne.s	.L3E3F2
	rts
.L3E3FE
	incbin	..\cdbin\STARTER.BIN,$1D0FE,18	;text, read from the disc file
	ori.w	#$6163,d2
	incbin	..\cdbin\STARTER.BIN,$1D114,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D124,18	;text, read from the disc file
	dc.w	$0077,$616E,$7420
	incbin	..\cdbin\STARTER.BIN,$1D13C,13	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D14A,18	;text, read from the disc file
	dc.w	$0020,$2020
	incbin	..\cdbin\STARTER.BIN,$1D160,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D170,18	;text, read from the disc file
	ori.w	#$7573,(a0)
	incbin	..\cdbin\STARTER.BIN,$1D186,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D196,18	;text, read from the disc file
	dc.w	$0020,$2020
	incbin	..\cdbin\STARTER.BIN,$1D1AC,15	;text, read from the disc file
	dc.b	$00
.L3E4BC
	incbin	..\cdbin\STARTER.BIN,$1D1BC,10	;text, read from the disc file
	ori.b	#$2E,$2E(a6)
	ori.b	#$20,$2020(a6)
	incbin	..\cdbin\STARTER.BIN,$1D1D2,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D1E2,18	;text, read from the disc file
	dc.w	$0073
	incbin	..\cdbin\STARTER.BIN,$1D1F6,17	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D208,18	;text, read from the disc file
	ori.w	#$6F75,$206D7573.l
	incbin	..\cdbin\STARTER.BIN,$1D222,11	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D22E,18	;text, read from the disc file
	ori.w	#$6E20,$7468(a1)
	incbin	..\cdbin\STARTER.BIN,$1D246,13	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D254,18	;text, read from the disc file
	dc.w	$0020,$2020
	incbin	..\cdbin\STARTER.BIN,$1D26A,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D27A,18	;text, read from the disc file
	ori.w	#$6620,$796F(a1)
	incbin	..\cdbin\STARTER.BIN,$1D292,13	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D2A0,18	;text, read from the disc file
	dc.w	$0000,$0808
	ori.b	#$0,(a0)+
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$3,d0
	move.b	(a1),-(a0)
	dc.w	$0002,$3111
	dc.w	$0002,$2300
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.w	d0,d0
	move.b	(a3),-(a0)
	move.l	d0,d0
	dc.w	$0032,$2000,$0022
	move.l	d0,d0
	dc.w	$0022,$2000
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dcb.b	97,0
	dc.b	$22
	move.l	d0,d0
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$3311
	dc.w	$0003,$1111
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	17,0
	dc.b	$22
	move.l	d0,d0
	dc.w	$0032
	move.l	d0,d0
	move.b	(a3),-(a0)
	move.l	d0,d0
	move.b	(a1),-(a0)
	move.w	d0,d0
	dcb.b	304,0
