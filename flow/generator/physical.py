#!/usr/bin/env python3
"""Physical-view identity for the generated ADPLL.

A selection names a PDK/library, but a hard macro is reusable only if its
structural parameters and physical views match the request.  This module is
the small, deterministic contract used by the delivery generator:

  structural parameters -> parameter hash
  LEF/Liberty/CDL/GDS/... -> per-view SHA-256 and a combined view hash
  library/PDK name -> a concrete macro inventory entry

A missing view or a parameter mismatch returns ``NEEDS_MACRO_REBUILD``; it is
never silently treated as a built macro.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_INVENTORY = Path(__file__).resolve().parent / "macro_inventory.json"
PARAMETER_KEYS = ("COARSE_NDELS", "MID_NDELS", "FINE_NDELS", "IL_NDELS")


def _load(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text())


def _sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def _canonical(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def parameter_hash(parameters: dict[str, Any]) -> str:
    normalized = {
        k.upper(): int(v) if isinstance(v, int) else v
        for k, v in parameters.items()
    }
    return hashlib.sha256(_canonical(normalized).encode()).hexdigest()


def normalize_parameters(parameters: dict[str, Any] | None) -> dict[str, Any]:
    out: dict[str, Any] = {}
    for key, value in (parameters or {}).items():
        upper = str(key).upper()
        alias = {
            "COARSE": "COARSE_NDELS",
            "MID": "MID_NDELS",
            "FINE": "FINE_NDELS",
            "INJECTION": "IL_NDELS",
        }.get(upper, upper)
        out[alias] = value
    return out


def macro_key_for_pdk(pdk: str) -> str | None:
    p = pdk.lower()
    if p.startswith("ics55"):
        return "ics55"
    if p.startswith("ihp") or "sg13g2" in p:
        return "ihp-sg13g2"
    if p.startswith("gf180mcu_as") or p == "gf180mcu":
        return "gf180mcu_as"
    return None


def _inventory_entry(inventory: dict[str, Any], pdk: str,
                     core: str | None = None) -> tuple[str, dict[str, Any]] | None:
    key = macro_key_for_pdk(pdk)
    if key is None:
        return None
    macros = inventory.get("macros", {})
    if core:
        if f"{key}:{core}" in macros:
            return f"{key}:{core}", macros[f"{key}:{core}"]
        # The base entry is the Core A IL-DCO macro.  Do not silently reuse it
        # for a different core; that would make a ring/counter look physical.
        if core == "core_a_il_dco" and key in macros:
            return key, macros[key]
        return None
    if key in macros:
        return key, macros[key]
    return None


def macro_library_for_pdk(pdk: str, core: str | None = None) -> str | None:
    try:
        entry = _inventory_entry(_load(DEFAULT_INVENTORY), pdk, core)
        return entry[1].get("cell_library") if entry else None
    except (OSError, ValueError):
        return None


def selected_library(result: dict[str, Any]) -> str | None:
    lib = result.get("library")
    if isinstance(lib, dict):
        return lib.get("library")
    if isinstance(lib, str):
        return lib
    blocks = result.get("blocks") or {}
    dco = blocks.get("dco") or {}
    return dco.get("library")


def _resolve_path(path: str) -> Path:
    p = Path(path)
    return p if p.is_absolute() else ROOT / p


def resolve_macro(result: dict[str, Any],
                  structural: dict[str, Any] | None = None,
                  inventory_path: Path | None = None) -> dict[str, Any]:
    """Bind a selection result to a concrete physical macro variant."""
    inv_path = inventory_path or DEFAULT_INVENTORY
    inventory = _load(inv_path)
    pdk = str(result.get("pdk") or "")
    selected = result.get("selected") or {}
    core = selected.get("id") or result.get("core")
    entry = _inventory_entry(inventory, pdk, core)
    if entry is None:
        return {
            "status": "NOT_AVAILABLE",
            "needs_rebuild": False,
            "reason": f"no hard-macro inventory entry for PDK {pdk} / core {core}",
            "macro": None,
        }
    key, macro_row = entry
    macro = dict(macro_row)
    expected = normalize_parameters(macro.get("parameters"))
    requested = normalize_parameters(structural)
    extra_keys = [k for k in ("BASE_NDELS", "ACC_BITS", "BASE_INC",
                              "COARSE_STEP", "MID_STEP", "FINE_STEP")
                  if k in expected]
    keys = list(PARAMETER_KEYS) + extra_keys
    requested = {k: requested.get(k, expected.get(k)) for k in keys}
    pmismatch = {
        k: {"expected": expected.get(k), "requested": requested.get(k)}
        for k in keys
        if expected.get(k) != requested.get(k)
    }
    lib_name = selected_library(result)
    lib_mismatch = (lib_name is not None
                    and lib_name != macro.get("cell_library"))
    views = {}
    view_hashes = {}
    for name, rel in (macro.get("views") or {}).items():
        path = _resolve_path(rel)
        exists = path.is_file()
        views[name] = {"path": str(path), "exists": exists}
        if exists:
            view_hashes[name] = _sha256(path)
        else:
            view_hashes[name] = None
    required = list(macro.get("required_views", []))
    missing_required = [x for x in required if not views.get(x, {}).get("exists")]
    status = "BUILT"
    if missing_required:
        status = "MISSING_VIEWS"
    elif lib_mismatch:
        status = "LIBRARY_MISMATCH"
    elif pmismatch:
        status = "PARAMETER_MISMATCH"
    identity = {
        "schema_version": 1,
        "macro": macro.get("name"),
        "pdk": macro.get("pdk"),
        "cell_library": macro.get("cell_library"),
        "flow": macro.get("flow"),
        "parameters": requested,
        "parameter_hash": parameter_hash(requested),
        "view_hash": hashlib.sha256(
            _canonical(view_hashes).encode()).hexdigest(),
        "views": views,
        "required_views": required,
        "missing_required_views": missing_required,
        "evidence": macro.get("evidence", {}),
        "build_command": macro.get("build_command"),
    }
    return {
        "status": status,
        "needs_rebuild": status in (
            "MISSING_VIEWS", "LIBRARY_MISMATCH", "PARAMETER_MISMATCH"),
        "reason": None if status == "BUILT" else {
            "MISSING_VIEWS": "required physical views are absent",
            "LIBRARY_MISMATCH": "selected library does not match the built macro",
            "PARAMETER_MISMATCH": "structural parameters differ from the built macro",
        }[status],
        "library": lib_name,
        "library_mismatch": lib_mismatch,
        "parameter_mismatch": pmismatch,
        "macro": identity,
    }


def write_manifest(result: dict[str, Any], path: Path) -> None:
    """Write a reproducible JSON identity; YAML is intentionally not used."""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
