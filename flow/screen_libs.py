#!/usr/bin/env python3
"""Build a library/block support matrix from flow/libraries.json.

This script does not choose a product configuration.  It reports which
libraries can support which core/block so the user can choose a per-block
combination (DCO / PD / digital) after the QoR sweep.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

FLOW_DIR = Path(__file__).resolve().parent
DEFAULT_CATALOGUE = FLOW_DIR / "libraries.json"

TIER_RANK = {"2-flow": 0, "2-flow*": 1, "1+": 2, "1": 3, "unknown": 4}
CORE_KEYS = [
    "core_a_il_dco",
    "core_b_ring_dco",
    "core_c_counter",
    "digital",
    "pd_ssbbpd",
    "tdc_sr",
]


def load(path: Path) -> list[dict[str, Any]]:
    return json.loads(path.read_text())


def usable(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    return [r for r in rows if r.get("usable")]


def core_status(row: dict[str, Any], core: str) -> str:
    return row.get("core_support", {}).get(core, {}).get("status", "-")


def core_missing(row: dict[str, Any], core: str) -> list[str]:
    return row.get("core_support", {}).get(core, {}).get("missing", [])


def rank(row: dict[str, Any]) -> tuple[int, int, str]:
    return (TIER_RANK.get(row.get("tier", "unknown"), 4), -row.get("corners", 0), row["library"])


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--catalogue", type=Path, default=DEFAULT_CATALOGUE)
    ap.add_argument("--pdk", default=None)
    ap.add_argument("--core", default=None, choices=CORE_KEYS)
    ap.add_argument("--json-out", type=Path, default=None)
    ap.add_argument("--md-out", type=Path, default=None)
    args = ap.parse_args()

    if args.json_out is None or args.md_out is None:
        suffix = ".".join(x for x in (args.pdk, args.core) if x)
        if suffix:
            args.json_out = args.json_out or FLOW_DIR / f"screening.{suffix}.json"
            args.md_out = args.md_out or FLOW_DIR / f"screening.{suffix}.md"
        else:
            args.json_out = args.json_out or FLOW_DIR / "screening.json"
            args.md_out = args.md_out or FLOW_DIR / "screening.md"

    rows = usable(load(args.catalogue))
    if args.pdk:
        rows = [r for r in rows if r["pdk"] == args.pdk]
    if args.core:
        rows = [r for r in rows if core_status(r, args.core) in ("full", "partial")]

    by_pdk: dict[str, list[dict[str, Any]]] = {}
    for r in rows:
        by_pdk.setdefault(r["pdk"], []).append(r)
    for pdk in by_pdk:
        by_pdk[pdk].sort(key=rank)

    by_core: dict[str, list[str]] = {}
    for core in CORE_KEYS:
        by_core[core] = []
        for r in sorted(rows, key=rank):
            status = core_status(r, core)
            if status in ("full", "partial"):
                suffix = "" if status == "full" else " (partial)"
                by_core[core].append(f"{r['pdk']}/{r['library']}{suffix}")

    out = {
        "filters": {"pdk": args.pdk, "core": args.core},
        "by_pdk": {
            pdk: [
                {
                    "library": r["library"],
                    "node": r["node"],
                    "voltage": r["voltage"],
                    "corners": r["corners"],
                    "tier": r["tier"],
                    "drc_lvs": r["drc_lvs"],
                    "sta_usable": r.get("sta_usable", True),
                    "pnr_ready": r.get("pnr_ready", None),
                    "liberty_source": r.get("liberty_source", "pdk"),
                    "core_support": {
                        k: {
                            "status": core_status(r, k),
                            "missing": core_missing(r, k),
                        }
                        for k in CORE_KEYS
                    },
                    "notes": r["notes"],
                }
                for r in libs
            ]
            for pdk, libs in by_pdk.items()
        },
        "by_core": by_core,
    }
    args.json_out.write_text(json.dumps(out, indent=2) + "\n")

    lines = [
        "# Library / block support matrix",
        "",
        "No product default is implied. `partial` means an optional cell is",
        "missing (for example a dedicated clock buffer); use a documented",
        "equivalent such as `buf` + `inv` after characterization.",
        "",
    ]
    for pdk, libs in by_pdk.items():
        lines += [
            f"## {pdk}",
            "",
            "| Library | V | Corners | Tier | PnR | Core A | Core B | Core C | Digital | Notes |",
            "|---|---|---|---|---|---|---|---|---|---|",
        ]
        for r in libs:
            lines.append(
                "| {lib} | {v} | {c} | {t} | {pnr} | {a} | {b} | {cc} | {d} | {n} |".format(
                    lib=r["library"],
                    v=",".join(str(x) for x in r["voltage"]),
                    c=r["corners"],
                    t=r["tier"],
                    pnr=("no" if r.get("pnr_ready") is False else ("yes" if r.get("pnr_ready") is True else "-")),
                    a=core_status(r, "core_a_il_dco"),
                    b=core_status(r, "core_b_ring_dco"),
                    cc=core_status(r, "core_c_counter"),
                    d=core_status(r, "digital"),
                    n=r["notes"].replace("|", "/"),
                )
            )
        lines.append("")

    lines += ["## Candidates by core", ""]
    for core, libs in by_core.items():
        lines.append(f"### {core}")
        lines.append("")
        if libs:
            lines += [f"- {x}" for x in libs]
        else:
            lines.append("- none")
        lines.append("")

    args.md_out.write_text("\n".join(lines) + "\n")

    print(f"usable libraries: {len(rows)}")
    print(f"wrote {args.json_out}, {args.md_out}")
    for core, libs in by_core.items():
        print(f"  {core}: {len(libs)} candidates")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
