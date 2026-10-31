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
    # Physical Core B/C defaults; ignored by Core A.
    "BASE_NDELS": 256,
    "ACC_BITS": 16,
    "BASE_INC": 3493,
    "COARSE_STEP": 120,
    "MID_STEP": 60,
    "FINE_STEP": 15,
}
FEATURE_FLAGS = (
    "wide_range", "fractional", "low_jitter", "fast_lock",
    "allow_low_res", "allow_unimplemented", "require_signoff",
)
ALLOWED_SPEC_FIELDS = {
    "design", "pdk", "target_mhz", "ref_mhz", "fcw", "out_div",
    "tick_frequency_mhz", "area", "mode", "features", "structural",
    "evidence_identity", "allow_experimental", "allow_macro_rebuild",
    "require_identity", "allow_unverified_dco",
}


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
    unknown = sorted(set(raw) - ALLOWED_SPEC_FIELDS)
    if unknown:
        raise SpecError(f"unknown specification field(s): {', '.join(unknown)}")
    features = raw.get("features", {})
    if not isinstance(features, dict):
        raise SpecError("features must be an object")
    unknown_features = sorted(set(features) - set(FEATURE_FLAGS))
    if unknown_features:
        raise SpecError(
            f"unknown feature flag(s): {', '.join(unknown_features)}")
    for key, value in features.items():
        if not isinstance(value, bool):
            raise SpecError(f"feature flag {key} must be boolean")
    for key in ("design", "pdk", "target_mhz", "ref_mhz", "fcw"):
        if key not in raw:
            raise SpecError(f"missing required specification field: {key}")
    if float(raw["target_mhz"]) <= 0 or float(raw["ref_mhz"]) <= 0:
        raise SpecError("target_mhz and ref_mhz must be positive")
    if int(raw["fcw"]) <= 0 or int(raw["out_div"] if "out_div" in raw else 1) < 1:
        raise SpecError("fcw and out_div must be positive")
    if "tick_frequency_mhz" in raw:
        try:
            tick = float(raw["tick_frequency_mhz"])
        except (TypeError, ValueError) as exc:
            raise SpecError("tick_frequency_mhz must be numeric") from exc
        if tick <= 0:
            raise SpecError("tick_frequency_mhz must be positive")
    if raw.get("mode", "buildable") not in ("buildable", "explore"):
        raise SpecError("mode must be buildable or explore")
    if raw.get("area", "medium") not in ("low", "medium", "high"):
        raise SpecError("area must be low, medium, or high")
    return raw


def _spec_defaults(raw: dict[str, Any]) -> dict[str, Any]:
    spec = dict(raw)
    spec.setdefault("out_div", 1)
    spec.setdefault("tick_frequency_mhz", None)
    spec.setdefault("area", "medium")
    spec.setdefault("mode", "buildable")
    spec.setdefault("features", {})
    spec.setdefault("structural", {})
    spec.setdefault("allow_experimental", False)
    spec.setdefault("allow_macro_rebuild", False)
    spec.setdefault("allow_unverified_dco", False)
    spec.setdefault("require_identity", False)
    if not isinstance(spec["features"], dict):
        raise SpecError("features must be an object")
    if not isinstance(spec["structural"], dict):
        raise SpecError("structural must be an object")
    unknown = sorted(set(spec["structural"]) - set(DEFAULT_STRUCTURAL))
    if unknown:
        raise SpecError(
            f"unknown structural parameter(s): {', '.join(unknown)}")
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

    # Core C is an externally ticked NCO.  A fixed 1 GHz assumption is not a
    # specification; the tick must be supplied and propagated to the NCO plan
    # and generated TICK constraint.
    selected_id = (selected or {}).get("id")
    tick_mhz = spec.get("tick_frequency_mhz")
    if selected_id == "core_c_counter" and tick_mhz is None:
        blockers.append(
            "Core C requires tick_frequency_mhz; a 1 GHz TICK is not assumed")
        if status != "BLOCKED":
            status = "NEEDS_TICK_FREQUENCY"

    dco = selection.get("dco_capability") or {}
    if dco.get("status", "").startswith("NEEDS_"):
        if state in ("MODEL_ONLY", "RTL_SYNTHESIZABLE", "UNIMPLEMENTED"):
            warnings.append(f"DCO: {dco.get('status')}")
        elif spec["allow_unverified_dco"]:
            warnings.append(
                f"DCO: {dco.get('status')}; physical bring-up allowed without "
                "frequency/PVT evidence")
            if status == "READY":
                status = "READY_PHYSICAL_UNCHARACTERIZED"
        else:
            blockers.append(f"DCO: {dco.get('status')}")
            if status == "READY":
                status = "NEEDS_DCO_CHARACTERIZATION"
    profile = selection.get("pdk_profile") or {}
    dco_target_mhz = float(spec["target_mhz"]) * int(spec["out_div"])
    max_arch_mhz = float(profile.get("max_arch_mhz", dco_target_mhz))
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

    acc_bits = int(structural.get("ACC_BITS", 16))
    base_inc = int(structural.get("BASE_INC", 3493))
    tick_for_nco = float(tick_mhz) if tick_mhz is not None else None
    nco = None
    if selected_id == "core_c_counter" and tick_for_nco is not None:
        # The RTL toggles OUT on every accumulator carry.  One output period
        # therefore needs two carries; the /2 factor is intentional.
        denom = float(2 ** (acc_bits + 1))
        nco = {
            "tick_mhz": tick_for_nco,
            "acc_bits": acc_bits,
            "base_inc": base_inc,
            "formula": "f_out = f_tick * increment / 2^(acc_bits+1)",
            "increment_min": 1,
            # PLL_COUNTER_DCO_PHYS clamps at half scale to keep the NCO below
            # the TICK Nyquist limit.
            "increment_max": 2 ** (acc_bits - 1),
            "f_out_code_0_mhz": tick_for_nco * min(
                base_inc, 2 ** (acc_bits - 1)) / denom,
            "increment_for_dco_target": max(1, min(
                2 ** (acc_bits - 1),
                int(round(dco_target_mhz * denom / tick_for_nco)))),
            "max_output_mhz": tick_for_nco / 2.0,
            "note": "carry-toggle NCO: increment is clamped at half scale; "
                    "maximum output is TICK/2",
            "kdco_coarse_mhz_per_code": tick_for_nco * int(structural.get("COARSE_STEP", 120)) / denom,
            "kdco_mid_mhz_per_code": tick_for_nco * int(structural.get("MID_STEP", 60)) / denom,
            "kdco_fine_mhz_per_code": tick_for_nco * int(structural.get("FINE_STEP", 15)) / denom,
        }
        if dco_target_mhz > float(nco["max_output_mhz"]):
            blockers.append(
                f"DCO target {dco_target_mhz:g} MHz exceeds TICK/2 "
                f"({nco['max_output_mhz']:g} MHz) for a carry-toggle NCO")
            if status != "BLOCKED":
                status = "NEEDS_NCO_RANGE"
        if (int(structural.get("BASE_INC", 3493)) !=
                int(nco["increment_for_dco_target"])):
            warnings.append(
                "BASE_INC is not the increment implied by the DCO target; "
                "the NCO will not hit dco_target_mhz without retuning BASE_INC")
    frequency_plan = {
        "target_mhz": float(spec["target_mhz"]),
        "target_semantics": "post_divider_OUT_DIV",
        "ref_mhz": float(spec["ref_mhz"]),
        "fcw": int(spec["fcw"]),
        "out_div": int(spec["out_div"]),
        "dco_target_mhz": dco_target_mhz,
        "fcw_times_ref_mhz": int(spec["fcw"]) * float(spec["ref_mhz"]),
        "integer_n": int(spec["fcw"]),
        "tick_frequency_mhz": tick_for_nco,
        "nco": nco,
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
        "divider_contract": {
            "out_div": int(spec["out_div"]),
            "initial_divisor_parameter": "DIV_INIT",
            "target": "OUT_DIV",
            "physical_runtime_ports": ["SET_DIV", "LOAD_DIV"],
            "generated_wrapper_exposes_runtime_ports": False,
            "note": "generated adpll_top ties SET_DIV to DIV_INIT and LOAD_DIV to 0",
        },
        "macro": macro,
        "dco": dco,
        "counter_range": counter_range,
        "evidence_identity": evidence_identity,
        "production_eligible": False,
    }
    resolved["resolved_hash"] = _hash(resolved)
    return resolved
