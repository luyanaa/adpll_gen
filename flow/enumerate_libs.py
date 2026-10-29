#!/usr/bin/env python3
"""Enumerate standard-cell libraries available in the local PDK trees.

The goal is not to decide a product baseline.  It is to build a complete,
machine-readable catalogue of libraries that *could* be used by the ADPLL
family, with enough metadata for the user to select a per-block combination.

Criteria are deliberately conservative:
  * Liberty, LEF, GDS and (CDL or Verilog) must exist.
  * DRC/LVS status is copied from pdks.json; "declared" means the PDK/library
    is believed usable but the exact sign-off evidence still has to be attached.
  * Required-cell checks are pattern based and are a screen, not a guarantee.
    A "partial" library can still be used for a block if the missing cell has a
    documented equivalent.

Outputs:
  flow/libraries.json   machine-readable catalogue
  flow/libraries.yaml   human-readable catalogue (simple flat YAML)
  flow/libraries.md     Markdown table for review
"""

from __future__ import annotations

import argparse
import glob
import json
import os
import re
from pathlib import Path
from typing import Any

FLOW_DIR = Path(__file__).resolve().parent
DEFAULT_PDKS = FLOW_DIR / "pdks.json"


SKIP_DIRS = {
    ".git",
    "__pycache__",
    "backup",
    "preopt",
    "prestorage",
    "work",
    "doc",
    "docs",
    "test",
    "tests",
    "example",
    "examples",
    "sym",
    "sch",
    "xschem",
}


def find_files(root: Path, suffixes: tuple[str, ...], max_depth: int = 6) -> list[Path]:
    """Return files under root with one of suffixes, pruning unrelated trees."""
    out: list[Path] = []
    root = root.resolve()
    base_depth = len(root.parts)
    for dirpath, dirnames, filenames in os.walk(root):
        here = Path(dirpath)
        depth = len(here.parts) - base_depth
        if depth >= max_depth:
            dirnames[:] = []
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for fname in filenames:
            if Path(fname).suffix.lower() in suffixes:
                out.append(here / fname)
    return sorted(out)


def parse_liberty(files: list[Path]) -> dict[str, Any]:
    """Extract cell names and nominal conditions from Liberty files."""
    cells: set[str] = set()
    voltages: set[float] = set()
    temperatures: set[float] = set()
    processes: set[float] = set()

    cell_re = re.compile(r'^\s*cell\s*\(\s*"?([A-Za-z0-9_]+)"?\s*\)')
    volt_re = re.compile(r"nom_voltage\s*:\s*([0-9.]+)")
    temp_re = re.compile(r"nom_temperature\s*:\s*(-?[0-9.]+)")
    proc_re = re.compile(r"nom_process\s*:\s*([0-9.]+)")

    for path in files:
        try:
            with path.open("r", errors="ignore") as fh:
                for line in fh:
                    m = cell_re.match(line)
                    if m:
                        cells.add(m.group(1))
                    m = volt_re.search(line)
                    if m:
                        voltages.add(float(m.group(1)))
                    m = temp_re.search(line)
                    if m:
                        temperatures.add(float(m.group(1)))
                    m = proc_re.search(line)
                    if m:
                        processes.add(float(m.group(1)))
        except OSError:
            continue

    return {
        "cells": cells,
        "voltages": sorted(voltages),
        "temperatures": sorted(temperatures),
        "processes": sorted(processes),
    }


CELL_RE = re.compile(r'^\s*cell\s*\(\s*"?([A-Za-z0-9_]+)"?\s*\)')


def parse_cell_names(path: Path) -> set[str]:
    """Fast cell-name-only scan of a Liberty file (all corners)."""
    cells: set[str] = set()
    try:
        with path.open("r", errors="ignore") as fh:
            for line in fh:
                m = CELL_RE.match(line)
                if m:
                    cells.add(m.group(1))
    except OSError:
        pass
    return cells


def parse_lef(files: list[Path]) -> tuple[set[str], int]:
    """Return macro names and a rough count of LEF macros."""
    macros: set[str] = set()
    macro_re = re.compile(r"^\s*MACRO\s+([A-Za-z0-9_]+)")
    for path in files:
        try:
            with path.open("r", errors="ignore") as fh:
                for line in fh:
                    m = macro_re.match(line)
                    if m:
                        macros.add(m.group(1))
        except OSError:
            continue
    return macros, len(macros)


def parse_voltage_from_name(name: str) -> list[float]:
    """Infer supply voltage from common PDK library/corner file names."""
    vals: set[float] = set()
    for m in re.finditer(r"(\d+)p(\d+)", name, re.I):
        vals.add(float(f"{m.group(1)}.{m.group(2)}"))
    for m in re.finditer(r"(\d+)v(\d+)", name, re.I):
        vals.add(float(f"{m.group(1)}.{m.group(2)}"))
    return sorted(vals)


def cell_match(cells: set[str], *patterns: str) -> bool:
    """Pattern based cell presence check (library prefixes are allowed)."""
    for cell in cells:
        for pat in patterns:
            if re.search(pat, cell, re.I):
                return True
    return False


def required_cells(cells: set[str]) -> dict[str, dict[str, Any]]:
    """Screen each block/core for the cells needed by the ADPLL family."""
    inv = (r"(^|[_])inv([_x]|$)",)
    nand2 = (r"(^|[_])nand2",)
    nand2b = (r"(^|[_])nand2b",)
    nand3 = (r"(^|[_])nand3",)
    nor2 = (r"(^|[_])nor2",)
    and2 = (r"(^|[_])and2",)
    or2 = (r"(^|[_])or2",)
    buf = (r"(^|[_])buf", r"(^|[_])buff")
    clkbuf = (r"clkbuf", r"ckbuf", r"clkinv", r"ckinv")
    dff = (r"(^|[_])(dff|dfr|dfx|dfs|dfn)",)
    mux2 = (r"(^|[_])mux2", r"(^|[_])mux")
    tie = (r"tiehi", r"tielo", r"tieh", r"tiel")
    scan = (r"sdf", r"scan")

    groups: dict[str, list[tuple[str, tuple[str, ...], bool]]] = {
        "core_a_il_dco": [
            ("inv", inv, True),
            ("inv_strong", (r"(^|[_])inv(x|_)?(4|5|8|10|12|16|20)",), False),
            ("nand2", nand2, True),
            ("nand2b", nand2b, True),
            ("nand3", nand3, True),
            ("nor2", nor2, True),
            ("and2", and2, False),
            ("buf", buf, True),
            ("clkbuf", clkbuf, False),
            ("dff", dff, True),
        ],
        "core_b_ring_dco": [
            ("inv", inv, True),
            ("nand2", nand2, True),
            ("buf", buf, True),
            ("mux2", mux2, True),
            ("clkbuf", clkbuf, False),
            ("dff", dff, True),
        ],
        "core_c_counter": [
            ("inv", inv, True),
            ("nand2", nand2, True),
            ("nor2", nor2, True),
            ("buf", buf, True),
            ("clkbuf", clkbuf, False),
            ("dff", dff, True),
            ("tie", tie, False),
        ],
        "digital": [
            ("inv", inv, True),
            ("nand2", nand2, True),
            ("nor2", nor2, True),
            ("buf", buf, True),
            ("clkbuf", clkbuf, False),
            ("dff", dff, True),
            ("mux2", mux2, False),
            ("tie", tie, False),
            ("scan_dff", scan, False),
        ],
        "pd_ssbbpd": [
            ("nand2", nand2, True),
            ("nor2", nor2, True),
            ("buf", buf, True),
            ("clkinv", (r"clkinv", r"ckinv"), False),
            ("dff", dff, True),
        ],
        "tdc_sr": [
            ("dff", dff, True),
            ("inv", inv, True),
            ("buf", buf, True),
        ],
    }

    result: dict[str, dict[str, Any]] = {}
    for group, requirements in groups.items():
        missing: list[str] = []
        optional_missing: list[str] = []
        for name, patterns, required in requirements:
            ok = cell_match(cells, *patterns)
            if not ok:
                (missing if required else optional_missing).append(name)
        if missing:
            status = "no"
        elif optional_missing:
            status = "partial"
        else:
            status = "full"
        result[group] = {
            "status": status,
            "missing": missing,
            "optional_missing": optional_missing,
        }
    return result


def infer_corners(lib_files: list[Path]) -> int:
    stems: set[str] = set()
    for p in lib_files:
        stem = p.stem
        stem = re.sub(r"_librelane$", "", stem, flags=re.I)
        stems.add(stem)
    return len(stems)


def parse_pdk_config(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text())


def scan_library(pdk: str, cfg: dict[str, Any], lib_dir: Path) -> dict[str, Any]:
    name = lib_dir.name
    low = name.lower()
    skip_reason = ""
    if any(x in low for x in ("backup", "preopt", "prestorage")):
        skip_reason = "backup/preopt directory"
    elif any(x in low for x in ("sram", "rom", "tcad", "io_", "_io", "pad")):
        skip_reason = "not a standard-cell library"

    libs = find_files(lib_dir, (".lib",))
    lefs = find_files(lib_dir, (".lef",))
    gdss = find_files(lib_dir, (".gds",))
    cdls = find_files(lib_dir, (".cdl",))
    verilogs = find_files(lib_dir, (".v", ".sv"))
    pdk_root = Path(cfg.get("root", ""))
    pdk_librelane = (pdk_root / "libs.tech" / "librelane").exists()
    librelane = pdk_librelane or any(
        "librelane" in str(p).lower() for p in lib_dir.rglob("*") if p.is_dir()
    )

    # Cell/timing content is the same across corners for a given library;
    # parse one representative file, not every corner.
    parsed = parse_liberty(libs[:1])
    cells = parsed["cells"]
    lef_macros, lef_count = parse_lef(lefs[:1])

    corner_count = infer_corners(libs)

    # Cell-set consistency: a corner may omit cells that other corners have.
    # This matters for Tier-2 flow: the same netlist must map in every corner,
    # or the missing cells must be excluded/remapped explicitly.
    # Ignore header/template/empty Liberty files: they contain no cells and
    # must not make the common set empty.
    cell_sets = [(p, parse_cell_names(p)) for p in libs]
    cell_sets = [(p, cs) for p, cs in cell_sets if cs]
    common_cells = set.intersection(*(cs for _, cs in cell_sets)) if cell_sets else set()
    corner_missing: dict[str, list[str]] = {}
    for path, cells_for_corner in cell_sets:
        missing = cells_for_corner - common_cells
        if missing:
            corner_missing[path.stem] = sorted(missing)[:50]
    corner_consistent = not corner_missing

    voltages: set[float] = set(parsed["voltages"])
    for p in libs:
        voltages.update(parse_voltage_from_name(p.stem))
    if not voltages:
        voltages.update(float(v) for v in cfg.get("voltage", []))

    has_cdl = bool(cdls)
    has_verilog = bool(verilogs)
    usable = (
        not skip_reason
        and bool(libs)
        and bool(lefs)
        and bool(gdss)
        and (has_cdl or has_verilog)
        and bool(cells)
    )

    drc_lvs = cfg.get("drc_lvs", "unknown")
    # Tier 2 flow means "all corners the PDK actually provides"; three
    # corners (TT/SS/FF) is already a complete corner set for some PDKs.
    tier2_candidate = usable and corner_count >= 2 and drc_lvs in ("pass", "declared")
    if tier2_candidate:
        tier_label = "2-flow" if drc_lvs == "pass" else "2-flow*"
    elif usable and corner_count >= 2:
        tier_label = "1+"
    else:
        tier_label = "1"

    core_support = required_cells(cells) if cells else {}
    notes: list[str] = []
    if skip_reason:
        notes.append(skip_reason)
    if not libs:
        notes.append("no Liberty")
    if not lefs:
        notes.append("no LEF")
    if not gdss:
        notes.append("no GDS")
    if not (has_cdl or has_verilog):
        notes.append("no CDL/Verilog")
    if cells and not lef_macros:
        notes.append("LEF has no MACRO")
    if corner_count <= 1:
        notes.append("single corner")
    if drc_lvs != "pass":
        notes.append(f"drc_lvs={drc_lvs}")
    if corner_missing:
        notes.append(f"corner cell-set mismatch in {len(corner_missing)} corner(s)")

    return {
        "pdk": pdk,
        "node": cfg.get("node", "unknown"),
        "library": name,
        "path": str(lib_dir),
        "usable": usable,
        "tier": tier_label,
        "tier2_candidate": tier2_candidate,
        "drc_lvs": drc_lvs,
        "corners": corner_count,
        "corner_consistent": corner_consistent,
        "common_cells": len(common_cells),
        "corner_missing": corner_missing,
        "voltage": sorted(voltages),
        "liberty_files": len(libs),
        "lef_files": len(lefs),
        "lef_macros": lef_count,
        "gds_files": len(gdss),
        "cdl_files": len(cdls),
        "verilog_files": len(verilogs),
        "cells": len(cells),
        "librelane": librelane,
        "pdk_librelane": pdk_librelane,
        "core_support": core_support,
        "notes": "; ".join(notes),
    }


def yaml_scalar(value: Any) -> str:
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, list):
        return "[" + ", ".join(yaml_scalar(v) for v in value) + "]"
    if isinstance(value, dict):
        return "{" + ", ".join(f"{yaml_scalar(k)}: {yaml_scalar(v)}" for k, v in value.items()) + "}"
    text = str(value)
    if text == "":
        return '""'
    if re.search(r"[:#\[\]{},&*?|>'\"]", text) or text[0] in "-? ":
        return '"' + text.replace("\\", "\\\\").replace('"', '\\"') + '"'
    return text


def write_yaml(rows: list[dict[str, Any]], path: Path) -> None:
    lines: list[str] = []
    for row in rows:
        first = True
        for key, value in row.items():
            prefix = "- " if first else "  "
            lines.append(f"{prefix}{key}: {yaml_scalar(value)}")
            first = False
        lines.append("")
    path.write_text("\n".join(lines) + "\n")


def write_markdown(rows: list[dict[str, Any]], path: Path) -> None:
    lines = [
        "# Library catalogue",
        "",
        "Generated by `flow/enumerate_libs.py`. `2-flow*` means the PDK/library",
        "declares DRC/LVS pass but the exact evidence still has to be attached.",
        "",
        "| PDK | Library | Usable | PnR | Node | V | Corners | Cell set | Lib/LEF/GDS/CDL | Core A | Core B | Core C | Tier | Notes |",
        "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|",
    ]
    for r in rows:
        cs = r.get("core_support", {})
        def st(k: str) -> str:
            return cs.get(k, {}).get("status", "-")
        files = f"{r['liberty_files']}/{r['lef_files']}/{r['gds_files']}/{r['cdl_files']}"
        lines.append(
            "| {pdk} | {lib} | {usable} | {pnr} | {node} | {v} | {corners} | {cellset} | {files} | {a} | {b} | {c} | {tier} | {notes} |".format(
                pdk=r["pdk"],
                lib=r["library"],
                usable="yes" if r["usable"] else "no",
                pnr=("no" if r.get("pnr_ready") is False else ("yes" if r.get("pnr_ready") is True else "-")),
                node=r["node"],
                v=",".join(str(x) for x in r["voltage"]),
                corners=r["corners"],
                cellset="same" if r.get("corner_consistent", True) else "mismatch",
                files=files,
                a=st("core_a_il_dco"),
                b=st("core_b_ring_dco"),
                c=st("core_c_counter"),
                tier=r["tier"],
                notes=r["notes"].replace("|", "/"),
            )
        )
    path.write_text("\n".join(lines) + "\n")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdks", type=Path, default=DEFAULT_PDKS)
    ap.add_argument("--out-dir", type=Path, default=FLOW_DIR)
    args = ap.parse_args()

    cfg = parse_pdk_config(args.pdks)
    rows: list[dict[str, Any]] = []
    for pdk, pcfg in cfg.items():
        if not pcfg.get("enabled", True):
            continue
        seen: set[Path] = set()
        for pattern in pcfg.get("lib_globs", []):
            for raw in glob.glob(pattern):
                lib_dir = Path(raw)
                if not lib_dir.is_dir() or lib_dir in seen:
                    continue
                seen.add(lib_dir)
                print(f"scan {pdk}: {lib_dir}", flush=True)
                rows.append(scan_library(pdk, pcfg, lib_dir))

    # Generated/overlay libraries (for example reconstructed sky130 Liberty)
    # replace the scanned row for the same PDK/library.
    overlay_path = FLOW_DIR / "sky130_lib" / "overlay.json"
    if overlay_path.exists():
        overlay = json.loads(overlay_path.read_text())
        # Only merge rows whose generated Liberty files exist in this checkout;
        # flow/sky130_lib/out/ is regenerable and gitignored.
        overlay = [
            r for r in overlay
            if any(Path(p).exists() for p in r.get("generated_liberty", []))
        ]
        by_key = {(r["pdk"], r["library"]): r for r in rows}
        for r in overlay:
            by_key[(r["pdk"], r["library"])] = r
        rows = list(by_key.values())

    # Additional library overlays that live outside /grid/<pdk> (for example
    # the ORFS ihp-sg13g2 1.2 V standard-cell library).  Only merge rows whose
    # source path exists in this checkout.
    overlays_dir = FLOW_DIR / "overlays"
    if overlays_dir.exists():
        by_key = {(r["pdk"], r["library"]): r for r in rows}
        for overlay_file in sorted(overlays_dir.glob("*.json")):
            try:
                overlay = json.loads(overlay_file.read_text())
            except (OSError, json.JSONDecodeError):
                continue
            for r in overlay:
                if Path(r.get("path", "")).exists():
                    by_key[(r["pdk"], r["library"])] = r
        rows = list(by_key.values())

    rows.sort(key=lambda r: (r["pdk"], not r["usable"], r["library"]))

    out_json = args.out_dir / "libraries.json"
    out_yaml = args.out_dir / "libraries.yaml"
    out_md = args.out_dir / "libraries.md"
    out_json.write_text(json.dumps(rows, indent=2) + "\n")
    write_yaml(rows, out_yaml)
    write_markdown(rows, out_md)

    usable = [r for r in rows if r["usable"]]
    tier2 = [r for r in rows if r["tier2_candidate"]]
    print(f"scanned {len(rows)} library directories")
    print(f"usable: {len(usable)}; tier2 candidates: {len(tier2)}")
    for r in rows:
        if r["usable"]:
            print(
                f"  {r['pdk']:10s} {r['library']:32s} corners={r['corners']:2d} "
                f"V={','.join(str(v) for v in r['voltage']):12s} tier={r['tier']:6s} "
                f"coreA={r['core_support'].get('core_a_il_dco', {}).get('status', '-'):7s} "
                f"coreB={r['core_support'].get('core_b_ring_dco', {}).get('status', '-'):7s} "
                f"coreC={r['core_support'].get('core_c_counter', {}).get('status', '-')}"
            )
    print(f"wrote {out_json}, {out_yaml}, {out_md}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
