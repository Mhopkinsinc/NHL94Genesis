#!/usr/bin/env python3
"""Port a range of the cartridge source to a HOCKEY.BIN fragment.

HOCKEY.BIN is the cartridge game linked again for the sub CPU (loaded at $1B000) with long
absolute addresses and no branch / quick-form optimisation. This tool walks the cartridge
source of one 94G file (from the build listing) and the disc bytes side by side:

  * an instruction whose disc decode is the cartridge instruction with relocated operands is
    written with the cartridge source's labels, symbols and comments, and the disc encoding
    (bsr.w for bsr.s, addi for addq, (sym).l for (sym).w ...);
  * data that is byte-equal is copied from the source line (String macros and all);
  * disc bytes with no cartridge twin are written as plain instructions under a "CD:" comment;
  * cartridge lines with no disc twin are dropped (counted in the report).

Symbols the fragment uses but does not define are solved from the disc operands: a RAM name
(the cartridge has it at $FFxxxx) goes into the shared include (one HOCKEY.BIN RAM map for all
fragments), a constant keeps its cartridge value, and a routine outside the fragment becomes an
equate at the top of the fragment. Anything that cannot be solved stays a number.

After writing the file it is assembled the same way build.js does, and any instruction that
SNASM encodes differently from the disc is replaced by its dc.w bytes (with a comment), so the
result matches by construction; the report says how many lines needed that.

  python tools/segacd_port.py --file onetimer94.asm --disc-start 0x76A8 --disc-end 0x7DDE \\
      --out src/segacd/hockey/onetimer94.asm

Needs the cartridge listing (output/obj/nhl94 .lst from npm run build:retail, or --lst), the
retail ROM (for the real bytes; the listing leaves forward references as 0), and cdbin/HOCKEY.BIN.
"""

import argparse
import os
import re
import subprocess
import sys

from capstone import Cs, CS_ARCH_M68K, CS_MODE_BIG_ENDIAN, CS_MODE_M68K_000

md = Cs(CS_ARCH_M68K, CS_MODE_M68K_000 | CS_MODE_BIG_ENDIAN)
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
BASE = 0x1B000
OPTIONS = ["/o", "d-", "/o", "s-", "/o", "r+", "/o", "l+", "/o", "l.", "/o", "ow+", "/o", "op-",
           "/o", "os+", "/o", "oz-", "/o", "omq-", "/o", "oaq-", "/o", "osq-"]

BRANCHES = {"bra", "bsr", "beq", "bne", "bhi", "bls", "bcc", "bcs", "bpl", "bmi", "bvc", "bvs",
            "bge", "bgt", "ble", "blt", "bhs", "blo"}
DBCC = {"dbra", "dbf", "dbt", "dbeq", "dbne", "dbhi", "dbls", "dbcc", "dbcs", "dbpl", "dbmi",
        "dbvc", "dbvs", "dbge", "dbgt", "dble", "dblt"}
DATA = {"dc", "dc.b", "dc.w", "dc.l", "ds", "ds.b", "ds.w", "ds.l", "dcb", "dcb.b", "dcb.w", "dcb.l"}
ALIGN = {"even", "cnop", "align"}
DIRECTIVES = {"include", "if", "ifd", "ifnd", "else", "elseif", "endif", "endc", "inform", "opt",
              "list", "nolist", "rsset", "rsreset", "module", "modend", "section", "incbin_off"}
REGS = {f"d{i}" for i in range(8)} | {f"a{i}" for i in range(8)} | {"sp", "pc", "sr", "ccr", "usp"}
ID = r"[A-Za-z_.@][\w.@$]*"


# ---------------------------------------------------------------- listing

class Line:
    __slots__ = ("addr", "field", "mac", "src", "n")

    def __init__(self, addr, field, mac, src, n):
        self.addr, self.field, self.mac, self.src, self.n = addr, field, mac, src, n


def read_listing(path):
    out = []
    with open(path, encoding="latin1") as f:
        for n, raw in enumerate(f):
            raw = raw.rstrip("\r\n")
            if len(raw) < 9 or not re.match(r"[0-9A-F]{8} ", raw):
                continue
            out.append(Line(int(raw[:8], 16), raw[9:34].strip(), len(raw) > 34 and raw[34] == "M",
                            raw[36:] if len(raw) > 36 else "", n))
    return out


def split_comment(s):
    """(code, comment) with the comment starting at a ; outside quotes."""
    q = None
    for i, ch in enumerate(s):
        if q:
            if ch == q:
                q = None
        elif ch in "'\"":
            q = ch
        elif ch == ";":
            return s[:i], s[i:]
    return s, ""


def split_ops(s):
    """Split an operand field at top-level commas."""
    out, depth, q, cur = [], 0, None, ""
    for ch in s:
        if q:
            cur += ch
            if ch == q:
                q = None
            continue
        if ch in "'\"":
            q = ch
        elif ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        elif ch == "," and depth == 0:
            out.append(cur.strip())
            cur = ""
            continue
        cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


def parse_src(src):
    """label, mnemonic, operands, comment of one source line."""
    code, comment = split_comment(src)
    label = None
    m = re.match(r"(" + ID + r"):?", code)
    if m and not code[:1].isspace():
        label = m.group(1)
        code = code[m.end():]
    parts = code.strip().split(None, 1)
    mnem = parts[0] if parts else ""
    ops = parts[1].strip() if len(parts) > 1 else ""
    return label, mnem, ops, comment


def symbols(lines):
    """Cartridge symbol values: global labels, local labels (scope, name), equates."""
    glob, kind, local = {}, {}, {}
    scope = None
    for ln in lines:
        if ln.mac:
            continue
        code, _ = split_comment(ln.src)
        m = re.match(r"(" + ID + r")(:?)(\s+(.*))?$", code)
        if not m or code[:1].isspace():
            continue
        name = m.group(1)
        rest = (m.group(4) or "").strip()
        low = rest.lower()
        eq = re.match(r"(equ|set|rs\.[bwl]|rs|=|equr|reg|macro)\b", low) or low.startswith("=")
        if eq:
            if ln.field.startswith("="):
                glob[name] = int(ln.field[1:9], 16)
                kind[name] = "rs" if low.startswith("rs") else "equ"
            continue
        if name.startswith("."):
            local[(scope, name)] = ln.addr
        else:
            glob[name] = ln.addr
            kind[name] = "label"
            scope = name
    return glob, kind, local


# ---------------------------------------------------------------- items

class Item:
    def __init__(self, ln, label, mnem, ops, comment, scope):
        self.ln = ln
        self.addr = ln.addr
        self.label, self.mnem, self.ops, self.comment = label, mnem, ops, comment
        self.scope = scope           # global label in force for local names
        self.pre = []                # comment lines and labels before this item
        self.licensed = False        # from an Extracted/ include: the bytes come from the disc file
        self.exp = []                # macro expansion lines
        self.len = 0
        self.kind = None             # insn / data / align / macro / dir
        self.cart = b""
        self.norm = None


def build_items(lines, lo, hi, rom, cart_glob, nlo=None, nhi=None):
    if nlo is not None:
        sel = [ln for ln in lines if nlo < ln.n < nhi]
    else:
        sel = [ln for ln in lines if lo <= ln.addr < hi]
    items, pre = [], []
    scope = None
    i = 0
    lic_left = 0                 # lines still to come from an Extracted/ include (licensed text)
    lic_lines = set()
    while i < len(sel):
        ln = sel[i]
        if ln.mac:
            i += 1
            continue
        if lic_left:
            lic_left -= 1
            lic_lines.add(ln.n)
        label, mnem, ops, comment = parse_src(ln.src)
        low = mnem.lower()
        if low == "include" and "extracted" in ops.lower():
            path = os.path.join(ROOT, "src", ops.split()[0].replace("\\", os.sep))
            if not os.path.exists(path):
                sys.exit(f"{path}: needed to know which lines are licensed text (run npm run build:retail)")
            lic_left = len(open(path, encoding="latin1").read().rstrip("\n").split("\n"))
        if label and not label.startswith("."):
            code = split_comment(ln.src)[0]
            if re.match(r"\S+\s+(equ|set|rs|=|macro|reg|equr)\b", code, re.I) or re.match(r"\S+\s*=", code):
                pre.append(("dir", ln))
                i += 1
                continue
            scope = label
        if not mnem:
            pre.append(("label" if label else "text", ln))
            i += 1
            continue
        it = Item(ln, label, mnem, ops, comment, scope)
        it.pre, pre = [x for x in pre if x[1].n not in lic_lines], []
        it.licensed = ln.n in lic_lines
        j = i + 1
        while j < len(sel) and sel[j].mac:
            it.exp.append(sel[j])
            j += 1
        # next non-macro line gives the end address
        nxt = hi
        for k in range(j, len(sel)):
            if not sel[k].mac:
                nxt = sel[k].addr
                break
        else:
            nxt = hi
        it.len = max(0, nxt - it.addr)
        it.cart = rom[it.addr:it.addr + it.len]
        if low in DATA or low == "incbin":
            it.kind = "data"
        elif low in ALIGN:
            it.kind = "align"
        elif low in DIRECTIVES:
            it.kind = "dir"
        elif it.exp:
            it.kind = "macro"
        elif it.len == 0:
            it.kind = "dir"
        else:
            it.kind = "insn"
            d = decode(rom, it.addr, it.addr + it.len, 0)
            if d is None or d.size != it.len:
                it.kind = "data"
            else:
                it.norm = norm(d)
        items.append(it)
        i = j
    tail = pre
    return items, tail


# ---------------------------------------------------------------- decoding

_cache = {}


def decode(blob, pc, end, base):
    key = (id(blob), pc, base)
    if key in _cache:
        return _cache[key]
    got = None
    if pc + 2 <= len(blob):
        for insn in md.disasm(blob[pc:pc + 10], base + pc):
            got = insn
            break
    if got is not None:
        raw = bytes(got.bytes)
        if got.size < 2 or pc + got.size > end or got.mnemonic in ("dc.w", "illegal"):
            got = None
        elif got.mnemonic.startswith("ori") and got.size == 2:
            got = None                       # capstone reads 0000 as a two-byte ori
    _cache[key] = got
    return got


def norm(insn):
    m = insn.mnemonic
    op = insn.op_str
    base = m.split(".")[0]
    if base in BRANCHES:
        return base + " @"
    if base in DBCC:
        return "dbra " + op.split(",")[0]
    sz = m.split(".")[-1] if "." in m else ""
    if base in ("cmp", "add", "sub", "and", "or", "eor") and op.startswith("#"):
        base = base + "i"
    if base == "moveq":
        base, sz = "move", "l"
    if base in ("addq", "addi"):
        base = "add"
    elif base in ("subq", "subi"):
        base = "sub"
    m = base + ("." + sz if sz else "")
    if base in ("jsr", "jmp") and "(pc" not in op and re.match(r"\$[0-9a-f]+(\.[wl])?$", op):
        return base + " @"
    if base in ("jsr", "jmp", "lea", "pea") and re.match(r"\$[0-9a-f]+(\.[wl]|\(pc\))", op):
        op = re.sub(r"\$[0-9a-f]+(\.[wl]|\(pc\))", "@", op)    # jsr x.l <-> bsr / lea (pc) <-> lea x.l
    op = re.sub(r"(?<![\w$])\$0\((a[0-7])", r"(\1", op)
    op = re.sub(r"(?<![\w$-])\$[0-9a-f]{3,}\((a[0-7])", r"@(\1", op)  # struct offsets can differ on the disc       # Xpos(a3), Xpos = 0: (a3) on the cartridge
    op = re.sub(r"\$[0-9a-f]+\.[wl]", "@", op)
    op = re.sub(r"\$[0-9a-f]+\(pc", "@(pc", op)
    op = re.sub(r"#\$[0-9a-f]{3,}", "#@", op)
    return m + " " + op


# ---------------------------------------------------------------- operands

def fmt_num(n):
    return f"${n:X}"


def disc_operands(insn):
    """Capstone operands -> list of dicts: text (SNASM), mode, value."""
    out = []
    for op in split_ops(insn.op_str.replace(", ", ",")):
        o = {"raw": op, "mode": "reg", "value": None, "text": None}
        t = re.sub(r"\ba7\b", "sp", op)
        m = re.match(r"#(-?)\$([0-9a-f]+)$", t)
        if m:
            o["mode"], o["value"] = "imm", int(m.group(2), 16) * (-1 if m.group(1) else 1)
        elif re.match(r"\$([0-9a-f]+)\.([wl])$", t):
            m = re.match(r"\$([0-9a-f]+)\.([wl])$", t)
            v = int(m.group(1), 16)
            if m.group(2) == "w" and v >= 0x8000:
                v |= 0xFFFF0000
            o["mode"], o["value"], o["size"] = "abs", v, m.group(2)
        elif re.match(r"(-?)\$([0-9a-f]+)\(pc(,.*)?\)$", t):
            m = re.match(r"(-?)\$([0-9a-f]+)\(pc(,.*)?\)$", t)
            o["mode"], o["value"], o["idx"] = "pcrel", int(m.group(2), 16), m.group(3) or ""
        elif re.match(r"(-?)\$([0-9a-f]+)\((a[0-7]|sp)(,.*)?\)$", t):
            m = re.match(r"(-?)\$([0-9a-f]+)\((a[0-7]|sp)(,.*)?\)$", t)
            o["mode"] = "disp"
            o["value"] = int(m.group(2), 16) * (-1 if m.group(1) else 1)
            o["reg"], o["idx"] = m.group(3), m.group(4) or ""
        elif re.match(r"\$([0-9a-f]+)$", t):
            o["mode"], o["value"] = "target", int(t[1:], 16)
        o["t"] = t
        out.append(o)
    return out


def snasm_text(o, insn):
    """Numeric SNASM text for one disc operand."""
    t, mode, v = o["t"], o["mode"], o["value"]
    base = insn.mnemonic.split(".")[0]
    if mode == "imm":
        if base == "moveq" and v >= 0x80:
            return f"#{v - 256}"
        return "#" + (f"-${-v:X}" if v < 0 else fmt_num(v))
    if mode == "abs":
        return f"${v:X}.{o['size']}"
    if mode == "disp":
        d = f"-${-v:X}" if v < 0 else fmt_num(v)
        return f"{d}({o['reg']}{o['idx']})"
    if mode in ("pcrel", "target"):
        return None                     # resolved by the caller (label or equate)
    return re.sub(r"\$([0-9a-f]+)", lambda m: "$" + m.group(1).upper(), t)


def cart_expr(op, mode):
    """Expression part of a cartridge operand for a given disc mode, or None."""
    s = op.strip()
    if mode == "imm":
        return s[1:].strip() if s.startswith("#") else None
    if mode == "abs":
        m = re.match(r"^\((.*)\)\.([wlWL])$", s) or re.match(r"^(.*?)\.([wlWL])$", s)
        if m:
            return m.group(1)
        if "(" in s and not s.startswith("("):
            return None
        return s
    if mode in ("disp", "pcrel"):
        m = re.match(r"^(.*?)\(\s*(a[0-7]|sp|pc)\s*(,.*)?\)$", s, re.I)
        if m:
            return m.group(1).strip() or "0"
        return None
    if mode == "target":
        return s
    return None


def has_ident(expr):
    for tok in re.findall(ID, expr or ""):
        if tok.lower() not in REGS and not re.match(r"\.[wlbs]$", tok.lower()):
            return True
    return False


# ---------------------------------------------------------------- expressions

class Unknown(Exception):
    pass


def evaluate(expr, lookup):
    """Evaluate a SNASM expression with lookup(name) -> int (raises Unknown)."""
    e = expr.strip()
    if not e:
        raise Unknown(expr)
    py = ""
    i = 0
    while i < len(e):
        ch = e[i]
        if ch == "$":
            m = re.match(r"\$([0-9A-Fa-f]+)", e[i:])
            py += str(int(m.group(1), 16))
            i += m.end()
        elif ch == "%":
            m = re.match(r"%([01]+)", e[i:])
            if not m:
                py += "%"
                i += 1
                continue
            py += str(int(m.group(1), 2))
            i += m.end()
        elif ch == "'":
            m = re.match(r"'([^']*)'", e[i:])
            if not m:
                raise Unknown(expr)
            v = 0
            for c in m.group(1):
                v = v * 256 + ord(c)
            py += str(v)
            i += m.end()
        elif ch.isdigit():
            m = re.match(r"\d+", e[i:])
            py += m.group(0)
            i += m.end()
        elif re.match(ID, e[i:]):
            m = re.match(ID, e[i:])
            py += "(" + str(lookup(m.group(0))) + ")"
            i += m.end()
        elif ch in "+-*/()&|^~<> \t!":
            if ch == "/":
                py += "//"
            elif ch == "!":
                py += "|"
            elif ch == "*" and (not py.strip() or py.strip()[-1] in "+-*/(&|^~<>"):
                raise Unknown(expr)            # * as the location counter
            else:
                py += ch
            i += 1
        else:
            raise Unknown(expr)
    try:
        return int(eval(py, {"__builtins__": {}}, {}))
    except Exception:
        raise Unknown(expr)


# ---------------------------------------------------------------- main work

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--lst", default=os.path.join(ROOT, "output", "obj", "nhl94 .lst"))
    ap.add_argument("--rom", default=None)
    ap.add_argument("--disc", default=os.path.join(ROOT, "cdbin", "HOCKEY.BIN"))
    ap.add_argument("--file", help="94G source file name (onetimer94.asm): its whole range")
    ap.add_argument("--cart-start", type=lambda s: int(s, 0))
    ap.add_argument("--cart-end", type=lambda s: int(s, 0))
    ap.add_argument("--disc-start", type=lambda s: int(s, 0), required=True)
    ap.add_argument("--disc-end", type=lambda s: int(s, 0), required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--inc", default=os.path.join(ROOT, "src", "segacd", "hockey", "hockey.inc"))
    ap.add_argument("--note", default=None, help="header note; a backslash-n in it starts a new line")
    ap.add_argument("--no-assemble", action="store_true")
    ap.add_argument("--register", action="store_true",
                    help="add the fragment to tools/segacd.json, tools/verifySegacd.js and the name map")
    ap.add_argument("--name", action="append", default=[], metavar="NAME=ADDR",
                    help="a disc address checked by hand (a RAM name or a routine outside the fragment)")
    a = ap.parse_args()

    rom_path = a.rom
    if not rom_path:
        sys.path.insert(0, os.path.join(ROOT, "tools"))
        rom_path = find_rom()
    rom = open(rom_path, "rb").read()
    disc = open(a.disc, "rb").read()
    if not os.path.exists(a.lst):
        sys.exit(f"{a.lst}: no cartridge listing. Run npm run build:retail (the Sega CD build empties output/obj/),\n"
                 "or pass --lst with a saved copy.")
    lines = read_listing(a.lst)
    cart_glob, cart_kind, cart_local = symbols(lines)

    lo, hi = a.cart_start, a.cart_end
    nlo = nhi = None
    if a.file:
        lo, hi, nlo, nhi = file_range(lines, a.file)
    items, tail = build_items(lines, lo, hi, rom, cart_glob, nlo, nhi)
    scope0 = scope_at(lines, lo)
    for it in items:
        if it.scope is None:
            it.scope = scope0

    walk = align(items, disc, a.disc_start, a.disc_end)
    frag = Fragment(a, items, walk, disc, rom, cart_glob, cart_kind, cart_local, lines, lo, hi, tail)
    for nv in a.name:
        n, v = nv.split("=")
        if n not in cart_glob:
            sys.exit(f"--name {nv}: {n} is not a cartridge name")
        frag.dsym[n] = int(v, 0)
    text = frag.emit()
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    open(a.out, "w", newline="\n").write(text)
    frag.write_inc()
    if not a.no_assemble:
        frag.fix_by_assembly(a.out)
    frag.report()
    if a.register:
        register(a, frag)


def find_rom():
    import hashlib
    want = "7b1489ab501258133bf03e5f0892b77d04312580"
    for n in os.listdir(ROOT):
        p = os.path.join(ROOT, n)
        if os.path.isfile(p) and n.lower().endswith((".bin", ".gen", ".md")) and os.path.getsize(p) == 0x100000:
            if hashlib.sha1(open(p, "rb").read()).hexdigest() == want:
                return p
    sys.exit("retail ROM not found in the repo folder (see tools/roms.js)")


def file_range(lines, name):
    inc = [(ln.addr, ln.n, split_comment(ln.src)[0].split()[-1]) for ln in lines
           if re.match(r"\s+include\s", split_comment(ln.src)[0]) and ln.src.strip().lower().startswith("include")]
    # top-level includes only: the ones listed in nhl94.asm order with increasing address
    for k, (addr, n, f) in enumerate(inc):
        if f.split("\\")[-1].lower() == name.lower():
            # the end is the next include whose address is higher
            for addr2, n2, f2 in inc[k + 1:]:
                if addr2 > addr and not f2.lower().endswith((".inc", ".mac")) and "Extracted" not in f2:
                    return addr, addr2, n, n2
    sys.exit(f"{name}: not found in the listing")


def scope_at(lines, lo):
    scope = None
    for ln in lines:
        if ln.addr > lo:
            break
        if ln.mac:
            continue
        code = split_comment(ln.src)[0]
        m = re.match(r"([A-Za-z_][\w@$]*)(:?)(\s+(.*))?$", code)
        if m and not code[:1].isspace():
            rest = (m.group(4) or "").lower()
            if not re.match(r"(equ|set|rs|=|macro|reg|equr)\b", rest) and not rest.startswith("="):
                scope = m.group(1)
    return scope


# ---------------------------------------------------------------- alignment

K = 3


def item_matches(it, disc, p, end):
    """Disc length when item it is at disc p, else None."""
    if it.kind == "insn":
        d = decode(disc, p, end, BASE)
        if d is not None and norm(d) == it.norm:
            return d.size
        return None
    if it.kind in ("data", "macro"):
        if it.len and disc[p:p + it.len] == it.cart:
            return it.len
        return None
    if it.kind == "align":
        if it.mnem.lower() == "even":
            return (p + BASE) & 1
        return it.len if disc[p:p + it.len] == it.cart else None
    if it.kind == "dir":
        return 0
    return None


def soft_matches(it, disc, p, end):
    """Data that carries addresses: same length, bytes may differ."""
    if it.kind == "data" and it.len and has_ident(it.ops) and p + it.len <= end:
        return it.len
    return None


def run_ok(items, i, disc, p, end, k):
    n = 0
    while n < k:
        if i >= len(items):
            return n > 0
        it = items[i]
        ln = item_matches(it, disc, p, end)
        if ln is None:
            return False
        if it.kind not in ("dir", "align") or ln:
            n += 1
        i += 1
        p += ln
    return True


def align(items, disc, start, end):
    walk = []        # ("m", item, p, len) / ("s", item, p, len) / ("cd", p, q) / ("cut", item)
    i, p = 0, start
    while i < len(items) and p < end:
        it = items[i]
        ln = item_matches(it, disc, p, end)
        in_run = bool(walk) and walk[-1][0] in ("m", "s")
        if ln is not None and (it.kind != "insn" or in_run or run_ok(items, i, disc, p, end, 2) or i + 1 == len(items)):
            walk.append(("m", it, p, ln))
            i += 1
            p += ln
            continue
        ln = soft_matches(it, disc, p, end)
        if ln is not None and run_ok(items, i + 1, disc, p + ln, end, K):
            walk.append(("s", it, p, ln))
            i += 1
            p += ln
            continue
        # resync: the cheapest (skip cart items, skip disc bytes) that gives K matches
        best = None
        for di in range(0, min(400, len(items) - i)):
            if best and di >= best[0]:
                break
            j = i + di
            if items[j].kind != "insn":
                continue
            maxq = min(end, p + 6000)
            q = p
            while q < maxq:
                cost = di + (q - p) / 8
                if best and cost >= best[0]:
                    break
                if run_ok(items, j, disc, q, end, K):
                    best = (cost, j, q)
                    break
                q += 2
        if best is None:
            break
        _, j, q = best
        for it2 in items[i:j]:
            walk.append(("cut", it2))
        if q > p:
            walk.append(("cd", p, q))
        i, p = j, q
    for it2 in items[i:]:
        walk.append(("cut", it2))
    if p < end:
        walk.append(("cd", p, end))
    return walk


# ---------------------------------------------------------------- emission

class Fragment:
    def __init__(self, a, items, walk, disc, rom, cglob, ckind, clocal, lines, lo, hi, tail):
        self.a, self.items, self.walk, self.disc, self.rom = a, items, walk, disc, rom
        self.cglob, self.ckind, self.clocal = cglob, ckind, clocal
        self.lo, self.hi, self.tail = lo, hi, tail
        self.start, self.end = a.disc_start, a.disc_end
        self.dsym = {}          # name -> disc value (solved)
        self.labels = {}        # disc runtime address -> [(name, scope)]
        self.label_at = {}      # (scope, name) or name -> disc runtime address
        self.inc_old = read_inc(a.inc)
        self.stats = {"aligned": 0, "soft": 0, "cd_bytes": 0, "cut": 0, "numeric": 0, "dcw": 0}
        self.externs = {}
        self.inc_new = {}
        self.globals_sorted = []
        self.starts = set()
        self.constraints = []
        self.force_numeric = set()
        self.evidence = set()

    # -- labels from aligned items
    def place_labels(self):
        self.starts = set()
        for w in self.walk:
            if w[0] in ("m", "s") and w[1].kind in ("insn", "data", "macro"):
                self.starts.add(BASE + w[2])
            elif w[0] == "cd":
                pc = w[1]
                while pc < w[2]:
                    self.starts.add(BASE + pc)
                    d = decode(self.disc, pc, w[2], BASE)
                    pc += d.size if d is not None else 2
        for w in self.walk:
            if w[0] in ("m", "s"):
                it, p = w[1], w[2]
                rt = BASE + p
                for kind, ln in it.pre:
                    if kind == "label":
                        lab = parse_src(ln.src)[0]
                        self.add_label(lab, rt, it.scope)
                if it.label:
                    self.add_label(it.label, rt, it.scope)

    def add_label(self, lab, rt, scope):
        key = (scope, lab) if lab.startswith(".") else lab
        self.label_at[key] = rt
        self.labels.setdefault(rt, []).append(lab)
        if not lab.startswith("."):
            self.globals_sorted = sorted(self.globals_sorted + [(rt, lab)])

    def lookup_disc(self, name, scope):
        """Disc value of a symbol, or raise Unknown."""
        if name.startswith("."):
            key = (scope, name)
            if key in self.label_at:
                return self.label_at[key]
            raise Unknown(name)
        if name in self.label_at:
            return self.label_at[name]
        if name in self.dsym:
            return self.dsym[name]
        if name in self.inc_old:
            return self.inc_old[name]
        k = self.ckind.get(name)
        if k in ("equ", "rs"):
            v = self.cglob[name]
            if v >= 0xFF0000 or (0xFFFF0000 <= v):
                raise Unknown(name)            # RAM: the disc has its own map
            return v
        raise Unknown(name)

    def place_from_evidence(self, name, rt, scope):
        """A cartridge label whose line has no disc twin, put where the disc branch to it goes."""
        if not (BASE + self.start <= rt < BASE + self.end) or rt not in self.starts:
            return False
        if name.startswith("."):
            if self.scope_of(rt) != scope or (scope, name) in self.label_at:
                return False
        else:
            if name in self.label_at or self.ckind.get(name) != "label":
                return False
            # a global label must not split the local labels around it
            if any(self.scope_of(rt) == sc and lab_rt >= rt for (sc, lab), lab_rt in
                   [(k, v) for k, v in self.label_at.items() if isinstance(k, tuple)]):
                return False
        self.add_label(name, rt, scope)
        self.evidence.add((rt, name))
        return True

    def is_address(self, name):
        k = self.ckind.get(name)
        v = self.cglob.get(name)
        if name.startswith("."):
            return True
        if k == "label":
            return True
        return v is not None and v >= 0xFF0000

    def solve(self, expr, value, width, scope, mode=None):
        """Try to make expr equal value (mod width). Returns True and records new symbols."""
        mask = (1 << width) - 1
        try:
            v = evaluate(expr, lambda n: self.lookup_disc(n, scope))
            if (v & mask) == (value & mask):
                return True
            if mode != "disp":
                return False
            # a struct offset whose disc value differs (the disc team struct has an extra word)
            free = [t for t in re.findall(ID, expr) if t.lower() not in REGS and not t.startswith(".")
                    and self.ckind.get(t) in ("equ", "rs") and not self.is_address(t)
                    and t not in self.dsym and t not in self.inc_old]
            if len(free) != 1:
                return False
            u = free[0]
            v0 = evaluate(expr, lambda n: 0 if n == u else self.lookup_disc(n, scope))
            v1 = evaluate(expr, lambda n: 1 if n == u else self.lookup_disc(n, scope))
            if v1 - v0 != 1:
                return False
            sol = (value - v0) & mask
            if sol & 0x8000 and width == 16:
                sol -= 0x10000
            if sol < 0:
                return False
            self.dsym[u] = sol
            return True
        except Unknown:
            pass
        unknown = []
        for tok in re.findall(ID, expr):
            if tok.lower() in REGS:
                continue
            try:
                self.lookup_disc(tok, scope)
            except Unknown:
                if tok not in unknown:
                    unknown.append(tok)
        if len(unknown) != 1:
            return False
        u = unknown[0]
        if mode == "target" and expr.strip() == u:
            return self.place_from_evidence(u, value, scope)
        if u.startswith(".") or not self.is_address(u) and u in self.cglob:
            return False
        if u not in self.cglob:
            return False

        def at(x):
            return evaluate(expr, lambda n: x if n == u else self.lookup_disc(n, scope))
        try:
            v0, v1 = at(0), at(1)
        except Unknown:
            return False
        if v1 - v0 == 1:
            sol = (value - v0) & 0xFFFFFFFF
        elif v1 - v0 == -1:
            sol = (v0 - value) & 0xFFFFFFFF
        else:
            return False
        if width < 32:
            # a 16-bit absolute / displacement: only a RAM or code address makes sense
            if sol & 0x8000 and width == 16:
                sol |= 0xFFFF0000
            sol &= 0xFFFFFFFF
        self.dsym[u] = sol
        return True

    def sym_operand(self, cop, o, insn, scope, key=None):
        """Symbolic text for disc operand o using cartridge operand cop, or None."""
        expr = cart_expr(cop, o["mode"])
        if expr is None or not has_ident(expr) or key in self.force_numeric:
            return None
        base = insn.mnemonic.split(".")[0]
        sz = insn.mnemonic.split(".")[-1] if "." in insn.mnemonic else "w"
        mode, width = None, 32
        if o["mode"] == "imm":
            width = {"b": 8, "w": 16, "l": 32}.get(sz, 16)
            if base == "moveq":
                width = 8
            if base in ("btst", "bset", "bclr", "bchg") or (base in ("lsl", "lsr", "asl", "asr", "rol", "ror", "roxl", "roxr", "addq", "subq")):
                width = 8
            if base in ("adda", "suba") and width >= 16:
                mode = "disp"                   # a struct offset added to a pointer
            text = "#" + expr
        elif o["mode"] == "abs":
            text = f"({expr}).{o['size']}"
        elif o["mode"] == "disp":
            mode, width = "disp", 16
            text = f"{expr}({o['reg']}{o['idx']})"
        elif o["mode"] == "pcrel":
            text = f"{expr}(pc{o['idx']})"
        elif o["mode"] == "target":
            mode = "target"
            text = expr
        else:
            return None
        if not self.solve(expr, o["value"], width, scope, mode):
            return None
        self.constraints.append((key, expr, o["value"], width, scope))
        return text

    def validate(self):
        """Every symbolic operand still equal to its disc value? Solve struct offsets that were
        assumed at their cartridge value; return the operand keys that cannot be made to fit."""
        changed = True
        while changed:
            changed = False
            for key, expr, value, width, scope in self.constraints:
                mask = (1 << width) - 1
                try:
                    if (evaluate(expr, lambda n: self.lookup_disc(n, scope)) & mask) == (value & mask):
                        continue
                except Unknown:
                    continue
                if self.solve(expr, value, width, scope, "disp"):
                    changed = True
        bad = set()
        for key, expr, value, width, scope in self.constraints:
            mask = (1 << width) - 1
            try:
                ok = (evaluate(expr, lambda n: self.lookup_disc(n, scope)) & mask) == (value & mask)
            except Unknown:
                ok = False
            if not ok:
                bad.add(key)
        return bad

    def same_number(self, cop, o, insn):
        """The cartridge operand text, when it is a plain number equal to the disc operand."""
        expr = cart_expr(cop, o["mode"])
        if expr is None:
            return None
        try:
            v = evaluate(expr, lambda n: (_ for _ in ()).throw(Unknown(n)))
        except Unknown:
            return None
        base = insn.mnemonic.split(".")[0]
        sz = insn.mnemonic.split(".")[-1] if "." in insn.mnemonic else "w"
        width = 16 if o["mode"] == "disp" else {"b": 8, "w": 16, "l": 32}.get(sz, 16)
        if base == "moveq":
            width = 8
        mask = (1 << width) - 1
        if (v & mask) != (o["value"] & mask):
            return None
        c = cop.strip()
        if o["mode"] == "disp" and c.startswith("("):
            return "0" + c                  # the disc keeps the zero displacement
        return c

    def scope_of(self, rt):
        """The global label in force at runtime address rt in the emitted fragment."""
        best = None
        for pos, name in self.globals_sorted:
            if pos <= rt:
                best = name
            else:
                break
        return best

    def target_name(self, rt, scope):
        """Label text for a branch / pc target at runtime address rt."""
        for lab in self.labels.get(rt, []):
            if not lab.startswith("."):
                return lab
            if self.label_at.get((scope, lab)) == rt:
                return lab
        if rt in self.starts and self.scope_of(rt) == scope:
            self.auto.add(rt)
            return f".L{rt:X}"
        for n, v in self.dsym.items():
            if v == rt and self.ckind.get(n) == "label":
                return n
        name = f"X_{rt:X}"
        self.externs[name] = rt
        return name

    def rev_name(self, v):
        """A unique name for address v (RAM map or a routine), for CD-only lines."""
        hits = set()
        for n, x in list(self.inc_old.items()) + list(self.dsym.items()):
            if x == v and self.is_address(n):
                hits.add(n)
        for k, x in self.label_at.items():
            if x == v and isinstance(k, str):
                hits.add(k)
        return hits.pop() if len(hits) == 1 else None

    def insn_line(self, insn, it, scope):
        """(mnemonic, operand text, numeric_fallbacks)."""
        mn = insn.mnemonic
        base = mn.split(".")[0]
        if base in ("lea", "pea", "exg", "link"):
            mn = base
        if base in BRANCHES and mn.endswith(".b"):
            mn = base + ".s"
        if base in ("btst", "bset", "bclr", "bchg") and re.search(r",\s*d[0-7]$", insn.op_str):
            mn = base
        if base in DBCC:
            mn = "dbf" if base == "dbra" else base
        # keep the cartridge spelling when it is the same instruction
        if it is not None:
            cm = it.mnem
            if same_mnem(cm, mn):
                mn = cm
        dops = disc_operands(insn)
        cops = split_ops(it.ops) if it is not None else []
        texts, fallback = [], []
        for k, o in enumerate(dops):
            t = None
            if it is None and o["mode"] == "abs" and o["value"] >= 0x10000:
                n = self.rev_name(o["value"])
                if n:
                    t = f"({n}).{o['size']}"
            if it is None and o["mode"] == "imm" and o["value"] >= 0x10000 and \
                    insn.mnemonic in ("movea.l", "cmpa.l", "adda.l", "move.l") and k == 0:
                n = self.rev_name(o["value"])
                if n:
                    t = "#" + n
            if it is not None and len(cops) == len(dops):
                t = self.sym_operand(cops[k], o, insn, scope, (it.ln.n, k))
                if t is None and has_ident(cart_expr(cops[k], o["mode"]) or ""):
                    fallback.append(cops[k])
                if t is None and o["mode"] == "reg" and len(cops) == len(dops):
                    if re.sub(r"\s", "", cops[k]).lower().replace("(a7)", "(sp)") == re.sub(r"\s", "", o["t"]).lower():
                        t = cops[k]
                if t is None and o["mode"] in ("imm", "disp") and not has_ident(cops[k]):
                    t = self.same_number(cops[k], o, insn)
                    if t is None:
                        fallback.append(cops[k])
                if t is None and o["mode"] == "abs" and not has_ident(cops[k]):
                    fallback.append(cops[k])
            if t is None:
                if o["mode"] in ("pcrel", "target"):
                    t = self.target_name(o["value"], scope)
                    if o["mode"] == "pcrel":
                        t += "(pc" + o["idx"] + ")"
                else:
                    t = snasm_text(o, insn)
            texts.append(t)
        return mn, ",".join(texts), fallback

    def emit(self):
        self.place_labels()
        for _ in range(6):
            text = self.emit_once()
            bad = self.validate() - self.force_numeric
            if not bad:
                return text
            self.force_numeric |= bad
        return text

    def emit_once(self):
        self.auto = set()
        self.externs = {}
        self.constraints = []
        for k in ("aligned", "soft", "cd_bytes", "cut", "numeric"):
            self.stats[k] = 0
        body = []
        for w in self.walk:
            if w[0] in ("m", "s"):
                it, p, ln = w[1], w[2], w[3]
                rt = BASE + p
                for kind, l2 in it.pre:
                    body.append(("text", l2.src.rstrip()))
                if w[0] == "m":
                    self.stats["aligned"] += 1
                else:
                    self.stats["soft"] += 1
                if it.kind == "insn":
                    insn = decode(self.disc, p, self.end, BASE)
                    mn, ops, fb = self.insn_line(insn, it, it.scope)
                    self.stats["numeric"] += len(fb)
                    code = split_comment(it.ln.src)[0]
                    gap = code[len(code.rstrip()):] or "\t"
                    com = it.comment
                    if fb:
                        note = "CD: the cartridge has " + ", ".join(fb)
                        com = (com + " (" + note + ")") if com else ";" + note
                    body.append(("insn", it.label, mn, ops, (gap + com) if com else "", p, insn.size))
                elif it.kind in ("data", "macro", "align", "dir"):
                    if w[0] == "s":
                        body.append(("data", it.label, self.reloc_data(it, p), p, ln))
                    elif it.mnem.lower() == "include":
                        pass
                    elif it.licensed:
                        body.append(("src", f"\tincbin\t..\\cdbin\\HOCKEY.BIN,${p:X},{ln}\t;licensed text: read from the disc file",
                                     p, ln))
                    else:
                        body.append(("src", it.ln.src.rstrip(), p, ln))
            elif w[0] == "cd":
                self.emit_cd(body, w[1], w[2])
            elif w[0] == "cut":
                it = w[1]
                if it.kind not in ("dir",):
                    self.stats["cut"] += 1
        self.body = body
        return self.render()

    def reloc_data(self, it, p):
        """dc.x with addresses: symbolize each element from the disc bytes."""
        mn = it.mnem.lower()
        size = {"dc.b": 1, "dc.w": 2, "dc.l": 4, "dc": 2}.get(mn)
        ops = split_ops(it.ops)
        if size is None or any(o.startswith(("'", '"')) for o in ops) or len(ops) * size != it.len:
            raw = self.disc[p:p + it.len]
            return "\t" + raw_dc(raw) + "\t\t;" + it.ops
        out = []
        for k, o in enumerate(ops):
            v = int.from_bytes(self.disc[p + k * size:p + (k + 1) * size], "big")
            key = (it.ln.n, k)
            if has_ident(o) and key not in self.force_numeric and self.solve(o, v, size * 8, it.scope):
                self.constraints.append((key, o, v, size * 8, it.scope))
                out.append(o)
            else:
                out.append(fmt_num(v))
                if has_ident(o):
                    self.stats["numeric"] += 1
        return f"\t{it.mnem}\t" + ",".join(out)

    def emit_cd(self, body, p, q):
        body.append(("text", ";CD: no cartridge twin"))
        pc = p
        self.stats["cd_bytes"] += q - p
        while pc < q:
            d = decode(self.disc, pc, q, BASE)
            if d is None:
                n = 2 if pc + 2 <= q else 1
                body.append(("raw", self.disc[pc:pc + n], pc))
                pc += n
                continue
            mn, ops, _ = self.insn_line(d, None, self.scope_of(BASE + pc))
            body.append(("insn", None, mn, ops, "", pc, d.size))
            pc += d.size

    def render(self, markers=False):
        out = []
        src94 = self.a.file or os.path.basename(self.a.out)
        out.append(f";\tHOCKEY.BIN ${self.start:X}-${self.end - 1:X} (runtime ${BASE + self.start:X}-${BASE + self.end - 1:X}):"
                   f" {src94} as the disc has it.")
        out.append(";\tThe cartridge source with long addresses and no short or quick forms. Lines under ;CD: have")
        out.append(";\tno cartridge twin. Names are the cartridge's; segacd\\hockey\\hockey.inc has the disc RAM map.")
        if self.a.note:
            out.append(";")
            for t in self.a.note.split("\\n"):
                out.append(f";\t{t}")
        out.append("")
        out.append("\tinclude\tmacros\\genesis.mac")
        out.append("\tinclude\tsegacd\\hockey\\hockey.inc")
        out.append("")
        ext_at = len(out)
        out.append(f"\torg\t${BASE + self.start:X}")
        out.append("")
        auto = sorted(self.auto)
        placed = set()
        for k, e in enumerate(self.body):
            sp = self.span(e)
            if sp is not None and sp[1]:
                for rt, name in sorted(self.evidence):
                    if rt == BASE + sp[0] and (rt, name) not in placed:
                        out.append(name + "\t\t\t\t\t\t;CD: placed where the disc branches to it")
                        placed.add((rt, name))
            if markers and sp is not None:
                out.append(f".zzm{k}")
            if e[0] == "text":
                out.append(e[1])
            elif e[0] == "src":
                out.append(e[1])
            elif e[0] == "data":
                lab = e[1] or ""
                out.append(lab + e[2])
            elif e[0] == "insn":
                _, lab, mn, ops, com, p, size = e
                rt = BASE + p
                if rt in self.auto:
                    out.append(f".L{rt:X}")
                line = f"{lab or ''}\t{mn}" + (f"\t{ops}" if ops else "")
                if com:
                    line += com if com[:1].isspace() else "\t" + com
                out.append(line)
            elif e[0] == "raw_insn":
                _, lab, raw, what, com, p = e
                if BASE + p in self.auto:
                    out.append(f".L{BASE + p:X}")
                out.append(f"{lab or ''}\t{raw_dc(raw)}\t\t;{what.strip()}: SNASM encodes it another way" + (" " + com.strip().lstrip(";") if com else ""))
            elif e[0] == "raw":
                raw, p = e[1], e[2]
                rt = BASE + p
                if rt in self.auto:
                    out.append(f".L{rt:X}")
                out.append(f"\t{raw_dc(raw)}")
        ext = []
        names = {}
        for n, v in self.dsym.items():
            if n in self.label_at or n in self.inc_old:
                continue
            if self.ckind.get(n) == "label":
                names[n] = v
            else:
                self.inc_new[n] = v
        for n, v in sorted(names.items(), key=lambda kv: kv[1]):
            ext.append(f"{n}\tequ\t${v:X}")
        for n, v in sorted(self.externs.items(), key=lambda kv: kv[1]):
            ext.append(f"{n}\tequ\t${v:X}")
        if ext:
            out[ext_at:ext_at] = ext + [""]
        # tail comments of the file
        return "\n".join(out).rstrip() + "\n"

    def write_inc(self):
        merged = dict(self.inc_old)
        for n, v in self.dsym.items():
            if n not in self.label_at and self.ckind.get(n) != "label":
                self.inc_new[n] = v
        for n, v in self.inc_new.items():
            if n in merged and merged[n] != v:
                print(f"warning: {n} is ${merged[n]:X} in the include, this fragment wants ${v:X}")
                continue
            merged[n] = v
        # constants used by the fragment and not defined in it
        text_all = "\n".join(str(e) for e in self.body)
        for n in self.used_constants(text_all):
            if n not in merged:
                merged[n] = self.cglob[n]
        write_inc(self.a.inc, merged, self.cglob, self.ckind)

    def used_constants(self, text):
        out = []
        defined = set()
        for e in self.body:
            if e[0] == "src":
                code = split_comment(e[1])[0]
                m = re.match(r"(" + ID + r")\s+(equ|set|=|rs)", code)
                if m:
                    defined.add(m.group(1))
        for e in self.body:
            if e[0] == "insn":
                s = e[3]
            elif e[0] == "data":
                s = split_comment(e[2])[0]
            elif e[0] == "src":
                s = split_comment(e[1])[0]
                s = s.split(None, 2)[-1] if s.split() else ""
                code = split_comment(e[1])[0]
                parts = code.strip().split(None, 1)
                s = parts[1] if len(parts) > 1 else ""
            else:
                continue
            for tok in re.findall(ID, s.replace("'", " ' ")) if "'" not in s else re.findall(ID, re.sub(r"'[^']*'", "", s)):
                if tok in defined or tok.startswith(".") or tok.lower() in REGS:
                    continue
                if tok in self.label_at or tok in self.externs or tok in self.dsym:
                    continue
                k = self.ckind.get(tok)
                if k in ("equ", "rs") and self.cglob[tok] < 0xFF0000:
                    out.append(tok)
        return out

    def span(self, e):
        """(disc offset, size) of a body entry, or None for text."""
        k = e[0]
        if k == "insn":
            return e[5], e[6]
        if k == "src":
            return e[2], e[3]
        if k == "data":
            return e[3], e[4]
        if k == "raw":
            return e[2], len(e[1])
        if k == "raw_insn":
            return e[5], len(e[2])
        return None

    def fix_by_assembly(self, path):
        """Assemble; an instruction SNASM sizes or encodes differently becomes its dc.w bytes."""
        want = self.disc[self.start:self.end]
        for attempt in range(400):
            chk = os.path.join(ROOT, "output", "port", "_chk.asm")
            os.makedirs(os.path.dirname(chk), exist_ok=True)
            open(chk, "w", newline="\n").write(self.render(markers=True))
            ok, binp, log = assemble(chk)
            if not ok:
                print(log)
                print(f"{path}: assembly failed (see above)")
                return
            built = open(binp, "rb").read()
            if built[:len(want)] == want and len(built) == len(want):
                ok2, binp2, log2 = assemble(path)
                b2 = open(binp2, "rb").read() if ok2 else b""
                print(("MATCH" if b2 == want else "MISMATCH (final build)") + f" {len(want)} bytes")
                return
            lst = os.path.join(ROOT, "output", "port", "_chk .lst")
            got = {}
            for line in open(lst, encoding="latin1"):
                m = re.match(r"([0-9A-F]{8}) .{27}\.zzm(\d+)\s*$", line.rstrip())
                if m:
                    got[int(m.group(2))] = int(m.group(1), 16)
            culprit = None
            prev = None
            for k, e in enumerate(self.body):
                sp = self.span(e)
                if sp is None or sp[1] == 0:
                    continue
                if k in got and got[k] != BASE + sp[0]:
                    culprit = prev
                    break
                prev = k
            if culprit is None:
                for k, e in enumerate(self.body):
                    sp = self.span(e)
                    if sp is None or sp[1] == 0 or k not in got:
                        continue
                    o = got[k] - BASE - self.start
                    if built[o:o + sp[1]] != want[sp[0] - self.start:sp[0] - self.start + sp[1]]:
                        culprit = k
                        break
            if culprit is None or self.body[culprit][0] != "insn":
                where = self.span(self.body[culprit]) if culprit is not None else None
                print(f"MISMATCH: cannot fix by itself (entry {culprit} {self.body[culprit] if culprit is not None else ''})")
                open(path, "w", newline="\n").write(self.render())
                return
            e = self.body[culprit]
            raw = self.disc[e[5]:e[5] + e[6]]
            self.body[culprit] = ("raw_insn", e[1], raw, e[2] + "\t" + e[3], e[4], e[5])
            self.stats["dcw"] += 1
            open(path, "w", newline="\n").write(self.render())
        print("gave up after 400 fixes")

    def report(self):
        s = self.stats
        print(f"{os.path.relpath(self.a.out, ROOT)}: ${self.start:X}-${self.end:X} ({self.end - self.start} bytes), "
              f"aligned {s['aligned']} (+{s['soft']} relocated data), CD-only {s['cd_bytes']} bytes, "
              f"cartridge lines dropped {s['cut']}, operands left numeric {s['numeric']}, dc.w lines {s['dcw']}")


def register(a, frag):
    """One line in tools/segacd.json and tools/verifySegacd.js, and the routines in the name map."""
    rel = os.path.relpath(os.path.abspath(a.out), os.path.join(ROOT, "src", "segacd")).replace("\\", "/")
    name = rel[:-4] if rel.endswith(".asm") else rel
    js = os.path.join(ROOT, "tools", "segacd.json")
    text = open(js, encoding="utf8").read()
    if f'"{name}"' not in text:
        opts = ", ".join(f'"{o}"' for o in OPTIONS)
        i = text.rindex("}")
        text = text[:i + 1] + f',\n  {{"name": "{name}", "options": [{opts}]}}' + "\n]\n"
        open(js, "w", encoding="utf8", newline="\n").write(text)
    vj = os.path.join(ROOT, "tools", "verifySegacd.js")
    text = open(vj, encoding="utf8").read()
    if f"output/segacd/{name}.bin" not in text:
        text = text.rstrip("\n") + "\n" + (f"compareAt('output/segacd/{name}.bin', 'cdbin/HOCKEY.BIN', "
                                           f"0x{frag.start:X}, 0x{frag.end - frag.start:X});") + "\n"
        open(vj, "w", encoding="utf8", newline="\n").write(text)
    nm = os.path.join(ROOT, "docs", "segacd-handoff", "name_map.csv")
    rows = open(nm, encoding="utf8").read().splitlines() if os.path.exists(nm) else ["disc_file,disc_addr,name_94g,notes"]
    have = {tuple(r.split(",")[:3]) for r in rows[1:]}
    src94 = a.file or ""
    for rt, name94 in frag.globals_sorted:
        key = ("HOCKEY.BIN", f"${rt - BASE:X}", name94)
        if key not in have:
            rows.append(",".join(key) + f",{src94}")
    head, body = rows[0], rows[1:]
    body.sort(key=lambda r: (r.split(",")[0], int(r.split(",")[1].lstrip("$"), 16)))
    open(nm, "w", encoding="utf8", newline="\n").write("\n".join([head] + body) + "\n")
    print(f"registered {name}: tools/segacd.json, tools/verifySegacd.js, {len(frag.globals_sorted)} names in name_map.csv")


def same_mnem(cart, disc):
    c, d = cart.lower(), disc.lower()
    if c == d:
        return True
    cb, cs = (c.split(".") + [""])[:2]
    db, ds = (d.split(".") + [""])[:2]
    if cb != db:
        if {cb, db} <= {"dbf", "dbra"}:
            return True
        return False
    if cs == ds:
        return True
    if cb in BRANCHES:
        return {cs, ds} <= {"s", "b"}
    return False


def raw_dc(raw):
    if len(raw) % 2 == 0:
        return "dc.w\t" + ",".join(f"${int.from_bytes(raw[i:i + 2], 'big'):04X}" for i in range(0, len(raw), 2))
    return "dc.b\t" + ",".join(f"${b:02X}" for b in raw)


def read_inc(path):
    out = {}
    if os.path.exists(path):
        for line in open(path):
            m = re.match(r"(" + ID + r")\s+equ\s+\$([0-9A-Fa-f]+)", line)
            if m:
                out[m.group(1)] = int(m.group(2), 16)
    return out


def write_inc(path, merged, cglob, ckind):
    ram = {n: v for n, v in merged.items() if cglob.get(n, 0) >= 0xFF0000}
    const = {n: v for n, v in merged.items() if n not in ram}
    out = [";\tHOCKEY.BIN names: the sub CPU RAM map (where each cartridge variable lives on the disc) and the",
           ";\tcartridge constants the HOCKEY.BIN fragments use. tools/segacd_port.py adds to this file.",
           "", "; RAM"]
    for n, v in sorted(ram.items(), key=lambda kv: (kv[1], kv[0])):
        out.append(f"{n}\tequ\t${v:X}")
    out += ["", "; constants"]
    for n, v in sorted(const.items(), key=lambda kv: kv[0].lower()):
        c = cglob.get(n)
        note = f"\t\t;the cartridge has ${c:X}" if c is not None and c != v else ""
        out.append(f"{n}\tequ\t${v:X}{note}")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, "w", newline="\n").write("\n".join(out) + "\n")


def assemble(path):
    exe = os.path.join(ROOT, "assembler", "Assembler.exe")
    rel = os.path.relpath(os.path.abspath(path), os.path.join(ROOT, "src")).replace("/", "\\")
    name = os.path.splitext(os.path.basename(path))[0]
    tmp = os.path.join(ROOT, "output", "port")
    os.makedirs(tmp, exist_ok=True)
    binp = os.path.join(tmp, name + ".bin")
    if os.path.exists(binp):
        os.remove(binp)
    args = ["/p", "/m", "/g"] + OPTIONS + [f"{rel},..\\output\\port\\{name}.bin,..\\output\\port\\{name},..\\output\\port\\{name}"]
    cmd = [exe] + args if os.name == "nt" else ["wine", exe] + args
    r = subprocess.run(cmd, cwd=os.path.join(ROOT, "src"), capture_output=True, text=True, encoding="latin1")
    log = r.stdout + r.stderr
    m = re.search(r"(\d+) error\(s\) from", log)
    ok = m is not None and int(m.group(1)) == 0 and os.path.exists(binp)
    return ok, binp, "\n".join(l for l in log.splitlines() if re.search(r"error|\.asm\(|\.inc\(", l, re.I))[:4000]


if __name__ == "__main__":
    main()
