#!/usr/bin/env python3
"""Reproducible sky130 macro LVS for the DCO hard macros.

Why this wrapper exists
-----------------------
The OpenPDK sky130 KLayout LVS deck is used for layout extraction.  Its
schematic reader keeps native CDL model names and native ``VNB`` substrate
pins, while the KLayout extractor emits ``sky130_fd_pr__*`` model names and a
``sky130_gnd`` substrate pin.  It also represents a CDL ``m=N`` device as N
parallel layout devices.  Those are netlist *view* differences, not physical
differences.

This script normalizes the official native cell CDL and asks netgen (with the
official ``sky130A_setup.tcl``) to compare the resulting circuit against the
KLayout-extracted layout netlist.  KLayout remains the extraction engine; the
netgen comparison is used because it correctly merges the parallel devices on
both sides and can match the resulting top-level connectivity.

The KLayout LVS comparison log is retained as evidence too.  It is expected to
report a top-pin/net-name comparison failure on these macros; the functional
topology result is the netgen report.
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
DEFAULT_MACROS = [
    ("PLL_RING_DCO_PHYS", ROOT / "flow/macro/ring_dco_sky130"),
    ("PLL_COUNTER_DCO_PHYS", ROOT / "flow/macro/counter_dco_sky130"),
]

MODEL_MAP = {
    "nfet_01v8": "sky130_fd_pr__nfet_01v8",
    "pfet_01v8_hvt": "sky130_fd_pr__pfet_01v8_hvt",
    "pfet_01v8": "sky130_fd_pr__pfet_01v8",
    "nfet_01v8_lvt": "sky130_fd_pr__nfet_01v8_lvt",
    "special_nfet_01v8": "sky130_fd_pr__nfet_01v8",
}


def find_pdk() -> Path:
    env = os.environ.get("SKY130A")
    if env:
        p = Path(env)
        if (p / "libs.tech/klayout/lvs/sky130.lvs").is_file():
            return p
        raise SystemExit(f"SKY130A={p} does not contain the sky130 KLayout deck")
    candidates = sorted(
        (Path.home() / ".ciel/ciel/sky130/versions").glob("*/sky130A"),
        key=lambda p: p.stat().st_mtime,
        reverse=True,
    )
    for p in candidates:
        if (p / "libs.tech/klayout/lvs/sky130.lvs").is_file():
            return p
    raise SystemExit("No sky130A under ~/.ciel/ciel/sky130/versions")


def logical_lines(path: Path) -> list[str]:
    lines = path.read_text(errors="replace").splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        s = lines[i]
        while i + 1 < len(lines) and lines[i + 1].lstrip().startswith("+"):
            i += 1
            s += " " + lines[i].lstrip()[1:].strip()
        out.append(s)
        i += 1
    return out


def normalize_tokens(line: str) -> str:
    """Normalize model and substrate terminal names without touching comments."""
    if line.lstrip().startswith("*"):
        return line
    toks = line.split()
    if not toks:
        return line
    for i, tok in enumerate(toks):
        key = tok.lower()
        if key in MODEL_MAP:
            toks[i] = MODEL_MAP[key]
        elif tok == "VNB":
            toks[i] = "sky130_gnd"
    return " ".join(toks)


def normalize_reference(path: Path, top: str, out: Path) -> None:
    """Create the LVS reference from the shipped native-cell .spice file.

    - map native CDL models to the names emitted by KLayout
    - map the native VNB substrate pin to the extractor's sky130_gnd
    - drop the unused INJ_EN port from the macro top (the RTL does not use it)
    - drop conb_1: its poly-short implementation does not extract as the CDL's
      ideal poly resistors; its LO output is a direct VGND tie in the layout
    """
    lines = logical_lines(path)
    blocks: dict[str, list[str]] = {}
    order: list[str] = []
    cur: str | None = None
    for line in lines:
        s = line.strip()
        if not s or s.startswith("*"):
            continue
        if s.upper().startswith(".SUBCKT"):
            cur = s.split()[1]
            order.append(cur)
            blocks[cur] = [normalize_tokens(s)]
            continue
        if s.upper().startswith(".ENDS"):
            if cur is not None:
                blocks[cur].append(s)
            cur = None
            continue
        if cur is not None:
            blocks[cur].append(normalize_tokens(s))

    if top not in blocks:
        raise SystemExit(f"{path}: no .SUBCKT {top}")

    # Drop the conb definition.  It is a tie cell whose physical layout uses a
    # poly short, not the ideal CDL resistor.
    blocks.pop("sky130_fd_sc_hd__conb_1", None)

    ten = blocks[top]
    kept = [ten[0]]
    conb_vgnd_nets: set[str] = set()
    for line in ten[1:]:
        s = line.strip()
        if s.upper().startswith(".ENDS"):
            kept.append(s)
            continue
        toks = s.split()
        if toks and toks[0].upper().startswith("X"):
            model = toks[-1]
            # Remove top-level conb instances.  conb_1 has ports
            # VGND VNB VPB VPWR HI LO; the physical cell shorts LO to VGND.
            if model == "sky130_fd_sc_hd__conb_1":
                nets = toks[1:-1]
                if len(nets) >= 6:
                    conb_vgnd_nets.add(nets[-1])
                continue
        kept.append(s)

    # Remove the unused top-level INJ_EN port and tie removed conb outputs.
    hp = kept[0].split()
    hp = [t for t in hp if t != "INJ_EN"]
    kept[0] = " ".join(hp)
    tied = [kept[0]]
    for line in kept[1:]:
        toks = line.split()
        if toks and toks[0].upper().startswith("X"):
            toks = ["VGND" if t in conb_vgnd_nets else t for t in toks]
            line = " ".join(toks)
        tied.append(line)
    blocks[top] = tied

    with out.open("w") as f:
        for name in order:
            if name not in blocks:
                continue
            for line in blocks[name]:
                f.write(line + "\n")


def run(cmd: list[str], log: Path) -> int:
    with log.open("w") as f:
        f.write("$ " + " ".join(cmd) + "\n\n")
        f.flush()
        p = subprocess.run(cmd, stdout=f, stderr=subprocess.STDOUT, text=True)
    return p.returncode


def extract_and_compare(name: str, macro: Path, pdk: Path, work: Path) -> bool:
    top = name
    gds = macro / f"{name}.gds"
    native = macro / f"{name}.spice"
    ref = work / f"{name}.lvs_reference.spice"
    lay = work / f"{name}_extracted.cir"
    klayout_log = macro / f"{name}_lvs_klayout.log"
    klayout_db = work / f"{name}.lvsdb"
    netgen_log = macro / f"{name}_lvs_netgen.log"
    netgen_rpt = macro / f"{name}_lvs_netgen.rpt"

    if not gds.is_file() or not native.is_file():
        print(f"SKIP {name}: missing {gds} or {native}", file=sys.stderr)
        return False

    normalize_reference(native, top, ref)

    deck = pdk / "libs.tech/klayout/lvs/sky130.lvs"
    klayout = shutil.which("klayout") or "klayout"
    cmd = [
        klayout, "-b", "-r", str(deck),
        "-rd", f"input={gds.resolve()}",
        "-rd", f"top_cell={top}",
        "-rd", f"report={klayout_db.resolve()}",
        "-rd", f"schematic={ref.resolve()}",
        "-rd", f"target_netlist={lay.resolve()}",
        "-rd", "thr=8",
        "-rd", "run_mode=deep",
        "-rd", "spice_net_names=true",
        "-rd", "spice_comments=false",
        "-rd", "scale=false",
        "-rd", "verbose=true",
        "-rd", "schematic_simplify=false",
        "-rd", "net_only=false",
        "-rd", "top_lvl_pins=true",
        "-rd", "combine=false",
        "-rd", "purge=true",
        "-rd", "purge_nets=false",
    ]
    run(cmd, klayout_log)
    if not lay.is_file():
        print(f"FAIL {name}: KLayout did not produce {lay}", file=sys.stderr)
        return False

    # Keep the extraction evidence beside the macro views.
    shutil.copyfile(lay, macro / f"{name}_extracted.cir")

    setup = pdk / "libs.tech/netgen/sky130A_setup.tcl"
    netgen = shutil.which("netgen") or "netgen"
    cmd = [
        netgen, "-batch", "lvs",
        f"{lay.resolve()} {top}",
        f"{ref.resolve()} {top}",
        str(setup.resolve()),
        str(netgen_rpt.resolve()),
    ]
    run(cmd, netgen_log)
    rpt = netgen_rpt.read_text(errors="replace") if netgen_rpt.is_file() else ""
    ok = "Circuits match uniquely" in rpt and "Top level cell failed" not in rpt
    print(f"{'PASS' if ok else 'FAIL'} {name}: {netgen_rpt if rpt else netgen_log}")
    return ok


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("macros", nargs="*", help="optional macro names")
    ap.add_argument("--work", type=Path, default=Path("/tmp/sky130_lvs_work"))
    args = ap.parse_args()
    pdk = find_pdk()
    args.work.mkdir(parents=True, exist_ok=True)
    wanted = set(args.macros)
    all_ok = True
    for name, macro in DEFAULT_MACROS:
        if wanted and name not in wanted:
            continue
        all_ok &= extract_and_compare(name, macro, pdk, args.work)
    return 0 if all_ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
