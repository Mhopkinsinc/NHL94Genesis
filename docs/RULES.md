# Rules (94G)

The rules for this repo's part of the alignment, then the learned rules. Read before every unit. Any tool adds a learned
rule in the same commit as the fix that confirmed it, newest last: `- YYYY-MM-DD <area>: <rule>. (<evidence>)`.

## Who decides what (all games)

| Category | Decided by |
|---|---|
| Name of a routine several games share | the earliest game that has it (92G is the root); a fix goes to the earliest repo first, then down the lineage |
| Name of a feature new in year N | that year's Genesis game (94G for 94S and 94PC, 95G for 95S and 95PC) |
| Name of a platform-only job | the earlier repo on that platform (93S for 94S, 94PC for 95PC), else what the code does |
| Same name, different job | the earlier meaning keeps the name |
| Top folder or file | the same-year Genesis file |
| RAM order | the merged order (92G, 93G, 94G, 93S, 94S, then 95G, 96G) |
| Data, assets, banks | the earlier repo on the same platform |
| Order inside a file | ROM order (the report re-sorts for display) |
| History | `docs/name_map.csv` only, never source comments |

## This repo

- Names: 92G is the root, then 93G. A 94 feature takes the name chosen here; 94S, 94PC, 95G and 95PC copy it.
- Files: this repo is the file-shape reference for 94S and 94PC. Do not re-split files without updating those repos and the report.
- On 2026-10-31 checks94, assign94 and input94 were folded into logic94; data94 and attract94 into setup94; the old video94 became middle94 and display94 became video94. Nothing should still use the old names.

## Learned

- 2026-11-04 contributing: CONTRIBUTING.md must not contradict History: lineage lives only in the name history file, never in source comments. (CONTRIBUTING rewrite vs RULES History row)
- 2026-11-04 name_map: a `from 92 Parent` split is not a rename row. `old,new` is this repo's previous name to its current name; recording Fprint→Fprintsmall made the pairing gate treat 93S/94S Fprint as a stale 94G name (lineage count rose). Delete the comment; do not invent a rename.
- 2026-11-05 names: CreditsList is 93G CreditsPages (String pages after Credits). 92G has only Credits. (owner)
- 2026-11-05 leftover split: high-ROM leftover files stay ROM-contiguous; split only at a global label into the next include. Do not move a routine into an earlier file (MATCH). `goalie94` / `title94` were named for one job but held the rest of high94_3. (Abdul: goalie94 looks like non-goalie, title94 like non-title)
- 2026-11-05 leftover recut: Abdul's cuts are period94 (EndShootout…ManualGoalieMenu), arena94 (RunArenaAnim…RandomSongs), shootoutpath94 (ReadLineData…ShootoutShootCheck), ui94 (UnpackPicture…PlayedByAway), helpers94 (SetSflags8Bit1…EndOneTimer), title94 (TitleScreen…CreditsScrollStep), logos94 (TeamLogoPalettes…HotColdIcon), chgplayer94 (chgplayer…j_setc2player). The leftover path slice cannot be named `shootout94`: that file is already the $FC320 shootout UI. (Abdul 2026-11-05)
