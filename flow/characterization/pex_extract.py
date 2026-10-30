#!/usr/bin/env python3
"""Extract the routed macro parasitics and isolate the DCO-net capacitance.

The DCO is not a standalone placed block yet.  Both macro P&R runs, however,
contain the complete DCO hierarchy, so the final OpenROAD database can be
extracted with the PDK RCX rules and the ``pll_ana_dco/*`` nets (plus the two
top-level outputs) selected from the resulting SPEF.

This is a real routed-geometry extraction.  It is *capacitance-only* when used
by ``dco_pex_cap.py``: the SPEF total net capacitance is grounded, and series
wire resistance and lateral coupling are not yet back-annotated.
"""
from __future__ import annotations

import argparse
import glob
import json
import re
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

IHP_ROOT = Path(
    "/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
    "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2"
)
DEFAULTS = {
    "ics55": {
        "db": ROOT / "pnr" / "outputs" / "ics55" / "PLL_ANALOG_MACRO.final.db",
        "rules": Path(
            "/grid/ics55/libs.tech/librelane/ics55_LLSC_H7CR/rcx.rules"
        ),
        "out": ROOT / "flow" / "characterization" / "pex_ics55",
    },
    "ihp-sg13g2": {
        "db": ROOT / "pnr" / "outputs" / "ihp-sg13g2-sg13g2_stdcell"
        / "PLL_ANALOG_MACRO.final.db",
        "rules": IHP_ROOT / "libs.tech" / "librelane" / "openrcx"
        / "ihp-sg13g2.nom.magic.rules",
        "out": ROOT / "flow" / "characterization" / "pex_ihp",
    },
}


def find_openroad() -> str:
    exe = shutil.which("openroad")
    if exe:
        return exe
    hits = sorted(glob.glob("/nix/store/*openroad*/bin/openroad"))
    if not hits:
        raise SystemExit("openroad not found; install it or add it to PATH")
    return hits[-1]


def read_spef(path: Path) -> tuple[dict[str, float], int]:
    text = path.read_text(errors="ignore")
    names: dict[str, str] = {}
    m = re.search(r"^\*NAME_MAP\s*$", text, re.M)
    if m:
        end = text.find("*PORTS", m.end())
        if end < 0:
            end = len(text)
        for line in text[m.end():end].splitlines():
            mm = re.match(r"\*(\d+)\s+(\S+)", line)
            if mm:
                names["*" + mm.group(1)] = mm.group(2)
    nets: dict[str, float] = {}
    for mm in re.finditer(r"^\*D_NET\s+(\S+)\s+([\d.eE+-]+)", text, re.M):
        name = names.get(mm.group(1), mm.group(1))
        nets[name] = float(mm.group(2))
    return nets, len(nets)


def dco_caps(nets: dict[str, float]) -> dict[str, float]:
    out = {}
    for name, cap in nets.items():
        if name.startswith("pll_ana_dco/"):
            out[name[len("pll_ana_dco/"):]] = cap
        elif name in ("OUT", "MID_OUT"):
            out[name] = cap
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdk", choices=sorted(DEFAULTS), required=True)
    ap.add_argument("--db")
    ap.add_argument("--rules")
    ap.add_argument("--out")
    ap.add_argument("--openroad")
    args = ap.parse_args()
    d = DEFAULTS[args.pdk]
    db = Path(args.db or d["db"])
    rules = Path(args.rules or d["rules"])
    out = Path(args.out or d["out"])
    out.mkdir(parents=True, exist_ok=True)
    if not db.exists():
        raise SystemExit(f"missing final database {db}")
    if not rules.exists():
        raise SystemExit(f"missing RCX rules {rules}")
    spef = out / "PLL_ANALOG_MACRO.spef"
    tcl = out / "extract.tcl"
    tcl.write_text(
        f'read_db "{db}"\n'
        f'extract_parasitics -ext_model_file "{rules}"\n'
        f'write_spef "{spef}"\n'
        "puts SPEF_DONE\n"
        "exit\n"
    )
    openroad = args.openroad or find_openroad()
    log = out / "extract.log"
    with log.open("w") as fh:
        subprocess.run([openroad, "-exit", "-no_splash", str(tcl)],
                       check=True, stdout=fh, stderr=subprocess.STDOUT)
    nets, total = read_spef(spef)
    caps = dco_caps(nets)
    cap_sum = sum(caps.values())
    (out / "dco_pex_caps.inc").write_text(
        "\n".join(
            f"Cpex{i} {name} 0 {cap}p\nRpex{i} {name} 0 1G"
            for i, (name, cap) in enumerate(sorted(caps.items()))
        )
        + "\n"
    )
    summary = {
        "technology": args.pdk,
        "source_db": str(db),
        "rcx_rules": str(rules),
        "spef": str(spef),
        "characterization_level": "L3_PEX_CAP",
        "spef_nets": total,
        "dco_nets": len(caps),
        "dco_cap_pf": round(cap_sum, 6),
        "back_annotation": "total_net_cap_grounded_with_1G_dc_path",
        "not_included": ["series_wire_R", "lateral_coupling", "PEX_PVT"],
        "nets": {k: round(v, 6) for k, v in sorted(caps.items())},
    }
    (out / "dco_pex.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(f"{args.pdk}: {len(caps)} DCO nets, {cap_sum:.6f} pF -> {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
