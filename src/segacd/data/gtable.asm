;	GTABLE.BIN (2,048 bytes): the index of GRAPH2.BIN (graph2.asm). Written by tools/segacd_graph2.py.
;	99 entries of 6 bytes, the start sector (word) and the byte size (long) of each resource, then a zero
;	entry and zero fill. Each resource starts on the sector after the one before it ends, so GRes works
;	the start sector out from the sizes. The resource number HOCKEY.BIN passes in d0 (BIOS call $6044,
;	d7 = 1) is the entry number. Which program reads this file (the sub CPU side) is not traced.

GRes	MACRO						;GRes size: one entry, at the next free sector
	dc.w	gsector
	dc.l	\1
gsector	=	gsector+((\1)+2047)/2048
	ENDM

	org	0

gsector	=	0
GTable
	GRes	$4F6D8				; 0  sector $000  the start-up pack
	GRes	$1FC42				; 1  sector $09F  the game graphics pack
	GRes	$46654				; 2  sector $0DF  the sprite pack
	GRes	$2043E				; 3  sector $16C  the player cards
	GRes	$6C7C				; 4  sector $1AD  the team logos
	GRes	$8D34				; 5  sector $1BB
	GRes	$61F4				; 6  sector $1CD
	GRes	$9B8E				; 7  sector $1DA
	GRes	$886A				; 8  sector $1EE
	GRes	$8BFC				; 9  sector $200
	GRes	$8D50				;10  sector $212
	GRes	$87E0				;11  sector $224
	GRes	$85BE				;12  sector $235
	GRes	$7D0C				;13  sector $246
	GRes	$5900				;14  sector $256
	GRes	$8378				;15  sector $262
	GRes	$9764				;16  sector $273
	GRes	$868A				;17  sector $286
	GRes	$8882				;18  sector $297
	GRes	$84C4				;19  sector $2A9
	GRes	$8C18				;20  sector $2BA
	GRes	$99EC				;21  sector $2CC
	GRes	$80F0				;22  sector $2E0
	GRes	$95DA				;23  sector $2F1
	GRes	$7BE4				;24  sector $304
	GRes	$7C7E				;25  sector $314
	GRes	$8BC2				;26  sector $324
	GRes	$8F2E				;27  sector $336
	GRes	$8D0A				;28  sector $348
	GRes	$83E8				;29  sector $35A
	GRes	$8C28				;30  sector $36B
	GRes	$854C				;31  sector $37D
	GRes	$E6EE				;32  sector $38E
	GRes	$E102				;33  sector $3AB
	GRes	$48E4				;34  sector $3C8
	GRes	$30E				;35  sector $3D2  per team: ANH
	GRes	$30E				;36  sector $3D3  per team: BUF
	GRes	$30E				;37  sector $3D4  per team: CGY
	GRes	$30E				;38  sector $3D5  per team: CHI
	GRes	$30E				;39  sector $3D6  per team: DAL
	GRes	$30E				;40  sector $3D7  per team: DET
	GRes	$30E				;41  sector $3D8  per team: EDM
	GRes	$30E				;42  sector $3D9  per team: FLA
	GRes	$30E				;43  sector $3DA  per team: HFD
	GRes	$30E				;44  sector $3DB  per team: LA
	GRes	$30E				;45  sector $3DC  per team: MTL
	GRes	$30E				;46  sector $3DD  per team: NJ
	GRes	$30E				;47  sector $3DE  per team: NYI
	GRes	$30E				;48  sector $3DF  per team: NYR
	GRes	$30E				;49  sector $3E0  per team: OTW
	GRes	$30E				;50  sector $3E1  per team: PHI
	GRes	$30E				;51  sector $3E2  per team: PIT
	GRes	$30E				;52  sector $3E3  per team: QUE
	GRes	$30E				;53  sector $3E4  per team: SJ
	GRes	$30E				;54  sector $3E5  per team: STL
	GRes	$30E				;55  sector $3E6  per team: TB
	GRes	$30E				;56  sector $3E7  per team: TOR
	GRes	$30E				;57  sector $3E8  per team: VAN
	GRes	$30E				;58  sector $3E9  per team: WSH
	GRes	$30E				;59  sector $3EA  per team: WPG
	GRes	$30E				;60  sector $3EB  per team: BOS
	GRes	$30E				;61  sector $3EC  per team: ASE
	GRes	$30E				;62  sector $3ED  per team: ASW
	GRes	$30E				;63  sector $3EE  per-team form, not used
	GRes	$CEC				;64  sector $3EF
	GRes	$12E4				;65  sector $3F1  the Stanley Cup sprite
	GRes	$22A				;66  sector $3F4  Hot.map.jim
	GRes	$2F6				;67  sector $3F5  Cold.map.jim
	GRes	$7AA8				;68  sector $3F6
	GRes	$71C8				;69  sector $406
	GRes	$7D88				;70  sector $415
	GRes	$7CA8				;71  sector $425
	GRes	$7C48				;72  sector $435
	GRes	$5F28				;73  sector $445
	GRes	$7588				;74  sector $451
	GRes	$7928				;75  sector $460
	GRes	$7128				;76  sector $470
	GRes	$74A8				;77  sector $47F
	GRes	$7A48				;78  sector $48E
	GRes	$7CA8				;79  sector $49E
	GRes	$7CE8				;80  sector $4AE
	GRes	$7F28				;81  sector $4BE
	GRes	$82E8				;82  sector $4CE
	GRes	$6DA8				;83  sector $4DF
	GRes	$7C88				;84  sector $4ED
	GRes	$79A8				;85  sector $4FD
	GRes	$75E8				;86  sector $50D
	GRes	$7548				;87  sector $51C
	GRes	$6E28				;88  sector $52B
	GRes	$7E28				;89  sector $539
	GRes	$7CA8				;90  sector $549
	GRes	$7F28				;91  sector $559
	GRes	$76E8				;92  sector $569
	GRes	$71A8				;93  sector $578
	GRes	$72E8				;94  sector $587
	GRes	$6EA8				;95  sector $596
	GRes	$F2FA				;96  sector $5A4
	GRes	$4FCC				;97  sector $5C3
	GRes	$2304				;98  sector $5CD
	dc.w	0					;the end: a zero entry
	dc.l	0
	dcb.b	$800-*,0
