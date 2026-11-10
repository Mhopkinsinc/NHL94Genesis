# Sega CD handoff

## Now
- Unit: none in progress.
- Last check: 2026-11-10, `npm run build:segacd` on Windows: MATCH 41 fragments, 0 errors. `build:retail` not run (needs the retail ROM).
- Next: PLAN.md step 0 (add a coverage script), then step 1.
- Open questions: the `$37xxx`-`$39xxx` image (PLAN.md step 2).

## Baseline log
- 2026-11-10 (McMarkis session, Windows 11, Node 22): fresh fork, `segacd-disc/*.BIN` copied to `cdbin/` (sizes as in GETTING_FILES.md).
  `npm run build:segacd`: MATCH 41 fragments. `tools/verify_all.sh -q` (with the retail ROM in the repo folder): ALL MATCH.

## Coverage (from NHL94Genesis `docs/segacd.md`, 2026-11-10)
| File | Size | Matched | Notes |
|---|---|---|---|
| MAIN.BIN | 60,416 | 13,994 (23%) | contiguous `$0`-`$34B7` plus Z80 loader and hardware readers |
| STARTER.BIN | 120,248 | 3,280 | boot, heap, PCM chip, audio stream, film player |
| HOCKEY.BIN | 184,842 | 2,656 | song/sfx requests, crowd, scouting text |
| PLAYER.BIN | 44,656 | 2,760 | photo picker, career rows, team page |
| GRAPH2.BIN | 3,051,520 | 0 | graphics archive; first longs are offsets |
| GTABLE.BIN | 2,048 | 0 | long offsets |
| Total code | 410,162 | 22,690 (5.5%) | |

## Parked units
(none)
