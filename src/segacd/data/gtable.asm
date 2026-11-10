;	GTABLE.BIN (2,048 bytes): the index of GRAPH2.BIN (graph2.asm). Written by tools/segacd_graph2.py.
;	99 entries of 6 bytes, the start sector (word) and the byte size (long) of each resource, then a zero
;	entry and zero fill. Each resource starts on the sector after the one before it ends, so GRes works
;	the start sector out from the sizes. The resource number the programs pass in d0 (BIOS call
;	$6044, d7 = 1) is the entry number. The code that reads this file is not traced.

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
	GRes	$2043E				; 3  sector $16C  FeaturedPictures
	GRes	$6C7C				; 4  sector $1AD  TeamLogoBitmaps
	GRes	$8D34				; 5  sector $1BB  STARTER.BIN
	GRes	$61F4				; 6  sector $1CD  player photos: ANH
	GRes	$9B8E				; 7  sector $1DA  player photos: BOS
	GRes	$886A				; 8  sector $1EE  player photos: BUF
	GRes	$8BFC				; 9  sector $200  player photos: CGY
	GRes	$8D50				;10  sector $212  player photos: CHI
	GRes	$87E0				;11  sector $224  player photos: DAL
	GRes	$85BE				;12  sector $235  player photos: DET
	GRes	$7D0C				;13  sector $246  player photos: EDM
	GRes	$5900				;14  sector $256  player photos: FLA
	GRes	$8378				;15  sector $262  player photos: HFD
	GRes	$9764				;16  sector $273  player photos: LA
	GRes	$868A				;17  sector $286  player photos: MTL
	GRes	$8882				;18  sector $297  player photos: NJ
	GRes	$84C4				;19  sector $2A9  player photos: NYI
	GRes	$8C18				;20  sector $2BA  player photos: NYR
	GRes	$99EC				;21  sector $2CC  player photos: OTW
	GRes	$80F0				;22  sector $2E0  player photos: PHI
	GRes	$95DA				;23  sector $2F1  player photos: PIT
	GRes	$7BE4				;24  sector $304  player photos: QUE
	GRes	$7C7E				;25  sector $314  player photos: SJ
	GRes	$8BC2				;26  sector $324  player photos: STL
	GRes	$8F2E				;27  sector $336  player photos: TB
	GRes	$8D0A				;28  sector $348  player photos: TOR
	GRes	$83E8				;29  sector $35A  player photos: VAN
	GRes	$8C28				;30  sector $36B  player photos: WSH
	GRes	$854C				;31  sector $37D  player photos: WPG
	GRes	$E6EE				;32  sector $38E  player photos: ASE
	GRes	$E102				;33  sector $3AB  player photos: ASW
	GRes	$48E4				;34  sector $3C8  per-team table (PLAYER.BIN)
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
	GRes	$CEC				;64  sector $3EF  93 tiles (STARTER.BIN, PLAYER.BIN)
	GRes	$12E4				;65  sector $3F1  the Stanley Cup sprite
	GRes	$22A				;66  sector $3F4  Hot.map.jim
	GRes	$2F6				;67  sector $3F5  Cold.map.jim
	GRes	$7AA8				;68  sector $3F6  per team: ANH (PLAYER.BIN)
	GRes	$71C8				;69  sector $406  per team: BOS (PLAYER.BIN)
	GRes	$7D88				;70  sector $415  per team: BUF (PLAYER.BIN)
	GRes	$7CA8				;71  sector $425  per team: CGY (PLAYER.BIN)
	GRes	$7C48				;72  sector $435  per team: CHI (PLAYER.BIN)
	GRes	$5F28				;73  sector $445  per team: DAL (PLAYER.BIN)
	GRes	$7588				;74  sector $451  per team: DET (PLAYER.BIN)
	GRes	$7928				;75  sector $460  per team: EDM (PLAYER.BIN)
	GRes	$7128				;76  sector $470  per team: FLA (PLAYER.BIN)
	GRes	$74A8				;77  sector $47F  per team: HFD (PLAYER.BIN)
	GRes	$7A48				;78  sector $48E  per team: LA (PLAYER.BIN)
	GRes	$7CA8				;79  sector $49E  per team: MTL (PLAYER.BIN)
	GRes	$7CE8				;80  sector $4AE  per team: NJ (PLAYER.BIN)
	GRes	$7F28				;81  sector $4BE  per team: NYI (PLAYER.BIN)
	GRes	$82E8				;82  sector $4CE  per team: NYR (PLAYER.BIN)
	GRes	$6DA8				;83  sector $4DF  per team: OTW (PLAYER.BIN)
	GRes	$7C88				;84  sector $4ED  per team: PHI (PLAYER.BIN)
	GRes	$79A8				;85  sector $4FD  per team: PIT (PLAYER.BIN)
	GRes	$75E8				;86  sector $50D  per team: QUE (PLAYER.BIN)
	GRes	$7548				;87  sector $51C  per team: SJ (PLAYER.BIN)
	GRes	$6E28				;88  sector $52B  per team: STL (PLAYER.BIN)
	GRes	$7E28				;89  sector $539  per team: TB (PLAYER.BIN)
	GRes	$7CA8				;90  sector $549  per team: TOR (PLAYER.BIN)
	GRes	$7F28				;91  sector $559  per team: VAN (PLAYER.BIN)
	GRes	$76E8				;92  sector $569  per team: WSH (PLAYER.BIN)
	GRes	$71A8				;93  sector $578  per team: WPG (PLAYER.BIN)
	GRes	$72E8				;94  sector $587  per team: ASE (PLAYER.BIN)
	GRes	$6EA8				;95  sector $596  per team: ASW (PLAYER.BIN)
	GRes	$F2FA				;96  sector $5A4  LoadGameGfx, BIOS d7 = 8
	GRes	$4FCC				;97  sector $5C3  STARTER.BIN
	GRes	$2304				;98  sector $5CD
	dc.w	0					;the end: a zero entry
	dc.l	0
	dcb.b	$800-*,0
