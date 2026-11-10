#!/bin/bash
# segacd_main.sh: write the MAIN.BIN fragments in src/segacd/main/ with tools/segacd_port.py (main CPU, $FF0000).
# These fill the gaps between the older hand fragments in src/segacd/ (left as they are). Needs only
# cdbin/MAIN.BIN. maindisp_2.asm, mainfont_2.asm, maintext_2.asm and maincrt_2.asm are written by hand: each
# includes the file it copies.
#
#   tools/segacd_main.sh
cd "$(dirname "$0")/.." || exit 1
mkdir -p output src/segacd/main
fail=0
port() {  # name start end [options...]
  local n=$1 s=$2 e=$3
  shift 3
  python tools/segacd_port.py --disc cdbin/MAIN.BIN --base 0xFF0000 --plain --tags --cart-start 0 --cart-end 0 \
    --disc-start "$s" --disc-end "$e" --out "src/segacd/main/$n.asm" --register "$@" > "output/port_main_$n.log" 2>&1
  grep -q "^MATCH" "output/port_main_$n.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_main_$n.log" | tr '\n' ' '; echo
}

port maincrt 0x34B8 0x35A8 --note 'The Sierra C run-time helpers after maintext.asm: 32-bit multiply and the divide / modulo\nentries with their jump table (the same code as STARTER.BIN crt.asm).'
port mainstart 0x35A8 0x3B3C --note 'Main CPU start-up: the stack at $FFFC00, the communication words $A12010-$A12018 cleared, then\nthe set-up before the command loop. Not named yet; hwread.asm follows.'
port mainwram 0x3C3E 0x40D0 --note 'After hwread.asm: copies from word RAM ($23BC88 ...) to the VDP ($C00000). Not named yet. The\nsecond copy of maindisp.asm (main/maindisp_2.asm) follows.'
port mainvdpinit 0x57E8 0x640C --note 'After the second copy of the C handlers and of the run-time (maincrt_2.asm): VDP set-up and\nvectors ($70, $A12006), then zeros. Not named yet.'
# mainz80 ($640C-$7153, the Z80 sound program) is Z80 source now: src/segacd/main/mainz80.z80, written by
# tools/segacd_z80dis.py and assembled by tools/build.js --segacd; mainz80.asm (by hand) includes it.
port maincmd 0x7154 0x76C8 --note 'Zeros, then a dispatch on d0 into the module after z80load.asm (mainmod.asm); z80load.asm follows.'
port mainmod 0x77B8 0xEC00 --note 'After z80load.asm: a module that checks a $1234 word before it runs, its tables, then zeros\nto the end of the file. Not named yet.'

exit $fail
