;	STARTER.BIN $5E00-$1AF0D (runtime $10E00-$25F0D): graphics and packed data, read from the disc file. Written by hand.
;
;	$5E00-$C56F holds 4-bit tiles and tile maps (rows of $8xxx / $Axxx words); $C570-$1AF0D is a block with
;	no zero byte in it (packed graphics or samples). Neither matches the cartridge. The format is not
;	worked out yet; the bytes are read from cdbin/STARTER.BIN, as the cartridge build reads its graphics
;	from Extracted/. startertail.asm follows.

	org	$10E00

StarterTiles						;4-bit tiles and their maps
	incbin	..\cdbin\STARTER.BIN,$5E00,26480
StarterPacked						;packed data, no zero bytes
	incbin	..\cdbin\STARTER.BIN,$C570,59806
