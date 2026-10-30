#!/usr/bin/env python3
"""Dense axis scan for the ics55 L3 transistor DCO.

The sparse baseline in ``ics55_l3_scan.py`` covers the code-space corners.  This
script runs the full fine bank at selected coarse/mid boundaries, with a
startup ``.ic`` and a per-point transient length, and writes results
incrementally so an interrupted run does not lose completed points.
"""
from __future__ import annotations

import argparse
import concurrent.futures as futures
import csv
import json
import os
import subprocess
import sys
import threading
from pathlib import Path

from ics55_l3_scan import (
    CELL_CDL, FLATTEN, MODEL_DIR, MODEL_LIB, ROOT, period_of, read_raw, write_code,
)


def stop_for_coarse(c: int) -> str:
    if c <= 3:
        return "3n"
    if c <= 9:
        return "4n"
    return "6n"


def parse_pairs(text: str, coarse: str, mid: str) -> list[tuple[int, int]]:
    if text:
        return [tuple(int(x) for x in p.split(":")) for p in text.split(",")]
    return [(int(c), int(m)) for c in coarse.split(",") for m in mid.split(",")]


def prepare(out: Path) -> str:
    out.mkdir(parents=True, exist_ok=True)
    for f in ("model_wrapper1_hsp.lib", "model_wrapper2_hsp.lib"):
        dst = out / f
        if not dst.exists():
            dst.symlink_to(MODEL_DIR / f)
    for d in ("mos", "bjt", "dio", "res", "var", "mom"):
        dst = out / d
        if not dst.exists():
            dst.symlink_to(MODEL_DIR / d, target_is_directory=True)

    dco = ROOT / "syn" / "outputs" / "ics55" / "PLL_ILDCO.sp"
    if not dco.exists():
        raise SystemExit(f"missing {dco}; run: make -C syn TOP=PLL_ILDCO gen")
    flat = out / "PLL_ILDCO_flat.sp"
    subprocess.run([sys.executable, str(FLATTEN),
                    "--cells", str(CELL_CDL), "--macro", str(dco),
                    "--top", "PLL_ILDCO", "--out", str(flat)],
                   check=True, stdout=subprocess.DEVNULL)
    lines = []
    for line in flat.read_text().splitlines():
        if line.startswith("M"):
            toks = line.split()
            toks[0] = "X" + toks[0][1:]
            toks = [("mr=" + t[2:]) if t.startswith("m=") else t for t in toks]
            line = " ".join(toks)
        lines.append(line)
    (out / "PLL_ILDCO_flat_x.sp").write_text("\n".join(lines) + "\n")

    (out / "models_flat.inc").write_text(
        f'.LIB "{MODEL_LIB}" tt_mos\n'
        ".PARAM lvdd=1.2\n"
        ".SUBCKT PLL_CELL_BUFFX0 VDD VSS I Z\n"
        "B1 Z 0 V=V(I)\n"
        ".ENDS\n"
    )
    base = (ROOT / "src" / "test_dco.sp").read_text()
    base = base.replace(".inc models.inc", ".inc models_flat.inc")
    base = base.replace(".inc PLL_ILDCO.sp", ".inc PLL_ILDCO_flat_x.sp")
    base = base.replace(".PARAM stopsim=(10000n)", ".PARAM stopsim=(10000n)")
    (out / "test_dco_l3_base.sp").write_text(base)
    return base


def load_existing(path: Path) -> dict[tuple[int, int, int], dict]:
    rows = {}
    if not path.exists():
        return rows
    for r in csv.DictReader(path.open()):
        key = (int(r["coarse_code"]), int(r["mid_code"]), int(r["fine_code"]))
        rows[key] = {
            "coarse": key[0], "mid": key[1], "fine": key[2],
            "period_ns": float(r["period_ns"]), "freq_mhz": float(r["freq_mhz"]),
        }
    return rows


def write_rows(path: Path, rows: dict[tuple[int, int, int], dict]) -> None:
    ordered = [rows[k] for k in sorted(rows)]
    path.write_text(
        "coarse_code,mid_code,fine_code,period_ns,freq_mhz\n"
        + "\n".join(
            f"{r['coarse']},{r['mid']},{r['fine']},{r['period_ns']:.6f},{r['freq_mhz']:.6f}"
            for r in ordered
        )
        + "\n"
    )


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(ROOT / "flow" / "characterization" / "ics55_l3_dense"))
    ap.add_argument("--pairs", default="", help="c:m pairs, e.g. 0:0,8:8")
    ap.add_argument("--coarse", default="0,8,15")
    ap.add_argument("--mid", default="0,8,15")
    ap.add_argument("--fine", default=",".join(str(i) for i in range(32)))
    ap.add_argument("--jobs", type=int, default=2)
    ap.add_argument("--timeout", type=int, default=180)
    ap.add_argument("--append", action="store_true")
    args = ap.parse_args()

    out = Path(args.out)
    base = prepare(out)
    fine = [int(x) for x in args.fine.split(",")]
    pairs = parse_pairs(args.pairs, args.coarse, args.mid)
    tasks = [(c, m, f) for c, m in pairs for f in fine]
    existing_path = out / "dco_tuning_l3.csv"
    rows = load_existing(existing_path) if args.append else {}
    tasks = [t for t in tasks if t not in rows]

    lock = threading.Lock()
    failures: list[tuple[int, int, int, str]] = []

    def run_point(task: tuple[int, int, int]) -> None:
        c, m, f = task
        stem = f"c{c}_m{m}_f{f}"
        code = out / f"test_dco_code_{stem}.sp"
        code.write_text(base)
        write_code(code, c, m, f)
        raw = out / f"test_dco_{stem}.raw"
        net = out / f"test_dco_{stem}.sp"
        net.write_text(
            "* L3 ics55 DCO transient\n"
            f".inc test_dco_code_{stem}.sp\n"
            ".ic V(OUT)=0.6 V(MID_OUT)=0.6\n"
            f".tran 1p {stop_for_coarse(c)}\n"
            ".SAVE V(OUT) V(MID_OUT)\n"
            ".control\nrun\n"
            f"write {raw.name}\n"
            "quit\n.endc\n"
        )
        env = dict(os.environ)
        env.setdefault("OMP_NUM_THREADS", "4")
        try:
            subprocess.run(
                ["ngspice", "-o", f"test_dco_{stem}.log", net.name],
                cwd=out, check=True, timeout=args.timeout, env=env,
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            )
            time, traces = read_raw(raw)
            p = period_of(time, traces["v(out)"])
            if p is None:
                raise RuntimeError("no output edges")
            row = {"coarse": c, "mid": m, "fine": f,
                   "period_ns": p / 1e-9, "freq_mhz": 1e-6 / p}
            with lock:
                rows[task] = row
                write_rows(out / "dco_tuning_l3_partial.csv", rows)
            print(f"c={c:2d} m={m:2d} f={f:2d} period={p*1e9:.3f}ns f={row['freq_mhz']:.3f}MHz", flush=True)
        except Exception as exc:  # keep the scan alive; report at the end
            with lock:
                failures.append((c, m, f, str(exc)))
            print(f"WARN c={c} m={m} f={f}: {exc}", flush=True)

    print(f"{len(tasks)} points, {args.jobs} workers, out={out}", flush=True)
    with futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        list(pool.map(run_point, tasks))

    write_rows(out / "dco_tuning_l3.csv", rows)
    (out / "dco_l3.json").write_text(json.dumps({
        "technology": "ics55",
        "library": "ics55_LLSC_H7CR",
        "model": "BSIM4.5 from ICsprout foundry CDL/model deck",
        "simulator": "ngspice-44.2",
        "characterization_level": "L3_transistor_dense_axes",
        "points": len(rows),
        "note": "Full fine bank at selected coarse/mid boundaries; no PEX/PVT/jitter signoff.",
        "results": [rows[k] for k in sorted(rows)],
    }, indent=2) + "\n")
    print(f"wrote {out/'dco_tuning_l3.csv'} ({len(rows)} points, {len(failures)} failures)", flush=True)
    for c, m, f, exc in failures:
        print(f"FAIL c={c} m={m} f={f}: {exc}", flush=True)
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
