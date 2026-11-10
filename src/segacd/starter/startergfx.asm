;	STARTER.BIN $5BD8-$1AF0D (runtime $10BD8-$25F0D): five screens and a block for driver function 5, read
;	from the disc file. Written by hand.
;
;	The driver module (subdrv.asm, at $D94C) copies the five screens one after another to $80000 and keeps
;	where each copy starts in $10984, $1094C, $109D8, $109DC and $109E0 ($10BD0: the end). Each is a
;	.map.jim picture: a long offset to the palette, a long offset to the map (width and height words, then
;	the map), and the tile count, bit 15 set when the tiles are packed. None of them is a cartridge
;	graphic. Then subdrv.asm (at $D9E4) passes StarterBlockF to driver function 5 (d0 = 5, d1 = 0); it
;	has only two zero bytes in 59,810 (samples?). The bytes are read from cdbin/STARTER.BIN, as the
;	cartridge build reads its graphics from Extracted/. startertail.asm follows.

	org	$10BD8

StarterScreenA						;40 x 28 map, $1E9 tiles (copy at $10984)
	incbin	..\cdbin\STARTER.BIN,$5BD8,18030
StarterScreenB						;32 x 4 map, $69 packed tiles (copy at $1094C)
	incbin	..\cdbin\STARTER.BIN,$A246,1788
StarterScreenC						;40 x 28 map, $76 packed tiles (copy at $109D8)
	incbin	..\cdbin\STARTER.BIN,$A942,4896
StarterScreenD						;36 x 100 map, $117 packed tiles (copy at $109DC)
	incbin	..\cdbin\STARTER.BIN,$BC62,1952
StarterScreenE						;18 x 26 map, $20 packed tiles (copy at $109E0)
	incbin	..\cdbin\STARTER.BIN,$C402,362
StarterBlockF						;passed to driver function 5
	incbin	..\cdbin\STARTER.BIN,$C56C,59810
