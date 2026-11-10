;	MAIN.BIN $7154-$76C7 (runtime $FF8154-$FF86C7).
;
;	Zeros, then DispatchSoundOperation: d0 = 0 (z80load.asm, next) or 1-9 (mainmod.asm).


TickSoundSequences	equ	$FF87B8
StartSoundSequence	equ	$FF8A34
StopSoundSequence	equ	$FF8ADE
ClearZ80SoundBuffers	equ	$FF8B90
RegisterSoundResourceBank	equ	$FF919C
LoadZ80SoundResources	equ	$FF91B0
RemoveZ80SoundResources	equ	$FF91FA
ClearZ80SoundResourceDirectory	equ	$FF92F8
X_FF86C8	equ	$FF86C8
X_FF8B36	equ	$FF8B36

	org	$FF8154

	dcb.b	768,0
	dc.w	$FF00
	dcb.b	511,0
	dc.b	$FF
	dc.w	$FE03
	dc.w	$00C0
	dc.w	$0000
DispatchSoundOperation
	tst.w	d0
	bne.s	.LFF8664
	bra.w	X_FF86C8
.LFF8664
	subi.w	#$1,d0
	bne.s	.LFF866E
	bra.w	TickSoundSequences
.LFF866E
	subi.w	#$1,d0
	bne.s	.LFF8678
	bra.w	StartSoundSequence
.LFF8678
	subi.w	#$1,d0
	bne.s	.LFF8682
	bra.w	StopSoundSequence
.LFF8682
	subi.w	#$1,d0
	bne.s	.LFF868C
	bra.w	X_FF8B36
.LFF868C
	subi.w	#$1,d0
	bne.s	.LFF8696
	bra.w	ClearZ80SoundBuffers
.LFF8696
	subi.w	#$1,d0
	bne.s	.LFF86A0
	bra.w	RegisterSoundResourceBank
.LFF86A0
	subi.w	#$1,d0
	bne.s	.LFF86AA
	bra.w	LoadZ80SoundResources
.LFF86AA
	subi.w	#$1,d0
	bne.s	.LFF86B4
	bra.w	RemoveZ80SoundResources
.LFF86B4
	subi.w	#$1,d0
	bne.s	.LFF86BE
	bra.w	ClearZ80SoundResourceDirectory
.LFF86BE
	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
