;	GRAPH2.BIN (3,051,520 bytes): a table of 23 long offsets (from the start of the file), then the 23 blocks.
;	Written by hand. The table is source; each block is graphics, read from the disc file (cdbin/GRAPH2.BIN),
;	as the cartridge build reads its graphics from Extracted/. Which block is which picture is not worked
;	out yet (HOCKEY.BIN loads them into its graphics pointer table, cdgfxptrs.asm).

	org	0

Graph2
	dc.l	Graph2_00-Graph2
	dc.l	Graph2_01-Graph2
	dc.l	Graph2_02-Graph2
	dc.l	Graph2_03-Graph2
	dc.l	Graph2_04-Graph2
	dc.l	Graph2_05-Graph2
	dc.l	Graph2_06-Graph2
	dc.l	Graph2_07-Graph2
	dc.l	Graph2_08-Graph2
	dc.l	Graph2_09-Graph2
	dc.l	Graph2_10-Graph2
	dc.l	Graph2_11-Graph2
	dc.l	Graph2_12-Graph2
	dc.l	Graph2_13-Graph2
	dc.l	Graph2_14-Graph2
	dc.l	Graph2_15-Graph2
	dc.l	Graph2_16-Graph2
	dc.l	Graph2_17-Graph2
	dc.l	Graph2_18-Graph2
	dc.l	Graph2_19-Graph2
	dc.l	Graph2_20-Graph2
	dc.l	Graph2_21-Graph2
	dc.l	Graph2_22-Graph2
Graph2_00	incbin	..\cdbin\GRAPH2.BIN,$5C,61370
Graph2_01	incbin	..\cdbin\GRAPH2.BIN,$F016,27768
Graph2_02	incbin	..\cdbin\GRAPH2.BIN,$15C8E,132154
Graph2_03	incbin	..\cdbin\GRAPH2.BIN,$360C8,8960
Graph2_04	incbin	..\cdbin\GRAPH2.BIN,$383C8,3278
Graph2_05	incbin	..\cdbin\GRAPH2.BIN,$39096,550
Graph2_06	incbin	..\cdbin\GRAPH2.BIN,$392BC,754
Graph2_07	incbin	..\cdbin\GRAPH2.BIN,$395AE,604
Graph2_08	incbin	..\cdbin\GRAPH2.BIN,$3980A,4674
Graph2_09	incbin	..\cdbin\GRAPH2.BIN,$3AA4C,120
Graph2_10	incbin	..\cdbin\GRAPH2.BIN,$3AAC4,1496
Graph2_11	incbin	..\cdbin\GRAPH2.BIN,$3B09C,3406
Graph2_12	incbin	..\cdbin\GRAPH2.BIN,$3BDEA,3418
Graph2_13	incbin	..\cdbin\GRAPH2.BIN,$3CB44,1426
Graph2_14	incbin	..\cdbin\GRAPH2.BIN,$3D0D6,448
Graph2_15	incbin	..\cdbin\GRAPH2.BIN,$3D296,17022
Graph2_16	incbin	..\cdbin\GRAPH2.BIN,$41514,462
Graph2_17	incbin	..\cdbin\GRAPH2.BIN,$416E2,14110
Graph2_18	incbin	..\cdbin\GRAPH2.BIN,$44E00,4832
Graph2_19	incbin	..\cdbin\GRAPH2.BIN,$460E0,25518
Graph2_20	incbin	..\cdbin\GRAPH2.BIN,$4C48E,10062
Graph2_21	incbin	..\cdbin\GRAPH2.BIN,$4EBDC,1418
Graph2_22	incbin	..\cdbin\GRAPH2.BIN,$4F166,2727578
