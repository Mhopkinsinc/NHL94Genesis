;	HOCKEY.BIN $2CCFC-$2CDAB (runtime $47CFC-$47DAB): the graphics pointer table. CD-only, written by hand.
;
;	44 long pointers, zeros on the disc, filled at run time. Where the cartridge loads a graphic by its
;	ROM label (movea.l #SetupMenuMap,a0), the disc loads the pointer from here (movea.l SetupMenuMapPtr,a0).
;	An entry is named <label>Ptr after the cartridge label the replaced lines used (tools/segacd_hockey.sh
;	passes the names with --cdname so the HOCKEY.BIN fragments use them); the comment gives the evidence.
;	Entries left unnamed are not certain.

	org	$47CFC

GfxPointers
	dc.l	0				;$47CFC the scouting script base (scoutload.asm)
GameSetUpMapPtr	dc.l	0			;$47D00 optsetup94: the replaced line loaded GameSetUpMap
GameSetUpMap2Ptr	dc.l	0			;$47D04 optsetup94: GameSetUpMap2
	dc.l	0				;$47D08 unknown
EASportsBGMapPtr	dc.l	0			;$47D0C six files: EASportsBGMap every time
FramerMapPtr	dc.l	0			;$47D10 FramerMap in 6 of 8 sites
FaceOffMapPtr	dc.l	0			;$47D14 FaceOffMap 3, FaceOffSprites 2 ($47D30 is the sprites)
RinktilelistPtr	dc.l	0			;$47D18 Rinktilelist in 5 sites
RefsMapPtr	dc.l	0			;$47D1C RefsMap 5, RefMap2 2 ($47D20 is RefMap2)
RefMap2Ptr	dc.l	0			;$47D20 RefMap2 3, RefsMap 2
	dc.l	0				;$47D24 sprites (Sprites or Spritetiles: one site each)
	dc.l	0				;$47D28 one site, HotList replaced (not sure)
CrowdSpritesPtr	dc.l	0			;$47D2C CrowdSprites 3 of 7
FaceOffSpritesPtr	dc.l	0			;$47D30 FaceOffSprites 3, FaceOffMap 2
ZamSpritesPtr	dc.l	0			;$47D34 ZamSprites 2
BigFontMapPtr	dc.l	0			;$47D38 BigFontMap 3 of 4
SmallFontMapPtr	dc.l	0			;$47D3C SmallFontMap 11 of 15
EnergyBarMapPtr	dc.l	0			;$47D40 EnergyBarMap 3 of 7
TeamblocksmapPtr	dc.l	0			;$47D44 Teamblocksmap 4
TeamBitmapsPtr	dc.l	0			;$47D48 TeamBitmaps 3
EASportsMapPtr	dc.l	0			;$47D4C EASportsMap 2
ArrowsmapPtr	dc.l	0			;$47D50 Arrowsmap 2
RonBarrMapPtr	dc.l	0			;$47D54 scout94: RonBarrMap (scoutload.asm: the Ron Barr picture)
ScoresMapPtr	dc.l	0			;$47D58 stats94: ScoresMap
	dc.l	0				;$47D5C unknown
	dc.l	0				;$47D60 unknown
	dc.l	0				;$47D64 rink tiles (Rinktilelist and RevRinkTilelist two sites each)
ReplayMapPtr	dc.l	0			;$47D68 ReplayMap 2
IceRinkHorMapPtr	dc.l	0			;$47D6C penalty94: IceRinkHorMap
PrintFont2MapPtr	dc.l	0			;$47D70 PrintFont2Map 3, SmallFontMap 2
SetupMenuMapPtr	dc.l	0			;$47D74 optsetup94: SetupMenuMap 2
SetupFramerMapPtr	dc.l	0			;$47D78 optsetup94: SetupFramerMap
LogoBoxMapPtr	dc.l	0			;$47D7C LogoBoxMap 4 of 5
NHLLogoMapPtr	dc.l	0			;$47D80 records94: NHLLogoMap
NHLPALogoMapPtr	dc.l	0			;$47D84 records94: NHLPALogoMap
	dc.l	0				;$47D88 player pictures, a list per team (cards94, middle94)
	dc.l	0				;$47D8C team logos, a list per team (optsetup94, period94, records94 ...)
	dc.l	0				;$47D90 ui94 / hockey94: a picture for PlayedByText
StanleyCupSpritePtr	dc.l	0			;$47D94 StanleyCupSprite 2
HotMapPtr	dc.l	0			;$47D98 logos94 loads it for a hot player, $47D9C for a cold one
ColdMapPtr	dc.l	0			;$47D9C logos94: the cold player icon
	dc.l	0				;$47DA0 unknown
	dc.l	0				;$47DA4 unknown
	dc.l	0				;$47DA8 ui94 / hockey94: a picture for PlayedByText
