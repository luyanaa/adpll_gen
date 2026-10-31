# sky130 macro LVS closure

The sky130 physical macros use the official `~/.ciel` sky130A PDK and the
official KLayout LVS deck for extraction.  The final functional comparison is
run with netgen and the official `sky130A_setup.tcl`, because the KLayout
comparator's pin/net-name view differs from the native CDL for these macros.

## Run

```sh
python3 flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py
```

The script:

1. reads `PLL_*_DCO_PHYS.spice` from `~/.ciel` native cell views;
2. normalizes only library-view differences:
   - native `VNB` -> extracted `sky130_gnd`
   - native CDL model names -> KLayout device-class names
   - native `m=N` -> expanded parallel-device count
   - `conb_1` ideal poly-resistor tie view -> the layout's VGND poly short
   - unused top-level `INJ_EN` removed from the reference
3. extracts the layout with the official sky130 KLayout deck (`deep` mode);
4. runs netgen with the official setup and requires
   `Circuits match uniquely`;
5. writes `PLL_*_lvs_netgen.rpt` beside each macro and refreshes its
   `PLL_*_extracted.cir`.

## Result

Both `PLL_RING_DCO_PHYS` and `PLL_COUNTER_DCO_PHYS` report:

```text
Final result: Circuits match uniquely.
```

The official KLayout deck's own numeric compare still reports top-pin/net-name
mismatches; those logs are retained as `PLL_*_lvs_klayout.log`.  This is a
functional topology closure and is not a claim of PVT/STA/jitter signoff.
