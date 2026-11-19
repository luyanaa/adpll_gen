#!/usr/bin/env python3
"""Add the SS_BBPD -> INJ_EDGE clock-to-Q arc to the IHP macro Liberty files.

Why clock-to-Q, not setup/hold
------------------------------
SS_BBPD is launched by a negative-edge flop inside the macro
(src/il_dco.v: PLL_CELL_DFFNQX1, CKN = INJ_EDGE).  The only meaningful arc from
INJ_EDGE to SS_BBPD is therefore clock-to-Q: a fixed delay after the INJ_EDGE
falling edge.  Modelling it as setup_rising/hold_rising would treat a launched
output as a captured input, and would put a setup requirement on a signal the
macro itself generates.

Why this script is brace-depth aware
------------------------------------
The first version used a regex to strip a previously injected
`timing() { ... }` group.  A brace-counting parser is required here: Liberty
groups nest, so a regex that stops at the first `}` leaves the group's tail
(rise_transition / cell_fall / fall_transition) orphaned and unbalances the
file.  That is exactly how the signoff PnR run died -- OpenSTA tolerated the
resulting malformed file, but OpenROAD's Liberty reader reported
"syntax error" at the now-mismatched brace.

So: every group is located by indentation depth, and the matching close brace
is found by counting.  Re-running is idempotent.

Corner scaling
--------------
TT c2q is seeded from the macro's own post-PEX STA (flow/IHP130_TAPEOUT_GAPS.md
B3: INJ_EN -> dff_y_impl/D setup +1.4837 ns bounds flop c2q + one inverter).
Each corner scales by that corner's INJ_EDGE delay at a MID load point: at
near-zero load the intrinsic term dominates and all three corners look equal,
which is misleading.
"""
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
CORNERS = HERE / "corners"
TT_C2Q = 0.35          # ns, seed from the macro post-PEX STA
TAGS = ("tt_1p20V_25C", "ss_1p08V_125C", "ff_1p32V_m40C")
BITS = (0, 1)


def inj_delay(path: Path) -> float:
    """Representative INJ_EDGE single-stage delay at a MID load point."""
    t = path.read_text()
    m = re.search(r'pin\s*\(\s*"?INJ_EDGE"?\s*\)\s*\{(.*?)\n\s{4}\}', t, re.S)
    body = m.group(1) if m else t
    mm = re.search(r'cell_rise\(template_1\)\s*\{.*?values\("([^"]+)"\)', body, re.S)
    if not mm:
        return 0.0
    vals = [float(x) for x in mm.group(1).split(",")]
    return vals[4] if len(vals) > 4 else vals[0]


def arc_lines(indent: str, c2q: float) -> list[str]:
    v, tr = f"{c2q:.5f}", "0.05000"
    i = indent
    out = [
        f"{i}timing() {{",
        f'{i}  related_pin : "INJ_EDGE";',
        f"{i}  timing_type : rising_edge;",
        f"{i}  timing_sense : non_unate;",
    ]
    for tbl, val in (
        ("cell_rise", v),
        ("rise_transition", tr),
        ("cell_fall", v),
        ("fall_transition", tr),
    ):
        out += [
            f"{i}  {tbl}(template_1) {{",
            f'{i}    index_1("0.00100");',
            f'{i}    values("{val}");',
            f"{i}  }}",
        ]
    out.append(f"{i}}}")
    return out


def _depth_delta(line: str) -> int:
    return line.count("{") - line.count("}")


def find_pin_block(lines: list[str], bit: int) -> tuple[int, int, int]:
    """Return (open_idx, close_idx, depth) of the SS_BBPD[bit] pin group."""
    pat = re.compile(r'^\s*pin\s*\(\s*"SS_BBPD\[' + str(bit) + r'\]"\s*\)\s*\{\s*$')
    for idx, line in enumerate(lines):
        if not pat.match(line):
            continue
        depth = 0
        for j in range(idx, len(lines)):
            depth += _depth_delta(lines[j])
            if depth == 0 and j > idx:
                return idx, j, len(lines[idx]) - len(lines[idx].lstrip())
        raise SystemExit(f"unbalanced pin block for SS_BBPD[{bit}]")
    raise SystemExit(f'pin("SS_BBPD[{bit}]") not found')


def strip_injected(lines: list[str]) -> list[str]:
    """Remove every timing() group carrying our INJ_EDGE arc, file-wide.

    A group counts as ours iff its body mentions both `related_pin` INJ_EDGE and
    `timing_type : rising_edge`.  Removal is brace-depth aware.

    This runs over the WHOLE file before any insertion.  Stripping only inside
    one pin block is not enough: a later call starting at that pin's index would
    scan to EOF and delete the arc just inserted into the other bit.
    """
    out = list(lines)
    i = 0
    while i < len(out):
        line = out[i]
        if not re.match(r"^\s*timing\(\)\s*\{\s*$", line):
            i += 1
            continue
        depth, end = 0, None
        for j in range(i, len(out)):
            depth += _depth_delta(out[j])
            if depth == 0 and j > i:
                end = j
                break
        if end is None:
            raise SystemExit("unbalanced timing() group while stripping")
        body = "\n".join(out[i : end + 1])
        if 'related_pin : "INJ_EDGE"' in body and "rising_edge" in body:
            del out[i : end + 1]
            continue
        i = end + 1
    return out


def patch(path: Path, c2q: float) -> int:
    lines = strip_injected(path.read_text().splitlines())
    added = 0
    for bit in BITS:
        lo, hi, depth = find_pin_block(lines, bit)
        indent = " " * (depth + 2)
        lines[hi:hi] = arc_lines(indent, c2q)
        added += 1
    path.write_text("\n".join(lines) + "\n")
    return added


def verify(path: Path) -> str:
    """Structural self-check: balanced braces and one arc per SS_BBPD bit."""
    t = path.read_text()
    if t.count("{") != t.count("}"):
        return f"BROKEN braces {t.count('{')}/{t.count('}')}"
    lines = t.splitlines()
    parts = []
    for bit in BITS:
        lo, hi, _ = find_pin_block(lines, bit)
        body = "\n".join(lines[lo : hi + 1])
        parts.append(
            f"bit{bit}: groups={body.count('timing()')} "
            f"rising_edge={body.count('rising_edge')} "
            f"related={body.count(chr(34) + 'INJ_EDGE' + chr(34))}"
        )
    return "; ".join(parts)


def main() -> int:
    base = inj_delay(CORNERS / f"PLL_ANALOG_MACRO__{TAGS[0]}.lib")
    if not base:
        raise SystemExit("could not read the TT INJ_EDGE delay")
    print(f"reference (TT) INJ_EDGE mid-load delay = {base:.5f} ns")
    bad = 0
    for tag in TAGS:
        p = CORNERS / f"PLL_ANALOG_MACRO__{tag}.lib"
        if not p.exists():
            print(f"MISSING {p}")
            bad += 1
            continue
        ratio = inj_delay(p) / base
        c2q = TT_C2Q * ratio
        n = patch(p, c2q)
        status = verify(p)
        if "BROKEN" in status or "groups=1 " not in status or status.count("groups=1") != 2:
            bad += 1
        print(f"  {tag:18s} ratio={ratio:.3f} c2q={c2q:.5f} ns arcs={n}  {status}")
    print("OK" if not bad else f"FAILURES: {bad}")
    return 1 if bad else 0


if __name__ == "__main__":
    raise SystemExit(main())
