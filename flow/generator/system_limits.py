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
    # Do not map OSU/OCD or AS-EX exception libraries onto the AS canary: they
    # have different views/flow results even when the cell family name is close.
    "sg13g2_stdcell": "ihp-sg13g2",
    "ics55_LLSC_H7CH": "ics55",
    "ics55_LLSC_H7CL": "ics55",
    "ics55_LLSC_H7CR": "ics55",
}

IDENTITY_FIELDS = (
    "process_id", "pdk_release", "standard_cell_library", "technology_view",
    "metal_stack", "physical_flow", "implementation_hash", "timing_corner",
)


def resolve_limits(pdk: str, identity: dict | None = None) -> tuple[dict | None, str | None]:
    """Return a limit record plus an identity error, if any.

    A PDK name alone is not enough to reuse an Fmax result.  Callers that have
    a concrete view/flow/hash can pass it here; an unknown or mismatched field
    produces ``FAIL_EVIDENCE_IDENTITY`` instead of silently borrowing another
    library's timing.
    """
    data = json.loads(PATH.read_text())
    rec = data.get(ALIASES.get(pdk, pdk))
    if rec is None:
        return None, "unknown_pdk"
    if identity is None:
        return rec, None
    stored = rec.get("evidence_identity")
    if not isinstance(stored, dict):
        return rec, "missing_identity"
    unknown = sorted(set(identity) - set(IDENTITY_FIELDS))
    if unknown:
        return rec, "unknown_fields:" + ",".join(unknown)
    if not any(identity.get(k) is not None for k in IDENTITY_FIELDS):
        return rec, "empty_identity"
    mismatched = []
    for key in IDENTITY_FIELDS:
        value = identity.get(key)
        if value is None:
            continue
        if stored.get(key) != value:
            mismatched.append(key)
    if mismatched:
        return rec, "mismatch:" + ",".join(mismatched)
    return rec, None


def limits(pdk: str, identity: dict | None = None) -> dict | None:
    return resolve_limits(pdk, identity)[0]


def check_system(pdk: str, target_mhz: float, ref_mhz: float | None = None,
                 fcw: int | None = None, out_div: int = 1,
                 identity: dict | None = None,
                 require_identity: bool = False) -> dict | None:
    lim, identity_error = resolve_limits(pdk, identity)
    if require_identity and identity is None:
        identity_error = "missing_identity"
    if identity_error and (identity is not None or require_identity):
        return {
            "status": "FAIL_EVIDENCE_IDENTITY",
            "pdk": pdk,
            "identity_error": identity_error,
            "identity": identity,
            "limits": lim,
            "reason": "PDK/library name alone is insufficient; provide the exact "
                      "process/view/flow/hash/corner evidence identity",
        }
    if out_div < 1:
        return {"status": "FAIL_FREQUENCY_PLAN", "pdk": pdk,
                "reason": "out_div must be at least 1"}
    reason = None
    if ref_mhz is not None and fcw is not None:
        # Integer-N planning relation: f_out = fcw * f_ref / out_div.
        # This is a pre-layout consistency check, not a lock or jitter claim.
        expected_dco = target_mhz * out_div
        intended_dco = fcw * ref_mhz
        tol = max(1.0, 0.02 * max(expected_dco, intended_dco))
        if abs(expected_dco - intended_dco) > tol:
            return {
                "status": "FAIL_FREQUENCY_PLAN",
                "pdk": pdk,
                "target_mhz": target_mhz,
                "ref_mhz": ref_mhz,
                "fcw": fcw,
                "out_div": out_div,
                "expected_dco_mhz": expected_dco,
                "fcw_times_ref_mhz": intended_dco,
                "tolerance_mhz": tol,
                "reason": "target/REF/FCW are inconsistent for integer-N planning",
                "limits": lim,
                "identity": identity,
            }
    if lim is None:
        return None
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
                "limits": lim, "identity": identity}
    return None
