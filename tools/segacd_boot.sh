#!/bin/bash
# segacd_boot.sh: write the boot area fragments in src/segacd/boot/ with tools/segacd_port.py.
# cdbin/BOOT.BIN is the first 16 sectors of the data track (tools/segacd_bootarea.py copies it from your
# own disc image). header.asm and security.asm are written by hand; these are the two programs:
#   ip.asm  the initial program after Sega's security block: BOOT.BIN $784 runs at $FF0584 (main CPU).
#   sp.asm  the system program: BOOT.BIN $1000 runs at sub CPU $6000. It holds the services HOCKEY.BIN,
#           STARTER.BIN and PLAYER.BIN call at $6044 (function number in d7), and the same Sierra C SDK
#           code as STARTER.BIN (its functions are named from their tags).
#
#   tools/segacd_boot.sh
cd "$(dirname "$0")/.." || exit 1
[ -f cdbin/BOOT.BIN ] || { echo "no cdbin/BOOT.BIN (python tools/segacd_bootarea.py <your disc image>.cue)"; exit 1; }
mkdir -p output src/segacd/boot
fail=0
# The initial program's helpers are the same code as MAIN.BIN's (mainstart_2.asm), so they have its names.
IP_LABELS=(
  --label IPMain=0xFF0584                 # interrupts set up, then MAIN.BIN copied from word RAM to $FF1000 and run
  --label WaitMainWordRam=0xFF0606        # until $A12003 bit 1 clears (as in MAIN.BIN)
  --label GiveSubWordRamAndWait=0xFF0612  # DMNA set, wait for RET to clear (as in MAIN.BIN)
  --label AcknowledgeMainVBlank=0xFF0626  # V interrupt: bit 0 of $A12000 (interrupts the sub CPU), rte
  --label IPHBlank=0xFF0630               # H interrupt: rte
  --label SyncMainShellStartup=0xFF0632   # the flag bit 6 / 7 handshake (as in MAIN.BIN)
  --label SetInterruptLevel=0xFF067C      # d0 into the SR interrupt mask
)
# The system program: the boot code, the services at $6044 (SegaOSCall, d7 = the entry of SegaOSCallTable)
# and what they use. CD-only names given here; docs/segacd_boot.md has the evidence.
SP_LABELS=(
  --label SegaOSCall=0x6044               # d7*4+2 into the bra.w displacement below: jumps to entry d7 of SegaOSCallTable
  --label SegaOSCallTable=0x6052          # seventeen bra.w, services 0-$10
  --label SegaOSStackTop=0x6226           # the boot stack
  --label SegaOSMain=0x622A               # drive init, MAIN.BIN (30 sectors from LBA 30) to word RAM, GTABLE.BIN (LBA 2728)
                                          # to GTableBuffer, STARTER.BIN (120 sectors from LBA 226) to $B000, jmp $B000
  --label OSReadSectors=0x637A            # 0: ReadSectors(d2 LBA, d1 sectors, d0 address)
  --label OSLoadResource=0x63AC           # 1: GRAPH2 resource d0 at LoadPointer (GTABLE entry, LBA 286 + sector, end mark checked, 3 tries)
  --label OSSetLoadPointer=0x64EC         # 2: a0 into LoadPointer
  --label OSStartTimer=0x64F4             # 3: StartTimerInterrupt
  --label OSReturnFromPlayer=0x64FC       # 4: HOCKEY.BIN read again (LBA $4F) to $1B000, back to OSRunPlayer's caller
  --label OSRunPlayer=0x662E              # 5: PLAYER.BIN (22 sectors from LBA 2729) to $1B000, over HOCKEY.BIN, and run
  --label OSGetLoadPointer=0x671A         # 6: LoadPointer into a0
  --label OSGetPcmDriver=0x6722           # $E: PcmDriverEntry into a0
  --label OSCallPcmDriver=0x672A          # $10: PcmDriverEntry with d0
  --label OSSetKeptWord=0x6730            # $B: d0 into KeptWord
  --label OSGetKeptWord=0x6738            # $C: KeptWord into d0
  --label OSPlayFilm=0x6740               # 7: main command $25, FilmSwitch 0 (open d1) then 1 until the end or FilmStopFlag
  --label FilmSwitch=0x68D2               # 0 open, 1 frame, else close (as filmrun.asm in STARTER.BIN)
  --label OSStopFilm=0x8078               # $A: FilmStopFlag set
  --label OSInitMainSound=0x808A          # 8: main command $29 with PcmDriverEntry in $FF8022
  --label OSInitMainSoundDriver=0x8122    # $F: main command $40 with PcmDriverEntry in $FF8022
  --label OSStopMainSoundHInt=0x818E      # 9: main command $2A
  --label OSStopTimer=0x81DE              # $D: the saved timer vector put back
  --label StartTimerInterrupt=0x81F2      # TimerInterrupt on the level 3 vector, interval $84, level 3 enabled
  --label TimerInterrupt=0x822C
  --label PcmDriverEntry=0x8260           # bra.w to the PCM driver, then its 130-byte command queue (as in STARTER.BIN)
  --label SyncWithMain=0x9AE0             # the flag bit 6 / 7 handshake
  --label ReadSectors=0xA3F8              # (LBA, sectors, address): BIOS reads through $5F22, five tries
  --cdname GTableBuffer=0x9B58
  --cdname PlayerCallerSp=0xA358
  --cdname PlayerReturn=0xA35C
  --cdname LoadPointer=0xA360
  --cdname SavedReadHook=0xA364
  --cdname ReadHookFlag=0xA368
  --cdname FilmStopFlag=0xA36A
  --cdname KeptWord=0xA36C
  --cdname SavedTimerVector=0xA36E
)
port() {  # name start end base [options...]
  local n=$1 s=$2 e=$3 b=$4
  shift 4
  python tools/segacd_port.py --disc cdbin/BOOT.BIN --base "$b" --plain --tags --cart-start 0 --cart-end 0 \
    --disc-start "$s" --disc-end "$e" --out "src/segacd/boot/$n.asm" --register "$@" > "output/port_boot_$n.log" 2>&1
  grep -q "^MATCH" "output/port_boot_$n.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_boot_$n.log" | tr '\n' ' '; echo
}

port ip 0x784 0x1000 0xFEFE00 "${IP_LABELS[@]}" --note 'The initial program after Sega'"'"'s security block (security.asm): it sets the interrupt level and the\nV / H interrupt vectors, waits for the sub CPU, takes word RAM, copies MAIN.BIN ($EC02 bytes, which the\nsystem program put in word RAM) to $FF1000 and jumps to it. Then zeros to the system program.'
port sp 0x1000 0x8000 0x5000 "${SP_LABELS[@]}" --note 'The system program (sub CPU $6000, module MAIN SEGAOS): the header, the service dispatch at $6044\n(function number in d7), the file table, then the Sierra C SDK code STARTER.BIN has too, and zeros.'

exit $fail
