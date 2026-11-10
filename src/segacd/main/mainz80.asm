;	MAIN.BIN $640C-$7153 (runtime $FF640C-$FF7153). Written by hand.
;
;	The Z80 sound program (di, ld sp,$1FFE, im 0, ...) and its tables. It is not the cartridge Z80 driver.
;	The source is mainz80.z80 (asm80, written by tools/segacd_z80dis.py); tools/build.js --segacd
;	assembles it into output/obj/z80/mainz80.bin before the fragments, and this includes it.

	org	$FF640C

	incbin	..\output\obj\z80\mainz80.bin
