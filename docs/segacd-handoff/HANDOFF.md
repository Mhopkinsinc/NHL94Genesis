# Sega CD handoff

## Now
- Unit: none in progress. Branch `mcmarkis/segacd-hockey` (fork Mhopkinsinc/NHL94Genesis), PR abdulahmad/NHL94Genesis#239.
- Last check: 2026-11-10, Windows: `npm run build:segacd` MATCH 121 fragments; `tools/verify_all.sh -q` ALL MATCH.
  `tools/segacd_check.sh`: all four code files match in full, 410,162 of 410,162 bytes. Of those, 43,120 (HOCKEY.BIN),
  25,806 (PLAYER.BIN) and about 87 KB (STARTER.BIN) are graphics, pictures, licensed names or credits read from the
  disc with incbin; the rest is source. GRAPH2.BIN and GTABLE.BIN (PLAN step 5) match too: all six disc files are
  built byte for byte (`src/segacd/data/`).
- Owner decision (Abdul, on the PR): all Sega CD code goes in the Sega CD folder and does not touch the existing
  work; align code, symbols and file names with 94G where possible. So the older hand fragments in `src/segacd/`
  stay as they are, and a 94G twin whose disc range holds one is written in parts around it (`name.asm`,
  `name_2.asm`, ... in `src/segacd/hockey/`; `port name:2 ...` in `tools/segacd_hockey.sh`).
- Done: PLAN step 0 (`tools/segacd_check.sh`), step 2 (`docs/segacd_memory_map.md`), and step 1: all of HOCKEY.BIN,
  one twin per 94G file in `src/segacd/hockey/` (some in parts around the older fragments), the team data with
  `--no-text`, and two CD-only files (`cdgfxptrs.asm`, `cdpads.asm`). title94 is not on the disc.
- How: `tools/segacd_port.py` writes a segment from the cartridge listing; `tools/segacd_hockey.sh` holds every
  segment's range, the hand-checked names and the header notes, and writes them all again from scratch
  (`npm run build:retail` first, keep a copy of `output/obj/nhl94 .lst`: the Sega CD build empties `output/obj/`).
  `docs/segacd.md` "HOCKEY.BIN from the cartridge source" explains the method.
- STARTER.BIN, MAIN.BIN, PLAYER.BIN (PLAN steps 3 and 4) match in full: `src/segacd/starter/`, `main/`, `player/`,
  written by `tools/segacd_starter.sh`, `segacd_main.sh`, `segacd_player.sh` (no ROM or listing needed).
- Next:
  1. PLAN step 5 is done in its first form: GRAPH2's offset table is source and its 23 blocks are incbin; GTABLE is
     source. Left: which code reads GTABLE (the 12-byte record guess), and which GRAPH2 block is which picture.
  2. Names: STARTER's driver module (runtime `$C000`, dispatch at `$C542`), MAIN's start-up and the module at
     `$77B8`, PLAYER's `playerinit` / `playercode`, and HOCKEY's header. (HOCKEY's graphics pointer table: 31 of 44 entries named, `--cdname` in `tools/segacd_hockey.sh`.)
  3. Formats: STARTER's tiles and packed block, MAIN's Z80 program (a Z80 disassembly with asm80 like the
     cartridge driver).
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
| MAIN.BIN | 60,416 | 60,416 (100%) | the older fragments, the second copies, the rest in `src/segacd/main/` (Z80 program as bytes) |
| STARTER.BIN | 120,248 | 120,248 (100%) | the older fragments and `src/segacd/starter/` (tiles, packed block, credits text incbin) |
| HOCKEY.BIN | 184,842 | 184,842 (100%) | 94G twins (some in parts), team data, CD-only pads and pointer table, the older fragments; 43,120 bytes incbin |
| PLAYER.BIN | 44,656 | 44,656 (100%) | the older fragments and `src/segacd/player/` (pictures incbin) |
| GRAPH2.BIN | 3,051,520 | 3,051,520 (100%) | offset table in source, 23 blocks incbin |
| GTABLE.BIN | 2,048 | 2,048 (100%) | 512 longs in source |
| Total code | 410,162 | 410,162 (100%) | was 22,690 (5.5%) at the start of the session |

## Parked units
(none)
