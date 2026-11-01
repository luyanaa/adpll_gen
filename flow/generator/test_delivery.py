from pathlib import Path
import json
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).parent))

from delivery import _wrapper_text, generate, verify
from spec import resolve_spec


def make_inventory(root: Path, *, library="ics55_LLSC_H7CR",
                   coarse=15, views=True):
    root.mkdir(parents=True, exist_ok=True)
    inv = {
        "schema_version": 1,
        "macros": {
            "ics55": {
                "name": "PLL_ANALOG_MACRO",
                "core": "core_a_il_dco",
                "pdk": "ics55",
                "cell_library": library,
                "root": str(root),
                "flow": "test_flow",
                "parameters": {
                    "COARSE_NDELS": coarse,
                    "MID_NDELS": 15,
                    "FINE_NDELS": 31,
                    "IL_NDELS": 4,
                },
                "views": {},
                "required_views": ["lef", "lib", "cdl", "gds"],
                "build_command": "make test-macro",
            }
        },
    }
    if views:
        for name in ("lef", "lib", "cdl", "gds"):
            p = root / f"PLL_ANALOG_MACRO.{name}"
            p.write_text(f"{name} view\n")
            inv["macros"]["ics55"]["views"][name] = str(p)
    else:
        inv["macros"]["ics55"]["views"] = {
            name: str(root / f"missing.{name}")
            for name in ("lef", "lib", "cdl", "gds")
        }
    path = root / "macro_inventory.json"
    path.write_text(json.dumps(inv, indent=2) + "\n")
    return path


def make_counter_inventory(root: Path, *, base_inc: int = 26214,
                           acc_bits: int = 16):
    """A core-specific physical inventory entry used to exercise Core C."""
    root.mkdir(parents=True, exist_ok=True)
    entry = {
        "name": "PLL_COUNTER_DCO_PHYS",
        "core": "core_c_counter",
        "pdk": "ics55",
        "cell_library": "ics55_LLSC_H7CR",
        "root": str(root),
        "flow": "test_flow",
        "parameters": {
            "COARSE_NDELS": 15, "MID_NDELS": 15, "FINE_NDELS": 31,
            "IL_NDELS": 4, "ACC_BITS": acc_bits, "BASE_INC": base_inc,
            "COARSE_STEP": 120, "MID_STEP": 60, "FINE_STEP": 15,
        },
        "views": {},
        "required_views": ["lef", "lib", "gds"],
        "build_command": "make test-counter-macro",
    }
    for name in entry["required_views"]:
        path = root / f"PLL_COUNTER_DCO_PHYS.{name}"
        path.write_text(f"{name} view\n")
        entry["views"][name] = str(path)
    inv = {"schema_version": 1,
           "macros": {"ics55:core_c_counter": entry}}
    path = root / "macro_inventory.json"
    path.write_text(json.dumps(inv, indent=2) + "\n")
    return path


def base_spec(**overrides):
    spec = {
        "design": "adpll_top",
        "pdk": "ics55",
        "target_mhz": 800,
        "ref_mhz": 100,
        "fcw": 8,
        "out_div": 1,
        "tick_frequency_mhz": 100.0,
        "area": "medium",
        "mode": "buildable",
        "features": {},
        "structural": {
            "COARSE_NDELS": 15,
            "MID_NDELS": 15,
            "FINE_NDELS": 31,
            "IL_NDELS": 4,
            "FILTER_BITS": 16,
            "FCW_BITS": 8,
            "CNT_EXTRA_BITS": 8,
            "MEAS_PERIODS": 1,
        },
        "allow_macro_rebuild": False,
        "allow_experimental": False,
    }
    spec.update(overrides)
    return spec


def main():
    with tempfile.TemporaryDirectory() as td:
        root = Path(td)
        inv = make_inventory(root)
        resolved = resolve_spec(base_spec(), inv)
        assert resolved["status"] == "READY", resolved
        assert resolved["macro"]["status"] == "BUILT", resolved["macro"]
        assert resolved["macro"]["macro"]["parameter_hash"], resolved["macro"]
        out = root / "pkg"
        result = generate(resolved, out, make_package=True)
        assert result["status"] == "READY", result
        lock = json.loads((out / "design.lock.json").read_text())
        assert lock["macro"]["status"] == "BUILT"
        assert lock["source_hashes"]
        assert lock["generated_files"]["rtl/adpll_top.v"]
        assert (out / "constraints" / "freq_lock_cdc.sdc").is_file()
        assert (out.parent / "pkg.tar.gz").is_file()
        assert verify(out)["status"] == "PASS", verify(out)

        # Core A top integration keeps pll_logic and pll_macro_top as real RTL
        # and blackboxes only the analog macro, whose name must match the
        # physical inventory.
        core_a_top = root / "core_a_top"
        result = generate(resolved, core_a_top, target="top-integration",
                          elaborate=True)
        assert result["status"] == "READY", result
        assert result["elaboration"]["status"] == "PASS", result["elaboration"]
        a_srcs = (core_a_top / "rtl" / "src" / "sources.f").read_text()
        assert "pll_macro_top.v" in a_srcs, a_srcs
        assert "pll_logic.v" in a_srcs, a_srcs
        assert "pll_analog.v" not in a_srcs, a_srcs
        assert "il_dco.v" not in a_srcs, a_srcs
        a_bb = (core_a_top / "rtl" / "src" / "hardmacro_blackbox.v").read_text()
        assert "module PLL_ANALOG_MACRO" in a_bb, a_bb
        assert "module pll_macro_top" not in a_bb, a_bb
        assert "IL_NDELS" in a_bb, a_bb
        assert "COARSE_MUX" in a_bb and "MID_OUT" in a_bb, a_bb

        # A structural change must invalidate the physical macro identity.
        bad = base_spec(structural={
            **base_spec()["structural"], "COARSE_NDELS": 7})
        resolved = resolve_spec(bad, inv)
        assert resolved["macro"]["status"] == "PARAMETER_MISMATCH", resolved["macro"]
        assert resolved["status"] == "NEEDS_MACRO_REBUILD", resolved

        # A rebuild plan is generated only when explicitly allowed.
        allow = base_spec(structural={
            **base_spec()["structural"], "COARSE_NDELS": 7},
            allow_macro_rebuild=True)
        resolved = resolve_spec(allow, inv)
        assert resolved["status"] == "READY_NEEDS_MACRO_REBUILD", resolved
        result = generate(resolved, root / "rebuild")
        assert result["status"] == "READY_NEEDS_MACRO_REBUILD", result

        # Missing views are not silently treated as built.
        miss = make_inventory(root / "missing", views=False)
        resolved = resolve_spec(base_spec(allow_macro_rebuild=True), miss)
        assert resolved["macro"]["status"] == "MISSING_VIEWS", resolved["macro"]
        assert resolved["status"] == "READY_NEEDS_MACRO_REBUILD", resolved

        # Library mismatch is a different identity, not a fallback.
        wrong = make_inventory(root / "wrong", library="ics55_LLSC_H7CH")
        resolved = resolve_spec(base_spec(), wrong)
        assert resolved["macro"]["status"] == "LIBRARY_MISMATCH", resolved["macro"]

        # Counter width is checked against the acquisition ratio; a too-small
        # counter is a blocker, not a silent wrap.
        narrow = dict(base_spec(), target_mhz=3, ref_mhz=1, fcw=3)
        narrow["structural"] = {
            **base_spec()["structural"], "FCW_BITS": 2, "CNT_EXTRA_BITS": 0,
            "ACC_BITS": 16, "BASE_INC": 26214,
        }
        narrow["allow_unverified_dco"] = True
        narrow_inv = make_counter_inventory(root / "narrow", base_inc=26214)
        resolved = resolve_spec(narrow, narrow_inv)
        assert resolved["counter_range"]["ok"] is False, resolved["counter_range"]
        assert resolved["status"] == "NEEDS_COUNTER_RANGE", resolved

        # Core C is a physical counter/NCO macro; its generated top must
        # expose TICK and instantiate PLL_COUNTER_TOP rather than Core A.
        counter_inv = make_counter_inventory(root / "counter")
        counter = base_spec(target_mhz=20, ref_mhz=10, fcw=2, area="high")
        counter["structural"].update({
            "ACC_BITS": 16, "BASE_INC": 26214,
            "COARSE_STEP": 120, "MID_STEP": 60, "FINE_STEP": 15,
        })
        counter["allow_unverified_dco"] = True
        resolved = resolve_spec(counter, counter_inv)
        assert resolved["selected"]["id"] == "core_c_counter", resolved
        assert resolved["status"] == "READY_PHYSICAL_UNCHARACTERIZED", resolved
        counter_pkg = root / "counter_pkg"
        result = generate(resolved, counter_pkg)
        assert result["status"] == "READY_PHYSICAL_UNCHARACTERIZED", result
        wrapper = (counter_pkg / "rtl" / "adpll_top.v").read_text()
        assert "PLL_COUNTER_TOP" in wrapper and "input TICK" in wrapper, wrapper
        assert "TICK(TICK)" in wrapper, wrapper
        assert "DIV_INIT" in wrapper, wrapper
        assert "input [DIV_BITS-1:0] SET_DIV" not in wrapper, wrapper
        assert ".SET_DIV(DIV_SET), .LOAD_DIV(1'b0)" in wrapper, wrapper
        sdc = (counter_pkg / "constraints" / "adpll.sdc").read_text()
        assert "get_ports MID_OUT" not in sdc, sdc
        assert "create_clock -name DCO_OUT -period 50.000000" in sdc, sdc
        assert "create_clock -name TICK -period 10.000000" in sdc, sdc
        cdc = (counter_pkg / "constraints" / "freq_lock_cdc.sdc").read_text()
        assert "get_ports MID_OUT" not in cdc, cdc
        assert "create_clock -name MID_OUT -period 50.000000" in cdc, cdc
        assert "\nset_false_path" not in cdc, cdc
        assert verify(counter_pkg)["status"] == "PASS"

        # Source sets are target-specific: top integration must not copy the
        # physical DCO RTL and re-elaborate it by accident.
        for emit_target in ("simulation", "macro-build", "top-integration"):
            pkg = root / f"target_{emit_target}"
            result = generate(resolved, pkg, target=emit_target)
            assert result["status"] == "READY_PHYSICAL_UNCHARACTERIZED", result
            srcs = (pkg / "rtl" / "src" / "sources.f").read_text()
            if emit_target == "top-integration":
                assert "hardmacro_blackbox.v" in srcs, srcs
                assert "pll_counter_dco_phys.v" not in srcs, srcs
                assert "pll_counter_top.v" in srcs, srcs
                assert "pll_logic.v" in srcs, srcs
                bb = (pkg / "rtl" / "src" / "hardmacro_blackbox.v").read_text()
                assert "module PLL_COUNTER_DCO_PHYS" in bb, bb
                assert "module PLL_COUNTER_TOP" not in bb, bb
                assert "input TICK" in bb, bb
                sdc = (pkg / "constraints" / "adpll.sdc").read_text()
                assert "get_ports MID_OUT" not in sdc, sdc
                assert "get_pins -hierarchical *u_pll*MID_OUT" in sdc, sdc
                cdc = (pkg / "constraints" / "freq_lock_cdc.sdc").read_text()
                assert "get_ports MID_OUT" not in cdc, cdc
                assert "*u_pll*MID_OUT" in cdc, cdc
                assert "*counter_frontend*gray_q*" in cdc, cdc
            else:
                assert "pll_counter_dco_phys.v" in srcs, srcs

        # The top-integration source set must elaborate with the real digital
        # controller and only the DCO macro blackbox.
        top_elab = root / "counter_top_elab"
        result = generate(resolved, top_elab, target="top-integration",
                          elaborate=True)
        assert result["status"] == "READY_PHYSICAL_UNCHARACTERIZED", result
        assert result["elaboration"]["status"] == "PASS", result["elaboration"]

        # out_div must change both the DCO target and the generated OUT_DIV
        # constraint.  The output contract is 10 MHz, so the raw DCO is 20 MHz.
        divided = base_spec(target_mhz=10, ref_mhz=10, fcw=2, area="high",
                            out_div=2)
        divided["structural"].update({
            "ACC_BITS": 16, "BASE_INC": 26214,
            "COARSE_STEP": 120, "MID_STEP": 60, "FINE_STEP": 15,
        })
        divided["allow_unverified_dco"] = True
        resolved = resolve_spec(divided, counter_inv)
        assert resolved["frequency_plan"]["dco_target_mhz"] == 20.0, resolved
        divided_pkg = root / "divided_pkg"
        result = generate(resolved, divided_pkg)
        assert result["status"] == "READY_PHYSICAL_UNCHARACTERIZED", result
        sdc = (divided_pkg / "constraints" / "adpll.sdc").read_text()
        assert "create_clock -name DCO_OUT -period 50.000000" in sdc, sdc
        assert "create_generated_clock -name OUT_DIV" in sdc, sdc
        assert "-divide_by 2" in sdc, sdc
        assert "create_generated_clock -name OUT_DIV -source [get_ports OUT] -divide_by 2 [get_ports OUT_DIV]" in sdc, sdc
        wrapper = (divided_pkg / "rtl" / "adpll_top.v").read_text()
        assert "parameter integer DIV_INIT = 2" in wrapper, wrapper

        # NCO feasibility: the carry-toggle ceiling is TICK/4, not TICK/2.
        too_high = base_spec(target_mhz=25.5, ref_mhz=25.5, fcw=1, area="high")
        too_high["structural"] = {
            **too_high["structural"], "ACC_BITS": 16, "BASE_INC": 26214,
            "COARSE_STEP": 120, "MID_STEP": 60, "FINE_STEP": 15,
        }
        too_high["allow_unverified_dco"] = True
        resolved = resolve_spec(too_high, counter_inv)
        assert resolved["frequency_plan"]["nco"]["max_output_mhz"] == 25.0, resolved
        assert resolved["frequency_plan"]["nco"]["target_reachable"] is False, resolved
        assert resolved["status"] == "NEEDS_NCO_RANGE", resolved
        assert any("f_TICK/4" in b for b in resolved["blockers"]), resolved

        # A fixed macro whose BASE_INC cannot produce the target must be
        # rejected, not silently packaged with a warning.
        fixed_inv = make_counter_inventory(root / "counter_fixed", base_inc=328)
        fixed = base_spec(target_mhz=20, ref_mhz=10, fcw=2, area="high")
        fixed["structural"] = {
            **fixed["structural"], "ACC_BITS": 16, "BASE_INC": 328,
            "COARSE_STEP": 120, "MID_STEP": 60, "FINE_STEP": 15,
        }
        fixed["allow_unverified_dco"] = True
        resolved = resolve_spec(fixed, fixed_inv)
        assert resolved["status"] == "NEEDS_NCO_FREQUENCY", resolved
        assert any("required BASE_INC=26214" in b for b in resolved["blockers"]), resolved
        assert resolved["frequency_plan"]["nco"]["base_inc_matches_target"] is False

        # A rebuild is the explicit escape hatch for an out-of-range fixed
        # macro; the plan must carry the computed BASE_INC.
        rebuild = dict(fixed, allow_macro_rebuild=True)
        resolved = resolve_spec(rebuild, fixed_inv)
        assert resolved["status"] == "READY_NEEDS_MACRO_REBUILD", resolved
        assert resolved["macro"]["needs_rebuild"] is True, resolved["macro"]
        assert resolved["macro"]["suggested_base_inc"] == 26214, resolved["macro"]

        # A larger BASE_INC is usable when the coarse/mid/fine code range
        # actually covers the target increment.
        tune_inv = make_counter_inventory(root / "counter_tune", base_inc=32768)
        tune = base_spec(target_mhz=23, ref_mhz=23, fcw=1, area="high")
        tune["structural"] = {
            **tune["structural"], "ACC_BITS": 16, "BASE_INC": 32768,
            "COARSE_STEP": 120, "MID_STEP": 60, "FINE_STEP": 15,
        }
        tune["allow_unverified_dco"] = True
        resolved = resolve_spec(tune, tune_inv)
        nco = resolved["frequency_plan"]["nco"]
        assert nco["target_reachable"] is True, resolved
        assert nco["increment_code_min"] <= nco["increment_for_dco_target"] <= nco["increment_code_max"], nco
        assert nco["increment_achievable"] is not None, nco
        assert resolved["status"] == "READY_PHYSICAL_UNCHARACTERIZED", resolved

        # Core C without a tick is a blocker, not a silent 1 GHz assumption.
        no_tick = base_spec(target_mhz=20, ref_mhz=10, fcw=2, area="high",
                            allow_macro_rebuild=True)
        no_tick.pop("tick_frequency_mhz", None)
        no_tick["structural"] = {
            **no_tick["structural"], "ACC_BITS": 16, "BASE_INC": 26214}
        no_tick["allow_unverified_dco"] = True
        resolved = resolve_spec(no_tick, counter_inv)
        assert resolved["status"] == "NEEDS_TICK_FREQUENCY", resolved
        assert any("tick_frequency_mhz" in b for b in resolved["blockers"]), resolved

        # The divider width is derived from out_div; out_div=256 must not be
        # truncated into an 8-bit DIV_INIT.
        fake = {
            "design": "adpll_top",
            "selected": {"id": "core_c_counter"},
            "architecture_state": "PHYSICAL_IMPLEMENTABLE",
            "structural_parameters": {
                "COARSE_NDELS": 15, "MID_NDELS": 15, "FINE_NDELS": 31,
                "ACC_BITS": 16, "BASE_INC": 26214,
                "COARSE_STEP": 120, "MID_STEP": 60, "FINE_STEP": 15,
                "FILTER_BITS": 16, "FCW_BITS": 8,
                "CNT_EXTRA_BITS": 8, "MEAS_PERIODS": 1,
            },
            "frequency_plan": {"out_div": 256},
            "divider_contract": {"out_div": 256, "div_bits": 9},
        }
        wrapper = _wrapper_text(fake)
        assert "parameter integer DIV_BITS = 9" in wrapper, wrapper
        assert "parameter integer DIV_INIT = 256" in wrapper, wrapper

        # FCW must fit its declared width.
        bad_fcw = base_spec(target_mhz=3, ref_mhz=1, fcw=3, area="high")
        bad_fcw["structural"] = {
            **bad_fcw["structural"], "FCW_BITS": 1, "ACC_BITS": 16,
            "BASE_INC": 26214,
        }
        bad_fcw["allow_unverified_dco"] = True
        resolved = resolve_spec(bad_fcw, counter_inv)
        assert resolved["status"] == "NEEDS_FCW_WIDTH", resolved

        # The current PLL_COUNTER_DCO_PHYS adder is 16-bit only.
        bad_acc = base_spec(target_mhz=20, ref_mhz=10, fcw=2, area="high")
        bad_acc["structural"] = {
            **bad_acc["structural"], "ACC_BITS": 12, "BASE_INC": 26214,
            "COARSE_STEP": 120, "MID_STEP": 60, "FINE_STEP": 15,
        }
        bad_acc["allow_unverified_dco"] = True
        acc_inv = make_counter_inventory(root / "acc12", acc_bits=12)
        resolved = resolve_spec(bad_acc, acc_inv)
        assert resolved["status"] == "NEEDS_ACC_BITS", resolved

        # gf180mcu has a physical Core B macro; uncharacterized bring-up
        # packaging is explicit rather than an experimental fallback.
        exp = base_spec(pdk="gf180mcu_as_sc_mcu7t3v3", target_mhz=100,
                        ref_mhz=50, fcw=2, mode="buildable",
                        allow_unverified_dco=True)
        resolved = resolve_spec(exp)
        assert resolved["status"] == "READY_PHYSICAL_UNCHARACTERIZED", resolved
        assert resolved["architecture_state"] == "PHYSICAL_IMPLEMENTABLE", resolved
        assert resolved["macro"]["status"] == "BUILT", resolved["macro"]
        assert resolved["macro"]["macro"]["macro"] == "PLL_RING_DCO_PHYS", resolved

        # Core B top integration: real ring top + digital controller, DCO macro
        # blackbox only.
        ring_top = root / "ring_top"
        result = generate(resolved, ring_top, target="top-integration",
                          elaborate=True)
        assert result["status"] == "READY_PHYSICAL_UNCHARACTERIZED", result
        assert result["elaboration"]["status"] == "PASS", result["elaboration"]
        ring_srcs = (ring_top / "rtl" / "src" / "sources.f").read_text()
        assert "pll_ring_top.v" in ring_srcs, ring_srcs
        assert "pll_logic.v" in ring_srcs, ring_srcs
        assert "pll_ring_dco_phys.v" not in ring_srcs, ring_srcs
        assert "il_dco.v" not in ring_srcs, ring_srcs
        ring_bb = (ring_top / "rtl" / "src" / "hardmacro_blackbox.v").read_text()
        assert "module PLL_RING_DCO_PHYS" in ring_bb, ring_bb
        assert "module PLL_RING_TOP" not in ring_bb, ring_bb
        assert "TICK" not in ring_bb, ring_bb
        assert "MID_OUT" in ring_bb, ring_bb
        exp = base_spec(pdk="ihp-sg13g2", target_mhz=100,
                        ref_mhz=50, fcw=2, mode="buildable",
                        allow_unverified_dco=True)
        resolved = resolve_spec(exp)
        assert resolved["status"] == "READY_PHYSICAL_UNCHARACTERIZED", resolved
        assert resolved["architecture_state"] == "PHYSICAL_IMPLEMENTABLE", resolved
        assert resolved["macro"]["status"] == "BUILT", resolved["macro"]

        # A PDK without a core-specific physical entry remains RTL/experimental.
        exp = base_spec(pdk="sky130_fd_sc_hd", target_mhz=100,
                        ref_mhz=50, fcw=2, mode="explore",
                        allow_experimental=True)
        resolved = resolve_spec(exp)
        assert resolved["status"] == "READY_EXPERIMENTAL", resolved
        assert resolved["architecture_state"] == "RTL_SYNTHESIZABLE", resolved

    print("test_delivery: PASS")


if __name__ == "__main__":
    main()
