#!/usr/bin/env python3
"""L1 DCO behavioral tuning scan.

This uses the `sim_dco` behavioral model (the delay values came from the
existing ics55 delay characterization).  It is NOT a PEX/transistor-level
characterization and must not be used as a jitter or PVT signoff result.

Outputs:
  dco_tuning.csv
  dco_tuning.json
"""
from __future__ import annotations

import argparse
import json
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SIM_DCO = ROOT / "src" / "sim_dco.v"


def make_tb(coarse_codes, mid_codes, fine_codes) -> str:
    return f"""`timescale 1fs/1fs
module dco_scan_tb;
    localparam integer CN = 15;
    localparam integer MN = 15;
    localparam integer FN = 31;
    reg [CN-1:0] COARSE_MUX;
    reg [MN-1:0] MID_MUX;
    reg [FN-1:0] FINE_MUX;
    wire CLK_VCO;

    sim_dco #(.COARSE_NDELS(CN), .MID_NDELS(MN), .FINE_NDELS(FN)) dut (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_VCO(CLK_VCO)
    );

    integer ci, mi, fi;
    integer coarse_vals [0:{len(coarse_codes)-1}];
    integer mid_vals [0:{len(mid_codes)-1}];
    integer fine_vals [0:{len(fine_codes)-1}];
    time t0, t1;
    integer period_fs;
    real freq_mhz;

    initial begin
        {chr(10).join(f"        coarse_vals[{i}] = {v};" for i,v in enumerate(coarse_codes))}
        {chr(10).join(f"        mid_vals[{i}] = {v};" for i,v in enumerate(mid_codes))}
        {chr(10).join(f"        fine_vals[{i}] = {v};" for i,v in enumerate(fine_codes))}
        COARSE_MUX = 0; MID_MUX = 0; FINE_MUX = 0;
        repeat (8) @(posedge CLK_VCO);
        for (ci = 0; ci < {len(coarse_codes)}; ci = ci + 1) begin
            for (mi = 0; mi < {len(mid_codes)}; mi = mi + 1) begin
                for (fi = 0; fi < {len(fine_codes)}; fi = fi + 1) begin
                    COARSE_MUX = (1 << coarse_vals[ci]) - 1;
                    MID_MUX = (1 << mid_vals[mi]) - 1;
                    FINE_MUX = (1 << fine_vals[fi]) - 1;
                    repeat (8) @(posedge CLK_VCO);
                    t0 = $time;
                    @(posedge CLK_VCO);
                    t1 = $time;
                    period_fs = t1 - t0;
                    freq_mhz = 1000000000.0 / period_fs;
                    $display("DCO,%0d,%0d,%0d,%0d,%0.6f",
                             coarse_vals[ci], mid_vals[mi], fine_vals[fi],
                             period_fs, freq_mhz);
                end
            end
        end
        $finish;
    end
endmodule
"""


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--output", default=str(ROOT / "flow" / "characterization" / "ics55_sim"))
    ap.add_argument("--coarse", default="0,5,10,15")
    ap.add_argument("--mid", default="0,5,10,15")
    ap.add_argument("--fine", default=",".join(str(i) for i in range(32)))
    args = ap.parse_args()

    coarse_codes = [int(x) for x in args.coarse.split(",") if x != ""]
    mid_codes = [int(x) for x in args.mid.split(",") if x != ""]
    fine_codes = [int(x) for x in args.fine.split(",") if x != ""]
    outdir = Path(args.output)
    outdir.mkdir(parents=True, exist_ok=True)

    tb_text = make_tb(coarse_codes, mid_codes, fine_codes)
    with tempfile.TemporaryDirectory(prefix="dco_scan_") as td:
        tdp = Path(td)
        tbfile = tdp / "dco_scan_tb.v"
        tbfile.write_text(tb_text)
        exe = tdp / "dco_scan.out"
        subprocess.run(
            ["iverilog", "-g2012", "-o", str(exe), str(tbfile), str(SIM_DCO)],
            check=True,
        )
        proc = subprocess.run(["vvp", str(exe)], text=True, capture_output=True, check=True)

    rows = []
    for line in proc.stdout.splitlines():
        if not line.startswith("DCO,"):
            continue
        _, c, m, f, period_fs, freq_mhz = line.split(",")
        rows.append(
            {
                "coarse_code": int(c),
                "mid_code": int(m),
                "fine_code": int(f),
                "period_fs": int(period_fs),
                "period_ps": int(period_fs) / 1000.0,
                "freq_mhz": float(freq_mhz),
            }
        )

    csv_path = outdir / "dco_tuning.csv"
    with csv_path.open("w") as f:
        f.write("coarse_code,mid_code,fine_code,period_fs,period_ps,freq_mhz\n")
        for r in rows:
            f.write(
                f"{r['coarse_code']},{r['mid_code']},{r['fine_code']},"
                f"{r['period_fs']},{r['period_ps']:.6f},{r['freq_mhz']:.6f}\n"
            )

    meta = {
        "model": "L1 behavioral sim_dco",
        "source": "src/sim_dco.v",
        "coarse_codes": coarse_codes,
        "mid_codes": mid_codes,
        "fine_codes": fine_codes,
        "points": len(rows),
        "freq_min_mhz": min((r["freq_mhz"] for r in rows), default=None),
        "freq_max_mhz": max((r["freq_mhz"] for r in rows), default=None),
        "note": "Behavioral delay model derived from existing ics55 delay data; not PEX/PVT/jitter signoff.",
    }
    (outdir / "dco_tuning.json").write_text(json.dumps(meta, indent=2) + "\n")

    print(f"wrote {csv_path} ({len(rows)} points)")
    print(f"wrote {outdir / 'dco_tuning.json'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
