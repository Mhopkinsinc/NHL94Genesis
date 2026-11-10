# NHL 94 Sega CD

The disc is the cartridge game, linked again for the two Sega CD 68000s, with a new shell from the official Sega CD SDK around it. It is not a source-level rewrite, and it is not the cartridge ROM with a CD boot strapped on.

The six disc files used here live in `cdbin/` locally (`MAIN.BIN`, `STARTER.BIN`, `HOCKEY.BIN`, `PLAYER.BIN`, `GRAPH2.BIN`, `GTABLE.BIN`). They are not in the repo and nothing in the build makes them: copy them from the data track (ISO 9660 file system) of your own NHL '94 Sega CD disc into `cdbin/` (gitignored). Without them, `npm run build:segacd` stops before assembling and names each missing file (the HOCKEY.BIN fragments read the licensed team nicknames from `cdbin/HOCKEY.BIN` with `incbin`, the way the cartridge build reads them from the ROM).

## What each file is

| File | CPU | What it is |
| --- | --- | --- |
| `STARTER.BIN` | Sub | SDK boot. Heap, film player, main/sub commands. Linked at `$21300`: the first instruction jumps to a Sierra C `link a6,#0` at `$262A8`. |
| `HOCKEY.BIN` | Sub | The game. Linked at `0` (its own branches land inside the file). About 181 KB. |
| `PLAYER.BIN` | Sub | A second module, also linked at `0`, with a relocating startup (`lea 0(pc,a6.l),a6`). Career stats, the team page, and player photos. The "Power play advantage" lines are this page, not the Ron Barr script. |
| `MAIN.BIN` | Main | SDK shell in Genesis RAM at `$FF0000`. Talks to the VDP and to the sub CPU through `$A120xx`. |
| `GTABLE.BIN` | | 2 KB of long offsets. |
| `GRAPH2.BIN` | | 3 MB graphics archive. The first longs are offsets into the file. |

`STARTER.BIN` and `MAIN.BIN` are the SDK. They contain `link a6` / `unlk a6` (39 and 26), `mmalloc` / `ffree`, `FilmOpen` / `FilmTask`, `Example Line 0` through `Example Line 7`, and the strings `SUBCPU is alive` and `MAINCPU is alive`. None of that is in the cartridge. Calls go through the sub CPU BIOS entry at `$6044` with the function number in `d7`.

`HOCKEY.BIN` has no `link a6`. It has 656 `rts` and 328 `movem.l` to the stack, the same shape as the cartridge, and it has the cartridge's screens: "Play Mode", "EA Hockey Night", "HAT TRICK!", "Line Editor", "SHOOTOUT MODE", the penalty names, the exception strings.

## The SDK change

The cartridge was built with EA's assembler. Short absolute addresses reach Genesis work RAM (`$B028` sign-extends to `$FFFFB028`), and `addq` / `bra.b` are used wherever they fit.

On the disc the same instructions were assembled with long addresses, because the game now runs on the sub CPU and those variables live in its program RAM. Two instructions from the end of the Play Mode screen:

Cartridge (`optsetup94`, bytes in front of `Play Mode`):

```
move.w  #0,$B02E.w
jsr     $11A48.l          ; printsmall
addq.w  #2,$B02A.w
bra.b   *-
bclr.b  #3,$C2F8.w
movem.l (sp)+,d0-d1
rts
```

Disc (`HOCKEY.BIN` `$928C`):

```
move.w  #0,$18D5E.l
jsr     $38D9E.l
addi.w  #2,$18D5A.l       ; addq has no absolute-long form
bra.w   *-                ; the function grew, so bra.b no longer reached
bclr.b  #3,$17F76.l
movem.l (sp)+,d0-d1
rts
```

Same order, same registers, same `#3` and `#2`. `addq` became `addi` and `bra.b` became `bra.w` because that is what the long addresses force. The EA Hockey Night ticker is the same kind of pair: `$B028` became `$18D58`.

| Cartridge | Disc | What |
| --- | --- | --- |
| `$FFB028` (`$B028.w`) | `$18D58` | print x |
| `$FFB02A` | `$18D5A` | print y |
| `$FFB02E` | `$18D5E` | print attribute |
| `$FFC2F8` (`$C2F8.w`) | `$17F76` | the flag byte `sflags6` |
| `$11086` random | `$37050` | absolute call |
| `$11340` ReadJoy1 | `$374F0` | absolute call |
| `$119B8` Framer | `$38CA0` | absolute call, 87 sites |
| `$11A48` printsmall | `$38D9E` | absolute call, 32 sites |
| `$11B92` printz | `$38F6E` | absolute call, 216 sites |
| `$11D3A` PushNumberWidth | `$3919A` | absolute call |
| `$11DE2` printbigz | `$39258` | absolute call, 36 sites |

`tools/segacd_relocs.py` finds these by matching six-instruction windows and keeping an absolute operand only when the cartridge address always becomes the same disc address. Run `python3 tools/segacd_relocs.py nhl94retail.bin cdbin/HOCKEY.BIN` for the full list (it needs the disc files in `cdbin/`).

Those `$37xxx`–`$39xxx` targets are HOCKEY.BIN itself: the file runs at `$1B000`, so `$38D9E` is file `$1DD9E`, where the cartridge `printsmall` opening is (its register save is at `$1DDAC`). Inside the file the same routines are reached with `bsr`. `docs/segacd_memory_map.md` has the evidence and the sub CPU memory map.

One path really changed. The address-error hex dump is byte for byte the same (`move.w (sp)+,d0` / `andi.w #$F,d0` / `addi.b #$30,d0`). The handler under it is not: the cartridge does `move #$2700,sr` and `bsr.w $11DE2` (printbigz); the disc does `bclr.b #5,$FF800F` and `jsr $39258`. `$39258` is that same printbigz. The new instruction is the sub CPU comm flag, which the cartridge does not have.

The team block at the front of `HOCKEY.BIN` matches the cartridge from Montreal's colors through the start of the roster (733 bytes, cart `$37E`, disc `$7C`) and then splits. The cartridge continues into "Madison Square Garden"; the disc has "Eastern division" there.

`PLAYER.BIN` and `HOCKEY.BIN` share no 16-byte window with each other that matters, and `PLAYER.BIN` shares almost nothing with the cartridge ROM (39 windows of 16 bytes). It is new code on the sub CPU, not a slice of `HOCKEY.BIN`.

## Disassembly that builds

`npm run build:segacd` (`node tools/build.js --segacd`) assembles the fragments below into `output/segacd/` and compares them to `cdbin/` with `tools/verifySegacd.js`. Each fragment's assembler options are in `tools/segacd.json`; a new fragment is one line there plus its compare in `verifySegacd.js`. The cartridge ROM is not involved. The Sega CD assemble uses `/o oz-` so a written `$0(an)` stays a 16-bit displacement. The cartridge build still uses `/o oz+`.

Verified bytes are 133,268 of the 410,162 bytes in the four code files (32.5%; `tools/segacd_check.sh` prints the current numbers). Before the HOCKEY.BIN segments they were 22,690 (5.5%). `MAIN.BIN` is contiguous from the first byte through `$FF34B7` (13,496 of 60,416) plus the hardware readers and the Z80 loader (498 bytes more, 13,994 total, 23.2%). `STARTER.BIN` is 3,280 bytes. `HOCKEY.BIN` is 113,234 bytes (61.3%), most of it the 94G twins in `src/segacd/hockey/`. `PLAYER.BIN` is 2,760 bytes. `GRAPH2.BIN` and `GTABLE.BIN` are still untouched. CD audio is `docs/segacd_audio.md`. `song` and `sfx` are `docs/segacd_song.md`. The scouting-report script is `docs/segacd_announce.md`. Career stats and photos are `docs/segacd_stats.md`. Crowd frames are `docs/segacd_crowd.md`. The film player, Z80 loader, and hardware readers are `docs/segacd_film.md`.

| Source | Compared to | Bytes |
| --- | --- | --- |
| `src/segacd/maincd.asm` | `cdbin/MAIN.BIN` | `$FF0000`-`$FF0271` (626) |
| `src/segacd/maindma.asm` | `cdbin/MAIN.BIN` `$272` | `$FF0272`-`$FF04FF` (654) |
| `src/segacd/maincont.asm` | `cdbin/MAIN.BIN` `$500` | `$FF0500`-`$FF0CB7` (1,976) |
| `src/segacd/mainblit.asm` | `cdbin/MAIN.BIN` `$CB8` | `$FF0CB8`-`$FF12BF` (1,544) |
| `src/segacd/mainvdp.asm` | `cdbin/MAIN.BIN` `$12C0` | `$FF12C0`-`$FF183F` (1,408) |
| `src/segacd/mainpad.asm` | `cdbin/MAIN.BIN` `$1840` | `$FF1840`-`$FF1E8F` (1,616) |
| `src/segacd/maindisp.asm` | `cdbin/MAIN.BIN` `$1E90` | `$FF1E90`-`$FF2D29` (3,738) |
| `src/segacd/mainfont.asm` | `cdbin/MAIN.BIN` `$2D2A` | `$FF2D2A`-`$FF3029` (768) |
| `src/segacd/maintext.asm` | `cdbin/MAIN.BIN` `$302A` | `$FF302A`-`$FF34B7` (1,166) |
| `src/segacd/subboot.asm` | `cdbin/STARTER.BIN` | first `$90` bytes (144) |
| `src/segacd/subheap.asm` | `cdbin/STARTER.BIN` `$4FA8` | `EngineIdle` and `GetData` (192) |
| `src/segacd/pcmclear.asm` | `cdbin/STARTER.BIN` `$3A0C` | PCM channel wipe (106) |
| `src/segacd/cdcwait.asm` | `cdbin/STARTER.BIN` `$3A76` | `CDBCHK` spin (20) |
| `src/segacd/pcmchip.asm` | `cdbin/STARTER.BIN` `$3FD0` | PCM init, start, stop, address, bank load (298) |
| `src/segacd/audiostream.asm` | `cdbin/STARTER.BIN` `$508C` | `AudioPlayPos` through `AudioBusy` (632) |
| `src/segacd/cdfade.asm` | `cdbin/STARTER.BIN` `$54F6` | seek/repeat, fader ramp, stop (120) |
| `src/segacd/cdrequest.asm` | `cdbin/HOCKEY.BIN` `$1C1D2` | `song` at runtime `$371D2` (52) |
| `src/segacd/sfxcd.asm` | `cdbin/HOCKEY.BIN` `$1C10C` | `sfx`, command `$26` (104) |
| `src/segacd/gate34.asm` | `cdbin/HOCKEY.BIN` `$1C174` | command `$34` (94) |
| `src/segacd/songplay.asm` | `cdbin/HOCKEY.BIN` `$10B1E` | `song` then one `MSCPLAY1` (58) |
| `src/segacd/cdtrack.asm` | `cdbin/HOCKEY.BIN` `$1C206` | choose a track and `MSCPLAY1` (202) |
| `src/segacd/cdcrowd.asm` | `cdbin/HOCKEY.BIN` `$238CE` | crowd-volume slew, no PSG write (78) |
| `src/segacd/cdstart.asm` | `cdbin/HOCKEY.BIN` `$24D66` | CD-DA mode, seek track 4, repeat it (130) |
| `src/segacd/scoutopen.asm` | `cdbin/HOCKEY.BIN` `$D2B6` | scouting screen open, song `$7A` (226) |
| `src/segacd/scouttext.asm` | `cdbin/HOCKEY.BIN` `$2486C` | scouting text player (542) |
| `src/segacd/scouttok.asm` | `cdbin/HOCKEY.BIN` `$24A8A` | scouting script tokens (384) |
| `src/segacd/scoutload.asm` | `cdbin/HOCKEY.BIN` `$24C12` | scouting file directory load (340) |
| `src/segacd/playerpic.asm` | `cdbin/PLAYER.BIN` `$1D54` | player photo picker (700) |
| `src/segacd/playercareer.asm` | `cdbin/PLAYER.BIN` `$2010` | career-stat rows (960) |
| `src/segacd/playerpage.asm` | `cdbin/PLAYER.BIN` `$23D0` | team stat page (1,100) |
| `src/segacd/crowdanim.asm` | `cdbin/HOCKEY.BIN` `$10D28` | crowd frame driver (318) |
| `src/segacd/crowdtable.asm` | `cdbin/HOCKEY.BIN` `$2654C` | crowd frame table, same as cartridge `updatecrowdf_cd0` (128) |
| `src/segacd/filmrun.asm` | `cdbin/STARTER.BIN` `$3D94` | movie open/task/close switch (278) |
| `src/segacd/filmcmd.asm` | `cdbin/STARTER.BIN` `$4D9E` | post a movie command (44) |
| `src/segacd/filmbuf.asm` | `cdbin/STARTER.BIN` `$4E26` | film buffer allocator (154) |
| `src/segacd/filmopen.asm` | `cdbin/STARTER.BIN` `$4336` | `FilmOpen` (514) |
| `src/segacd/filmsm.asm` | `cdbin/STARTER.BIN` `$3EAA` | `SM` chunk copy (294) |
| `src/segacd/filmtask.asm` | `cdbin/STARTER.BIN` `$458C` | `FilmTask` (418) |
| `src/segacd/filmclose.asm` | `cdbin/STARTER.BIN` `$473A` | `FilmClose` (66) |
| `src/segacd/z80load.asm` | `cdbin/MAIN.BIN` `$76C8` | Z80 loader (240) |
| `src/segacd/hwread.asm` | `cdbin/MAIN.BIN` `$3B3C` | VDP, joypad, and HV readers (258) |
| `src/segacd/hockey/onetimer94.asm` | `cdbin/HOCKEY.BIN` `$76A8` | `onetimer94.asm`: the one-timer (1,844) |
| `src/segacd/hockey/fourway94.asm` | `cdbin/HOCKEY.BIN` `$7DDC` | `fourway94.asm`: only `Set4WayPlayer` is left (92) |
| `src/segacd/hockey/crowd94.asm` | `cdbin/HOCKEY.BIN` `$7E38` | `crowd94.asm`: crowd records, hot and cold players, corner collisions (1,428) |
| `src/segacd/hockey/optsetup94.asm` | `cdbin/HOCKEY.BIN` `$83CC` | `optsetup94.asm`: game setup and options (6,034) |
| `src/segacd/hockey/cards94.asm` | `cdbin/HOCKEY.BIN` `$9B5E` | `cards94.asm`: user records bookkeeping, ratings; no player card screen (6,122) |
| `src/segacd/hockey/records94.asm` | `cdbin/HOCKEY.BIN` `$B348` | `records94.asm`: name entry and Record Holders (5,400) |
| `src/segacd/hockey/shootout94.asm` | `cdbin/HOCKEY.BIN` `$C860` | `shootout94.asm`: shootout (2,420) |
| `src/segacd/hockey/scout94.asm` | `cdbin/HOCKEY.BIN` `$D1D4` | `scout94.asm` part 1: matchups (226) |
| `src/segacd/hockey/scout94_2.asm` | `cdbin/HOCKEY.BIN` `$D398` | `scout94.asm` part 2, after `scoutopen.asm`: scouting report screen (3,638) |
| `src/segacd/hockey/period94.asm` | `cdbin/HOCKEY.BIN` `$E1CE` | `period94.asm`: period stats, game statistics, Manual Goalie (4,060) |
| `src/segacd/hockey/arena94.asm` | `cdbin/HOCKEY.BIN` `$F1AA` | `arena94.asm`: arena / faceoff animations (994) |
| `src/segacd/hockey/shootoutpath94.asm` | `cdbin/HOCKEY.BIN` `$F58C` | `shootoutpath94.asm`: saved lines, shootout skate paths (886) |
| `src/segacd/hockey/ui94.asm` | `cdbin/HOCKEY.BIN` `$F902` | `ui94.asm`: unpack, rink graphics, HiScore, played-by (1,382) |
| `src/segacd/hockey/helpers94.asm` | `cdbin/HOCKEY.BIN` `$FE68` | `helpers94.asm` (238) |
| `src/segacd/hockey/logos94.asm` | `cdbin/HOCKEY.BIN` `$FF56` | `logos94.asm`: logo palettes, lead song, hot / cold icon (1,420) |
| `src/segacd/hockey/chgplayer94.asm` | `cdbin/HOCKEY.BIN` `$104E2` | `chgplayer94.asm`: chgplayer and far thunks (306) |
| `src/segacd/hockey/hockey94.asm` | `cdbin/HOCKEY.BIN` `$10614` | `hockey94.asm` part 1: game and period start, clock (1,290) |
| `src/segacd/hockey/hockey94_2.asm` | `cdbin/HOCKEY.BIN` `$10B58` | `hockey94.asm` part 2, after `songplay.asm` (464) |
| `src/segacd/hockey/hockey94_3.asm` | `cdbin/HOCKEY.BIN` `$10E66` | `hockey94.asm` part 3, after `crowdanim.asm` (1,170) |
| `src/segacd/hockey/menu94.asm` | `cdbin/HOCKEY.BIN` `$112F8` | `menu94.asm`: menu core (872) |
| `src/segacd/hockey/stats94.asm` | `cdbin/HOCKEY.BIN` `$11660` | `stats94.asm`: scores, line editor, roster, stat screens (10,148) |
| `src/segacd/hockey/replay94.asm` | `cdbin/HOCKEY.BIN` `$13E04` | `replay94.asm`: replay (2,950) |
| `src/segacd/hockey/logic94.asm` | `cdbin/HOCKEY.BIN` `$1498A` | `logic94.asm`: player update, input, assignments (29,224) |
| `src/segacd/hockey/middle94.asm` | `cdbin/HOCKEY.BIN` `$1BBB2` | `middle94.asm` part 1: shared helpers (1,370) |
| `src/segacd/hockey/middle94_2.asm` | `cdbin/HOCKEY.BIN` `$1C2D0` | `middle94.asm` part 2, after `sfxcd` ... `cdtrack` (5,750) |
| `src/segacd/hockey/decompress94.asm` | `cdbin/HOCKEY.BIN` `$1D946` | `decompress94.asm`: graphics decompressor (654) |
| `src/segacd/hockey/print94.asm` | `cdbin/HOCKEY.BIN` `$1DBD4` | `print94.asm`: print routines (2,118) |
| `src/segacd/hockey/penalty94.asm` | `cdbin/HOCKEY.BIN` `$1E41A` | `penalty94.asm` part 1, up to `updatepwrplay` (3,296) |
| `src/segacd/hockey/collide94.asm` | `cdbin/HOCKEY.BIN` `$1F0FA` | `collide94.asm` part 1, up to `setpersonel` (8,662) |
| `src/segacd/hockey/penalty94_2.asm` | `cdbin/HOCKEY.BIN` `$212D0` | `penalty94.asm` part 2 (4,438) |
| `src/segacd/hockey/collide94_2.asm` | `cdbin/HOCKEY.BIN` `$22426` | `collide94.asm` part 2 (1,682) |

`maincd.asm` is the main CPU command loop: read `$A12020` when sub flag bit 6 is set, dispatch through the long table at `$FF01BE`, and put the VBlank vector at `$FD08` back when the command finishes. Past the handshake it clears the eight command words, waits on memory-mode bit 2, and hands word RAM back and forth (DMNA / RET in `$A12003`). Two commands add `$180000` to a sub CPU pointer so the main CPU sees the same word RAM (`$080000` there, `$200000` here).

`maindma.asm` is the word-RAM blit that command path calls. It expands nibbles, writes the VDP at `$C00000`, and sets up DMA. A source in `$200000`-`$240000` is adjusted by two when the address is odd. The slice ends on `cmpa.w #0,a0`, and `maincont.asm` is the rest of that routine: the VBlank-status spin at `$FF051C`, a copy of the `$23A450` block into `$FF284E`, VDP fills, and the helpers that add `$180000` to a pointer. A 9-long table sits at `$FF0C94`.

`mainblit.asm` reads a byte stream into `$FF2DB2`-`$FF2DBA` and shakes the gate-array flag bits at `$A12018` / `$A12028`. It ends with the 16-long handler table at `$FF1280`. `mainvdp.asm` is those handlers and the routines next to them: VDP data and register writes, waits on `$A12024`, and copies that add `$180000` before calling the DMA helper at `$FF0418`. The file stops on the `rts` at `$FF183E`.

`mainpad.asm` is the zero fill after that `rts` and the byte table at `$FF1DBC`. `maindisp.asm` saves the VBlank vector at `$FD08`, points it at `$FF1F8C`, and calls `MAINCODE`. When that returns it waits on a flag and puts the old vector back, then programs the VDP and copies tiles. `mainfont.asm` is the font bitmap that follows the `rts` at `$FF2D28`.

`maintext.asm` is the Sierra C handlers those calls land in: `DoDrawTextCommand`, `DoMoviePlayBack`, `MAINCODE`, `ReDraw`, `drawprint`, `NumStr`, `HexStr`, `aprint`, `InitWorld`, `GetCommandFromSub`, and `Set1MFlag`. Each `rts` is followed by the function name (a tag byte, then the ASCII). `InitWorld` prints `MAINCPU is alive`. The same eleven names occur again later in the file, `$2240` bytes on.

`subboot.asm` is the sub CPU's first instructions, the flag handshake, BIOS function 0 at `$6044`, and `jmp $1B000` into `HOCKEY.BIN`. `subheap.asm` is the Sierra C `EngineIdle` and `GetData` at `$262A8` (the `link a6` the boot jumps to). The function name is the bytes after each `rts`.

The audio slices are the sub CPU's CD-DA calls and the PCM stream. `docs/segacd_audio.md` lists the `_CDBIOS` numbers, the track word at `$1745E`, and the crowd-volume routine whose PSG stores were dropped. `scoutopen.asm` starts the scouting screen on song `$7A`. `scouttext.asm` and `scouttok.asm` type the Ron Barr script. `docs/segacd_announce.md` is that write-up.

`playerpic.asm`, `playercareer.asm`, and `playerpage.asm` are the `PLAYER.BIN` overlay: a photo (or a generic `$504`-byte frame), the Regular/Playoff career rows, and the Players/Goalies page with the power-play lines. `docs/segacd_stats.md`.

`crowdanim.asm` is the cartridge crowd-frame driver. The frame table in `crowdtable.asm` matches `updatecrowdf_cd0` with nothing added. The HV counter reads became command `$1B` and a word from `$FF8010`. `docs/segacd_crowd.md`.

`filmrun.asm` chooses `FilmOpen`, `FilmTask`, or `FilmClose`. `filmcmd.asm` posts that choice to the main CPU, where `DoMoviePlayBack` blits command `2`. `filmbuf.asm` allocates the buffer. `filmopen.asm`, `filmsm.asm`, `filmtask.asm`, and `filmclose.asm` are the `FILM` / `SM` player. `docs/segacd_film.md`.

`cdrequest.asm` is `song` at runtime `$371D2`. `sfxcd.asm` is `sfx` at `$3710C`. `songplay.asm` is the one call that then `MSCPLAY1`s the track. `docs/segacd_song.md`.

`z80load.asm` copies a `$C3 $00` block to the Z80. `hwread.asm` is the main CPU's one-line port readers, including the HV counter copy into `$A12010`.

`tools/emit_m68k.py` writes a slice as SNASM (`moveq #-1` instead of `moveq #$FF`, unsized `btst` to a data register, `$FFFFFD08.w` instead of `$FD08.w`). `tools/segacd_relocs.py` is the six-instruction matcher that prints the cartridge-to-disc address pairs. Both are Sega CD helpers only; the cartridge build does not use them.

## HOCKEY.BIN from the cartridge source

HOCKEY.BIN runs at `$1B000` (`docs/segacd_memory_map.md`) and is linked in the cartridge's file order, with the files that are new in 94 moved in front of `hockey94.asm`: team data, then `onetimer94`, `fourway94`, `crowd94`, `optsetup94`, `cards94`, `records94`, `shootout94`, `scout94`, `period94`, `arena94`, `shootoutpath94`, `ui94`, `helpers94`, (`title94`, not yet matched), `logos94`, `chgplayer94`, then `hockey94`, `menu94`, `stats94`, `replay94`, `logic94`, `middle94` and the rest. Each disc segment is the twin of one 94G file and sits in `src/segacd/hockey/` under that file's name, with the 94G names. The older hand-made fragments in `src/segacd/` stay as they are: a 94G file whose disc range holds one is written in parts around it (`hockey94.asm`, `hockey94_2.asm`, `hockey94_3.asm` around `songplay.asm` and `crowdanim.asm`), and each part's header names its neighbours. On the disc `penalty94` and `collide94` are interleaved (half of each, twice), so each has two parts as well.

The disc assembler did not optimise: an unsized branch is `.w`, `add`/`sub` of a small immediate is `addi`/`subi` (never `addq`/`subq`), `cmp.l #n,dn` is `cmpi.l` (the cartridge ROM has `cmp.l`, one of its fixopcodes patches), a zero displacement stays `0(an)`. Absolute addresses are long because the variables and the code are above `$7FFF` on the sub CPU.

`tools/segacd_port.py` does the transcription. It walks the cartridge build listing (`output/obj/nhl94 .lst` from `npm run build:retail`; the Sega CD build empties `output/obj/`, so keep a copy) and the disc bytes side by side. A disc instruction that is the cartridge instruction with relocated operands is written as the cartridge source line, with the disc encoding and the cartridge's labels, symbols and comments. Byte-equal data is copied (String macros and all). Disc code with no cartridge twin is written under `;CD:`. A name the fragment uses but does not define is solved from the disc operand: RAM names and struct offsets go to `src/segacd/hockey/hockey.inc` (shared by the HOCKEY.BIN fragments), routines outside the fragment become equates at its top. The tool assembles the result and checks it against the disc; an instruction SNASM would encode differently becomes `dc.w` with a comment (none so far). `--register` adds the fragment to `tools/segacd.json`, `tools/verifySegacd.js` and `docs/segacd-handoff/name_map.csv`. `tools/segacd_hockey.sh` runs it for every HOCKEY.BIN segment in disc order with its range, the names checked by hand (`--name seed=0x18C18`) and the header note, so the fragments and `hockey.inc` can be written again from scratch.

```
python tools/segacd_port.py --file onetimer94.asm --disc-start 0x76A8 --disc-end 0x7DDC --out src/segacd/hockey/onetimer94.asm --register
```

What the cartridge build takes from the ROM (the licensed New York team nicknames in `optsetup94`, the asset files it `incbin`s from `Extracted/`, such as the matchup palettes in `cards94`) is `incbin ..\cdbin\HOCKEY.BIN,offset,length` here, read from your own disc file. The Sega CD build never reads `Extracted/`, and `segacd_port.py` stops if a written fragment would contain a player name or team nickname.

What the CD changed so far: graphics are no longer ROM labels (each `movea.l #map` became a load from a pointer table at `$47D00`, inside HOCKEY.BIN but zeros on the disc, filled at run time), the beam-counter seed is command `$1B` to the main CPU, the corner-collision radius test in `checkcornercoll` compares with `$42` instead of `$1000`, and the team struct is one word longer from `tmap` on (`docs/segacd_memory_map.md`). `title94` (title screen and credits) is not on the disc. `cards94` lost the whole player card screen and its save RAM readers moved next to `sram94`. `fourway94` is the first file the CD cut: `Detect4WayPlay` and the `ReadJoySwapPad` routines are gone, and one `rts` that nothing calls is left in their place.
