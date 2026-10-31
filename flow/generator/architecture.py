#!/usr/bin/env python3
"""Architecture selection for the ADPLL generator.

This is intentionally a *selection* layer, not a claim that the selected
architecture is signoff-ready.  It consumes the measured PDK ceilings and the
candidate matrix, then emits a primary architecture, fallbacks, the best
library for the selected core, and the evidence still required.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

try:  # package import
    from .capability import check_target
    from .physical import macro_library_for_pdk
    from .system_limits import check_system, limits
except ImportError:  # direct script execution
    from capability import check_target
    from physical import macro_library_for_pdk
    from system_limits import check_system, limits

ROOT = Path(__file__).resolve().parents[2]
GEN = ROOT / "flow" / "generator"
CATALOG = GEN / "architecture_catalog.json"
PROFILES = GEN / "pdk_profiles.json"
LIBRARIES = ROOT / "flow" / "libraries.json"

AREA_RANK = {"small": 1, "small-medium": 2, "medium": 3,
             "medium-large": 4, "large": 5}
AREA_LIMIT = {"low": 5, "medium": 4, "high": 2}
AREA_WEIGHT = {"low": 0.02, "medium": 0.06, "high": 0.12}
BAND = lambda f: "low" if f < 150 else ("mid" if f < 500 else "high")


def _load(path: Path) -> Any:
    return json.loads(path.read_text())


def profile_for(pdk: str) -> dict[str, Any] | None:
    profiles = _load(PROFILES)
    for key, profile in profiles.items():
        if pdk == key or pdk in profile.get("aliases", []):
            return {"key": key, **profile}
    # Library-specific names map to the PDK family profile.
    if pdk.startswith("ics55"):
        return {"key": "ics55", **profiles["ics55"]}
    if pdk.startswith("ihp") or "sg13g2" in pdk.lower():
        return {"key": "ihp130", **profiles["ihp130"]}
    if pdk.startswith("gf180mcu_fd"):
        return {"key": "gf180mcu_fd5", **profiles["gf180mcu_fd5"]}
    if pdk.startswith("gf180mcu_osu") or pdk.startswith("gf180mcu_ocd"):
        return {"key": "gf180mcu_as", **profiles["gf180mcu_as"]}
    if pdk.startswith("gf180mcu"):
        return {"key": "gf180mcu_as", **profiles["gf180mcu_as"]}
    if pdk.startswith("sky130"):
        return {"key": "sky130", **profiles["sky130"]}
    if pdk.lower().startswith("etri"):
        return {"key": "etri050", **profiles["etri050"]}
    if pdk.lower().startswith("freepdk45"):
        return {"key": "freepdk45", **profiles["freepdk45"]}
    return None


def library_pdk(pdk: str) -> str:
    p = pdk.lower()
    if p.startswith("ics55"):
        return "ics55"
    if p.startswith("ihp") or "sg13g2" in p:
        return "ihp130"
    if p.startswith("gf180"):
        return "gf180mcu"
    if p.startswith("etri"):
        return "ETRI050"
    if p.startswith("sky130"):
        return "sky130"
    if p.startswith("freepdk45"):
        return "freepdk45"
    return pdk


def best_library(pdk: str, core: str) -> dict[str, Any] | None:
    rows = _load(LIBRARIES)
    target_pdk = library_pdk(pdk)
    rows = [r for r in rows if r.get("usable") and r.get("pdk") == target_pdk]
    # If --pdk names an exact library, prefer it.
    exact = [r for r in rows if r.get("library") == pdk]
    if exact:
        rows = exact
    preferred = macro_library_for_pdk(pdk, core)
    candidates = []
    for r in rows:
        support = r.get("core_support", {}).get(core, {})
        status = support.get("status", "-")
        if status not in ("full", "partial"):
            continue
        tier = {"2-flow": 0, "2-flow*": 1, "1+": 2, "1": 3}.get(r.get("tier", "1"), 3)
        candidates.append((0 if status == "full" else 1,
                           0 if r.get("pnr_ready") is True else 1,
                           0 if (preferred and r.get("library") == preferred) else 1,
                           tier,
                           -int(r.get("corners", 0) or 0),
                           r.get("library", ""), r, support))
    if not candidates:
        return None
    candidates.sort(key=lambda x: x[:6])
    *_, row, support = candidates[0]
    return {
        "pdk": row.get("pdk"),
        "library": row.get("library"),
        "voltage": row.get("voltage"),
        "tier": row.get("tier"),
        "drc_lvs": row.get("drc_lvs"),
        "pnr_ready": row.get("pnr_ready"),
        "core_support": support.get("status"),
        "missing": support.get("missing", []),
        "notes": row.get("notes", ""),
    }


def selection_template(result: dict[str, Any], design: str = "adpll_top") -> dict[str, Any] | None:
    lib = result.get("library")
    sel = result.get("selected")
    if not lib or not sel:
        return None
    voltages = lib.get("voltage") or [0.0]
    voltage = float(voltages[0])
    hard = (sel.get("physical_buildable", False)
            and sel.get("implementation") == "rtl"
            and sel.get("hardmacro_ready", False))
    return {
        "pdk": lib["pdk"],
        "design": design,
        "core": sel["core"],
        "blocks": {
            "dco": {"library": lib["library"], "voltage": voltage,
                     "kind": "hard_macro" if hard else "soft"},
            "pd": {"library": lib["library"], "voltage": voltage,
                    "kind": "hard_macro" if hard else "soft"},
            "digital": {"library": lib["library"], "voltage": voltage,
                        "kind": "soft"},
        },
        "tier": lib.get("tier", "1"),
        "corners": "all",
        "notes": "Generated architecture template only; not a signoff claim. "
                 "DCO/PEX/PVT, closed-loop lock/jitter and DRC/LVS evidence are required.",
        "features": {k: True for k in sel.get("features", [])
                     if k in ("fractional_n", "multiphase")},
    }


BUILDABLE_STATES = {"PHYSICAL_IMPLEMENTABLE", "CHARACTERIZED"}


def implementation_state(a: dict[str, Any], pdk: str | None = None) -> str:
    """Classify what the repository can actually do with an architecture.

    MODEL_ONLY is a simulation model.  RTL_SYNTHESIZABLE can produce a netlist
    but has no verified physical backend.  PHYSICAL_IMPLEMENTABLE has a
    physical generation path (Core A/B/C).  CHARACTERIZED additionally has the
    evidence bundle required by the selected corner/view.
    """
    if a.get("characterization_state") == "CHARACTERIZED":
        return "CHARACTERIZED"
    impl = a.get("implementation")
    if impl in ("missing", "roadmap"):
        return "UNIMPLEMENTED"
    if impl == "simulation":
        return "MODEL_ONLY"
    if impl in ("rtl", "rtl_partial"):
        # A hardmacro flag alone is not a physical backend.
        if (impl == "rtl" and a.get("hardmacro_ready") is True
                and a.get("physical_variant", False)):
            core = str(a.get("core") or a.get("id") or "")
            if pdk is not None and macro_library_for_pdk(pdk, core) is None:
                # The architecture has physical RTL, but this PDK has no
                # core-specific physical macro inventory entry.
                return "RTL_SYNTHESIZABLE"
            return "PHYSICAL_IMPLEMENTABLE"
        return "RTL_SYNTHESIZABLE"
    return "UNIMPLEMENTED"


def implementation_ready(a: dict[str, Any]) -> bool:
    refs = a.get("implementation_refs", [])
    if a.get("implementation") in ("missing", "roadmap"):
        return False
    return bool(refs) and all((ROOT / ref).exists() for ref in refs)


def _candidate_reasons(a: dict, target: float, pdk_class: str) -> list[str]:
    reasons = []
    lo, hi = a["freq_mhz"]
    if lo <= target <= hi:
        reasons.append(f"target inside {lo:g}-{hi:g} MHz band")
    if pdk_class in a.get("pdk_classes", []):
        reasons.append(f"PDK class {pdk_class} supported")
    return reasons


def select(pdk: str, target_mhz: float, area: str = "medium",
           ref_mhz: float | None = None, fcw: int | None = None,
           wide_range: bool = False, fractional: bool = False,
           low_jitter: bool = False, fast_lock: bool = False,
           allow_low_res: bool = False,
           require_signoff: bool = False,
           allow_unimplemented: bool = False,
           mode: str = "buildable",
           out_div: int = 1,
           evidence_identity: dict[str, Any] | None = None,
           require_identity: bool = False) -> dict[str, Any]:
    if mode not in ("buildable", "explore"):
        raise ValueError("mode must be 'buildable' or 'explore'")
    if allow_unimplemented and mode == "buildable":
        raise ValueError("--allow-unimplemented requires --mode explore")
    if out_div < 1:
        raise ValueError("out_div must be at least 1")
    prof = profile_for(pdk)
    if prof is None:
        return {"status": "FAIL_UNKNOWN_PDK", "pdk": pdk,
                "reason": "no architecture profile for this PDK"}

    sys_hit = check_system(pdk, target_mhz, ref_mhz, fcw, out_div,
                           identity=evidence_identity,
                           require_identity=require_identity)
    if sys_hit:
        sys_hit["profile"] = prof
        return sys_hit
    if target_mhz > prof["max_arch_mhz"]:
        return {"status": "FAIL_PDK_FMAX", "pdk": pdk,
                "target_mhz": target_mhz,
                "max_arch_mhz": prof["max_arch_mhz"],
                "reason": "target exceeds the measured architecture ceiling"}
    if require_signoff and target_mhz > prof["signoff_mhz"]:
        return {"status": "FAIL_SIGNOFF_FMAX", "pdk": pdk,
                "target_mhz": target_mhz,
                "signoff_mhz": prof["signoff_mhz"],
                "reason": "target exceeds the conservative PDK signoff ceiling"}

    band = BAND(target_mhz)
    required = set()
    if wide_range:
        required.add("wide_range")
    if fractional:
        required.add("fractional_n")
    if low_jitter:
        required.add("low_jitter")
    if fast_lock:
        required.add("fast_lock")

    all_arch = _load(CATALOG)["architectures"]
    candidates = []
    for a in all_arch:
        if band not in a["bands"]:
            continue
        if prof["class"] not in a["pdk_classes"]:
            continue
        if target_mhz < a["freq_mhz"][0] or target_mhz > a["freq_mhz"][1]:
            continue
        if AREA_RANK[a["area"]] > AREA_LIMIT[area]:
            continue
        if not required.issubset(set(a["features"])):
            continue
        # Core C / ring are the default low-frequency path.  The low-res
        # TDC/bang-bang variant is a cost fallback, not a default choice.
        if a["id"] == "low_res_tdc_bangbang" and not allow_low_res:
            continue
        state = implementation_state(a, pdk)
        # A model-only architecture is a simulation candidate, not a physical
        # Generator build.  Only buildable mode may reach the backend.
        if mode == "buildable" and state not in BUILDABLE_STATES:
            continue
        # Simulation/RTL states must have their declared source files.  Only an
        # explicit roadmap override may admit a missing implementation.
        if state != "UNIMPLEMENTED" and not implementation_ready(a):
            continue
        if state == "UNIMPLEMENTED" and not allow_unimplemented:
            continue
        if state == "MODEL_ONLY":
            model_freq = a.get("model_freq_mhz", a["freq_mhz"])
            if target_mhz < model_freq[0] or target_mhz > model_freq[1]:
                continue
        center = sum(a["freq_mhz"]) / 2.0
        freq_score = 1.0 - min(1.0, abs(target_mhz - center) / max(center, 1.0))
        area_penalty = AREA_RANK[a["area"]] * AREA_WEIGHT[area]
        complexity_penalty = a["complexity"] * 0.035
        score = 0.82 * freq_score + 0.12 - area_penalty - complexity_penalty
        candidates.append((score, a))

    # Area-tight low-frequency designs should not be pulled back to a larger
    # ring/Core A by a marginal frequency-fit score.
    if area == "high" and target_mhz < 150:
        forced = [x for x in candidates if x[1]["id"] == "core_c_counter"]
        if forced:
            candidates = forced
    if not candidates:
        return {"status": "FAIL_NO_ARCHITECTURE", "pdk": pdk,
                "target_mhz": target_mhz, "band": band, "area": area,
                "reason": "no candidate satisfies frequency, PDK class, area, and feature constraints"}

    candidates.sort(key=lambda x: (-x[0], x[1]["id"]))
    lib = best_library(pdk, candidates[0][1]["core"])
    if lib is None:
        return {"status": "FAIL_NO_LIBRARY", "pdk": pdk,
                "target_mhz": target_mhz, "band": band,
                "candidates": [a["id"] for _, a in candidates[:4]],
                "reason": "no usable library supports the selected core"}

    def materialize(score: float, a: dict) -> dict[str, Any]:
        keep = ("id", "name", "core", "freq_mhz", "area", "area_rank",
                "complexity", "features", "risk", "benefit", "implementation",
                "implementation_refs", "hardmacro_ready", "implementation_class",
                "model_freq_mhz", "physical_note", "requires_reference_tick",
                "external_clock_dependent")
        return {
            **{k: a[k] for k in keep if k in a},
            "score": round(score, 4),
            "implementation_ready": implementation_ready(a),
            "implementation_state": implementation_state(a, pdk),
            "physical_buildable": implementation_state(a, pdk) in BUILDABLE_STATES,
            "reasons": _candidate_reasons(a, target_mhz, prof["class"]),
        }

    selected = materialize(*candidates[0])
    fallbacks = [materialize(*x) for x in candidates[1:4]]

    warnings = []
    if target_mhz > prof["signoff_mhz"]:
        warnings.append(
            f"target {target_mhz:g} MHz exceeds the conservative signoff ceiling "
            f"{prof['signoff_mhz']:g} MHz; architecture selection is experimental")
    if not prof.get("qualified"):
        warnings.append(prof.get("maturity", "PDK is not signoff-qualified"))
    if lib.get("core_support") == "partial":
        warnings.append(f"library {lib['library']} is partial for {selected['core']}")
    if lib.get("pnr_ready") is False:
        warnings.append(f"library {lib['library']} is not PnR-ready")
    if area == "high" and selected["area_rank"] > 2:
        warnings.append("area-tight request still selected a medium/large DCO")
    if selected.get("external_clock_dependent"):
        warnings.append(
            f"selected architecture depends on an external "
            f"{selected.get('requires_reference_tick', 'high-speed')} MHz tick; "
            "it is not a standalone DCO")
    if selected["implementation_state"] == "MODEL_ONLY":
        warnings.append("selected architecture is MODEL_ONLY: simulation only, not a physical Generator build")
    elif selected["implementation_state"] == "RTL_SYNTHESIZABLE":
        warnings.append("selected architecture is RTL_SYNTHESIZABLE but has no verified physical backend")
    elif selected["implementation_state"] == "UNIMPLEMENTED":
        warnings.append("selected architecture has no implementation")
    if allow_unimplemented and selected["implementation"] in ("missing", "roadmap"):
        warnings.append("selected architecture is roadmap-only (--allow-unimplemented)")
    if not selected["implementation_ready"]:
        warnings.append("selected architecture implementation references are incomplete")
    if evidence_identity is None and limits(pdk) is not None:
        warnings.append(
            "system-limit identity is unverified; pass --evidence-identity "
            "and --require-evidence-identity before reusing this Fmax")

    cap_pdk = {
        "ics55": "ics55",
        "ihp130": "ihp-sg13g2",
    }.get(prof["key"], pdk)
    try:
        dco = check_target(cap_pdk, target_mhz, 0.0, "l1", 10.0, ref_mhz, fcw,
                           architecture_id=selected["id"],
                           implementation_id=selected["implementation"],
                           out_div=out_div,
                           identity=evidence_identity,
                           require_identity=require_identity)
    except Exception as exc:  # keep architecture output even if a manifest is broken
        dco = {"status": "FAIL_UNCHARACTERIZED", "reason": str(exc)}

    dco_status = dco.get("status", "FAIL_UNCHARACTERIZED")
    if dco_status == "FAIL_OUT_OF_RANGE":
        status = "FAIL_DCO_RANGE"
    elif dco_status == "FAIL_NO_CODE_WITHIN_TOLERANCE":
        status = "FAIL_DCO_CODE"
    elif dco_status == "NEEDS_DCO_CHARACTERIZATION":
        if selected.get("physical_buildable"):
            # Physical silicon/macro path exists; DCO evidence is a separate
            # characterization gate, not an architecture-selection failure.
            status = "PASS_ARCH_SELECTED_PHYSICAL"
        else:
            status = ("NEEDS_DCO_CHARACTERIZATION" if mode == "buildable"
                      else "PASS_ARCH_SELECTED_EXPERIMENTAL")
    elif dco_status.startswith("PASS_"):
        status = "PASS_ARCH_SELECTED_WITH_DCO"
    else:
        status = "PASS_ARCH_SELECTED_EXPERIMENTAL"

    return {
        "status": status,
        "pdk": pdk,
        "target_mhz": target_mhz,
        "band": band,
        "area": area,
        "ref_mhz": ref_mhz,
        "fcw": fcw,
        "pdk_profile": prof,
        "mode": mode,
        "selected": selected,
        "fallbacks": fallbacks,
        "library": lib,
        "dco_capability": dco,
        "dco_binding": {
            "architecture_id": selected["id"],
            "implementation_id": selected["implementation"],
            "architecture_state": selected["implementation_state"],
            "evidence_identity": evidence_identity,
            "identity_verified": evidence_identity is not None,
        },
        "warnings": warnings,
        "production_eligible": False,
        "required_evidence": [
            "DCO L3/PEX/PVT tuning manifest covering the target and local tuning margin",
            "closed-loop lock, lock-loss and startup behavior at this target",
            "phase noise / integrated jitter at the target",
            "DRC/LVS on the selected library and macro views",
            "digital timing closure at the selected OUT/REF clocks",
        ],
    }


def main() -> int:
    ap = argparse.ArgumentParser(description="ADPLL architecture selector")
    ap.add_argument("--pdk", required=True)
    ap.add_argument("--target-mhz", type=float, required=True)
    ap.add_argument("--area", choices=sorted(AREA_LIMIT), default="medium")
    ap.add_argument("--ref-mhz", type=float)
    ap.add_argument("--fcw", type=int)
    ap.add_argument("--wide-range", action="store_true")
    ap.add_argument("--fractional", action="store_true")
    ap.add_argument("--low-jitter", action="store_true")
    ap.add_argument("--fast-lock", action="store_true")
    ap.add_argument("--allow-low-res", action="store_true")
    ap.add_argument("--require-signoff", action="store_true")
    ap.add_argument("--allow-unimplemented", action="store_true")
    ap.add_argument("--mode", choices=("buildable", "explore"), default="buildable")
    ap.add_argument("--out-div", type=int, default=1)
    ap.add_argument("--evidence-identity", type=Path,
                    help="JSON object with process/view/flow/hash/corner fields")
    ap.add_argument("--require-evidence-identity", action="store_true")
    ap.add_argument("--json-out", type=Path)
    ap.add_argument("--emit-selection", type=Path)
    args = ap.parse_args()
    identity = (json.loads(args.evidence_identity.read_text())
                if args.evidence_identity else None)
    result = select(args.pdk, args.target_mhz, args.area, args.ref_mhz,
                    args.fcw, args.wide_range, args.fractional,
                    args.low_jitter, args.fast_lock, args.allow_low_res,
                    args.require_signoff, args.allow_unimplemented,
                    mode=args.mode, out_div=args.out_div,
                    evidence_identity=identity,
                    require_identity=args.require_evidence_identity)
    text = json.dumps(result, indent=2)
    if args.json_out:
        args.json_out.write_text(text + "\n")
    if args.emit_selection:
        if not result["status"].startswith("PASS_"):
            return 1
        tpl = selection_template(result)
        if tpl is None:
            return 1
        args.emit_selection.write_text(json.dumps(tpl, indent=2) + "\n")
    print(text)
    return 0 if result["status"].startswith("PASS_") else 1


if __name__ == "__main__":
    raise SystemExit(main())
