#!/usr/bin/env python3
"""Deterministic Spec -> package delivery for the ADPLL generator.

Usage:
  python3 flow/generator/delivery.py \
    --spec flow/generator/spec.example.json \
    --out build/adpll_ics55 --package

The output is a build-ready template: RTL source set, generated top wrapper,
macro rebuild/config contract, SDC, validation plan, and design.lock.json.
It intentionally does not run synthesis/DRC/LVS and never sets
production_eligible.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import tarfile
from pathlib import Path
from typing import Any

try:  # package import
    from .cdc import cdc_contract, sdc_text
    from .clock_ir import (audit_sdc_text, build_clock_ir, sdc_lines,
                           validate_clock_ir)
    from .physical import DEFAULT_INVENTORY, macro_key_for_pdk
    from .spec import SpecError, load_spec, resolve_spec
except ImportError:  # direct script execution
    from cdc import cdc_contract, sdc_text
    from clock_ir import (audit_sdc_text, build_clock_ir, sdc_lines,
                          validate_clock_ir)
    from physical import DEFAULT_INVENTORY, macro_key_for_pdk
    from spec import SpecError, load_spec, resolve_spec

ROOT = Path(__file__).resolve().parents[2]
COMMON_SOURCES = (
    # Digital blocks used by all physical core wrappers.
    "src/pll_logic.v",
    "src/freq_lock.v",
    "src/frequency_counter_frontend.v",
    "src/digital_loop_filter.v",
    "src/lock_detector.v",
    "src/term_decoder.v",
    "src/delta_sigma.v",
    "src/fix_div.v",
    "src/conf_div.v",
)
ANALOG_SOURCES = (
    "src/pll_analog.v",
    "src/il_dco.v",
    "src/injection.v",
    "src/coarse_delay.v",
    "src/mid_delay.v",
    "src/fine_delay.v",
    "src/sym.v",
    "src/sym_mux.v",
    "src/ssbbpd.v",
)
SIM_SOURCES = (
    "src/sim_SSBBPD.v",
    "src/sim_sym.v",
    "src/sim_buff.v",
    "src/sim_mux.v",
    "src/sim_dco.v",
    "src/sim_injection.v",
)
TARGETS = ("simulation", "macro-build", "top-integration")
TOP_MODULE = {
    "core_a_il_dco": "pll_macro_top",
    "core_b_ring_dco": "PLL_RING_TOP",
    "core_c_counter": "PLL_COUNTER_TOP",
}

CELL_SOURCES = {
    "ics55": "src/pll_cells_ics55.v",
    "ihp-sg13g2": "src/pll_cells_ihp-sg13g2.v",
    "gf180mcu_as": "src/pll_cells_gf180mcu.v",
    "freepdk45": "src/pll_cells_freepdk45.v",
}
MACRO_WRAPPERS = {
    "ics55": "flow/macro/ics55_h7cr/pll_analog_macro.v",
    "ihp-sg13g2": "flow/macro/ihp130_sg13g2/pll_analog_macro.v",
    "gf180mcu_as": "flow/macro/gf180mcu/pll_analog_macro.v",
}


def _sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def _canonical(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def _write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)


def _selected_core(resolved: dict[str, Any]) -> str:
    return str((resolved.get("selected") or {}).get("id") or "")


def _source_manifest(resolved: dict[str, Any], target: str = "simulation") -> list[str]:
    if target not in TARGETS:
        raise ValueError(f"unknown emit target: {target}")
    key = macro_key_for_pdk(str(resolved["spec"]["pdk"]))
    core = _selected_core(resolved)
    selected = resolved.get("selected") or {}
    if target == "top-integration":
        # The generated top instantiates one fixed blackbox; do not copy the
        # physical RTL or the analog simulation models into this source set.
        return []
    files = list(COMMON_SOURCES)
    if target == "simulation":
        files.extend(ANALOG_SOURCES)
        files.extend(SIM_SOURCES)
    elif target == "macro-build":
        files.extend(ANALOG_SOURCES)
    if key and key in CELL_SOURCES:
        files.append(CELL_SOURCES[key])
    # Core implementation RTL is required for simulation and macro build.
    files.extend(selected.get("implementation_refs", []))
    if key and key in MACRO_WRAPPERS and core == "core_a_il_dco":
        files.append(MACRO_WRAPPERS[key])
    return list(dict.fromkeys(files))

def _wrapper_text(resolved: dict[str, Any]) -> str:
    p = resolved["structural_parameters"]
    core = _selected_core(resolved)
    is_counter = core == "core_c_counter"
    is_ring = core == "core_b_ring_dco"
    if is_counter:
        top = "PLL_COUNTER_TOP"
    elif is_ring:
        top = "PLL_RING_TOP"
    else:
        top = "pll_macro_top"

    core_params = [
        f"    parameter integer COARSE_NDELS = {p['COARSE_NDELS']},",
        f"    parameter integer MID_NDELS = {p['MID_NDELS']},",
        f"    parameter integer FINE_NDELS = {p['FINE_NDELS']},",
    ]
    inst_params = [
        "        .COARSE_NDELS(COARSE_NDELS),",
        "        .MID_NDELS(MID_NDELS),",
        "        .FINE_NDELS(FINE_NDELS),",
    ]
    if is_counter:
        core_params += [
            f"    parameter integer ACC_BITS = {p.get('ACC_BITS', 16)},",
            f"    parameter integer BASE_INC = {p.get('BASE_INC', 3493)},",
            f"    parameter integer COARSE_STEP = {p.get('COARSE_STEP', 120)},",
            f"    parameter integer MID_STEP = {p.get('MID_STEP', 60)},",
            f"    parameter integer FINE_STEP = {p.get('FINE_STEP', 15)},",
        ]
        inst_params += [
            "        .ACC_BITS(ACC_BITS),",
            "        .BASE_INC(BASE_INC),",
            "        .COARSE_STEP(COARSE_STEP),",
            "        .MID_STEP(MID_STEP),",
            "        .FINE_STEP(FINE_STEP),",
        ]
    elif is_ring:
        core_params.append(
            f"    parameter integer BASE_NDELS = {p.get('BASE_NDELS', 256)},")
        inst_params.append("        .BASE_NDELS(BASE_NDELS),")
    else:
        core_params.append(f"    parameter integer IL_NDELS = {p['IL_NDELS']},")
        inst_params.append("        .IL_NDELS(IL_NDELS),")

    common_params = [
        f"    parameter integer FILTER_BITS = {p.get('FILTER_BITS', 16)},",
        f"    parameter integer FCW_BITS = {p.get('FCW_BITS', 8)},",
        "    parameter integer DIV_BITS = 8,",
        f"    parameter integer DIV_INIT = {int(resolved['frequency_plan']['out_div'])},",
        "    parameter integer LOCK_TOL = 1,",
        "    parameter integer LOCK_COUNT = 16,",
        "    parameter integer LOSS_COUNT = 4,",
        f"    parameter integer CNT_EXTRA_BITS = {p.get('CNT_EXTRA_BITS', 8)},",
        f"    parameter integer MEAS_PERIODS = {p.get('MEAS_PERIODS', 1)}",
    ]
    inst_common = [
        "        .FILTER_BITS(FILTER_BITS),",
        "        .FCW_BITS(FCW_BITS),",
        "        .DIV_BITS(DIV_BITS),",
        "        .DIV_INIT(DIV_INIT),",
        "        .LOCK_TOL(LOCK_TOL),",
        "        .LOCK_COUNT(LOCK_COUNT),",
        "        .LOSS_COUNT(LOSS_COUNT),",
        "        .CNT_EXTRA_BITS(CNT_EXTRA_BITS),",
        "        .MEAS_PERIODS(MEAS_PERIODS)",
    ]
    params = "\n".join(core_params + common_params)
    inst = "\n".join(inst_params + inst_common)
    tick_port = "    input TICK,\n" if is_counter else ""
    tick_conn = "        .TICK(TICK),\n" if is_counter else ""
    return f"""// Generated by flow/generator/delivery.py.  Template only; no signoff claim.
// Design: {resolved['design']}
// Architecture: {resolved['selected']['id']} ({resolved['architecture_state']})
`timescale 1fs/1fs

module adpll_top #(
{params}
) (
    input REF, RST_N, INJ_EN,
{tick_port}    input [FILTER_BITS-1:0] KP, KI,
    input [FCW_BITS-1:0] FCW,
    input DSM_EN_DT, DSM_EN_SHDT,
    input [1:0] DSM_ORDER,
    output OUT_DIV, LOCKED, ERR, OUT
);

    // out_div is a generated, fixed configuration.  The physical top still
    // has SET_DIV/LOAD_DIV for bring-up, but this integration wrapper does not
    // expose them; changing the divisor requires regenerating the design.
    localparam [DIV_BITS-1:0] DIV_SET = DIV_INIT;

    {top} #(
{inst}
    ) u_pll (
        .REF(REF), .RST_N(RST_N), .INJ_EN(INJ_EN),
{tick_conn}        .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT), .DSM_EN_SHDT(DSM_EN_SHDT),
        .DSM_ORDER(DSM_ORDER),
        .SET_DIV(DIV_SET), .LOAD_DIV(1'b0), .OUT_DIV(OUT_DIV),
        .LOCKED(LOCKED), .ERR(ERR), .OUT(OUT)
    );

endmodule
"""

def _blackbox_text(resolved: dict[str, Any]) -> str:
    p = resolved["structural_parameters"]
    core = _selected_core(resolved)
    top = TOP_MODULE.get(core, "pll_macro_top")
    if core == "core_c_counter":
        params = f"""    parameter integer COARSE_NDELS = {p['COARSE_NDELS']},
    parameter integer MID_NDELS = {p['MID_NDELS']},
    parameter integer FINE_NDELS = {p['FINE_NDELS']},
    parameter integer FILTER_BITS = {p.get('FILTER_BITS', 16)},
    parameter integer FCW_BITS = {p.get('FCW_BITS', 8)},
    parameter integer CNT_EXTRA_BITS = {p.get('CNT_EXTRA_BITS', 8)},
    parameter integer MEAS_PERIODS = {p.get('MEAS_PERIODS', 1)},
    parameter integer DIV_BITS = 8,
    parameter integer DIV_INIT = {int(resolved['frequency_plan']['out_div'])},
    parameter integer LOCK_TOL = 1,
    parameter integer LOCK_COUNT = 16,
    parameter integer LOSS_COUNT = 4,
    parameter integer ACC_BITS = {p.get('ACC_BITS', 16)},
    parameter integer BASE_INC = {p.get('BASE_INC', 3493)},
    parameter integer COARSE_STEP = {p.get('COARSE_STEP', 120)},
    parameter integer MID_STEP = {p.get('MID_STEP', 60)},
    parameter integer FINE_STEP = {p.get('FINE_STEP', 15)}"""
        tick = "    input TICK,\n"
    elif core == "core_b_ring_dco":
        params = f"""    parameter integer COARSE_NDELS = {p['COARSE_NDELS']},
    parameter integer MID_NDELS = {p['MID_NDELS']},
    parameter integer FINE_NDELS = {p['FINE_NDELS']},
    parameter integer FILTER_BITS = {p.get('FILTER_BITS', 16)},
    parameter integer FCW_BITS = {p.get('FCW_BITS', 8)},
    parameter integer CNT_EXTRA_BITS = {p.get('CNT_EXTRA_BITS', 8)},
    parameter integer MEAS_PERIODS = {p.get('MEAS_PERIODS', 1)},
    parameter integer DIV_BITS = 8,
    parameter integer DIV_INIT = {int(resolved['frequency_plan']['out_div'])},
    parameter integer LOCK_TOL = 1,
    parameter integer LOCK_COUNT = 16,
    parameter integer LOSS_COUNT = 4,
    parameter integer BASE_NDELS = {p.get('BASE_NDELS', 256)}"""
        tick = ""
    else:
        params = f"""    parameter integer COARSE_NDELS = {p['COARSE_NDELS']},
    parameter integer MID_NDELS = {p['MID_NDELS']},
    parameter integer FINE_NDELS = {p['FINE_NDELS']},
    parameter integer FILTER_BITS = {p.get('FILTER_BITS', 16)},
    parameter integer FCW_BITS = {p.get('FCW_BITS', 8)},
    parameter integer CNT_EXTRA_BITS = {p.get('CNT_EXTRA_BITS', 8)},
    parameter integer MEAS_PERIODS = {p.get('MEAS_PERIODS', 1)},
    parameter integer DIV_BITS = 8,
    parameter integer DIV_INIT = {int(resolved['frequency_plan']['out_div'])},
    parameter integer LOCK_TOL = 1,
    parameter integer LOCK_COUNT = 16,
    parameter integer LOSS_COUNT = 4,
    parameter integer IL_NDELS = {p.get('IL_NDELS', 4)}"""
        tick = ""
    return f"""// Generated hard-macro blackbox for top integration.
// Do not re-synthesize the physical DCO from RTL here.
(* blackbox *)
module {top} #(
{params}
) (
    input REF, RST_N, INJ_EN,
{tick}    input [FILTER_BITS-1:0] KP, KI,
    input [FCW_BITS-1:0] FCW,
    input DSM_EN_DT, DSM_EN_SHDT,
    input [1:0] DSM_ORDER,
    input [DIV_BITS-1:0] SET_DIV,
    input LOAD_DIV,
    output OUT_DIV, LOCKED, ERR, OUT
);
endmodule
"""


def _sdc_text(resolved: dict[str, Any], target: str = "simulation") -> str:
    include_mid = target != "top-integration"
    ir = build_clock_ir(resolved, include_internal_mid=include_mid)
    problems = validate_clock_ir(ir, require_internal_mid=include_mid)
    if problems:
        raise ValueError("clock IR is incomplete: " + "; ".join(problems))
    lines = [
        "# Generated top constraints; not a timing signoff.",
        "# Clock periods come from the resolved frequency plan, not a fixed TICK.",
        f"# target(OUT_DIV)={ir['target_mhz']:g} MHz; "
        f"DCO(OUT)={ir['dco_target_mhz']:g} MHz; out_div={ir['out_div']}",
    ]
    lines.extend(sdc_lines(ir))
    lines.extend([
        "set_clock_uncertainty 0.050 [get_clocks REF]",
        "set_clock_uncertainty 0.050 [get_clocks DCO_OUT]",
        "set_clock_uncertainty 0.050 [get_clocks OUT_DIV]",
    ])
    if include_mid:
        lines.extend([
            "# MID_OUT is internal; the CDC file adds its source-register max-delay.",
            "# No broad false_path or REF/DCO clock group here; that would mask",
            "# the Gray-bus max-delay check.  See freq_lock_cdc.sdc.",
        ])
    else:
        lines.extend([
            "# Top integration uses a hard-macro blackbox; MID_OUT is not a",
            "# top-level pin.  Internal CDC constraints belong inside the macro.",
        ])
    text = "\n".join(lines) + "\n"
    sdc_problems = audit_sdc_text(text, ir, require_internal_mid=include_mid)
    if sdc_problems:
        raise ValueError("generated SDC audit failed: " + "; ".join(sdc_problems))
    return text


def _macro_yaml(resolved: dict[str, Any]) -> str:
    macro = resolved.get("macro") or {}
    ident = macro.get("macro") or {}
    p = resolved["structural_parameters"]
    views = ident.get("views", {})
    lines = [
        "# Generated by flow/generator/delivery.py",
        f"design: {resolved['design']}",
        f"macro: {ident.get('macro', 'PLL_ANALOG_MACRO')}",
        f"pdk: {resolved['spec']['pdk']}",
        f"cell_library: {ident.get('cell_library', '')}",
        f"flow: {ident.get('flow', '')}",
        f"status: {macro.get('status', 'UNKNOWN')}",
        f"needs_rebuild: {str(bool(macro.get('needs_rebuild'))).lower()}",
        "parameters:",
    ]
    for key in ("COARSE_NDELS", "MID_NDELS", "FINE_NDELS", "IL_NDELS",
                "ACC_BITS", "BASE_INC", "DIV_INIT"):
        if key == "DIV_INIT":
            lines.append(f"  {key}: {int(resolved['frequency_plan']['out_div'])}")
        elif key in p:
            lines.append(f"  {key}: {p[key]}")
    lines.append(f"  OUT_DIV: {resolved['frequency_plan']['target_mhz']}")
    lines.append("views:")
    for name, view in views.items():
        lines.append(f"  {name}: {view.get('path')}")
    if macro.get("build_command"):
        lines.append(f"build_command: {macro['build_command']}")
    return "\n".join(lines) + "\n"


def _validation_plan(resolved: dict[str, Any]) -> dict[str, Any]:
    macro = resolved.get("macro") or {}
    return {
        "schema_version": 1,
        "design": resolved["design"],
        "status": resolved["status"],
        "must_pass": [
            "RTL elaboration and lint of generated/adpll_top.v",
            "macro parameter and physical-view identity match design.lock.json",
            "DCO characterization is bound to the selected architecture/implementation",
            "frequency plan target/REF/FCW/out_div consistency",
            "out_div is bound to DIV_INIT and OUT_DIV SDC; runtime override is explicit",
            "Gray-bus CDC skew/synchronizer review",
            "post-layout DRC/LVS/antenna and PVT/lock/jitter evidence",
        ],
        "blocking_checks": {
            "macro_status": macro.get("status"),
            "macro_needs_rebuild": bool(macro.get("needs_rebuild")),
            "architecture_state": resolved.get("architecture_state"),
            "counter_range": resolved.get("counter_range"),
        },
        "cdc": cdc_contract(
            int(resolved["structural_parameters"].get("FCW_BITS", 8)),
            int(resolved["structural_parameters"].get("CNT_EXTRA_BITS", 8)),
            int(resolved["structural_parameters"].get("MEAS_PERIODS", 1)),
        ),
        "commands": {
            "build_macro": macro.get("build_command"),
            "elaborate": "compile rtl/src/*.v with the selected PDK cell models",
        },
        "production_eligible": False,
    }


def _elaborate(out: Path, target: str) -> dict[str, Any]:
    """Compile the generated wrapper; separate from simulation/STA signoff."""
    tool = shutil.which("iverilog")
    if not tool:
        return {"status": "SKIPPED", "reason": "iverilog not installed"}
    sources = sorted((out / "rtl" / "src").glob("*.v"))
    cmd = [tool, "-g2012", "-s", "adpll_top",
           "-o", str(out / "rtl" / "elaborate.out")]
    if target == "simulation":
        cmd.append("-DSIMULATION")
    elif target == "macro-build":
        # The cell-model file defines PDK cells as blackboxes under YOSYS.
        # Icarus then checks connectivity without the full PDK.
        cmd.append("-DYOSYS")
    cmd.extend(str(path) for path in sources)
    cmd.append(str(out / "rtl" / "adpll_top.v"))
    proc = subprocess.run(cmd, cwd=out / "rtl", text=True, capture_output=True)
    log = out / "validation" / "elaborate.log"
    log.parent.mkdir(parents=True, exist_ok=True)
    log.write_text(" ".join(cmd) + "\n" + proc.stdout + proc.stderr)
    return {
        "status": "PASS" if proc.returncode == 0 else "FAIL",
        "returncode": proc.returncode,
        "log": str(log.relative_to(out)),
        "command": " ".join(cmd),
    }


def generate(resolved: dict[str, Any], out: Path,
             make_package: bool = False,
             run_macro_build: bool = False,
             inventory_path: Path | None = None,
             target: str = "simulation",
             elaborate: bool = False) -> dict[str, Any]:
    if target not in TARGETS:
        return {"status": "BLOCKED", "reason": f"unknown emit target: {target}",
                "out": str(out.resolve())}
    macro = resolved.get("macro") or {}
    if run_macro_build and macro.get("needs_rebuild"):
        command = macro.get("build_command")
        if not command:
            return {
                "status": "BLOCKED",
                "reason": "macro needs rebuild but no build_command is recorded",
                "out": str(out.resolve()),
            }
        proc = subprocess.run(command, shell=True, cwd=ROOT,
                              text=True, capture_output=True)
        log = out.resolve() / "macro" / "build.log"
        log.parent.mkdir(parents=True, exist_ok=True)
        log.write_text(proc.stdout + proc.stderr)
        if proc.returncode != 0:
            return {
                "status": "MACRO_BUILD_FAILED",
                "reason": command,
                "returncode": proc.returncode,
                "log": str(log),
                "out": str(out.resolve()),
            }
        resolved = resolve_spec(resolved["spec"], inventory_path)
    out = out.resolve()
    out.mkdir(parents=True, exist_ok=True)
    status = resolved.get("status")
    if status not in ("READY", "READY_NEEDS_MACRO_REBUILD",
                      "READY_EXPERIMENTAL", "READY_PHYSICAL_UNCHARACTERIZED"):
        return {
            "status": "BLOCKED",
            "reason": f"resolved design status is {status}",
            "blockers": resolved.get("blockers", []),
            "out": str(out),
        }

    rtl_src = out / "rtl" / "src"
    rtl_src.mkdir(parents=True, exist_ok=True)
    source_hashes: dict[str, str] = {}
    missing_sources = []
    if target == "top-integration":
        blackbox = rtl_src / "hardmacro_blackbox.v"
        _write(blackbox, _blackbox_text(resolved))
        source_hashes["generated/hardmacro_blackbox.v"] = _sha256(blackbox)
    else:
        for rel in _source_manifest(resolved, target):
            src = ROOT / rel
            if not src.is_file():
                missing_sources.append(rel)
                continue
            dst = rtl_src / src.name
            shutil.copyfile(src, dst)
            source_hashes[rel] = _sha256(dst)
    if missing_sources:
        return {
            "status": "BLOCKED",
            "reason": "missing source files",
            "missing_sources": missing_sources,
            "out": str(out),
        }

    _write(rtl_src / "sources.f",
           "\n".join(sorted(p.name for p in rtl_src.glob("*.v"))) + "\n")
    _write(out / "rtl" / "adpll_top.v", _wrapper_text(resolved))
    _write(out / "resolved.json",
           json.dumps(resolved, indent=2, sort_keys=True) + "\n")
    include_mid = target != "top-integration"
    clock_ir = build_clock_ir(resolved, include_internal_mid=include_mid)
    clock_problems = validate_clock_ir(clock_ir,
                                       require_internal_mid=include_mid)
    if clock_problems:
        return {
            "status": "BLOCKED",
            "reason": "clock IR validation failed",
            "clock_ir_problems": clock_problems,
            "out": str(out),
        }
    _write(out / "constraints" / "adpll.sdc", _sdc_text(resolved, target))
    _write(out / "constraints" / "clock_ir.json",
           json.dumps(clock_ir, indent=2, sort_keys=True) + "\n")
    if target == "top-integration":
        _write(out / "constraints" / "freq_lock_cdc.sdc",
               "# No top-level Gray CDC is exposed by the hard-macro blackbox.\n"
               "# Apply the macro-build/simulation CDC constraints inside the macro partition.\n")
    else:
        _write(out / "constraints" / "freq_lock_cdc.sdc", sdc_text(
            1000.0 / float(clock_ir["dco_target_mhz"]),
            1000.0 / float(clock_ir["ref_mhz"]),
            int(resolved["structural_parameters"].get("FCW_BITS", 8)),
            int(resolved["structural_parameters"].get("CNT_EXTRA_BITS", 8)),
            int(resolved["structural_parameters"].get("MEAS_PERIODS", 1)),
        ))
    _write(out / "macro" / "config.yaml", _macro_yaml(resolved))
    macro = resolved.get("macro") or {}
    build_cmd = macro.get("build_command") or "# no rebuild command recorded"
    _write(out / "macro" / "build.sh", f"""#!/bin/sh
# Generated rebuild entry point; review before running.
set -eu
ROOT="${{ADPLL_REPO_ROOT:-{ROOT}}}"
cd "$ROOT"
{build_cmd}
""")
    os.chmod(out / "macro" / "build.sh", 0o755)
    _write(out / "validation" / "plan.json",
           json.dumps(_validation_plan(resolved), indent=2, sort_keys=True) + "\n")

    _write(out / "README.md", f"""# {resolved['design']}

Generated by `flow/generator/delivery.py` from `{resolved['spec']['pdk']}`.

- Architecture: `{resolved['selected']['id']}` / `{resolved['architecture_state']}`
- Resolution: `{status}`
- Macro: `{(resolved.get('macro') or {}).get('status')}`
- Production eligible: **false**

This package is a build/validation template.  It is not a DRC/LVS/timing
signoff and does not contain a GDS/PDK characterization result.
""")
    generated_hashes = {}
    for path in sorted(out.rglob("*")):
        if path.is_file() and path.name != "design.lock.json":
            generated_hashes[str(path.relative_to(out))] = _sha256(path)
    lock = {
        "schema_version": 1,
        "design": resolved["design"],
        "status": status,
        "spec_hash": resolved.get("spec_hash"),
        "resolved_hash": resolved.get("resolved_hash"),
        "parameter_hash": resolved.get("parameter_hash"),
        "macro": resolved.get("macro"),
        "counter_range": resolved.get("counter_range"),
        "emit_target": target,
        "divider_contract": resolved.get("divider_contract"),
        "clock_ir": clock_ir,
        "cdc": cdc_contract(
            int(resolved["structural_parameters"].get("FCW_BITS", 8)),
            int(resolved["structural_parameters"].get("CNT_EXTRA_BITS", 8)),
            int(resolved["structural_parameters"].get("MEAS_PERIODS", 1)),
        ),
        "source_hashes": source_hashes,
        "generated_files": generated_hashes,
        "production_eligible": False,
    }
    _write(out / "design.lock.json",
           json.dumps(lock, indent=2, sort_keys=True) + "\n")
    package = None
    if make_package:
        package = out.parent / (out.name + ".tar.gz")
        with tarfile.open(package, "w:gz") as tar:
            tar.add(out, arcname=out.name)
    elaboration = _elaborate(out, target) if elaborate else None
    return {
        "status": status,
        "target": target,
        "out": str(out),
        "package": str(package) if package else None,
        "lock": str(out / "design.lock.json"),
        "macro_status": (resolved.get("macro") or {}).get("status"),
        "elaboration": elaboration,
        "production_eligible": False,
    }


def verify(out: Path) -> dict[str, Any]:
    out = out.resolve()
    lock_path = out / "design.lock.json"
    if not lock_path.is_file():
        return {"status": "FAIL_NO_LOCK", "out": str(out)}
    lock = json.loads(lock_path.read_text())
    mismatches = []
    missing = []
    for rel, digest in (lock.get("generated_files") or {}).items():
        path = out / rel
        if not path.is_file():
            missing.append(rel)
        elif _sha256(path) != digest:
            mismatches.append(rel)
    return {
        "status": "PASS" if not missing and not mismatches else "FAIL_HASH",
        "out": str(out),
        "missing": missing,
        "mismatches": mismatches,
        "production_eligible": False,
    }


def main() -> int:
    ap = argparse.ArgumentParser(description="ADPLL spec-to-package delivery")
    ap.add_argument("--spec", type=Path)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--macro-inventory", type=Path, default=DEFAULT_INVENTORY)
    ap.add_argument("--package", action="store_true")
    ap.add_argument("--run-macro-build", action="store_true")
    ap.add_argument("--target", choices=TARGETS, default="simulation",
                    help="simulation, macro-build, or top-integration source set")
    ap.add_argument("--elaborate", action="store_true",
                    help="compile the generated wrapper with iverilog")
    ap.add_argument("--verify", action="store_true")
    args = ap.parse_args()
    if args.verify:
        result = verify(args.out)
        print(json.dumps(result, indent=2, sort_keys=True))
        return 0 if result["status"] == "PASS" else 1
    if args.spec is None:
        print(json.dumps({"status": "ERROR", "reason": "--spec is required"}, indent=2))
        return 1
    try:
        raw = load_spec(args.spec)
        resolved = resolve_spec(raw, args.macro_inventory)
        result = generate(resolved, args.out, args.package,
                          run_macro_build=args.run_macro_build,
                          inventory_path=args.macro_inventory,
                          target=args.target, elaborate=args.elaborate)
    except (SpecError, OSError, ValueError) as exc:
        print(json.dumps({"status": "ERROR", "reason": str(exc)}, indent=2))
        return 1
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0 if result["status"].startswith("READY") else 1


if __name__ == "__main__":
    raise SystemExit(main())
