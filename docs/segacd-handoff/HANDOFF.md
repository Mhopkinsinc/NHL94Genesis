# Sega CD handoff

## Now
- Unit: none in progress. Branch `mcmarkis/segacd-hockey` (fork Mhopkinsinc/NHL94Genesis), PR to abdulahmad/NHL94Genesis.
- Last check: 2026-11-10, Windows: `npm run build:segacd` MATCH 59 fragments; `tools/verify_all.sh -q` ALL MATCH.
  `tools/segacd_check.sh`: HOCKEY.BIN 78,476 of 184,842 (42.5%); all code files 98,510 of 410,162 (24.0%).
- Done this session: PLAN step 0 (`tools/segacd_check.sh`), step 2 (`docs/segacd_memory_map.md`: HOCKEY.BIN runs at
  `$1B000`, so the `$37xxx` calls are HOCKEY.BIN itself), and step 1 for 18 of the 94G files: onetimer94, fourway94,
  crowd94, optsetup94, cards94, records94, shootout94, period94, arena94, shootoutpath94, ui94, helpers94, logos94,
  chgplayer94, menu94, stats94, replay94, logic94 (`src/segacd/hockey/`, one file per 94G file, 94G names).
  title94 is not on the disc.
- How: `tools/segacd_port.py` writes a segment from the cartridge listing; `tools/segacd_hockey.sh` holds every
  segment's range, the hand-checked names and the header notes, and writes them all again from scratch
  (`npm run build:retail` first, keep a copy of `output/obj/nhl94 .lst`: the Sega CD build empties `output/obj/`).
  `docs/segacd.md` "HOCKEY.BIN from the cartridge source" explains the method.
- Next, in disc order:
  1. Decision for Abdul (see Open): hockey94 (`$10614`-`$112F7`) and scout94 (`$D1D4`-`$E1CD`) contain the existing
     hand fragments `songplay`, `crowdanim` and `scoutopen`. Either fold them into the 94G twins (drop their
     segacd.json / verifySegacd.js lines, keep their notes) or split the twins around them.
  2. middle94 (`$1BBB2`-), decompress94, print94, then penalty94 / collide94 (interleaved on the disc: penalty94
     starts near `$1E4F2`, collide94 near `$1F212`, more penalty94 near `$215AE`), video94 (`$22AB8`-), setup94,
     tables94. Existing fragments inside them: cdrequest, sfxcd, gate34, cdtrack (middle94 area), cdcrowd (video94),
     cdstart and the scout* trio (setup94 area), crowdtable (tables94). Same decision as 1.
  3. The front of the file (`$0`-`$76A7`): header, team data (`$7C`-), frames94, the game start at `$7096`, sram94
     and the save RAM readers moved from cards94 (`$7534`). Team data holds the licensed player names: read them
     from `cdbin/HOCKEY.BIN` with incbin, as the tool does for the New York nicknames; never write them.
- Open questions:
  - Fold or split around the existing hand fragments (above). Owner decides.
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
| HOCKEY.BIN | 184,842 | 78,476 (42.5%) | 18 94G twins `$76A8`-`$1BBB1` except hockey94 and scout94; the older song/sfx, crowd, scouting fragments |
| PLAYER.BIN | 44,656 | 2,760 (6.2%) | photo picker, career rows, team page |
| GRAPH2.BIN | 3,051,520 | 0 | graphics archive; first longs are offsets |
| GTABLE.BIN | 2,048 | 0 | long offsets |
| Total code | 410,162 | 98,510 (24.0%) | was 22,690 (5.5%) at the start of the session |

## Parked units
(none)
