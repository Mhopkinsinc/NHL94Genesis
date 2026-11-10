#!/bin/bash
# segacd_starter.sh: write the STARTER.BIN fragments in src/segacd/starter/ with tools/segacd_port.py.
# STARTER.BIN is the Sega CD SDK (no cartridge code): the fragments are its instructions, with the Sierra C
# function names taken from the name tag after each rts. Needs only cdbin/STARTER.BIN (no ROM, no listing).
# The older hand fragments in src/segacd/ (filmopen.asm, subheap.asm ...) are left as they are; these fill
# the gaps between them. This file records each fragment's range and note.
#
#   tools/segacd_starter.sh
cd "$(dirname "$0")/.." || exit 1
mkdir -p output src/segacd/starter
fail=0
port() {  # name start end [options...]
  local n=$1 s=$2 e=$3
  shift 3
  python tools/segacd_port.py --disc cdbin/STARTER.BIN --base 0xB000 --plain --tags --cart-start 0 --cart-end 0 \
    --disc-start "$s" --disc-end "$e" --out "src/segacd/starter/$n.asm" --register "$@" > "output/port_starter_$n.log" 2>&1
  grep -q "^MATCH" "output/port_starter_$n.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_starter_$n.log" | tr '\n' ' '; echo
}

# STARTER.BIN runs at file + $B000 (runtime $B000-$285B7). Every absolute call and data reference in it fits
# that base: the driver module's jmp $D85A is file $285A, crt's lea $104EC.l is the data after crt (file
# $54EC), startertail's jsr $27A6A is its own code at file $1CA6A. The older subboot.asm, pcmclear.asm,
# cdcwait.asm ... give runtimes at $21300 (an earlier guess); their bytes match either way.
port subhdr 0x90 0x1542 --note 'Zeros after subboot.asm, then the start of the sub CPU driver module: a\nfile record (HOCKEY.BIN, $01FF), and an entry table (jmp $D85A, bra.w $C542).'
port subdrv 0x1542 0x3A0C --note 'The sub CPU driver module: a command dispatch on d0 at $C542, the gate array at $8000-$802x\n(short addresses), its work area at $EC90 ... Not named yet. pcmclear.asm follows (its bytes match; its\ncomment gives a runtime at $21300, but STARTER.BIN runs at file + $B000).'
port subdrv_2 0x3A8A 0x3D94 --note 'The end of the sub CPU driver module, between cdcwait.asm and filmrun.asm.'
port subirq 0x40FA 0x4336 --note 'After pcmchip.asm: a long that keeps the BIOS vector at $5F90 (the first line, decoded as an\nori.b #0), code that hooks that vector with its own handler and puts it back, then the C function Wait.'
port subtext 0x4788 0x49FA --note 'SwapMeg, DrawText, NumStr, HexStr, aprint: text to the main CPU (SendCommandToMain, the\nDoDrawTextCommand side is in maintext.asm) and number formatting.'
port heapalloc 0x49FA 0x4C84 --note 'The heap: ffree, findSmallestBlock, MaxFree, mmalloc, InitHeap.'
port subinit 0x4C84 0x4D9E --note 'InitWorld (prints SUBCPU is alive), GetTicks, WaitIODone.'
port copydata 0x4DDE 0x4E26 --note 'CopyData (after SendCommandToMain in filmcmd.asm).'
port engine 0x4ECE 0x4FA8 --note 'DisposeEngine, GetSectDst, PeekSectDst: the CD read engine (InitEngine is in filmbuf.asm,\nEngineIdle and GetData in subheap.asm).'
port readdata 0x5068 0x508C --note 'ReadData (between GetData in subheap.asm and the audio stream in audiostream.asm).'
port filmopen_tag 0x4538 0x458C --note 'The FilmOpen name tag after filmopen.asm and the strings FilmOpen prints.'
port filmtask_tag 0x472E 0x473A --note 'The FilmTask name tag after filmtask.asm.'
port filmclose_tag 0x477C 0x4788 --note 'The FilmClose name tag after filmclose.asm.'
port filmcmd_tag 0x4DCA 0x4DDE --note 'The SendCommandToMain name tag after filmcmd.asm.'
port filmbuf_tag 0x4EC0 0x4ECE --note 'The InitEngine name tag after filmbuf.asm.'
port startertext 0x556E 0x5E00 --raw --raw-text --note 'After cdfade.asm: tables, the SDK demo strings (Example Line 0-7) and more tables, as bytes.\nstartergfx.asm (by hand) follows.'
port startertail 0x1AF0E 0x1D5B8 --text-incbin --label SubMain=0x262A8 --note 'After startergfx.asm to the end of the file: the credits text (read from the disc file: it names\nreal people), then code and data, decoded as found. SubMain (a name given here) is where the boot'"'"'s\njmp $262A8 lands: stack at $C41C, the gate array command words cleared, then the start-up. The code\nends with jmp $B00E, back to the boot, which loads HOCKEY.BIN at $1B000 over this part of the file.'
port crt 0x5304 0x54F6 --note 'The Sierra C run-time helpers after AudioBusy: 32-bit multiply ($10304) and the divide /\nmodulo entries with their jump table. No name tags here; cdfade.asm follows.'

exit $fail
