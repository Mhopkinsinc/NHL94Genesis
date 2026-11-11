# The boot area and the system program

The first 16 sectors of the data track are the boot area. It is not a file on the disc, so the six files in `cdbin/` do not have it: `tools/segacd_bootarea.py` copies it from your own disc image (a `.cue` with its `.bin`, or an `.iso`) into `cdbin/BOOT.BIN`, and the `src/segacd/boot/` fragments are compared with it. `npm run build:segacd` skips those four fragments when `cdbin/BOOT.BIN` is missing.

```
python tools/segacd_bootarea.py "path/to/NHL '94.cue"           (cdbin/BOOT.BIN)
python tools/segacd_bootarea.py "path/to/NHL '94.cue" --files   (and the six files, from the disc's file system)
```

| BOOT.BIN | Runtime | Fragment | What |
| --- | --- | --- | --- |
| `$0`-`$1FF` | | `boot/header.asm` | the disc header: volume `NHLHOCKEY94`, system `CDSYS.BIN`, where the two programs are, the system header (`SEGA GENESIS`, `NHL HOCKEY 94`, `GM T-50015 -00`, region U) |
| `$200`-`$783` | main `$FF0000` | `boot/security.asm` | Sega's US security block (the licence screen): read from the disc |
| `$784`-`$FFF` | main `$FF0584` | `boot/ip.asm` | the initial program |
| `$1000`-`$7FFF` | sub `$6000` | `boot/sp.asm` | the system program, module `MAIN SEGAOS` (code to `$A4DD`, then zeros) |

`tools/segacd_boot.sh` writes `ip.asm` and `sp.asm` with `segacd_port.py` and holds the names (CD-only, given here) with a reason each.

## Start-up

The BIOS loads the initial program at main CPU `$FF0000` and the system program at sub CPU `$6000`.

- **SegaOSMain** (`$622A`, sub CPU): drive init (BIOS `$10`, `$96`), then MAIN.BIN (30 sectors from LBA 30) into word RAM at `$80000`, GTABLE.BIN (LBA 2728) into GTableBuffer (`$9B58`), and STARTER.BIN (120 sectors from LBA 226) to `$B000`; then `jmp $B000`.
- **IPMain** (`$FF0584`, main CPU): interrupt level and the V / H interrupt vectors, the start-up handshake, word RAM taken, then `$EC02` bytes copied from word RAM `$200000` to `$FF1000` and `jmp $FF1000`. That is MAIN.BIN, which is why it runs at `$FF1000` (`docs/segacd_main_shell.md`). Its helpers are the same code as MAIN.BIN's and have the same names.
- STARTER.BIN runs the start-up sequence and its tail jumps back to `$B00E` in its own boot code, which reads HOCKEY.BIN (`$92` sectors from LBA `$4F`) to `$1B000` with service 0 and jumps to it (`docs/segacd.md`).

Every file is read by a sector number written in the code, never by name (the file names `HOCKEY.BIN`, `RAM.BIN`, `MAIN.BIN`, `PLAYR.BIN`, `START.BIN` after `$6346` are not used):

| File | LBA | Read by |
| --- | --- | --- |
| MAIN.BIN | 30 (`$1E`) | SegaOSMain |
| HOCKEY.BIN | 79 (`$4F`) | STARTER.BIN's boot code, OSReturnFromPlayer |
| STARTER.BIN | 226 (`$E2`) | SegaOSMain |
| GRAPH2.BIN | 286 (`$11E`) | OSLoadResource: LBA 286 + the resource's sector |
| GTABLE.BIN | 2728 (`$AA8`) | SegaOSMain |
| PLAYER.BIN | 2729 (`$AA9`) | OSRunPlayer |
| HOCKEY.SEG | 2778 (`$ADA`) | the intro film: STARTER.BIN passes it to StarterDriverEntry |

The disc also holds the films (`GOAL*.SEG`, `HIT*.SEG`, `STNLY*.SEG`, `THNDR*.SEG`: OSPlayFilm with the sector in d1) and the speech (`RON*.PCM`, the team names `ANAHEIM.PCM` ...). Those are media, not code, and are not part of this build.

## The services at `$6044`

HOCKEY.BIN, STARTER.BIN and PLAYER.BIN call `jsr $6044.w` with the service number in d7. **SegaOSCall** turns d7 into `d7 * 4 + 2`, writes it over the displacement of the `bra.w` that follows (at `$6050`), and so lands on entry d7 of **SegaOSCallTable**:

| d7 | Service | What it does |
| --- | --- | --- |
| 0 | OSReadSectors | ReadSectors(d2 LBA, d1 sectors, d0 address) |
| 1 | OSLoadResource | GRAPH2 resource d0: its GTABLE entry (start sector, size), read from LBA 286 + sector to LoadPointer, which moves past it; the `$12345678` end mark is checked and the read tried up to 3 times. Main CPU commands `$2E` before and `$2D` after (the V interrupt handlers, `docs/segacd_main_shell.md`). Returns the address in a0 |
| 2 | OSSetLoadPointer | a0 into LoadPointer (`$A360`) |
| 3 | OSStartTimer | StartTimerInterrupt: TimerInterrupt on level 3, interval `$84` ("The timer" below) |
| 4 | OSReturnFromPlayer | HOCKEY.BIN read again to `$1B000`, then back to the caller of OSRunPlayer (its stack was kept); with no caller kept, main command `$28` and `jmp $1B000` |
| 5 | OSRunPlayer | service 9, the caller's stack and return kept (PlayerCallerSp, PlayerReturn), PLAYER.BIN (22 sectors from LBA 2729) to `$1B000`, over HOCKEY.BIN, LoadPointer `$26000`, `jmp $1B000` with d0-d2 (the teams and FourWayPlay) |
| 6 | OSGetLoadPointer | LoadPointer into a0 |
| 7 | OSPlayFilm | main command `$25` (the shell's C program shows the film), FilmSwitch 0 (open the film at sector d1; d0 picks the buffer layout) then 1 until the film ends or FilmStopFlag is set |
| 8 | OSInitMainSound | main command `$29` with PcmDriverEntry in `$FF8022`; then PCM driver commands 0 (init), 5 with a1 (a record directory), 6 with a2 (load a record list), 5 with a3; StartTimerInterrupt; PcmServiceEnabled set. LoadGameGfx passes GRAPH2 resource 96 (the game's 13 wave samples), HOCKEY.BIN `$223D6` (the list) and `$222EA` (13 sound definitions) |
| 9 | OSStopMainSoundHInt | main command `$2A`; PcmServiceEnabled cleared, so the timer stops running the driver |
| `$A` | OSStopFilm | FilmStopFlag set |
| `$B` / `$C` | OSSetKeptWord / OSGetKeptWord | d0 into / out of KeptWord (`$A36C`), kept across HOCKEY.BIN reloads (sram94 reads it at the cold start) |
| `$D` | OSStopTimer | the saved level 3 vector put back |
| `$E` | OSGetPcmDriver | PcmDriverEntry into a0 |
| `$F` | OSInitMainSoundDriver | main command `$40` with PcmDriverEntry in `$FF8022`; PCM command 0, StartTimerInterrupt, PcmServiceEnabled set |
| `$10` | OSCallPcmDriver | PcmDriverEntry with d0 |

The callers already in the source match: STARTER's boot code (service 0), LoadGameGfx and period94 (1), startertail (2, `$A`, `$B`), scoutload (3, `$D`), PLAYER's exit (4), RunPlayerOverlay in cards94 (9 then 5), PLAYER's team films (7), LoadGameGfx (8 with `$60`, `$D`), sram94 (`$C`, 3).

## Sound

PcmDriverEntry (`$8260`) is a `bra.w` to DispatchPcmCommand, then PcmCommandQueue (a count word and the packed command longs, 130 bytes). OSInitMainSound gives its address to the main CPU with command `$29` (InitSoundCommand), which hands it to the Z80 loader; z80load.asm keeps that address + 4, the queue. So the main CPU's sound engine writes its PCM events into the sub CPU driver's queue (FlushDeferredSoundEvents), and the driver plays them.

The driver (`$8260`-`$9ADF`) is STARTER.BIN's (`docs/segacd_starter_driver.md`) with one command added. Every routine named in STARTER's copy has a twin here with the same bytes (found by runs of equal bytes: about half of the 6,272 bytes are such runs, and the rest differs by the addresses and the added code), and has the STARTER name.

| d0 | Handler | What it does |
| --- | --- | --- |
| 0 | InitPcmDriver | allocation, mappings, channels, levels; the queue cleared; silence (`$80`) then `$FF` loop marks at wave RAM 0; no stream |
| 1 | ServicePcmDriver | drain the queue; when `$FF800C` (12 bits) has moved `$20` on since PcmLastTimerTick, update the envelopes and ServicePcmStream. PcmServiceBusy keeps it from running twice at once. TimerInterrupt calls it |
| 2 | ControlPcmSampleAllocation | d1 = 0: the saved position set to `$100`; 1: PcmAllocPosition saved; 2: put back, and the samples above it forgotten |
| 3 | PlayPcmSample | a sample with explicit frequency, envelope and pan |
| 4 | | not supported: d0 = 1, carry set |
| 5 | SetPcmRecordDirectory | a0 into PcmRecordDirectories + d1 * 4 |
| 6 | LoadPcmRecordList | type/id word pairs to `$FFFF`; each type 2 record (a wave sample) uploaded to wave RAM at PcmAllocPosition and noted in PcmSampleAddress |
| 7 | PcmCommandNoOp | `rts` |
| 8 | SetPcmSoundLoopOffset | set or add to the loop offset word of a type 0 record |
| 9 | PlayPcmStream | not in STARTER: a stream (below) |
| `$80` on | DispatchPackedPcmCommand | the packed commands of the queue |

The packed ranges are MIDI's status bytes: `$8x` note off (StopPackedPcmSound), `$9x` note on (PlayPackedPcmSound), `$Bx` and `$Cx` control and program change (both SetPcmSoundMapping), `$Ex` pitch bend (SetPcmPitchControl); `$Ax`, `$Dx` and `$Fx` are refused. The low nibble with the long's top byte picks one of 128 slots, which PcmSoundMapping and PcmPitchControl are indexed by (the byte after the status byte is the value).

### The stream (command 9)

PlayPcmStream plays a sound longer than wave RAM straight from sub CPU memory, through two halves of the wave RAM left free above the loaded samples:

| a0 | What it does |
| --- | --- |
| -1 | stop: the channel's loop address set to 0 (the silence InitPcmDriver put there), PcmStreamActive cleared |
| 0 | ask: d0 = 0 while a stream plays, -1 when none does |
| other | start (d0 = 7, carry set, when one plays): a0 is the sound, ended by a `$FF` byte; d1 the frequency, d2 the envelope, d3 the pan |

Starting cuts the free wave RAM into halves A and B (`$400` bytes each when at least `$800` is free), fills both (FillPcmStreamHalf: the next bytes, then a `$FF` loop mark), takes a channel that is off or else the one with the lowest PcmChannelPriority, and starts it at half A. Each time the channel moves into a half, ServicePcmStream (in command 1, so from the timer) fills the other one and points the loop address at it, so the channel goes round A, B, A ... When the `$FF` end byte has been copied, PcmStreamSource becomes -1 and the loop address 0: the channel plays silence until the stream is stopped. PcmStreamActive is also cleared when the stream's channel is found off.

The scouting report reads its script aloud this way (`docs/segacd_announce.md`): service 0 reads a clip to LoadPointer and service `$10` sends command 9 with d1 = `$400`, d2 = `$FF`, d3 = `$FFFF`.

### The timer

StartTimerInterrupt (service 3, and services 8 and `$F`) puts TimerInterrupt into the BIOS level 3 jump (the long at the address in the vector at `$6C`, + 2, kept in SavedTimerVector), writes `$84` to the gate array timer `$FF8030` and enables level 3 in `$FF8032`. OSStopTimer (`$D`) puts the old jump target back.

TimerInterrupt writes `$84` to the timer again and, while PcmServiceEnabled is set (services 8 and `$F` set it, service 9 clears it), calls the driver with d0 = 1: it is what runs the driver. It also counts TimerCountdown from 15 to 0 and round again, which nothing reads.

## Not worked out

What FilmSwitch's other arguments are; the driver's per-channel tables (`$97E4`-`$9834`, left as `X_` addresses) and the per-slot tables at `$98D4`-`$99D4`.
