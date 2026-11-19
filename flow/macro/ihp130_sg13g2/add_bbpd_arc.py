#!/usr/bin/env python3
"""Add the SS_BBPD -> INJ_EDGE clock-to-Q arc to the IHP macro Liberty files.

Why clock-to-Q, not setup/hold
------------------------------
SS_BBPD is launched by a negative-edge flop inside the macro
(src/il_dco.v: PLL_CELL_DFFNQX1, CKN = INJ_EDGE).  The only meaningful arc
from INJ_EDGE to SS_BBPD is therefore a clock-to-Q: a fixed delay after the
INJ_EDGE falling edge.  Modelling it as setup_rising/hold_rising would treat a
launched output as a captured input, and would put a setup requirement on a
signal the macro itself generates.

Corner scaling
--------------
TT c2q is seeded from the macro's own post-PEX STA (flow/IHP130_TAPEOUT_GAPS.md
B3: INJ_EN -> dff_y_impl/D setup +1.4837 ns bounds flop c2q + one inverter).
Each corner scales by that corner's INJ_EDGE delay at a MID load point:
near-zero load the intrinsic term dominates and all three corners look equal,
which is misleading.
"""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
CORNERS = Path(__file__).resolve().parent / 'corners'
TT_C2Q = 0.35          # ns, seed from the macro post-PEX STA
TAGS = ('tt_1p20V_25C', 'ss_1p08V_125C', 'ff_1p32V_m40C')


def inj_delay(path: Path) -> float:
    t = path.read_text()
    m = re.search(r'pin\s*\(\s*"?INJ_EDGE"?\s*\)\s*\{(.*?)\n\s{4}\}', t, re.S)
    body = m.group(1) if m else t
    mm = re.search(r'cell_rise\(template_1\)\s*\{.*?values\("([^"]+)"\)',
                   body, re.S)
    if not mm:
        return 0.0
    vals = [float(x) for x in mm.group(1).split(',')]
    return vals[4] if len(vals) > 4 else vals[0]


def arc(indent: str, c2q: float) -> str:
    v, tr = f'{c2q:.5f}', '0.05000'
    i = indent
    return (
        f'{i}timing() {{\n'
        f'{i}  related_pin : "INJ_EDGE";\n'
        f'{i}  timing_type : rising_edge;\n'
        f'{i}  timing_sense : non_unate;\n'
        f'{i}  cell_rise(template_1) {{\n'
        f'{i}    index_1("0.00100");\n'
        f'{i}    values("{v}");\n'
        f'{i}  }}\n'
        f'{i}  rise_transition(template_1) {{\n'
        f'{i}    index_1("0.00100");\n'
        f'{i}    values("{tr}");\n'
        f'{i}  }}\n'
        f'{i}  cell_fall(template_1) {{\n'
        f'{i}    index_1("0.00100");\n'
        f'{i}    values("{v}");\n'
        f'{i}  }}\n'
        f'{i}  fall_transition(template_1) {{\n'
        f'{i}    index_1("0.00100");\n'
        f'{i}    values("{tr}");\n'
        f'{i}  }}\n'
        f'{i}}}\n')


def strip_existing(t: str) -> str:
    """Remove arcs this script previously injected, so re-running is safe.

    Without this the script is not idempotent: running it twice put two
    clock-to-Q groups on each SS_BBPD bit, which OpenSTA accepts but which
    double-counts nothing and misleads anyone reading the Liberty.
    """
    return re.sub(
        r'\n(\s*)timing\(\)\s*\{\s*\n\s*related_pin\s*:\s*"INJ_EDGE"\s*;\s*\n'
        r'\s*timing_type\s*:\s*rising_edge\s*;.*?\n\s*\}\s*(?=\n)',
        '', t, flags=re.S)


def patch(path: Path, c2q: float) -> int:
    t = strip_existing(path.read_text())
    added = 0
    for bit in (0, 1):
        # Find this pin's block, then its `direction : output;` line.
        pm = re.search(
            r'(pin\s*\(\s*"?SS_BBPD\[' + str(bit) + r'\]"?\s*\)\s*\{\n)'
            r'(\s*)direction\s*:\s*output\s*;\n', t, re.S)
        if not pm:
            print(f'  WARNING: SS_BBPD[{bit}] not found in {path.name}')
            continue
        indent = pm.group(2)
        insert_at = pm.end()
        t = t[:insert_at] + arc(indent, c2q) + t[insert_at:]
        added += 1
    path.write_text(t)
    return added


def main() -> int:
    base = inj_delay(CORNERS / f'PLL_ANALOG_MACRO__{TAGS[0]}.lib')
    print(f'reference (TT) INJ_EDGE mid-load delay = {base:.5f} ns')
    for tag in TAGS:
        p = CORNERS / f'PLL_ANALOG_MACRO__{tag}.lib'
        if not p.exists():
            print(f'MISSING {p}')
            continue
        ratio = inj_delay(p) / base if base else 1.0
        c2q = TT_C2Q * ratio
        n = patch(p, c2q)
        print(f'  {tag:18s} ratio={ratio:.3f} c2q={c2q:.5f} ns arcs={n}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
