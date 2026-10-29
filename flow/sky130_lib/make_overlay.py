#!/usr/bin/env python3
"""Build flow/sky130_lib/overlay.json from the reconstructed Liberty files.

The converter output is STA-usable but not a complete PnR library: the source
JSON corpus has no fill/tap/decap/diode (or lp busdriver/bushold) cell timing.
The overlay marks pnr_ready=false so the catalogue/screening can still compare
the STA/PPA data without pretending these are drop-in LibreLane libraries.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any

HERE = Path(__file__).resolve().parent
FLOW = HERE.parent
sys.path.insert(0, str(FLOW))

import enumerate_libs as el  # noqa: E402

OUT = HERE / "out"
LIBS = ["sky130_fd_sc_ms", "sky130_fd_sc_lp", "sky130_fd_sc_ls", "sky130_fd_sc_hdll"]


def voltage_from_name(name: str) -> list[float]:
    vals: set[float] = set()
    for m in re.finditer(r"(\d+)v(\d+)", name, re.I):
        vals.add(float(f"{m.group(1)}.{m.group(2)}"))
    return sorted(vals)


def main() -> int:
    rows: list[dict[str, Any]] = []
    for lib in LIBS:
        files = sorted(p for p in OUT.glob(f"{lib}_*.lib") if not p.stem.endswith("_yosys"))
        if not files:
            continue
        cell_sets = []
        for p in files:
            cs = el.parse_cell_names(p)
            if cs:
                cell_sets.append((p, cs))
        cells = set().union(*(cs for _, cs in cell_sets)) if cell_sets else set()
        common = set.intersection(*(cs for _, cs in cell_sets)) if cell_sets else set()
        missing: dict[str, list[str]] = {}
        for p, cs in cell_sets:
            diff = cs - common
            if diff:
                missing[p.stem] = sorted(diff)[:50]
        stats_path = files[0].with_suffix(".stats.json")
        stats = json.loads(stats_path.read_text()) if stats_path.exists() else {}
        missing_physical = stats.get("cell_dirs_without_json", [])
        voltages: set[float] = set()
        for p in files:
            voltages.update(voltage_from_name(p.stem))
        corners = len({p.stem for p in files})
        tier2 = corners >= 2
        notes = (
            "reconstructed Liberty from .lib.json (STA-usable); "
            "pnr_ready=false until fill/tap/decap/diode "
            f"({', '.join(missing_physical)}) are supplied"
        )
        rows.append(
            {
                "pdk": "sky130",
                "node": "130nm",
                "library": lib,
                "path": f"/grid/sky130/{lib}",
                "usable": True,
                "sta_usable": True,
                "pnr_ready": False,
                "liberty_source": "reconstructed_libjson",
                "generated_liberty": [str(p) for p in files],
                "tier": "2-flow*" if tier2 else "1",
                "tier2_candidate": tier2,
                "drc_lvs": "declared",
                "corners": corners,
                "corner_consistent": not missing,
                "common_cells": len(common),
                "corner_missing": missing,
                "voltage": sorted(voltages),
                "liberty_files": len(files),
                "lef_files": 0,
                "lef_macros": 0,
                "gds_files": 0,
                "cdl_files": 0,
                "verilog_files": 0,
                "cells": len(cells),
                "librelane": False,
                "pdk_librelane": False,
                "core_support": el.required_cells(cells),
                "notes": notes,
            }
        )
    (HERE / "overlay.json").write_text(json.dumps(rows, indent=2) + "\n")
    print(f"wrote {HERE / 'overlay.json'} with {len(rows)} libraries")
    for r in rows:
        print(
            f"  {r['library']:24s} corners={r['corners']:2d} cells={r['cells']:3d} "
            f"tier={r['tier']:7s} coreA={r['core_support']['core_a_il_dco']['status']:7s} "
            f"coreB={r['core_support']['core_b_ring_dco']['status']:7s} "
            f"coreC={r['core_support']['core_c_counter']['status']}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
