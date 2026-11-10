# Sega CD handoff

## Now
- Unit: none in progress. Branch `mcmarkis/segacd-hockey` (fork Mhopkinsinc/NHL94Genesis), PR abdulahmad/NHL94Genesis#239.
- Last check: 2026-11-10, Windows: `npm run build:segacd` MATCH 78 fragments; `tools/verify_all.sh -q` ALL MATCH.
  `tools/segacd_check.sh`: HOCKEY.BIN 136,150 of 184,842 (73.7%; 7,204 of it assets read with incbin); all code files 156,184 of
  410,162 (38.1%).
- Owner decision (Abdul, on the PR): all Sega CD code goes in the Sega CD folder and does not touch the existing
  work; align code, symbols and file names with 94G where possible. So the older hand fragments in `src/segacd/`
  stay as they are, and a 94G twin whose disc range holds one is written in parts around it (`name.asm`,
  `name_2.asm`, ... in `src/segacd/hockey/`; `port name:2 ...` in `tools/segacd_hockey.sh`).
- Done: PLAN step 0 (`tools/segacd_check.sh`), step 2 (`docs/segacd_memory_map.md`), and step 1 for HOCKEY.BIN
  `$76A8`-`$28A7D`: onetimer94 through tables94 and the start of graphics94 (title94 is not on the disc), with
  hockey94, scout94, middle94, video94, setup94 and tables94 split around the hand fragments, and penalty94 /
  collide94 in two parts each (interleaved on the disc).
- How: `tools/segacd_port.py` writes a segment from the cartridge listing; `tools/segacd_hockey.sh` holds every
  segment's range, the hand-checked names and the header notes, and writes them all again from scratch
  (`npm run build:retail` first, keep a copy of `output/obj/nhl94 .lst`: the Sega CD build empties `output/obj/`).
  `docs/segacd.md` "HOCKEY.BIN from the cartridge source" explains the method.
- Next, in disc order:
  1. The rest of HOCKEY.BIN after graphics94 part 1: `$28A7E`-`$2CCFF` (arena sprite data: the ArenaAnims
     pointers in arena94 point into it; scouting text?), the zero-filled graphics pointer table `$2CD00`-`$2CDAB`,
     and code from `$2CDAE` to the end `$2D209` (not yet identified).
  2. The front of the file (`$0`-`$76A7`): header, team data (`$7C`-), frames94, the game start at `$7096`, sram94
     and the save RAM readers moved from cards94 (`$7534`). Team data holds the licensed player names: read them
     from `cdbin/HOCKEY.BIN` with incbin, as the tool does for the New York nicknames; never write them.
  3. Then PLAN step 3 (STARTER.BIN) and step 4 (PLAYER.BIN, the rest of MAIN.BIN).
- Open questions:
  - The team struct is one word longer from `tmap` on; probably `tmsort` became a long. Confirm when a fragment uses
    `tmsort` (logic94 has `movea.w tmsort(a2),a0` among its CD lines).
  - `STARTER.BIN` is linked at `$21300`, inside the range HOCKEY.BIN occupies; how the load works is not traced.

## Baseline log
- 2026-11-10 (McMarkis session, Windows 11, Node 22): fresh fork, `segacd-disc/*.BIN` copied to `cdbin/` (sizes as in GETTING_FILES.md).
  `npm run build:segacd`: MATCH 41 fragments. `tools/verify_all.sh -q` (with the retail ROM in the repo folder): ALL MATCH.

## Coverage (`tools/segacd_check.sh`, 2026-11-10)
| File | Size | Matched | Notes |
|---|---|---|---|
| MAIN.BIN | 60,416 | 13,994 (23.2%) | contiguous `$0`-`$34B7` plus Z80 loader and hardware readers |
| STARTER.BIN | 120,248 | 3,280 (2.7%) | boot, heap, PCM chip, audio stream, film player |
| HOCKEY.BIN | 184,842 | 136,150 (73.7%) | 94G twins `$76A8`-`$28A7D` (some in parts) and the older song/sfx, crowd, scouting fragments |
| PLAYER.BIN | 44,656 | 2,760 (6.2%) | photo picker, career rows, team page |
| GRAPH2.BIN | 3,051,520 | 0 | graphics archive; first longs are offsets |
| GTABLE.BIN | 2,048 | 0 | long offsets |
| Total code | 410,162 | 156,184 (38.1%) | was 22,690 (5.5%) at the start of the session |

## Parked units
(none)
