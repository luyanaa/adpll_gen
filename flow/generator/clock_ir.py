#!/usr/bin/env python3
"""Explicit clock relationships for generated constraints.

The SDC generator must never guess a period from the REF reference alone.  The
DCO output, the post-divider output, and the internal measurement clock are
different clocks with different periods.  This module is the single source of
that relationship for both ``adpll.sdc`` and the CDC constraints.

The IR is deliberately small and JSON-serialisable so the generated package
can ship it beside the SDC and a check can detect silent empty ``get_ports``
collections later.
"""
from __future__ import annotations

from typing import Any


def _period_ns(freq_mhz: float) -> float:
    if freq_mhz <= 0:
        raise ValueError("clock frequency must be positive")
    return 1000.0 / float(freq_mhz)


def build_clock_ir(resolved: dict[str, Any],
                   include_internal_mid: bool = True) -> dict[str, Any]:
    plan = resolved.get("frequency_plan") or {}
    spec = resolved.get("spec") or {}
    selected = resolved.get("selected") or {}

    ref_mhz = float(plan.get("ref_mhz", spec.get("ref_mhz", 0.0)))
    out_mhz = float(plan.get("target_mhz", spec.get("target_mhz", 0.0)))
    out_div = int(plan.get("out_div", spec.get("out_div", 1)))
    dco_mhz = float(plan.get("dco_target_mhz", out_mhz * out_div))
    tick_mhz = spec.get("tick_frequency_mhz")
    is_counter = selected.get("core") == "core_c_counter" or selected.get("id") == "core_c_counter"

    clocks: list[dict[str, Any]] = [
        {
            "name": "REF",
            "period_ns": _period_ns(ref_mhz),
            "source": "port:REF",
            "kind": "primary",
            "role": "reference",
        },
        {
            "name": "DCO_OUT",
            "period_ns": _period_ns(dco_mhz),
            "source": "port:OUT",
            "kind": "primary",
            "role": "raw_dco_output",
            "note": "OUT is the raw DCO/NCO output, not the divided output",
        },
        {
            "name": "OUT_DIV",
            "period_ns": _period_ns(out_mhz),
            "source": "port:OUT_DIV",
            "kind": "generated",
            "source_clock": "DCO_OUT",
            "source_port": "OUT",
            "target": "port",
            "divide_by": out_div,
            "role": "post_divider_output",
        },
        {
            "name": "MID_OUT",
            "period_ns": _period_ns(dco_mhz),
            "source": "pin:*u_pll*MID_OUT",
            "kind": "generated",
            "source_clock": "DCO_OUT",
            "source_port": "OUT",
            "target": "pin",
            "divide_by": 1,
            "role": "internal_measurement_clock",
            "note": "MID_OUT is internal; never use get_ports for it",
        },
    ]
    if not include_internal_mid:
        clocks = [c for c in clocks if c["name"] != "MID_OUT"]
    if is_counter:
        if tick_mhz is None:
            raise ValueError("Core C requires tick_frequency_mhz for the clock IR")
        clocks.append({
            "name": "TICK",
            "period_ns": _period_ns(float(tick_mhz)),
            "source": "port:TICK",
            "kind": "primary",
            "role": "nco_tick",
        })
        # Do not put REF/DCO/MID_OUT in an asynchronous clock group here:
        # set_clock_groups is a false-path construct and would override the
        # Gray-bus max-delay check.  TICK/REF are independent external inputs;
        # the Gray CDC exceptions live in freq_lock_cdc.sdc.
        asynchronous_groups = [["REF"], ["TICK"]]
    else:
        asynchronous_groups = []

    return {
        "schema_version": 1,
        "target_mhz": out_mhz,
        "dco_target_mhz": dco_mhz,
        "out_div": out_div,
        "ref_mhz": ref_mhz,
        "tick_mhz": float(tick_mhz) if tick_mhz is not None else None,
        "clocks": clocks,
        "asynchronous_groups": asynchronous_groups,
        "relationships": (
            "f_DCO = f_REF * fcw; f_OUT_DIV = f_DCO / out_div; "
            "MID_OUT follows the raw DCO output in this digital contract"
        ),
        "status": "PLANNED_NOT_TIMING_SIGNOFF",
    }


def sdc_lines(ir: dict[str, Any]) -> list[str]:
    """Render primary/generated clock declarations from the IR."""
    lines: list[str] = []
    for clock in ir["clocks"]:
        name = clock["name"]
        period = float(clock["period_ns"])
        if clock["kind"] == "primary":
            lines.append(
                f"create_clock -name {name} -period {period:.6f} "
                f"[get_ports {clock['source'].split(':', 1)[1]}]"
            )
        else:
            source_port = clock.get("source_port", "OUT")
            target_name = clock["source"].split(":", 1)[1]
            source = f"[get_ports {source_port}]"
            if clock.get("target") == "pin":
                target = f"[get_pins -hierarchical {target_name}]"
            else:
                target = f"[get_ports {target_name}]"
            divide = int(clock.get("divide_by", 1))
            lines.append(
                f"create_generated_clock -name {name} -source {source} "
                f"-divide_by {divide} {target}"
            )
    groups = " ".join(
        "-group {" + " ".join(group) + "}"
        for group in ir.get("asynchronous_groups", []))
    if groups:
        lines.append(f"set_clock_groups -asynchronous {groups}")
    return lines


def validate_clock_ir(ir: dict[str, Any],
                      require_internal_mid: bool = True) -> list[str]:
    """Return human-readable defects; an empty list is the only useful pass."""
    problems: list[str] = []
    names = {c["name"] for c in ir.get("clocks", [])}
    required_names = ["REF", "DCO_OUT", "OUT_DIV"]
    if require_internal_mid:
        required_names.append("MID_OUT")
    for required in required_names:
        if required not in names:
            problems.append(f"missing clock {required}")
    for clock in ir.get("clocks", []):
        if clock["name"] == "DCO_OUT":
            expected = _period_ns(float(ir["dco_target_mhz"]))
            if abs(float(clock["period_ns"]) - expected) > 1e-9:
                problems.append("DCO_OUT period does not match DCO target")
        if clock["name"] == "OUT_DIV":
            expected = _period_ns(float(ir["target_mhz"]))
            if abs(float(clock["period_ns"]) - expected) > 1e-9:
                problems.append("OUT_DIV period does not match target")
        if "MID_OUT" in str(clock.get("source", "")) and clock.get("kind") == "primary":
            problems.append("MID_OUT must be constrained as an internal/generated clock")
    return problems


def audit_sdc_text(text: str, ir: dict[str, Any],
                    require_internal_mid: bool = True) -> list[str]:
    """Static audit of generated SDC; not a substitute for OpenSTA."""
    import re

    problems: list[str] = []
    if "get_ports MID_OUT" in text:
        problems.append("MID_OUT is constrained as a top port")
    expected = {c["name"]: c for c in ir.get("clocks", [])}
    for name in (("REF", "DCO_OUT", "OUT_DIV", "MID_OUT")
                 if "MID_OUT" in expected else ("REF", "DCO_OUT", "OUT_DIV")):
        if name not in expected:
            problems.append(f"clock IR missing {name}")
    for name in ("DCO_OUT", "OUT_DIV"):
        clock = expected.get(name)
        if not clock:
            continue
        match = re.search(
            rf"create_(?:generated_)?clock\s+-name\s+{name}\s+.*?-period\s+([0-9.]+)",
            text)
        if name == "OUT_DIV":
            match = re.search(
                rf"create_generated_clock\s+-name\s+OUT_DIV\s+.*?-divide_by\s+(\d+)",
                text)
            want_div = int(clock.get("divide_by", 1))
            if not match or int(match.group(1)) != want_div:
                problems.append("OUT_DIV generated-clock divider missing/mismatched")
            continue
        want_period = float(clock["period_ns"])
        if not match or abs(float(match.group(1)) - want_period) > 1e-6:
            problems.append(f"{name} period missing/mismatched")
    if "set_false_path" in text:
        problems.append("broad set_false_path is present in generated top SDC")
    return problems
