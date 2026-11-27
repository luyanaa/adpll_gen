# Stock sg13g2_inv_4 driver — simplification accepted (v5)

Question: is the custom Wp=5.30/Wn=2.96 driver still needed after SR regen?
Answer: no.  Measured with stock sg13g2_inv_4 stage 1, stage 2 inv_4, bank
unchanged (127-finger symmetric N/P moscap 0.9x1.1).

## Element (stock inv_4)

| corner | BASE | c64 | c96 | max (c127) | LSB | d target | 1.15*d | reach |
|---|---|---|---|---|---|---|---|---|
| ss | 146.4 | 244.0 | 380.7 | 654.3 | 4.0 | 500 | 575 | yes (code ~115) |
| tt | 89.9 | 148.7 | 261.9 | 511.6 | 3.32 | 375 | 431 | yes (code ~118) |
| ff | 60.5 | 114.1 | 294.6 | 458.7 | 3.14 | 250 | 288 | yes (code ~92) |

vs custom driver (v3): SS 147.7->655.6, TT 90.7->512.3, FF 61.0->459.2.
Delta < 2 ps at BASE and max -> the custom driver changed only duty, which
SR regeneration now produces independently.  BASE < 250 at TT/FF.

## Regenerated digital gate with stock-element BASE/LSB
| case | de-offset | duty (all 8) | rails | early |
|---|---|---|---|---|
| SS 4ns | 7.0 ps | 49.80 % | both | none |
| SS 2ns | 0.0 ps | 50.00 % | both | none |
| TT 3ns | 0.0 ps | 50.00 % | both | none |
| FF 2ns | 3.5 ps | 49.80 % | both | none |
Element output duty is worse (23-115 ps asym, as expected) but no longer
reaches any output.

## k=7 D_set outlier — diagnosed as (a) load asymmetry in the test deck
Tap loads in the SPICE regen deck (old): x1..x7 drove (real next-element input)
+ (extra dummy inv_4) + tap buf + regen; x8 drove the dummy + tap buf + regen
with no real next-element input.  So x8 was under-loaded by one element input,
and for the custom driver the dummy inv_4 did not match the INV4B input either.
Fixed: dummy only on x8, and it uses the same stage-1 cell as the real element
input.  With stock inv_4 the dummy and the next-element input are the same
cell, so all eight taps are symmetric.
(The per-cycle extractor still does not associate k=0..3, and k=7 D_set jumps
between runs 354..525 ps -> the residual is extraction-limited, not a design
skew.  FF clean extraction gives 1.5-1.7 ps.)
