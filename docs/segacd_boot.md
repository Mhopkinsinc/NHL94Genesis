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
| 3 | OSStartTimer | StartTimerInterrupt: TimerInterrupt on the level 3 vector, interval `$84` |
| 4 | OSReturnFromPlayer | HOCKEY.BIN read again to `$1B000`, then back to the caller of OSRunPlayer (its stack was kept); with no caller kept, main command `$28` and `jmp $1B000` |
| 5 | OSRunPlayer | service 9, the caller's stack and return kept (PlayerCallerSp, PlayerReturn), PLAYER.BIN (22 sectors from LBA 2729) to `$1B000`, over HOCKEY.BIN, LoadPointer `$26000`, `jmp $1B000` with d0-d2 (the teams and FourWayPlay) |
| 6 | OSGetLoadPointer | LoadPointer into a0 |
| 7 | OSPlayFilm | main command `$25` (the shell's C program shows the film), FilmSwitch 0 (open the film at sector d1; d0 picks the buffer layout) then 1 until the film ends or FilmStopFlag is set |
| 8 | OSInitMainSound | main command `$29` with PcmDriverEntry in `$FF8022`; then PCM driver commands 0 (init), 5 with a1 (a record directory), 6 with a2 (load a record list), 5 with a3; StartTimerInterrupt. LoadGameGfx passes GRAPH2 resource 96 (the game's 13 wave samples), HOCKEY.BIN `$223D6` (the list) and `$222EA` (13 sound definitions) |
| 9 | OSStopMainSoundHInt | main command `$2A` |
| `$A` | OSStopFilm | FilmStopFlag set |
| `$B` / `$C` | OSSetKeptWord / OSGetKeptWord | d0 into / out of KeptWord (`$A36C`), kept across HOCKEY.BIN reloads (sram94 reads it at the cold start) |
| `$D` | OSStopTimer | the saved level 3 vector put back |
| `$E` | OSGetPcmDriver | PcmDriverEntry into a0 |
| `$F` | OSInitMainSoundDriver | main command `$40` with PcmDriverEntry in `$FF8022` |
| `$10` | OSCallPcmDriver | PcmDriverEntry with d0 |

The callers already in the source match: STARTER's boot code (service 0), LoadGameGfx and period94 (1), startertail (2, `$A`, `$B`), scoutload (3, `$D`), PLAYER's exit (4), RunPlayerOverlay in cards94 (9 then 5), PLAYER's team films (7), LoadGameGfx (8 with `$60`, `$D`), sram94 (`$C`, 3).

## Sound

PcmDriverEntry (`$8260`) is a `bra.w` to a PCM driver, then its 130-byte command queue: the same layout as STARTER.BIN's driver (DispatchPcmCommandEntry, `docs/segacd_starter_driver.md`). OSInitMainSound gives its address to the main CPU with command `$29` (InitSoundCommand), which hands it to the Z80 loader; z80load.asm keeps that address + 4, the queue. So the main CPU's sound engine writes its PCM events into the sub CPU driver's queue (FlushDeferredSoundEvents), and the driver plays them.

## Not worked out

What FilmSwitch's other arguments are; the PCM driver's commands in this copy (probably as in STARTER.BIN's, `docs/segacd_starter_driver.md`); TimerInterrupt's job.
