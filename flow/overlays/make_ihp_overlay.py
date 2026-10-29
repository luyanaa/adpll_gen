#!/usr/bin/env python3
"""Generate the ihp130 sg13g2_stdcell overlay row.

The ORFS ihp-sg13g2 platform is outside /grid/<pdk>, so enumerate_libs.py
does not see it as a normal library directory.  This overlay records the exact
1.2 V library used by the canary.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
FLOW = HERE.parent
sys.path.insert(0, str(FLOW))

import enumerate_libs as el  # noqa: E402

ROOT = Path("/opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2")


def main() -> int:
    # The ORFS platform also ships 1.5 V variants (typ_1p50V/fast_1p65V/
    # slow_1p35V).  They are a different voltage domain; keep this row to the
    # 1.2 V core corners used by the canary.
    libs = sorted(
        p for p in (ROOT / "lib").glob("sg13g2_stdcell_*.lib")
        if any(tag in p.name for tag in ("typ_1p20V_25C", "fast_1p32V_m40C", "slow_1p08V_125C"))
    )
    if not libs:
        raise SystemExit(f"no 1.2 V Liberty files under {ROOT / 'lib'}")
    cell_sets = []
    for p in libs:
        cs = el.parse_cell_names(p)
        if cs:
            cell_sets.append((p, cs))
    common = set.intersection(*(cs for _, cs in cell_sets))
    missing = {
        p.stem: sorted(cs - common)[:50]
        for p, cs in cell_sets
        if cs - common
    }
    cells = set().union(*(cs for _, cs in cell_sets))
    row = {
        "pdk": "ihp130",
        "node": "130nm",
        "library": "sg13g2_stdcell",
        "path": str(ROOT),
        "usable": True,
        "sta_usable": True,
        "pnr_ready": True,
        "liberty_source": "orfs_platform",
        "official_pdk": False,
        "tier": "2-flow*" if len(libs) >= 2 else "1",
        "tier2_candidate": len(libs) >= 2,
        "drc_lvs": "declared",
        "corners": len(libs),
        "corner_consistent": not missing,
        "common_cells": len(common),
        "corner_missing": missing,
        "voltage": [1.2],
        "liberty_files": len(libs),
        "lef_files": 2,
        "lef_macros": 0,
        "gds_files": 1,
        "cdl_files": 1,
        "verilog_files": 1,
        "cells": len(cells),
        "librelane": True,
        "pdk_librelane": True,
        "core_support": el.required_cells(cells),
        "notes": (
            "ORFS ihp-sg13g2 sg13g2_stdcell 1.2V; 3 cell-identical corners; "
            "official IHP PDK root and DRC/LVS decks absent; PnR canary ran "
            "with a locally authored minimal PDK config; not signoff"
        ),
    }
    out = HERE / "ihp130_sg13g2.json"
    out.write_text(json.dumps([row], indent=2) + "\n")
    print(f"wrote {out}")
    print(
        f"cells={row['cells']} corners={row['corners']} "
        f"coreA={row['core_support']['core_a_il_dco']['status']} "
        f"coreB={row['core_support']['core_b_ring_dco']['status']} "
        f"coreC={row['core_support']['core_c_counter']['status']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
