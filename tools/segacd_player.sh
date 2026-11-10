#!/bin/bash
# segacd_player.sh: write the PLAYER.BIN fragments in src/segacd/player/ with tools/segacd_port.py.
# PLAYER.BIN is position-independent (linked at 0, pc-relative, variables through a6). These fill the
# gaps around the older hand fragments (playerpic, playercareer, playerpage: left as they are). Needs
# only cdbin/PLAYER.BIN. playerphotos.asm (the images and the variable area) is written by hand.
#
#   tools/segacd_player.sh
cd "$(dirname "$0")/.." || exit 1
mkdir -p output src/segacd/player
fail=0
port() {  # name start end [options...]
  local n=$1 s=$2 e=$3
  shift 3
  python tools/segacd_port.py --disc cdbin/PLAYER.BIN --base 0x0 --plain --tags --cart-start 0 --cart-end 0 \
    --disc-start "$s" --disc-end "$e" --out "src/segacd/player/$n.asm" --register "$@" > "output/port_player_$n.log" 2>&1
  grep -q "^MATCH" "output/port_player_$n.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_player_$n.log" | tr '\n' ' '; echo
}

port playerinit 0x0 0x1D54 --note 'The start of PLAYER.BIN: clear the sub CPU flag bit 5, set the stack and a6 pc-relative (lea\n0(pc,a6.l)), save the registers, then the code up to playerpic.asm. Not named yet.'
port playercode 0x281C 0x3F84 --note 'After playerpage.asm: the rest of the PLAYER.BIN code (gate array commands through $FF800E /\n$FF800F / $FF8020 ...). Not named yet.'
port playertext 0x3F84 0x40C6 --raw --raw-text --note 'The column tables and the headings of the stat pages (Players, Goalies, Gp, Mins, Regular,\nPlayoff ...); playerphotos.asm follows.'

exit $fail
