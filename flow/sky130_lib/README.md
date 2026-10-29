# sky130 per-cell `.lib.json` → Liberty converter

`convert_libjson.py` rebuilds a single Liberty `.lib` file from the SkyWater
per-cell JSON timing dumps shipped under `/grid/sky130/sky130_fd_sc_*`.

This directory is self-contained; no existing repository files are modified.

## Verdict (short)

| Question | Answer |
|---|---|
| Can the reconstructed `.lib` be parsed by OpenSTA? | **Yes** — all 12 generated files read with zero warnings/errors. |
| Is it usable for STA (NLDM timing, setup/hold, clock-to-Q)? | **Yes** for the generated corners. OpenSTA 2.0.17 links a small netlist and reports real slacks (see below). |
| Does Yosys read it? | **Yes with `read_liberty -lib`** (cell-library/blackbox mode), all cells imported. Plain `read_liberty` fails on 6 ICG cells because the source omits the GCLK function — the same failure occurs on the reference Sky130 HD `.lib`. See [Yosys caveat](#yosys-caveat). |
| Is leakage/power data complete? | **No.** `ms` NLDM corners have no leakage data at all; `lp` is essentially missing it; `ls`/`hdll` are corner-dependent. `ms` `*_pwrlkg` corners do carry leakage. |
| Can it be used as the sole PnR library in LibreLane/ORFS? | **No** — fill/tap/decap/diode (and busdriver/bushold for `lp`) have no timing JSON. STA of an existing netlist works; PnR needs those physical cells from elsewhere. |

## Files produced

`out/` contains one Liberty file per corner (plus a Yosys-compatibility
variant of `ms ss_n40C_1v28`):

| Liberty file | cells | timing groups | internal_power groups | leakage_power groups | tables | table values | size |
|---|---:|---:|---:|---:|---:|---:|---:|
| `sky130_fd_sc_hdll_ss_n40C_1v28.lib` | 324 | 2568 | 3110 | 200 | 14575 | 592,265 | 12.0 MiB |
| `sky130_fd_sc_hdll_tt_025C_1v80.lib` | 324 | 2568 | 3110 | 3918 | 14575 | 592,265 | 12.3 MiB |
| `sky130_fd_sc_lp_ff_n40C_1v95.lib` | 701 | 5644 | 4488 | 10 | 30386 | 6,325,417 | 71.6 MiB |
| `sky130_fd_sc_lp_ss_n40C_1v65.lib` | 701 | 5644 | 4488 | 10 | 30386 | 4,583,757 | 55.3 MiB |
| `sky130_fd_sc_ls_ss_n40C_1v28.lib` | 386 | 3348 | 4116 | 5433 | 20640 | 3,574,823 | 50.2 MiB |
| `sky130_fd_sc_ls_tt_100C_1v80.lib` | 386 | 3348 | 2489 | 892 | 17386 | 1,402,722 | 21.1 MiB |
| `sky130_fd_sc_ms_ff_100C_1v95.lib` | 376 | 3348 | 2489 | 0 | 17396 | 1,512,052 | 21.9 MiB |
| `sky130_fd_sc_ms_ff_n40C_1v95_pwrlkg.lib` | 376 | 3348 | 4115 | 5432 | 20648 | 4,893,209 | 58.3 MiB |
| `sky130_fd_sc_ms_ss_n40C_1v28.lib` | 376 | 3348 | 2489 | 0 | 17396 | 3,078,188 | 35.9 MiB |
| `sky130_fd_sc_ms_ss_n40C_1v28_yosys.lib` | 376 | 3348 | 2489 | 0 | 17396 | 3,078,188 | 35.9 MiB |
| `sky130_fd_sc_ms_tt_025C_1v80_ccsnoise.lib` | 376 | 3348 | 2489 | 0 | 22223 | 8,297,311 | 118.6 MiB |
| `sky130_fd_sc_ms_tt_100C_1v80.lib` | 376 | 3348 | 2489 | 0 | 17396 | 1,485,714 | 21.6 MiB |

Each `.lib` has a matching `*.stats.json` with the full conversion report
(cell count, group counts, template references, dimension checks, missing cell
directories, ...).

`validation/` holds the exact command logs quoted below.

The `_yosys` file is not a different corner: it is `ms ss_n40C_1v28` with
functions derived for the 6 integrated clock-gate cells so that plain
`yosys read_liberty` succeeds. The primary `ms ss_n40C_1v28.lib` is the
faithful reconstruction.

## Source JSON schema

```
/grid/sky130/<lib>/
├── timing/<lib>__common.lib.json          library defaults (units, nom_process,
│                                          thresholds, base templates)
├── timing/<lib>__<corner>.lib.json        corner header (defines, templates,
│                                          operating conditions, nom_*)
└── cells/<base>/<lib>__<cell>__<corner>.lib.json
                                           one cell body (no `cell (...)` wrapper)
```

The JSON is an AST-like Liberty dump.  Every object maps keys to values:

* **`group,instance`** — a Liberty group.  `pin,A`, `pg_pin,VPWR`,
  `timing` entries inside lists, `lu_table_template,delay_template13x7`,
  `operating_conditions,ss_n40C_1v28`, `ff,IQ,IQ_N`.
  The instance can itself contain commas for multi-name groups
  (`ff (IQ, IQ_N)`, `statetable ("CLK GATE","M0")`).
* **Key without a comma, dict value** — a single unnamed group
  (`internal_power ()`, `timing ()`, `test_cell ()`, and CCS groups such as
  `ccsn_first_stage ()`, `output_voltage_rise ()`).
* **Key without a comma, list value** —
  * list of dicts → repeated groups (`timing` is usually a list of timing
    groups; `internal_power` can be a list of power groups);
  * list of scalars → Liberty list attribute (`index_1`, `index_2`,
    `table` rows for a `statetable`).
* **`values`** — a flat list (1-D table such as `hidden_pwr_template13`) or a
  list of rows (2-D table).  Rows are emitted as separate quoted strings.
* **`define`** — a list of `{attribute_name, attribute_type, group_name}`
  objects; emitted as Liberty `define(name, group, type);`.
* **`comp_attribute,capacitive_load_unit|library_features|technology|voltage_map`**
  — compiler metadata that maps to real Liberty attributes; unknown
  `comp_attribute` entries are preserved as comments.
* Scalar values can be numbers, strings, or the strings `"true"`/`"false"`
  (emitted as bare Liberty booleans).

The JSON has **no library group and no cell group around the cell body**:

* library name is derived as `<lib>__<corner>` (override with `--name`);
* cell name is recovered from the file name
  `<lib>__<cell>__<corner>.lib.json` and emitted with the library prefix,
  e.g. `cell (sky130_fd_sc_ms__inv_1)`;
* `cell_footprint` confirms the prefix convention.

## Converter behaviour

* Merges `common.lib.json` + corner header (corner wins; conflicts reported in
  the stats file).  `nom_process`, units, thresholds and `time_unit` come from
  `common`; templates and operating conditions from both.
* Emits, in order: library attributes → `comp_attribute` mappings →
  `define(...)` → table templates → `normalized_driver_waveform` →
  `operating_conditions` → `type`/bus declarations → `default_operating_conditions`
  → cells.
  `default_operating_conditions` is emitted *after* the operating-condition
  group because OpenSTA resolves it eagerly and warns otherwise.
* Emits all cell content generically: `pin`, `bus`, `pg_pin`, `timing`,
  `internal_power`, `leakage_power`, `ff`, `latch`, `statetable`, `test_cell`,
  `type`, CCS `ccsn_*`/`vector` groups, scalar/repeated attributes.
* Numbers are written with Python's shortest round-tripping `repr()`, so the
  source values are preserved exactly (Liberty units are taken as-is: ns, pF,
  V, mA, nW, kΩ; no unit conversion or scaling).
* `index_N` becomes `index_N ("v1, v2, ...");`; `values` becomes the standard
  backslash-continued multi-line form; `statetable` rows are joined into one
  quoted `table : "row1,row2,...";` string, matching the reference Sky130
  `.lib` files.
* Every table template reference is checked against
  `lu_table_template`/`power_lut_template` definitions (`scalar` is a Liberty
  built-in).  Every 1-D/2-D table is checked against its index lengths.
  All 12 generated files report **0 missing templates and 0 dimension
  mismatches**.
* Cell directories without a JSON file for the corner are listed in the output
  header comment, the stats file and stderr (see [gaps](#completeness-and-gaps)).

### CLI

```bash
python3 convert_libjson.py \
  --lib sky130_fd_sc_ms --corner ss_n40C_1v28 \
  --out out/sky130_fd_sc_ms_ss_n40C_1v28.lib
```

Useful options:

```
--root DIR                 sky130 root (default /grid/sky130)
--name NAME                Liberty library name (default <lib>__<corner>)
--list-corners             list available corners for --lib and exit
--only-cell CELL           convert one cell (repeatable; full or short name)
--limit N                  convert at most N cells (debugging)
--no-power                 omit internal_power groups
--no-defines               omit define(...) statements
--derive-icg-functions     Yosys-plain compatibility variant (see below)
--stats-json PATH          write the conversion report as JSON
--strict                   fail on missing templates instead of warning
--quiet
```

Exit codes: `0` success, `2` missing/invalid input, `3` strict-mode validation
failure.

## Validation

Tools used: Yosys 0.52 and OpenSTA 2.0.17 (`/usr/bin/yosys`, `/usr/bin/sta`).

### Yosys — cell-library read (`-lib`)

```
$ yosys -p "read_liberty -lib out/sky130_fd_sc_ms_ss_n40C_1v28.lib; stat"
1. Executing Liberty frontend: out/sky130_fd_sc_ms_ss_n40C_1v28.lib
Imported 376 cell types from liberty file.

2. Printing statistics.

End of script. ...
```

All generated files behave the same:

```
sky130_fd_sc_ms_ss_n40C_1v28.lib              Imported 376 cell types
sky130_fd_sc_ms_tt_100C_1v80.lib              Imported 376 cell types
sky130_fd_sc_ms_ff_100C_1v95.lib              Imported 376 cell types
sky130_fd_sc_ms_tt_025C_1v80_ccsnoise.lib     Imported 376 cell types
sky130_fd_sc_ms_ff_n40C_1v95_pwrlkg.lib       Imported 376 cell types
sky130_fd_sc_lp_ss_n40C_1v65.lib              Imported 701 cell types
sky130_fd_sc_lp_ff_n40C_1v95.lib              Imported 701 cell types
sky130_fd_sc_ls_tt_100C_1v80.lib              Imported 386 cell types
sky130_fd_sc_ls_ss_n40C_1v28.lib              Imported 386 cell types
sky130_fd_sc_hdll_tt_025C_1v80.lib            Imported 324 cell types
sky130_fd_sc_hdll_ss_n40C_1v28.lib            Imported 324 cell types
```

### OpenSTA — parse and link

```
$ sta -no_init -exit validation/read_ms_ss.tcl     # read_liberty ...; puts "READ OK"
OpenSTA 2.0.17 ...
READ OK
```

No `Error:` or `Warning:` lines are printed for any of the 12 files
(`validation/02_...`, `validation/09_all_outputs_summary.txt`).

### OpenSTA — real timing paths

Inverter/buffer/flop netlist (`validation/03_opensta_paths_ms_ss.txt`):

```
Startpoint                           Endpoint                               Slack
--------------------------------------------------------------------------------

d (input)                            u_ff/D (sky130_fd_sc_ms__dfxtp_1)       2.99

Startpoint                           Endpoint                               Slack
--------------------------------------------------------------------------------

d (input)                            u_ff/D (sky130_fd_sc_ms__dfxtp_1)       0.95
```

Two-flop netlist, exercising clock-to-Q → combinational → setup
(`validation/04_opensta_paths_seq.txt`):

```
u1/Q (sky130_fd_sc_ms__dfxtp_2)      u3/D (sky130_fd_sc_ms__dfxtp_2)         1.24   (max)
u1/Q (sky130_fd_sc_ms__dfxtp_2)      u3/D (sky130_fd_sc_ms__dfxtp_2)         1.07   (min)
```

This proves delay tables, transition tables, clock-to-Q arcs, setup and hold
arcs are usable by a real STA engine.

### OpenSTA — power

`ms ss_n40C_1v28` (no leakage data in the source JSON):

```
Sequential     1.04e-05   8.40e-08   0.00e+00   1.05e-05
Combinational  6.51e-07   6.44e-08   0.00e+00   7.15e-07
Total          1.11e-05   1.48e-07   0.00e+00   1.12e-05
```

`ms ff_n40C_1v95_pwrlkg` (leakage present):

```
Sequential     8.40e-05   1.90e-07   1.72e-10   8.42e-05
Combinational  2.27e-07   1.27e-07   9.53e-12   3.54e-07
Total          8.43e-05   3.17e-07   1.82e-10   8.46e-05
```

### Yosys caveat

Plain `read_liberty` (no `-lib`) errors on the integrated clock-gate cells:

```
$ yosys -p "read_liberty out/sky130_fd_sc_ms_ss_n40C_1v28.lib; stat"
ERROR: Missing function on output GCLK of cell sky130_fd_sc_ms__dlclkp_1.
```

This is a property of the source data, not of the converter: the JSON (and the
reference vendor-style `/opt/OpenROAD-flow-scripts/.../sky130_fd_sc_hd__tt_025C_1v80.lib`)
omit `function` on `clock_gate_out_pin` outputs, and Yosys also treats
`direction : internal` nodes (M0) as outputs requiring a function:

```
$ yosys -p "read_liberty /opt/.../sky130_fd_sc_hd__tt_025C_1v80.lib"
ERROR: Missing function on output GCLK of cell sky130_fd_sc_hd__dlclkp_1.

$ yosys -p "read_liberty -lib /opt/.../sky130_fd_sc_hd__tt_025C_1v80.lib"
Imported 428 cell types from liberty file.
```

`read_liberty -lib` is the normal mode for reading a standard-cell library
(it creates blackbox cells and does not synthesize from the lib).  If plain
`read_liberty` is required, use:

```bash
python3 convert_libjson.py --lib sky130_fd_sc_ms --corner ss_n40C_1v28 \
  --derive-icg-functions \
  --out out/sky130_fd_sc_ms_ss_n40C_1v28_yosys.lib
yosys -p "read_liberty out/sky130_fd_sc_ms_ss_n40C_1v28_yosys.lib; stat"
```

In that variant only the 6 ICG cells (`dlclkp_*`, `sdlclkp_*`) are changed:
`GCLK.function` is copied from the JSON `state_function` and `M0.function` is
derived from the `statetable` truth table (e.g. `GATE`, or `SCE | GATE`).
Timing/area/power data are untouched.  The default output remains faithful and
does not invent these functions.

## Enabling in LibreLane / OpenROAD

1. **STA**: use the `.lib` files directly as corner libraries.  OpenSTA parses
   them and computes delays/constraints (verified above).  Each file is a
   single corner; load all corners you need as separate Liberty libraries.
2. **Synthesis**: Yosys must read them with `read_liberty -lib` (the normal
   standard-cell mode, also used by ORFS/LibreLane).  Plain `read_liberty`
   needs `-ignore_miss_func` or the `--derive-icg-functions` variant.
3. **PnR**: these are **not** complete PnR libraries.  Fill, tap, decap and
   diode cells have no timing JSON and are therefore absent.  Supply them from
   another source (or generate them) before running placement/legalization.
   `lp` also lacks its bus drivers/holders.
4. **Power**: do not enable leakage-based power optimization from the `ms`
   NLDM corners — leakage is zero.  Use `ms ff_n40C_1v95_pwrlkg` when leakage
   matters, and check the per-corner leakage coverage for `lp`/`ls`/`hdll`.
5. **25 °C tt for `ms`**: there is no plain `tt_025C_1v80` dump.  The
   `tt_025C_1v80_ccsnoise` file contains the same NLDM tables (plus CCS
   groups) and can be used as a 25 °C tt NLDM corner; `tt_100C_1v80` is the
   plain NLDM tt corner.

## Completeness and gaps

### Corner coverage

* `ms`: 17 corners. There is **no plain `tt_025C_1v80`**; the 25 °C tt data
  exists only as `tt_025C_1v80_ccsnoise`. The NLDM tt corner is
  `tt_100C_1v80`.
* `lp`: 14 corners, **no tt corner at all**.
* `ls`: 19 corners (`tt_100C_1v80`, `tt_025C_1v80_ccsnoise`, ...).
* `hdll`: 11 corners (includes plain `tt_025C_1v80`).

Use `--list-corners` for the exact list.

### Cells absent from the JSON (no timing data)

These directories exist but contain no `<lib>__*__<corner>.lib.json`, so they
cannot be reconstructed:

* `ms`: `diode, fill, fill_diode, latchupcell, tap, tapmet1, tapvgnd,
  tapvgnd2, tapvpwrvgnd`
* `lp`: `busdriver, busdriver2, busdrivernovlp, busdrivernovlp2,
  busdrivernovlpsleep, bushold, bushold0, busreceiver, decap, decapkapwr,
  diode, fill, sleep_pargate_plv, sleep_sergate_plv, tap, tapvgnd, tapvgnd2,
  tapvpwrvgnd`
* `ls`: `decaphetap, fill, latchupcell, tap, tapmet1, tapvgnd, tapvgnd2,
  tapvgndnovpb, tapvpwrvgnd`
* `hdll`: `fill, muxb, tap, tapvgnd, tapvgnd2, tapvpwrvgnd`
  (`muxb` has only GDS/LEF/SPICE; the 9 bus-mux cells `muxb16to1_*` do have JSON.)

Consequences:

* **STA of an existing netlist**: fine; these cells are physical-only or
  optional.
* **PnR (LibreLane/ORFS)**: not usable as the only library — fill/tap/decap/
  diode cells are required for legalization and well-tap insertion.  The
  `lp` bus drivers/holders would also be missing.

### Timing completeness

Audited on the generated corners:

* every timing group has both `cell_rise` and `cell_fall` tables (0 one-sided);
* every delay arc has both `rise_transition` and `fall_transition`;
* every setup/hold/recovery/removal arc has both `rise_constraint` and
  `fall_constraint`;
* every timing group has `related_pin` or `related_bus_pins`;
* all template references resolve (`scalar` is built-in);
* 0 table dimension mismatches (1-D values length == `index_1`; 2-D rows ==
  `index_1`, columns == `index_2`).

Large tables (up to 36×71 for `lp`) are handled; the converter does not
truncate or interpolate.

### Power/leakage

`cell_leakage_power` is in nW and `internal_power`/`leakage_power` tables are
in the library's power units.

| Library / corner | `leakage_power` groups | `cell_leakage_power` zero | Verdict |
|---|---:|---:|---|
| `ms` NLDM (`ss_n40C_1v28`, `tt_100C_1v80`, `ff_100C_1v95`, `tt_*_ccsnoise`) | 0 | 376/376 | **leakage unusable (all zero)** |
| `ms` `ff_n40C_1v95_pwrlkg` | 5432 | 283/376 | leakage usable |
| `lp` (`ss_n40C_1v65`, `ff_n40C_1v95`) | 10 | 691/701 | **essentially missing** |
| `ls` `ss_n40C_1v28` | 5433 | 285/386 | mostly present |
| `ls` `tt_100C_1v80` | 892 | 318/386 | partial |
| `hdll` `tt_025C_1v80` | 3918 | 297/324 | mostly present |
| `hdll` `ss_n40C_1v28` | 200 | 317/324 | partial |

`internal_power` switching power is present for all cells in all generated
corners (2 tables per pin group typically), but without `related_pg_pin` in the
JSON it is referenced to the default power rail.

### Other limitations

* **No wire-load models** (`wire_load`, `wire_load_selection`) in the JSON;
  OpenSTA uses no wire-load model unless SPEF/RC is supplied by the flow.
* **No CCS current waveforms** in the NLDM corners.  The `*_ccsnoise` corners
  do contain `ccsn_first_stage`, `dc_current`, `output_voltage_*` and
  `vector` groups; the converter emits them and OpenSTA/Yosys accept them, but
  only the NLDM `cell_rise`/`cell_fall` tables should be relied on for
  delay calculation.
* **No `test_cell` timing**: `test_cell` groups are emitted with directions
  and functions only (as in the source).
* **`comp_attribute,voltage_map`** appears both as a dict (common) and a list
  (corner header); the corner form wins and is emitted as
  `voltage_map (VPWR, 1.28);` etc.
* **No multi-corner Liberty**: one file per corner.  Load multiple files as
  separate corners in OpenSTA/LibreLane; library and operating-condition names
  are corner-qualified.
* **Functions of ICG cells**: see [Yosys caveat](#yosys-caveat).
* **No cell `dont_use`/`dont_touch` inversion**: attributes from the JSON are
  preserved verbatim.
* CCS/bus-specific attributes (`related_bus_pins`, `interface_timing`,
  `bus_type`, `type (bus16)`) are preserved; OpenSTA sees the hdll `muxb16to1_2`
  pins as `D`, `S` (buses) and `Z`.

## Reproducing the outputs

```bash
cd flow/sky130_lib

# required validated output
python3 convert_libjson.py --lib sky130_fd_sc_ms --corner ss_n40C_1v28 \
  --out out/sky130_fd_sc_ms_ss_n40C_1v28.lib \
  --stats-json out/sky130_fd_sc_ms_ss_n40C_1v28.stats.json

# extra ms corners + compatibility variant
python3 convert_libjson.py --lib sky130_fd_sc_ms --corner tt_100C_1v80 \
  --out out/sky130_fd_sc_ms_tt_100C_1v80.lib
python3 convert_libjson.py --lib sky130_fd_sc_ms --corner ff_100C_1v95 \
  --out out/sky130_fd_sc_ms_ff_100C_1v95.lib
python3 convert_libjson.py --lib sky130_fd_sc_ms --corner tt_025C_1v80_ccsnoise \
  --out out/sky130_fd_sc_ms_tt_025C_1v80_ccsnoise.lib
python3 convert_libjson.py --lib sky130_fd_sc_ms --corner ff_n40C_1v95_pwrlkg \
  --out out/sky130_fd_sc_ms_ff_n40C_1v95_pwrlkg.lib
python3 convert_libjson.py --lib sky130_fd_sc_ms --corner ss_n40C_1v28 \
  --derive-icg-functions --name sky130_fd_sc_ms__ss_n40C_1v28_yosys \
  --out out/sky130_fd_sc_ms_ss_n40C_1v28_yosys.lib

# other libraries
python3 convert_libjson.py --lib sky130_fd_sc_lp  --corner ss_n40C_1v65 \
  --out out/sky130_fd_sc_lp_ss_n40C_1v65.lib
python3 convert_libjson.py --lib sky130_fd_sc_lp  --corner ff_n40C_1v95 \
  --out out/sky130_fd_sc_lp_ff_n40C_1v95.lib
python3 convert_libjson.py --lib sky130_fd_sc_ls  --corner tt_100C_1v80 \
  --out out/sky130_fd_sc_ls_tt_100C_1v80.lib
python3 convert_libjson.py --lib sky130_fd_sc_ls  --corner ss_n40C_1v28 \
  --out out/sky130_fd_sc_ls_ss_n40C_1v28.lib
python3 convert_libjson.py --lib sky130_fd_sc_hdll --corner tt_025C_1v80 \
  --out out/sky130_fd_sc_hdll_tt_025C_1v80.lib
python3 convert_libjson.py --lib sky130_fd_sc_hdll --corner ss_n40C_1v28 \
  --out out/sky130_fd_sc_hdll_ss_n40C_1v28.lib
```

Validate everything:

```bash
for f in out/*.lib; do
  yosys -p "read_liberty -lib $f; stat" >/dev/null || echo "YOSYS FAIL $f"
  printf 'read_liberty %s\n' "$f" > /tmp/read.tcl
  sta -no_init -exit /tmp/read.tcl 2>&1 | grep -E 'Error|Warning' && echo "STA WARN $f"
done
```

## Provenance

Input data: SkyWater PDK `sky130_fd_sc_*` timing JSON dumps
(`/grid/sky130`).  Output files are derived reconstructions, not
vendor-signed-off Liberty; no warranty of accuracy for sign-off use.  The
converter is deterministic apart from the generation timestamp in the file
header; `values` are copied bit-for-bit from the JSON.
