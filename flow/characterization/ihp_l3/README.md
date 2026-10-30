# IHP SG13G2 L3 DCO baseline (sparse)

This is the first **working transistor-level** DCO baseline.  It uses the
IHP SG13G2 standard-cell SPICE view and the PSP103 Verilog-A model compiled
with OpenVAF into an OSDI library, run with ngspice 44.2.

## Flow

```sh
python3 flow/characterization/ihp_l3_scan.py \
  --coarse 0,8,15 --mid 0,8,15 --fine 0,8,31 \
  --period-ns 100 \
  --out flow/characterization/ihp_l3
```

The script:

1. compiles `psp103.va` with `/opt/openvaf` to `psp103.osdi` (ignored by git);
2. writes a `.spiceinit` that loads the OSDI model;
3. builds `test_dco_l3.sp` from `src/test_dco.sp`;
4. runs ngspice for each code point;
5. parses the binary rawfile and writes `dco_tuning_l3.csv` / `dco_l3.json`.

## Data

```text
points = 27
range  = 212.09 .. 624.26 MHz
grid   = coarse {0,8,15} x mid {0,8,15} x fine {0,8,31}
```

This is a **sparse** L3 scan.  Some fine-sweep points are non-monotonic
(for example coarse=8/mid=0: 281.5, 296.2, 284.2 MHz for fine=0/8/31), so
this is not yet a clean capability map.  It is useful as a transistor-level
baseline and for calibrating the L1 behavioral model; it is not PEX, PVT,
jitter or production signoff.

## Status

```text
L3 transistor netlist:   working in ngspice via PSP103 OSDI
L3 PEX:                  not done
L3 PVT:                  not done
L3 dense grid:           not done
```

The generated `*.osdi`, netlists, rawfiles and logs are intentionally ignored;
only the CSV, JSON and this README are tracked.

## PEX / PVT

See `../pex_ihp/README.md` for routed RCX extraction, DCO-net
capacitance back-annotation and TT/SS/FF frequency.  The dense fine-bank
extension is `../ihp_l3_dense/`.
