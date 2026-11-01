# ADDLL_TOP sky130 status

- RTL functional model verified (iverilog): loop locks to minimum-delay
  full-period alignment, `DLY_CODE` dithers +/-1 LSB.
- Physical cascade `PLL_COUNTER_DCDL_PHYS` written (COARSE->MID->FINE
  buffered chain).
- PnR not yet run — this directory is the prepared LibreLane flow.
- No DRC/LVS/timing signoff claimed.
