from pathlib import Path
import json
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).parent))

from delivery import generate, verify
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


def base_spec(**overrides):
    spec = {
        "design": "adpll_top",
        "pdk": "ics55",
        "target_mhz": 800,
        "ref_mhz": 100,
        "fcw": 8,
        "out_div": 1,
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
        narrow = dict(base_spec(), ref_mhz=1, fcw=800)
        narrow["structural"] = {
            **base_spec()["structural"], "FCW_BITS": 4, "CNT_EXTRA_BITS": 0}
        resolved = resolve_spec(narrow, inv)
        assert resolved["counter_range"]["ok"] is False, resolved["counter_range"]
        assert resolved["status"] == "NEEDS_COUNTER_RANGE", resolved

        # MODEL_ONLY can be packaged as an explicitly experimental template.
        exp = base_spec(pdk="gf180mcu_as_sc_mcu7t3v3", target_mhz=100,
                        ref_mhz=50, fcw=2, mode="explore",
                        allow_experimental=True)
        resolved = resolve_spec(exp)
        assert resolved["status"] == "READY_EXPERIMENTAL", resolved
        assert resolved["architecture_state"] == "MODEL_ONLY", resolved

    print("test_delivery: PASS")


if __name__ == "__main__":
    main()
