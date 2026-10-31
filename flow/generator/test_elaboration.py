#!/usr/bin/env python3
"""Generated-RTL elaboration gate.

Run after installing Icarus Verilog.  The three emit targets must compile as
separate source sets; in particular, top integration must use the blackbox and
must not silently re-synthesize the physical DCO RTL.
"""
from __future__ import annotations

import shutil
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from delivery import generate
from spec import resolve_spec
from test_delivery import base_spec, make_counter_inventory


def main() -> int:
    if shutil.which("iverilog") is None:
        print("test_elaboration: SKIP (iverilog unavailable)")
        return 0
    with tempfile.TemporaryDirectory() as td:
        root = Path(td)
        inv = make_counter_inventory(root / "counter")
        spec = base_spec(target_mhz=20, ref_mhz=10, fcw=2, area="high")
        spec["structural"].update({
            "ACC_BITS": 16, "BASE_INC": 328,
            "COARSE_STEP": 120, "MID_STEP": 60, "FINE_STEP": 15,
        })
        spec["allow_unverified_dco"] = True
        resolved = resolve_spec(spec, inv)
        for target in ("simulation", "macro-build", "top-integration"):
            out = root / target
            result = generate(resolved, out, target=target, elaborate=True)
            elaboration = result.get("elaboration") or {}
            if result["status"] != "READY_PHYSICAL_UNCHARACTERIZED":
                print(result)
                return 1
            if elaboration.get("status") != "PASS":
                log = out / elaboration.get("log", "")
                print(f"{target}: {elaboration}")
                if log.is_file():
                    print(log.read_text()[-4000:])
                return 1
            print(f"{target}: elaboration PASS")
    print("test_elaboration: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
