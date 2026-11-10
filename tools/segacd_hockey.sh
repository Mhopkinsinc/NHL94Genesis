#!/bin/bash
# segacd_hockey.sh: write the HOCKEY.BIN fragments in src/segacd/hockey/ from the cartridge source with
# tools/segacd_port.py, in disc order, starting from an empty hockey.inc (the RAM map is rebuilt as it goes).
# This file is the record of each segment's disc range, the names checked by hand, and the header note.
#
#   tools/segacd_hockey.sh [listing] [last-segment]
#
# listing: the cartridge build listing (default output/obj/nhl94 .lst; run npm run build:retail first,
# and keep a copy: npm run build:segacd empties output/obj/). Needs the retail ROM in the repo folder
# and cdbin/HOCKEY.BIN. Then run npm run build:segacd (or tools/segacd_check.sh).
cd "$(dirname "$0")/.." || exit 1
LST=${1:-"output/obj/nhl94 .lst"}
STOP=$2
[ -f "$LST" ] || { echo "no cartridge listing at '$LST' (npm run build:retail)"; exit 1; }
rm -f src/segacd/hockey/hockey.inc
fail=0
# Disc addresses and values checked by hand (each with the line that shows it):
KNOWN=(
  --name seed=0x18C18          # optsetup94 SetupDemo: the command $1B word goes where the cartridge stores HVcount
  --name TeamList=0x1B00C      # file $C: the 28 team record pointers
  --name tmgoals=0xB6          # cards94 UpdatePlayerRecords: addi.w #$B6,d0 for addi.w #tmgoals,d0
  --name tmpshots=0xEA         # cards94 UpdatePlayerRecords: addi.w #$EA,d0 for addi.w #tmpshots,d0
)
port() {  # name start end [options...]
  local n=$1 s=$2 e=$3; shift 3
  python tools/segacd_port.py --lst "$LST" --file "$n.asm" --disc-start "$s" --disc-end "$e" \
    --out "src/segacd/hockey/$n.asm" --register "${KNOWN[@]}" "$@" > "output/port_$n.log" 2>&1
  grep -q "^MATCH" "output/port_$n.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_$n.log" | tr '\n' ' '; echo
  if [ "$n" = "$STOP" ]; then exit $fail; fi
}
mkdir -p output

port onetimer94 0x76A8 0x7DDC --note 'Same code as the cartridge. The disc team struct is one word longer: tmOneTimers and tmsize\nare two bytes further on (hockey.inc).'
port fourway94 0x7DDC 0x7E38 --note 'CD: Detect4WayPlay and the ReadJoySwapPad routines are gone (the sub CPU has no pad ports);\none rts, called by nothing, is left where they were. Set4WayPlayer is the cartridge code.'
port crowd94 0x7E38 0x83CC --note 'Same code as the cartridge, with one change in checkcornercoll: the corner-circle test compares\nthe squared distance with $42 where the cartridge has $1000 (the radius $40 squared).'
port optsetup94 0x83CC 0x9B5E --note 'The option logic and strings are the cartridge'"'"'s. CD: the graphics are not ROM labels any more:\neach movea.l #map / lea of a tile set became a load from a pointer table at $47D00-$47D8C\n(file $2CD00, zeros on the disc, filled at run time), and the beam-counter seed is command $1B\nto the main CPU (the word comes back in $FF8010). The New York full names are read from the disc file.'
port cards94 0x9B5E 0xB348 --note 'The record bookkeeping (GetRecordValue, UpdateRecords ...) and CalcAttrib are the cartridge code.\nCD: the save RAM readers (ReadPlayerRecord ... NameLogIO) moved next to sram94 (file $7534);\nFeaturedPictures and the player card screen (PlayerCards ... BuildCardPlayerList) are gone;\nTeamPalettes stay (read from the disc file); pictures come through a list at $47D88;\nMenuWaitVblank became the BIOS call at $6044.'

exit $fail
