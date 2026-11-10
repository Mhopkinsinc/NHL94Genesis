# Sega CD handoff

## Now
- Unit: none in progress. Branch `mcmarkis/segacd-hockey` (fork Mhopkinsinc/NHL94Genesis), PR abdulahmad/NHL94Genesis#239.
- Last check: 2026-11-10, Windows: `npm run build:segacd` MATCH 84 fragments; `tools/verify_all.sh -q` ALL MATCH.
  `tools/segacd_check.sh`: HOCKEY.BIN 163,288 of 184,842 (88.3%; 24,226 of it graphics read with incbin); all code files 183,322
  of 410,162 (44.7%).
- Owner decision (Abdul, on the PR): all Sega CD code goes in the Sega CD folder and does not touch the existing
  work; align code, symbols and file names with 94G where possible. So the older hand fragments in `src/segacd/`
  stay as they are, and a 94G twin whose disc range holds one is written in parts around it (`name.asm`,
  `name_2.asm`, ... in `src/segacd/hockey/`; `port name:2 ...` in `tools/segacd_hockey.sh`).
- Done: PLAN step 0 (`tools/segacd_check.sh`), step 2 (`docs/segacd_memory_map.md`), and step 1 for HOCKEY.BIN
  `$5432` to the end: frames94, sram94 (with `Begin`, the game start), the moved cards94 save RAM readers, onetimer94
  through tables94, graphics94 (two parts), the graphics pointer table (`cdgfxptrs.asm`) and the CD pad reader
  (`cdpads.asm`). title94 is not on the disc. Twins are split around the older hand fragments where needed.
- How: `tools/segacd_port.py` writes a segment from the cartridge listing; `tools/segacd_hockey.sh` holds every
  segment's range, the hand-checked names and the header notes, and writes them all again from scratch
  (`npm run build:retail` first, keep a copy of `output/obj/nhl94 .lst`: the Sega CD build empties `output/obj/`).
  `docs/segacd.md` "HOCKEY.BIN from the cartridge source" explains the method.
- Next:
  1. The front of HOCKEY.BIN, `$0`-`$5431`: the header (`jmp $22096`, 2 unknown bytes, `null`, the 28 `TeamList`
     pointers at `$C`) and the team data from `$7C`. The team data holds licensed player names and team nicknames,
     and the disc rosters differ from the cartridge's (the cartridge-name check cannot catch disc-only names), so
     every string there must be `incbin ..\cdbin\HOCKEY.BIN` (a no-text mode for the port tool, or by hand), never
     `dc.b 'text'`. Ratings and record offsets can be written out.
  2. Then PLAN step 3 (STARTER.BIN) and step 4 (PLAYER.BIN, the rest of MAIN.BIN).
  3. Name the graphics pointer table entries from the cartridge labels they replace (each CD block that loads
     `$47Dxx` stands where the cartridge loaded a label).
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
| HOCKEY.BIN | 184,842 | 163,288 (88.3%) | `$5432` to the end: 94G twins (some in parts), CD-only pads and pointer table, the older fragments |
| PLAYER.BIN | 44,656 | 2,760 (6.2%) | photo picker, career rows, team page |
| GRAPH2.BIN | 3,051,520 | 0 | graphics archive; first longs are offsets |
| GTABLE.BIN | 2,048 | 0 | long offsets |
| Total code | 410,162 | 183,322 (44.7%) | was 22,690 (5.5%) at the start of the session |

## Parked units
(none)
