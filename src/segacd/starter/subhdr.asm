;	STARTER.BIN $90-$1541 (runtime $B090-$C541).
;
;	Zeros after subboot.asm, then the start of the sub CPU driver module: a
;	file record (HOCKEY.BIN, $01FF), and an entry table (jmp $D85A, bra.w $C542).


X_C542	equ	$C542

	org	$B090

	dcb.b	5008,0
	dc.b	'HOCKEY.BIN'
	dc.w	$0000,$01FF
	dcb.b	20,0
	dc.w	$FFFF
	dcb.b	114,0
	jmp	$D85A.l
	bra.w	X_C542
	dcb.b	130,0
