# Sega CD handoff

## Now
- Unit: none in progress. Branch `mcmarkis/segacd-hockey` (fork Mhopkinsinc/NHL94Genesis), PR abdulahmad/NHL94Genesis#239.
- Last check: 2026-11-10, Windows: `npm run build:segacd` MATCH 99 fragments; `tools/verify_all.sh -q` ALL MATCH.
  `tools/segacd_check.sh`: HOCKEY.BIN 184,842 of 184,842 (100%; 43,120 of it read from the disc with incbin: graphics, licensed
  names, team data blocks); STARTER.BIN 21,728 of 120,248 (18.1%); MAIN.BIN 19,666 of 60,416 (32.6%); all code files 228,996 of
  410,162 (55.8%).
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
- STARTER.BIN (PLAN step 3, started): `src/segacd/starter/`, written by `tools/segacd_starter.sh` (no ROM or listing
  needed). All code from `$0` to `$556D` is matched except the name tags after the film functions (`$4538`-`$458B`,
  `$472E`-`$4739`, `$477C`-`$4787`, `$4DCA`-`$4DDD`, `$4EC0`-`$4ECD`, between Abdul's fragments). File `$1000`-`$3D93`
  is a separate driver module that runs at file + `$B000` (docs/segacd.md "STARTER.BIN").
- Next:
  1. STARTER.BIN: name the driver module's routines (command dispatch at `$C542`, gate array, CDC / PCM calls), the
     five tag gaps above, then the data from `$556E` (tables, Example Line strings, 53 KB that look like sound).
  2. PLAN step 4: PLAYER.BIN (linked at 0, relocating start-up) and the rest of MAIN.BIN. `$40D0`-`$56F7` is done
     (`src/segacd/main/*_2.asm`: a byte-for-byte copy of `$1E90`-`$34B7`, the older files included unchanged); left:
     `$34B8`-`$3B3B`, `$3C3E`-`$40CF`, `$56F8`-`$76C7`, `$77B8` to the end.
  3. HOCKEY.BIN polish: the header as source; names for the graphics pointer table entries.
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
| MAIN.BIN | 60,416 | 19,666 (32.6%) | contiguous `$0`-`$34B7`, its second copy at `$40D0`, Z80 loader, hardware readers |
| STARTER.BIN | 120,248 | 21,728 (18.1%) | all code `$0`-`$556D` but five name tags; data from `$556E` |
| HOCKEY.BIN | 184,842 | 184,842 (100%) | 94G twins (some in parts), team data, CD-only pads and pointer table, the older fragments; 43,120 bytes incbin |
| PLAYER.BIN | 44,656 | 2,760 (6.2%) | photo picker, career rows, team page |
| GRAPH2.BIN | 3,051,520 | 0 | graphics archive; first longs are offsets |
| GTABLE.BIN | 2,048 | 0 | long offsets |
| Total code | 410,162 | 228,996 (55.8%) | was 22,690 (5.5%) at the start of the session |

## Parked units
(none)
