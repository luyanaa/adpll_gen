# OR1 1 µm smoke experiment

Experimental check of `/grid/OpenRule1um/OR1PDK/or1` with a 4-bit shift
register.  This is **not** a signoff flow.

## Run

```sh
cd flow/canary/OR1_smoke
librelane --manual-pdk --pdk-root /grid/OpenRule1um/OR1PDK \
  --pdk or1 --scl or1_fd_sc \
  -S Checker.PowerGridViolations -S Checker.DisconnectedPins \
  -S OpenROAD.IRDropReport \
  --to Magic.StreamOut config.yaml
```

## Results

- Synthesis, placement, CTS, global route and detailed route complete.
- Detailed route: **9 OpenROAD violations**, all `Off Grid`/`Recheck` on
  `metal2` (route points such as x=102.9, y=181.5 against the 2 µm tracks).
- Magic streamout completes and produces `counter.gds` / `counter.mag`.
- Magic DRC reports **477 markers**:
  - 324 `Can't overlap those layers`
  - 96 `POL-DIFF space < 0.5um`
  - 33 `ML1 space < 1.0um`
  - 7 `POL space < 1.0um`
  - smaller counts for Parea/DIFF/Narea/ML2/NWL.
- Reaching streamout requires the local `or1_fd_sc_fixed.lef`, which gives
  `VDD/VSS` `DIRECTION INOUT`; the vendor LEF omits direction on several
  power pins, making OpenROAD treat them as signal inputs.

## PDK gaps

- `libs.tech/klayout/tech/or1A.*` is referenced by `config.tcl` but absent;
  KLayout DRC/LVS cannot run.
- Only the TT library is present, but the PDK advertises `min_*`/`max_*`
  STA corners; a full flow fails when saving those views.
- PDN generation reports no metal1-metal2 vias and floating VDD shapes;
  top-level power pins are absent.
- The 12T/GDS DRC compatibility of the vendor standard cells is not clean
  under the supplied Magic tech: the 477 markers above appear after a
  successful route.
- Track/pin alignment produces OpenROAD off-grid violations; `tracks.info`
  needs adjustment before signoff.

Do not claim OR1 DRC/LVS or timing signoff.
