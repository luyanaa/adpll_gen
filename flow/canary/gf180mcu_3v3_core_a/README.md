# gf180mcuD + `/grid` 3.3 V canaries (7T / 9T / 12T)

This lane runs the same `pll_logic` digital control on the `/grid` GF180MCU
3.3 V standard-cell libraries while using the production `gf180mcuD` PDK for
the technology views, decks, Netgen setup and RCX rules.

The PDK is external and not vendored.  A local PDK root is assembled with:

```text
gf180mcuD/libs.tech                  -> CIEL gf180mcuD libs.tech
gf180mcuD/libs.ref/<scl>             -> /grid/gf180mcu/<scl> (or pdk/libs.ref)
gf180mcuD/libs.ref/gf180mcu_fd_io    -> CIEL gf180mcuD fd_io
```

The 9T/12T OSU libraries have `tlef/<scl>.tlef`, not `techlef/*.tlef`, and no
tap cells.  The canary therefore uses a local technology LEF with the OSU
site(s) added and overrides `TECH_LEFS`, `LIB`, and `CELL_CDLS` in the design
config.  This is a canary-local view, not a PDK edit.

## Results

| Library | Status | Die / area | Stdcell | Route | Signoff | Timing @ 20 ns |
|---|---|---|---|---|---|---|
| `gf180mcu_as_sc_mcu7t3v3` (7T) | **complete** | 416.82 × 434.74 µm / 0.181208 mm² | 59,360.4 µm² | DRC 0; 11,001 single-cut vias | Magic/KLayout DRC **0**, Netgen LVS **PASS**, antenna **PASS** | setup min **+0.283 ns** (SS), TT **+1.478 ns**; hold min **+0.103 ns**; 12.9 mW |
| `gf180mcu_osu_sc_gp9t3v3` (9T) | **partial** | 508.045 × 557.245 µm / 0.283106 mm² | 88,480.4 µm² | DRC 0; 8,677 vias | Netgen LVS **PASS**; KLayout DRC **1445** (NP.2 889, NW.2a 152, NW.2b 98, PP.2 89, M1.2a 88, ...) | no CTS; setup -6.884 ns; hold +0.498 ns |
| `gf180mcu_osu_sc_gp12t3v3` (12T) | **blocked** | — | — | `DRT-0085` valid access pattern | not reached | not reached |

### 7T (complete)

`config.digital_gf180mcuD_7t.yaml` is the completed 3.3 V lane.  It uses the
AS 7-track library; the standard PDK views, gf180mcuD KLayout/Magic decks,
Netgen LVS and RCX rules all work.  This is the one completed `/grid` 3.3 V
3v3 P&R/signoff result.

### 9T (partial)

`config.digital_gf180mcuD_9t.yaml`:

- Synthesis, placement, detailed routing, extraction and **LVS** complete.
- TritonCTS crashes in `getBufferFanoutLimit`/`dbMaster::staCell()` for this
  OSU library, so CTS and post-CTS resize are skipped; the route is pre-CTS.
- Fill insertion cannot close a 162 dbu gap because the OSU fill cells start at
  `__fill_4`; fill is skipped.
- KLayout DRC reports 1445 markers.  The top categories are well/implant
  (`NP.2` 889, `NW.2a` 152, `NW.2b` 98, `PP.2` 89) plus 88 `M1.2a` items.
  The OSU library has no tap/endcap cells (`__filltie`/`__tap`), so the
  well-tie/abutment context is not DRC-clean.  This is a library-view blocker,
  not a routing DRC.
- The run should be treated as route+LVS evidence only.

### 12T (blocked)

`config.digital_gf180mcuD_12t.yaml` (OSU gp12t) reaches detailed routing but
TritonRoute reports `DRT-0085` access-pattern failures (notably `tieh`); the
OSU 12T library has no tap cells and the site/LEF view is inconsistent.
`config.digital_gf180mcuD_12t_ocd.yaml` (OCD 12T) is not runnable cleanly:
Yosys/ABC segfaults on the mapped network, and the library has no single
merged Liberty (the per-cell `lib/nom` files were not used).

No 12T P&R/DRC/LVS result is claimed.

## Reproduce (7T, the completed lane)

```sh
cd flow/canary/gf180mcu_3v3_core_a
librelane --manual-pdk --pdk-root /tmp/pdk_gf180mcuD_3v3 \
  --pdk gf180mcuD --scl gf180mcu_as_sc_mcu7t3v3 \
  -S Checker.SetupViolations -S Checker.HoldViolations \
  -S Checker.MaxSlewViolations -S Checker.MaxCapViolations \
  config.digital_gf180mcuD_7t.yaml
```

The 9T run adds `-S OpenROAD.CTS -S OpenROAD.ResizerTimingPostCTS
-S OpenROAD.FillInsertion`; the DRC errors above remain.

## Why this is not a full 3.3 V family closure

- 7T is complete and signoff-clean.
- 9T/12T (OSU) are research libraries with missing tap cells, no coherent
  CTS-visible buffer masters, and a LEF/GDS well/implant context that the
  gf180mcuD deck does not accept at cell boundaries.  Fixing them requires
  regenerating the library GDS/LEF or adding well-tied fillers, not a flow
  knob.
- The 12T OCD alternative needs a merged Liberty / synth fix before P&R.

No generated GDS/DEF/run directories are tracked.
