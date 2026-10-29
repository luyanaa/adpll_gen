#!/usr/bin/env python3
"""L3 IHP SG13G2 DCO scan using ngspice + OpenVAF-compiled PSP103 OSDI.

This is the first transistor-level baseline.  It uses the IHP standard-cell
SPICE view and the compiled PSP103 Verilog-A model; it is not a PEX or PVT
claim.
"""
from __future__ import annotations

import argparse
import json
import re
import struct
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_PDK = Path("/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2")


def read_raw(path: Path) -> tuple[list[float], dict[str, list[float]]]:
    b = path.read_bytes()
    marker = b"Binary:\n"
    i = b.index(marker) + len(marker)
    text = b[:i].decode("latin1")
    nvars = int(re.search(r"No\. Variables:\s*(\d+)", text).group(1))
    npoints = int(re.search(r"No\. Points:\s*(\d+)", text).group(1))
    names = re.findall(r"^\s*\d+\s+(\S+)\s+", text, re.M)
    vals = struct.unpack("<%dd" % (nvars * npoints), b[i : i + nvars * npoints * 8])
    time = []
    traces = {n: [] for n in names}
    for k in range(npoints):
        time.append(vals[k * nvars])
        for j, n in enumerate(names):
            traces[n].append(vals[k * nvars + j])
    return time, traces


def measure_period(time: list[float], wave: list[float], thresh: float = 0.6) -> float | None:
    edges = []
    for k in range(1, len(time)):
        if wave[k - 1] < thresh <= wave[k]:
            edges.append(time[k])
    if len(edges) < 3:
        return None
    # Ignore the first edge and any startup transient; use the last 60% of edges.
    edges = edges[max(1, int(len(edges) * 0.25)) :]
    periods = [edges[i + 1] - edges[i] for i in range(len(edges) - 1)]
    return sum(periods) / len(periods) if periods else None


def write_code(path: Path, code: int, rail: str) -> None:
    s = path.read_text()
    for name in ("fine", "mid", "coarse"):
        def repl(m):
            idx = int(m.group(1))
            val = rail if idx < code else "0.0"
            return f"V{name}<{idx}> {name}<{idx}> GND DC={val}"
        s = re.sub(rf"^V{name}<(\d+)> {name}<\d+> GND DC=\S+", repl, s, flags=re.M)
    path.write_text(s)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdk", default=str(DEFAULT_PDK))
    ap.add_argument("--out", default=str(ROOT / "flow" / "characterization" / "ihp_l3"))
    ap.add_argument("--coarse", default="0,8,15")
    ap.add_argument("--mid", default="0,8,15")
    ap.add_argument("--fine", default="0,8,31")
    ap.add_argument("--period-ns", type=float, default=100.0)
    args = ap.parse_args()
    pdk = Path(args.pdk)
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    # Compile PSP103 once into the output directory.
    va = pdk / "libs.tech" / "verilog-a" / "psp103" / "psp103.va"
    osdi = out / "psp103.osdi"
    if not osdi.exists():
        subprocess.run(["/opt/openvaf", str(va), "-o", str(osdi)], check=True,
                       stdout=subprocess.DEVNULL)

    # ngspice startup file with the OSDI model.
    (out / ".spiceinit").write_text(
        f"set num_threads=8\nosdi '{osdi.resolve()}'\n"
    )

    # Model include: use the ngspice PSP104 wrapper and standard-cell SPICE.
    (out / "models_l3.inc").write_text(
        f'.LIB "{pdk}/libs.tech/ngspice/models/cornerMOSlv.lib" mos_tt\n'
        f'.INCLUDE "{pdk}/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice"\n'
        ".PARAM lvdd=1.2\n"
        ".SUBCKT PLL_CELL_BUFFX0 VDD VSS I Z\n"
        "B1 Z 0 V=V(I)\n"
        ".ENDS\n"
    )

    # The generated transistor netlist is in the synthesis output.
    import shutil
    shutil.copy(ROOT / "syn" / "outputs" / "ihp-sg13g2" / "PLL_ILDCO.sp",
                out / "PLL_ILDCO.sp")
    base = (ROOT / "src" / "test_dco.sp").read_text()
    base = base.replace(".inc models.inc", ".inc models_l3.inc")
    base = base.replace(".PARAM stopsim=(10000n)", f".PARAM stopsim=({args.period_ns}n)")
    (out / "test_dco_l3.sp").write_text(base)
    (out / "test_dco_l3_tran.sp").write_text(
        "* L3 DCO transient\n"
        ".inc test_dco_l3.sp\n"
        f".tran 10n {args.period_ns}n uic\n"
        ".SAVE V(OUT) V(MID_OUT)\n"
        ".control\nrun\nwrite test_dco_l3.raw\nquit\n.endc\n"
    )

    rows = []
    for c in [int(x) for x in args.coarse.split(",")]:
        for m in [int(x) for x in args.mid.split(",")]:
            for f in [int(x) for x in args.fine.split(",")]:
                write_code(out / "test_dco_l3.sp", c, "lvdd")
                # write_code applies one code to all three banks; do the banks
                # separately by replacing the other two below.
                s = (out / "test_dco_l3.sp").read_text()
                for name, code in (("mid", m), ("coarse", c), ("fine", f)):
                    def repl(mm):
                        idx = int(mm.group(1))
                        val = "lvdd" if idx < code else "0.0"
                        return f"V{name}<{idx}> {name}<{idx}> GND DC={val}"
                    s = re.sub(rf"^V{name}<(\d+)> {name}<\d+> GND DC=\S+", repl, s, flags=re.M)
                (out / "test_dco_l3.sp").write_text(s)
                subprocess.run(["ngspice", "-o", "test_dco_l3.log", "test_dco_l3_tran.sp"],
                               cwd=out, check=True, timeout=600,
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                time, traces = read_raw(out / "test_dco_l3.raw")
                period = measure_period(time, traces["v(out)"])
                if period is None:
                    print(f"WARN c={c} m={m} f={f}: no enough edges")
                    continue
                freq = 1e-6 / period
                rows.append({"coarse": c, "mid": m, "fine": f,
                             "period_ns": period / 1e-9, "freq_mhz": freq})
                print(f"c={c:2d} m={m:2d} f={f:2d} period={period*1e9:.3f}ns f={freq:.3f}MHz")

    (out / "dco_tuning_l3.csv").write_text(
        "coarse_code,mid_code,fine_code,period_ns,freq_mhz\n"
        + "\n".join(f"{r['coarse']},{r['mid']},{r['fine']},{r['period_ns']:.6f},{r['freq_mhz']:.6f}" for r in rows)
        + "\n"
    )
    (out / "dco_l3.json").write_text(json.dumps({
        "technology": "ihp-sg13g2",
        "model": "PSP103 OSDI via OpenVAF 23.5.0",
        "simulator": "ngspice-44.2",
        "characterization_level": "L3_transistor_no_pex",
        "points": len(rows),
        "note": "Transistor-level standard-cell/PSP103 DCO; not PEX/PVT/jitter signoff.",
        "results": rows,
    }, indent=2) + "\n")
    print(f"wrote {out/'dco_tuning_l3.csv'} ({len(rows)} points)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
