#!/usr/bin/env python3
"""Dense fine-bank scan for the IHP SG13G2 L3 DCO.

The sparse baseline in ``ihp_l3_scan.py`` uses 100 ns transients.  This script
uses a 30 ns window for the fast fine-bank sweep (the oscillator has already
started by then) and runs points in parallel, writing results incrementally.
"""
from __future__ import annotations

import argparse
import concurrent.futures as futures
import csv
import json
import os
import re
import shutil
import struct
import subprocess
import threading
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
IHP_ROOT = Path(
    "/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
    "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2"
)


def read_raw(path: Path):
    b = path.read_bytes()
    marker = b"Binary:\n"
    i = b.index(marker) + len(marker)
    text = b[:i].decode("latin1")
    nv = int(re.search(r"No\. Variables:\s*(\d+)", text).group(1))
    np = int(re.search(r"No\. Points:\s*(\d+)", text).group(1))
    names = re.findall(r"^\s*\d+\s+(\S+)\s+", text, re.M)
    vals = struct.unpack("<%dd" % (nv * np), b[i:i + nv * np * 8])
    return ([vals[k * nv] for k in range(np)],
            {n: [vals[k * nv + j] for k in range(np)] for j, n in enumerate(names)})


def period_of(time, wave, threshold=0.6):
    edges = [time[k] for k in range(1, len(time)) if wave[k - 1] < threshold <= wave[k]]
    if len(edges) < 3:
        return None
    edges = edges[max(1, int(len(edges) * 0.25)):]
    periods = [b - a for a, b in zip(edges, edges[1:])]
    return sum(periods) / len(periods) if periods else None


def write_code(path: Path, c: int, m: int, f: int):
    s = path.read_text()
    for name, code in (("fine", f), ("mid", m), ("coarse", c)):
        s = re.sub(
            rf"^V{name}<(\d+)> {name}<\d+> GND DC=\S+",
            lambda mm: f"V{name}<{mm.group(1)}> {name}<{mm.group(1)}> GND DC="
                       + ("lvdd" if int(mm.group(1)) < code else "0.0"),
            s, flags=re.M,
        )
    path.write_text(s)


def prepare(out: Path) -> str:
    out.mkdir(parents=True, exist_ok=True)
    src = ROOT / "flow" / "characterization" / "ihp_l3"
    osdi = src / "psp103.osdi"
    if not osdi.exists():
        raise SystemExit(f"missing {osdi}; run ihp_l3_scan.py first")
    (out / ".spiceinit").write_text(f"set num_threads=4\nosdi '{osdi.resolve()}'\n")
    shutil.copy(src / "PLL_ILDCO.sp", out / "PLL_ILDCO.sp")
    (out / "models_l3.inc").write_text(
        f'.LIB "{IHP_ROOT}/libs.tech/ngspice/models/cornerMOSlv.lib" mos_tt\n'
        f'.INCLUDE "{IHP_ROOT}/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice"\n'
        ".PARAM lvdd=1.2\n"
        ".SUBCKT PLL_CELL_BUFFX0 VDD VSS I Z\n"
        "B1 Z 0 V=V(I)\n"
        ".ENDS\n"
    )
    base = (ROOT / "src" / "test_dco.sp").read_text()
    base = base.replace(".inc models.inc", ".inc models_l3.inc")
    base = base.replace(".inc PLL_ILDCO.sp", ".inc PLL_ILDCO.sp")
    return base


def load_existing(path: Path):
    rows = {}
    if not path.exists():
        return rows
    for r in csv.DictReader(path.open()):
        key = (int(r["coarse_code"]), int(r["mid_code"]), int(r["fine_code"]))
        rows[key] = r
    return rows


def write_rows(path: Path, rows):
    path.write_text(
        "coarse_code,mid_code,fine_code,period_ns,freq_mhz\n"
        + "\n".join(
            f"{k[0]},{k[1]},{k[2]},{r['period_ns']},{r['freq_mhz']}"
            for k, r in sorted(rows.items())
        )
        + "\n"
    )


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(ROOT / "flow" / "characterization" / "ihp_l3_dense"))
    ap.add_argument("--coarse", type=int, default=8)
    ap.add_argument("--mid", type=int, default=0)
    ap.add_argument("--fine", default=",".join(str(i) for i in range(32)))
    ap.add_argument("--jobs", type=int, default=2)
    ap.add_argument("--timeout", type=int, default=300)
    ap.add_argument("--append", action="store_true")
    args = ap.parse_args()
    out = Path(args.out)
    base = prepare(out)
    fine = [int(x) for x in args.fine.split(",")]
    rows = load_existing(out / "dco_tuning_l3.csv") if args.append else {}
    tasks = [(args.coarse, args.mid, f) for f in fine if (args.coarse, args.mid, f) not in rows]
    lock = threading.Lock()
    failures = []

    def run(task):
        c, m, f = task
        stem = f"c{c}_m{m}_f{f}"
        code = out / f"test_dco_code_{stem}.sp"
        code.write_text(base)
        write_code(code, c, m, f)
        net = out / f"test_dco_{stem}.sp"
        net.write_text(
            "* IHP dense DCO transient\n"
            f".inc test_dco_code_{stem}.sp\n"
            ".tran 10n 30n uic\n"
            ".SAVE V(OUT) V(MID_OUT)\n"
            ".control\nrun\n"
            f"write test_dco_{stem}.raw\n"
            "quit\n.endc\n"
        )
        env = dict(os.environ)
        env.setdefault("OMP_NUM_THREADS", "4")
        try:
            subprocess.run(["ngspice", "-o", f"test_dco_{stem}.log", net.name],
                           cwd=out, check=True, timeout=args.timeout, env=env,
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            time, tr = read_raw(out / f"test_dco_{stem}.raw")
            p = period_of(time, tr["v(out)"])
            if p is None:
                raise RuntimeError("no output edges")
            row = {"period_ns": f"{p*1e9:.6f}", "freq_mhz": f"{1e-6/p:.6f}"}
            with lock:
                rows[task] = row
                write_rows(out / "dco_tuning_l3_partial.csv", rows)
            print(f"c={c} m={m} f={f} f={1e-6/p:.3f}MHz", flush=True)
        except Exception as exc:
            with lock:
                failures.append((task, str(exc)))
            print(f"WARN c={c} m={m} f={f}: {exc}", flush=True)

    print(f"{len(tasks)} points, {args.jobs} workers", flush=True)
    with futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        list(pool.map(run, tasks))
    write_rows(out / "dco_tuning_l3.csv", rows)
    (out / "dco_l3.json").write_text(json.dumps({
        "technology": "ihp-sg13g2",
        "characterization_level": "L3_transistor_dense_axes",
        "points": len(rows),
        "results": [dict(coarse_code=k[0], mid_code=k[1], fine_code=k[2], **v)
                    for k, v in sorted(rows.items())],
        "note": "30 ns fine-bank sweep; no PEX/PVT/jitter signoff.",
    }, indent=2) + "\n")
    print(f"wrote {len(rows)} points, {len(failures)} failures", flush=True)
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
