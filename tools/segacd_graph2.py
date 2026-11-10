"""segacd_graph2.py: write src/segacd/data/graph2.asm and gtable.asm.

GRAPH2.BIN is a sector archive and GTABLE.BIN its index. This script reads only cdbin/GRAPH2.BIN,
cdbin/GTABLE.BIN and cdbin/HOCKEY.BIN (for the per-team resource list), checks the structure, and writes
both files. The names below were checked by hand: the code that stores each pack entry (scoutload.asm
for resource 0, LoadGameGfx in hockey94.asm for resource 1) and the bytes, compared with the cartridge
graphics files in Extracted/ ("file" below: the piece is that file, byte for byte).

    python tools/segacd_graph2.py        then npm run build:segacd
"""
import os

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
MARK = bytes.fromhex("12345678")        # every resource ends with it

# Resource 0, the start-up pack (scoutload.asm): label, the pointer table entry the code stores it in,
# the cartridge file it equals, or a note.
PACK0 = [
    ("ScoutingReportText", "$47CFC", None, "the scouting script (the disc has its own, longer than the cartridge text)"),
    ("TeamLogos", "$47D8C", None, "the team logos: a table of offsets, then the pictures (resource 4 holds the same)"),
    ("PlayerCards", "$47D88", None, "the player cards: a table of offsets, then the pictures (resource 3 holds the same)"),
    (None, "$47DA4", None, "not known (resource 98 holds the same)"),
    ("SmallFontMap", "SmallFontMapPtr", "SmallFont.map.jim", None),
    ("HotMap", "HotMapPtr", "Hot.map.jim", None),
    ("ColdMap", "ColdMapPtr", "Cold.map.jim", None),
    ("Arrowsmap", "ArrowsmapPtr", "Arrows.map.jim", None),
    ("BigFontMap", "BigFontMapPtr", "BigFont94.map.jim", None),
    ("FramerMap", "FramerMapPtr", "Framer.map.jim", None),
    ("RonBarrMap", "RonBarrMapPtr", "RonBarr.map.jim", None),
    ("PrintFont2Map", "PrintFont2MapPtr", "SmallFont94.map.jim", None),
    ("EASportsBGMap", "EASportsBGMapPtr", "EASportsBG.map.jim", None),
    (None, "$47D08", None, "a screen map with no cartridge twin"),
    ("SetupFramerMap", "SetupFramerMapPtr", "GameSetupBkgd2.map.jim", None),
    ("Teamblocksmap", "TeamblocksmapPtr", None, "the disc has its own (the cartridge TeamBlocks.map.jim is another size)"),
    ("LogoBoxMap", "LogoBoxMapPtr", "GameSetupLogoBorder.map.jim", None),
    ("TeamBitmaps", "TeamBitmapsPtr", "TeamBlocks94.map.jim", None),
    ("StanleyCupSprite", "StanleyCupSpritePtr", None, "the first 4,832 bytes of the cartridge StanleyCup.anim"),
    ("Rinktilelist", "RinktilelistPtr", "IceRink94.map.jim", None),
    ("GameSetUpMap", "GameSetUpMapPtr", "GameSetUp94-1.map.jim", None),
    ("SetupMenuMap", "SetupMenuMapPtr", "GameSetupBkgd1.map.jim", None),
    ("GameSetUpMap2", "GameSetUpMap2Ptr", None, "GameSetUp94-2.map.jim and more"),
]
# Resource 1, the game graphics pack (LoadGameGfx), in the order the code stores the entries.
PACK1 = [
    ("SmallFontMap", "SmallFontMapPtr", "SmallFont.map.jim", None),
    ("Rinktilelist", "RinktilelistPtr", "IceRink94.map.jim", None),
    ("EnergyBarMap", "EnergyBarMapPtr", "EnergyBar.map.jim", None),
    ("CrowdSprites", "CrowdSpritesPtr", "Crowd.anim", None),
    ("BigFontMap", "BigFontMapPtr", "BigFont94.map.jim", None),
    ("EASportsMap", "EASportsMapPtr", "EASports.map.jim", None),
    ("ZamSprites", "ZamSpritesPtr", "Zam.anim", None),
    ("FaceOffSprites", "FaceOffSpritesPtr", "FaceOff.anim", None),
    ("RefsMap", "RefsMapPtr", "Refs.map.jim", None),
    ("RefMap2", "RefMap2Ptr", "Refs2.map.jim", None),
    ("Teamblocksmap", "TeamblocksmapPtr", None, "the disc has its own (resource 0 holds the same)"),
    ("FramerMap", "FramerMapPtr", "Framer.map.jim", None),
    ("ScoresMap", "ScoresMapPtr", "Scores.map.jim", None),
    ("FaceOffMap", "FaceOffMapPtr", "FaceOff.map.jim", None),
    ("HotList", "HotListPtr", None, "the first 1,674 bytes of the cartridge HotList.bin"),
    ("EASportsBGMap", "EASportsBGMapPtr", "EASportsBG.map.jim", None),
    ("RevRinkTilelist", "RevRinkTilelistPtr", "IceRink94Reverse.map.jim", None),
    ("ReplayMap", "ReplayMapPtr", "ReplayOptions.map.jim", None),
    ("IceRinkHorMap", "IceRinkHorMapPtr", "IceRinkHor.map.jim", None),
    ("PrintFont2Map", "PrintFont2MapPtr", "SmallFont94.map.jim", None),
    ("NHLLogoMap", "NHLLogoMapPtr", "NHLLogo.map.jim", None),
    ("NHLPALogoMap", "NHLPALogoMapPtr", None, "the first 1,046 bytes of the cartridge NHLPALogo.map.jim"),
    ("HotMap", "HotMapPtr", "Hot.map.jim", None),
    ("ColdMap", "ColdMapPtr", "Cold.map.jim", None),
    (None, "$47DA8", None, "the same form as the per-team resources 35-62"),
]
TEAMS = "ANH BOS BUF CGY CHI DAL DET EDM FLA HFD LA MTL NJ NYI NYR OTW PHI PIT QUE SJ STL TB TOR VAN WSH WPG ASE ASW".split()
TEAMRES = 0x2A9FA - 0x1B000             # HOCKEY.BIN: the resource number of each team's 782-byte item


def main():
    g = open(os.path.join(ROOT, "cdbin", "GRAPH2.BIN"), "rb").read()
    t = open(os.path.join(ROOT, "cdbin", "GTABLE.BIN"), "rb").read()
    h = open(os.path.join(ROOT, "cdbin", "HOCKEY.BIN"), "rb").read()
    ents = []
    for i in range(0, len(t), 6):
        s, n = int.from_bytes(t[i:i + 2], "big"), int.from_bytes(t[i + 2:i + 6], "big")
        if n == 0:
            break
        ents.append((s, n))
    assert len(ents) == 99 and not any(t[6 * len(ents):]), "GTABLE: 99 entries, then zeros"
    for k, (s, n) in enumerate(ents):
        nxt = ents[k + 1][0] if k + 1 < len(ents) else len(g) // 2048
        assert nxt == s + (n + 2047) // 2048, f"resource {k}: the next starts on the sector after it"
        assert not any(g[s * 2048 + n:nxt * 2048]), f"resource {k}: zero fill"
        assert g[s * 2048 + n - 4:s * 2048 + n] == MARK, f"resource {k}: end mark"
    teamres = [int.from_bytes(h[TEAMRES + 4 * i:TEAMRES + 4 * i + 4], "big") for i in range(28)]
    byres = {r: TEAMS[i] for i, r in enumerate(teamres)}

    # Who loads each resource (BIOS $6044, d7 = 1): HOCKEY.BIN, STARTER.BIN (startertail.asm) and PLAYER.BIN
    # (playerinit.asm; $7C(a6) and $7E(a6) are the home and away team numbers). No load was found for
    # 3, 63, 65-67 and 98: the copies in resource 0 are the ones used.
    res = {
        2: "the sprite pack: two offsets, then Spritetiles.bin (from +$A) and frameSprData.bin (at +$408AA).\n"
           "hockey94 LoadGameGfx and period94 load it into $47D24",
        3: "the player cards: a table of offsets, then the pictures (NoPic*.map.jim, PicturePalette.bin,\n"
           "Card*.map.jim). Resource 0 piece 2 is the same without the end mark; no load of this one found",
        4: "the team logos: a table of offsets, then logoANA.map.jim ... (period94 loads it into $47D8C).\n"
           "Resource 0 piece 1 is the same without the end mark",
        5: "STARTER.BIN loads it (d0 = 5)",
        34: "a table of 28 long offsets, one per team, then the data they point at. PLAYER.BIN keeps it at\n"
            "$86(a6) and its team pages read it",
        64: "a word $0808, the count $5D, 93 tiles (32 bytes each) and 324 bytes more. STARTER.BIN loads it\n"
            "into $C43A, PLAYER.BIN into $70(a6)",
        65: "the Stanley Cup sprite (resource 0 piece 18 without the end mark); no load of this one found",
        66: "Hot.map.jim (HotMap); no load of this one found",
        67: "Cold.map.jim (ColdMap); no load of this one found",
        96: "hockey94 LoadGameGfx loads it (d0 = $60) into $47DA0 and passes it to the BIOS call with d7 = 8",
        97: "STARTER.BIN loads it (d0 = $61) into $C436",
        98: "resource 0 piece 3 without the end mark; no load of this one found",
    }
    for r in range(35, 64):
        res[r] = (f"per team: {byres[r]} (HOCKEY.BIN $2A9FA, one per team; LoadGameGfx loads the home team's\n"
                  "into $47D90)") if r in byres else "the per-team form; no team in the HOCKEY.BIN $2A9FA list uses it"
    for r in range(6, 34):
        res[r] = (f"per team: {TEAMS[r - 6]}'s player photos, a table of offsets then the pictures. PLAYER.BIN\n"
                  "loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)")
    for r in range(68, 96):
        res[r] = (f"per team: {TEAMS[r - 68]}, three offsets then data. PLAYER.BIN loads 68 + team for the home and\n"
                  "away teams (pointers at $0-$8(a6) and $C-$14(a6))")

    out = [
        ";\tGRAPH2.BIN (3,051,520 bytes, 1490 sectors): the graphics archive. Written by tools/segacd_graph2.py.",
        ";\t99 resources, each starting on a 2048-byte sector, ending with the mark $12345678 and zero filled to",
        ";\tthe next sector. GTABLE.BIN (gtable.asm) is the index: the start sector and byte size of each, in",
        ";\tthis order. HOCKEY.BIN, STARTER.BIN and PLAYER.BIN ask for resource n with the BIOS call $6044,",
        ";\td7 = 1 and d0 = n, and get its address in a0.",
        ";",
        ";\tResources 0 and 1 are packs: a table of long offsets from the pack start, then the pieces. The code",
        ";\tadds the pack address to each offset and keeps the pointers in HOCKEY.BIN's graphics pointer table",
        ";\t(src/segacd/hockey/cdgfxptrs.asm): scoutload.asm for resource 0, LoadGameGfx (hockey94.asm) for",
        ";\tresource 1. A piece is named R0_ or R1_ and the cartridge label (graphics94.asm) of the graphic it",
        ";\tis; the comment names the cartridge file when the bytes are that file's. All the data is read from",
        ";\tthe disc file, as the cartridge build reads its graphics from Extracted/.",
        "",
        "\torg\t0",
        "",
        "Graph2",
    ]

    def incbin(a, n):
        return f"incbin\t..\\cdbin\\GRAPH2.BIN,${a:X},{n}"

    def mark():
        out.append("\tdc.b\t$12,$34,$56,$78\t\t\t\t;the end mark")

    def pack(k, names):
        s, size = ents[k]
        base = s * 2048
        blk = g[base:base + size]
        cnt = len(names)
        offs = [int.from_bytes(blk[4 * i:4 * i + 4], "big") for i in range(cnt)]
        assert offs[0] == 4 * cnt, f"resource {k}: {cnt} offsets"
        ends = offs[1:] + [size - 4]
        labs = [f"R{k}_{lab}" if lab else f"R{k}_{i:02}" for i, (lab, _, _, _) in enumerate(names)]
        for i, (lab, ptr, _, _) in enumerate(names):
            out.append(f"\tdc.l\t{labs[i]}-Res{k:02}\t\t\t;{i:2} -> {ptr}")
        for i, (lab, ptr, f, note) in enumerate(names):
            out.append(f"{labs[i]}\t{incbin(base + offs[i], ends[i] - offs[i])}\t;" + (f"= {f}" if f else note))
        mark()

    for k, (s, n) in enumerate(ents):
        a = s * 2048
        if k:
            out.append(f"\tdcb.b\t${a:X}-*,0\t\t\t\t;zero fill to sector ${s:03X}")
        out.append("")
        if k == 0:
            out.append(f";\tresource 0 (sector $000, {n:,} bytes): the start-up pack. scoutload.asm loads it (d0 = 0)")
            out.append("Res00")
            pack(0, PACK0)
        elif k == 1:
            out.append(f";\tresource 1 (sector ${s:03X}, {n:,} bytes): the game graphics pack. LoadGameGfx (hockey94.asm)")
            out.append(";\tloads it (d0 = 1)")
            out.append("Res01")
            pack(1, PACK1)
        else:
            lines = res.get(k, "not traced").split("\n")
            head = f";\tresource {k} (sector ${s:03X}, {n:,} bytes):"
            if len(lines) == 1 and len(head) + len(lines[0]) < 110:
                out.append(f"{head} {lines[0]}")
            else:
                out.append(head)
                out.extend(f";\t{l}" for l in lines)
            out.append(f"Res{k:02}\t{incbin(a, n - 4)}")
            mark()
    out.append(f"\tdcb.b\t${len(g):X}-*,0\t\t\t\t;zero fill to the end of the last sector")
    open(os.path.join(ROOT, "src", "segacd", "data", "graph2.asm"), "w", newline="\n").write("\n".join(out) + "\n")

    what = {0: "the start-up pack", 1: "the game graphics pack", 2: "the sprite pack", 3: "the player cards",
            4: "the team logos", 65: "the Stanley Cup sprite", 66: "Hot.map.jim", 67: "Cold.map.jim"}
    gt = [
        ";\tGTABLE.BIN (2,048 bytes): the index of GRAPH2.BIN (graph2.asm). Written by tools/segacd_graph2.py.",
        ";\t99 entries of 6 bytes, the start sector (word) and the byte size (long) of each resource, then a zero",
        ";\tentry and zero fill. Each resource starts on the sector after the one before it ends, so GRes works",
        ";\tthe start sector out from the sizes. The resource number the programs pass in d0 (BIOS call",
        ";\t$6044, d7 = 1) is the entry number. The code that reads this file is not traced.",
        "",
        "GRes\tMACRO\t\t\t\t\t\t;GRes size: one entry, at the next free sector",
        "\tdc.w\tgsector",
        "\tdc.l\t\\1",
        "gsector\t=\tgsector+((\\1)+2047)/2048",
        "\tENDM",
        "",
        "\torg\t0",
        "",
        "gsector\t=\t0",
        "GTable",
    ]
    what.update({5: "STARTER.BIN", 34: "per-team table (PLAYER.BIN)", 64: "93 tiles (STARTER.BIN, PLAYER.BIN)",
                 96: "LoadGameGfx, BIOS d7 = 8", 97: "STARTER.BIN"})
    for k, (s, n) in enumerate(ents):
        w = what.get(k, "")
        if 6 <= k <= 33:
            w = f"player photos: {TEAMS[k - 6]}"
        if 68 <= k <= 95:
            w = f"per team: {TEAMS[k - 68]} (PLAYER.BIN)"
        if 35 <= k <= 63:
            w = f"per team: {byres[k]}" if k in byres else "per-team form, not used"
        gt.append(f"\tGRes\t${n:X}\t\t\t\t;{k:2}  sector ${s:03X}" + (f"  {w}" if w else ""))
    gt += ["\tdc.w\t0\t\t\t\t\t;the end: a zero entry", "\tdc.l\t0", "\tdcb.b\t$800-*,0"]
    open(os.path.join(ROOT, "src", "segacd", "data", "gtable.asm"), "w", newline="\n").write("\n".join(gt) + "\n")
    print("wrote src/segacd/data/graph2.asm and gtable.asm (99 resources)")


if __name__ == "__main__":
    main()
