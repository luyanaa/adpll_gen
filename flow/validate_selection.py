#!/usr/bin/env python3
"""Validate a per-block selection against the library catalogue.

This is intentionally stricter than the JSON schema: it checks that the
selected library actually supports the block/core, that the voltage is one of
the library's characterized voltages, and that a Tier-2 claim is not made from
a Tier-1-only library.

No product default is chosen here; the user's selection is validated.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

FLOW_DIR = Path(__file__).resolve().parent
DEFAULT_CATALOGUE = FLOW_DIR / "libraries.json"
DEFAULT_SELECTION = FLOW_DIR / "selection.example.json"

TIER_RANK = {"2-flow": 0, "2-flow*": 1, "1+": 2, "1": 3}
CORE_BLOCK = {
    "core_a_il_dco": "core_a_il_dco",
    "core_b_ring_dco": "core_b_ring_dco",
    "core_c_counter": "core_c_counter",
}


def load(path: Path) -> Any:
    return json.loads(path.read_text())


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--catalogue", type=Path, default=DEFAULT_CATALOGUE)
    ap.add_argument("--selection", type=Path, default=DEFAULT_SELECTION)
    args = ap.parse_args()

    libs = load(args.catalogue)
    sel = load(args.selection)

    errors: list[str] = []
    warnings: list[str] = []

    pdk = sel.get("pdk")
    core = sel.get("core")
    blocks = sel.get("blocks", {})
    requested_tier = sel.get("tier")

    if core not in CORE_BLOCK:
        errors.append(f"unknown core: {core}")

    for required in ("dco", "pd", "digital"):
        if required not in blocks:
            errors.append(f"missing block: {required}")

    by_key = {(r["pdk"], r["library"]): r for r in libs}
    selected_rows: list[dict[str, Any]] = []

    for block_name, spec in blocks.items():
        lib_name = spec.get("library")
        row = by_key.get((pdk, lib_name))
        if row is None:
            errors.append(f"{block_name}: library {pdk}/{lib_name} not in catalogue")
            continue
        selected_rows.append(row)
        if not row.get("usable"):
            errors.append(f"{block_name}: {lib_name} is not usable")

        voltage = spec.get("voltage")
        lib_voltages = [round(float(v), 3) for v in row.get("voltage", [])]
        if voltage is None:
            errors.append(f"{block_name}: missing voltage")
        elif not any(abs(float(voltage) - v) < 0.02 for v in lib_voltages):
            errors.append(
                f"{block_name}: voltage {voltage} not in {lib_name} voltages {lib_voltages}"
            )

        support_key = {
            "dco": core,
            "pd": "pd_ssbbpd",
            "tdc": "tdc_sr",
            "digital": "digital",
            "divider": "digital",
            "dsm": "digital",
        }.get(block_name, core)
        support = row.get("core_support", {}).get(support_key, {})
        status = support.get("status", "-")
        if status == "no":
            errors.append(
                f"{block_name}: {lib_name} does not support {support_key} "
                f"(missing {support.get('missing', [])})"
            )
        elif status == "partial":
            warnings.append(
                f"{block_name}: {lib_name} is partial for {support_key} "
                f"(optional missing {support.get('optional_missing', [])}); document equivalent"
            )

        kind = spec.get("kind")
        if core in ("core_a_il_dco", "core_b_ring_dco"):
            if block_name in ("dco", "pd") and kind != "hard_macro":
                warnings.append(f"{block_name}: {core} normally uses a hard_macro")
            if block_name == "digital" and kind != "soft":
                warnings.append(f"{block_name}: digital control is normally soft")
        if kind not in ("hard_macro", "soft"):
            errors.append(f"{block_name}: kind must be hard_macro or soft")

        if row.get("pnr_ready") is False:
            warnings.append(
                f"{block_name}: {lib_name} is STA-usable but pnr_ready=false "
                "(fill/tap/decap/diode missing); do not use it for PnR/signoff yet"
            )

    voltages = {round(float(s.get("voltage", 0)), 3) for s in blocks.values() if s.get("voltage") is not None}
    if len(voltages) > 1 and "level_shifters" not in blocks:
        errors.append(
            f"mixed voltages {sorted(voltages)} without a level_shifters block; "
            "select level shifters and validate UPF/level-shift timing"
        )

    if requested_tier not in TIER_RANK:
        errors.append(f"unknown tier: {requested_tier}")
    else:
        selected_tier_rank = TIER_RANK[requested_tier]
        for row in selected_rows:
            row_rank = TIER_RANK.get(row.get("tier", "1"), 3)
            if selected_tier_rank < row_rank:
                errors.append(
                    f"tier {requested_tier} is stronger than library {row['library']} "
                    f"({row.get('tier')}); lower the claim or attach evidence"
                )
        if requested_tier == "2-flow" and any(r.get("drc_lvs") != "pass" for r in selected_rows):
            warnings.append(
                "2-flow selected but at least one library has drc_lvs=declared; "
                "attach the exact DRC/LVS evidence before claiming 2-flow"
            )

    print(f"selection: pdk={pdk} core={core} tier={requested_tier}")
    for row in selected_rows:
        print(f"  {row['library']}: tier={row.get('tier')} drc_lvs={row.get('drc_lvs')} "
              f"voltage={row.get('voltage')} corners={row.get('corners')}")
    for w in warnings:
        print(f"WARN: {w}")
    for e in errors:
        print(f"ERROR: {e}")
    if errors:
        print(f"FAILED: {len(errors)} error(s), {len(warnings)} warning(s)")
        return 1
    print(f"OK: {len(warnings)} warning(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
