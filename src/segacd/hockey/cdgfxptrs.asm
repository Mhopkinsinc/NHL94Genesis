;	HOCKEY.BIN $2CCFC-$2CDAB (runtime $47CFC-$47DAB): the graphics pointer table. CD-only, written by hand.
;
;	44 long pointers, zeros on the disc, filled at run time. Where the cartridge loads a graphic by its
;	ROM label (movea.l #SetupMenuMap,a0), the disc loads the pointer from here (movea.l $47D74,a0).
;	Entries seen so far, from the code that reads them:
;	  $47CFC  scouting script base (src/segacd/scoutload.asm)
;	  $47D0C  a screen background bitmap (records94 name entry, shootout94, stats94, scout94_2, setup94)
;	  $47D54  the Ron Barr picture (scoutload.asm)
;	  $47D74  SetupMenuMap (optsetup94: movea.l #SetupMenuMap,a0 on the cartridge)
;	  $47D88  player pictures, a list per team (cards94)
;	  $47D8C  team logos, a list per team (optsetup94, period94, records94)

	org	$47CFC

GfxPointers
	dcb.l	44,0
