#!/usr/bin/env python3
"""Specification -> ResolvedDesign for the ADPLL generator.

The resolver is deliberately a deterministic data transformation.  It does not
run synthesis or claim signoff.  It asks the architecture/capability layers
whether the request is buildable, then binds the selected architecture to a
concrete macro parameter/view identity.
"""
from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path
from typing import Any

try:  # package import
    from .architecture import select
    from .physical import normalize_parameters, resolve_macro
except ImportError:  # direct script execution
    from architecture import select
    from physical import normalize_parameters, resolve_macro

SCHEMA_VERSION = 1
DEFAULT_STRUCTURAL = {
    "COARSE_NDELS": 15,
    "MID_NDELS": 15,
    "FINE_NDELS": 31,
    "IL_NDELS": 4,
    "FILTER_BITS": 16,
    "FCW_BITS": 8,
    "CNT_EXTRA_BITS": 8,
    "MEAS_PERIODS": 1,
}
FEATURE_FLAGS = (
    "wide_range", "fractional", "low_jitter", "fast_lock",
    "allow_low_res", "allow_unimplemented",
)


class SpecError(ValueError):
    """The input specification is malformed."""


def _canonical(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def _hash(value: Any) -> str:
    return hashlib.sha256(_canonical(value).encode()).hexdigest()


def load_spec(path: Path) -> dict[str, Any]:
    raw = json.loads(path.read_text())
    if not isinstance(raw, dict):
        raise SpecError("specification must be a JSON object")
    for key in ("design", "pdk", "target_mhz", "ref_mhz", "fcw"):
        if key not in raw:
            raise SpecError(f"missing required specification field: {key}")
    if float(raw["target_mhz"]) <= 0 or float(raw["ref_mhz"]) <= 0:
        raise SpecError("target_mhz and ref_mhz must be positive")
    if int(raw["fcw"]) <= 0 or int(raw["out_div"] if "out_div" in raw else 1) < 1:
        raise SpecError("fcw and out_div must be positive")
    if raw.get("mode", "buildable") not in ("buildable", "explore"):
        raise SpecError("mode must be buildable or explore")
    if raw.get("area", "medium") not in ("low", "medium", "high"):
        raise SpecError("area must be low, medium, or high")
    return raw


def _spec_defaults(raw: dict[str, Any]) -> dict[str, Any]:
    spec = dict(raw)
    spec.setdefault("out_div", 1)
    spec.setdefault("area", "medium")
    spec.setdefault("mode", "buildable")
    spec.setdefault("features", {})
    spec.setdefault("structural", {})
    spec.setdefault("allow_experimental", False)
    spec.setdefault("allow_macro_rebuild", False)
    spec.setdefault("require_identity", False)
    if not isinstance(spec["features"], dict):
        raise SpecError("features must be an object")
    if not isinstance(spec["structural"], dict):
        raise SpecError("structural must be an object")
    return spec


def resolve_spec(raw: dict[str, Any],
                 inventory_path: Path | None = None) -> dict[str, Any]:
    """Resolve a specification into a design, or return explicit blockers."""
    spec = _spec_defaults(raw)
    features = spec["features"]
    structural = {
        **DEFAULT_STRUCTURAL,
        **normalize_parameters(spec["structural"]),
    }
    evidence_identity = spec.get("evidence_identity")
    if evidence_identity is not None and not isinstance(evidence_identity, dict):
        raise SpecError("evidence_identity must be an object")
    if spec["allow_experimental"] and spec["mode"] != "explore":
        raise SpecError("allow_experimental requires mode=explore")

    selection = select(
        spec["pdk"], float(spec["target_mhz"]), area=spec["area"],
        ref_mhz=float(spec["ref_mhz"]), fcw=int(spec["fcw"]),
        wide_range=bool(features.get("wide_range", False)),
        fractional=bool(features.get("fractional", False)),
        low_jitter=bool(features.get("low_jitter", False)),
        fast_lock=bool(features.get("fast_lock", False)),
        allow_low_res=bool(features.get("allow_low_res", False)),
        require_signoff=bool(features.get("require_signoff", False)),
        allow_unimplemented=bool(features.get("allow_unimplemented", False)),
        mode=spec["mode"], out_div=int(spec["out_div"]),
        evidence_identity=evidence_identity,
        require_identity=bool(spec["require_identity"]),
    )

    blockers: list[str] = []
    warnings: list[str] = []
    selected = selection.get("selected")
    selection_ok = str(selection.get("status", "")).startswith("PASS_")
    state = (selected or {}).get("implementation_state")
    macro = resolve_macro(selection, structural, inventory_path)
    macro_status = macro.get("status")
    if not selection_ok:
        blockers.append(f"architecture selection: {selection.get('status')}")

    if not selection_ok:
        status = "BLOCKED"
    elif state in ("MODEL_ONLY", "RTL_SYNTHESIZABLE", "UNIMPLEMENTED"):
        if spec["allow_experimental"]:
            status = "READY_EXPERIMENTAL"
            warnings.append(
                f"{state} architecture: simulation/RTL template, not a physical build")
        else:
            status = "NEEDS_EXPERIMENTAL_APPROVAL"
            blockers.append(
                f"{state} architecture requires allow_experimental=true")
    elif macro_status != "BUILT":
        if spec["allow_macro_rebuild"]:
            status = "READY_NEEDS_MACRO_REBUILD"
            warnings.append(
                f"macro {macro_status}; generation includes the rebuild plan")
        else:
            status = "NEEDS_MACRO_REBUILD"
            blockers.append(
                f"macro {macro_status}; set allow_macro_rebuild=true to generate "
                "the rebuild plan")
    else:
        status = "READY"

    dco = selection.get("dco_capability") or {}
    if dco.get("status", "").startswith("NEEDS_"):
        if state in ("MODEL_ONLY", "RTL_SYNTHESIZABLE", "UNIMPLEMENTED"):
            warnings.append(f"DCO: {dco.get('status')}")
        else:
            blockers.append(f"DCO: {dco.get('status')}")
            if status == "READY":
                status = "NEEDS_DCO_CHARACTERIZATION"
    profile = selection.get("pdk_profile") or {}
    max_arch_mhz = float(profile.get("max_arch_mhz", spec["target_mhz"]))
    max_ratio = max(1, math.ceil(max_arch_mhz / float(spec["ref_mhz"])))
    counter_bits = (int(structural.get("FCW_BITS", 8))
                    + int(structural.get("CNT_EXTRA_BITS", 8)))
    bits_needed = max(1, math.ceil(math.log2(max_ratio + 1)))
    counter_ok = counter_bits >= bits_needed
    counter_range = {
        "max_arch_mhz": max_arch_mhz,
        "ref_mhz": float(spec["ref_mhz"]),
        "max_ratio": max_ratio,
        "counter_bits": counter_bits,
        "bits_needed": bits_needed,
        "ok": counter_ok,
    }
    if not counter_ok:
        blockers.append(
            f"frequency counter has {counter_bits} bits, needs {bits_needed} "
            f"for {max_ratio}:1 max acquisition ratio")
        if status in ("READY", "READY_EXPERIMENTAL"):
            status = "NEEDS_COUNTER_RANGE"

    frequency_plan = {
        "target_mhz": float(spec["target_mhz"]),
        "ref_mhz": float(spec["ref_mhz"]),
        "fcw": int(spec["fcw"]),
        "out_div": int(spec["out_div"]),
        "dco_target_mhz": float(spec["target_mhz"]) * int(spec["out_div"]),
        "fcw_times_ref_mhz": int(spec["fcw"]) * float(spec["ref_mhz"]),
        "integer_n": int(spec["fcw"]),
    }
    resolved = {
        "schema_version": SCHEMA_VERSION,
        "design": spec["design"],
        "spec": spec,
        "spec_hash": _hash(spec),
        "status": status,
        "blockers": blockers,
        "warnings": warnings,
        "selection": selection,
        "selected": selected,
        "architecture_state": state,
        "structural_parameters": structural,
        "parameter_hash": _hash(structural),
        "frequency_plan": frequency_plan,
        "macro": macro,
        "dco": dco,
        "counter_range": counter_range,
        "evidence_identity": evidence_identity,
        "production_eligible": False,
    }
    resolved["resolved_hash"] = _hash(resolved)
    return resolved
