#!/usr/bin/env python3
"""Per-PDK system frequency ceilings.

These are digital/P&R planning limits, not DCO tuning evidence.  A target below
the ceiling is still uncharacterized if no DCO table exists.
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PATH = ROOT / "flow" / "generator" / "system_limits.json"

ALIASES = {
    "ETRI050": "etri050",
    "ETRI050_fd_sc_12t": "etri050",
    "gf180mcu_as_sc_mcu7t3v3": "gf180mcu_as_sc_mcu7t3v3",
    "gf180mcu_fd_sc_mcu7t5v0": "gf180mcu_fd_sc_mcu7t5v0",
    "gf180mcu_fd_sc_mcu9t5v0": "gf180mcu_fd_sc_mcu9t5v0",
}


def limits(pdk: str) -> dict | None:
    data = json.loads(PATH.read_text())
    return data.get(ALIASES.get(pdk, pdk))


def check_system(pdk: str, target_mhz: float, ref_mhz: float | None = None,
                 fcw: int | None = None) -> dict | None:
    lim = limits(pdk)
    if lim is None:
        return None
    reason = None
    if target_mhz > lim["max_out_mhz"]:
        reason = (f"target {target_mhz:.1f} MHz exceeds {pdk} "
                  f"planning ceiling {lim['max_out_mhz']:.1f} MHz")
    elif ref_mhz is not None and ref_mhz > lim["max_ref_mhz"]:
        reason = (f"REF {ref_mhz:.1f} MHz exceeds {pdk} "
                  f"planning ceiling {lim['max_ref_mhz']:.1f} MHz")
    elif fcw is not None and fcw > lim["max_fcw"]:
        reason = f"FCW {fcw} exceeds {pdk} planning ceiling {lim['max_fcw']}"
    if reason:
        return {"status": "FAIL_SYSTEM_FMAX", "pdk": pdk,
                "target_mhz": target_mhz, "reason": reason,
                "limits": lim}
    return None
