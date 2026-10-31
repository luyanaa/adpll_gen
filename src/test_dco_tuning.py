#!/usr/bin/env python3
import json
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from dco_tuning import analyze_map, TuningError


def make_map(process="TT", temp=25, voltage=1.2, reverse=False):
    codes = list(range(16))
    freqs = [1000 - 20 * c for c in codes]
    if reverse:
        freqs[1], freqs[2] = freqs[2], freqs[1]
    return {
        "pdk": "ics55", "process": process, "temperature_c": temp,
        "voltage_v": voltage,
        "coarse": [{"code": c, "frequency_mhz": freqs[c]} for c in codes],
        "mid": [{"code": c, "frequency_mhz": freqs[c]} for c in codes],
    }


def main():
    a = analyze_map(make_map())
    assert a["monotonic"] and a["valid_for_sar"]
    assert a["direction"] == "decreasing"
    assert a["kdco_mhz_per_code"]["coarse_min"] == -20
    try:
        analyze_map(make_map(reverse=True))
    except TuningError as exc:
        assert "nonmonotonic" in str(exc)
    else:
        raise AssertionError("nonmonotonic map accepted")
    with tempfile.TemporaryDirectory() as td:
        p = Path(td) / "maps.json"
        p.write_text(json.dumps({"maps": [make_map(), make_map("SS", -40, 1.08)]}))
        out = Path(td) / "out.json"
        r = subprocess.run([sys.executable, str(HERE / "dco_tuning.py"),
                            "--input", str(p), "--json-out", str(out)],
                           text=True, capture_output=True)
        assert r.returncode == 0, r.stderr
        d = json.loads(out.read_text())
        assert d["valid_for_sar"] and len(d["pvt"]["corners"]) == 2
    print("test_dco_tuning: PASS")


if __name__ == "__main__":
    main()
