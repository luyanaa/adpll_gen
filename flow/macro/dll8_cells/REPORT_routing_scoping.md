# Routing scoping for the routed element (bottleneck, with counts)

Base: dll8_elem_shared_well.gds (KLayout DRC 0), 119.88 x 60.83 um, 127
fingers in two 8x8 groups (N 64 even = moscap_n+nmos; P 63 odd =
moscap_p+pmos, shared 31/0+32/0 well).

## Connection classes and counts (scripted, no autorouter)
| class | nets | endpoints | note |
|---|---|---|---|
| mid bus (stage-1 inv_4 out -> all switch S -> stage-2 inv_4 in) | 1 | 127 S + 2 inv pins | 2D grid -> needs a spine + 127 branches |
| drain -> cap-gate (per finger) | 127 | 254 (switch D, cap G) | local 2-point straps |
| thermometer control (127 unique nets) | 127 | 127 gates + 127 boundary pads | strap channel at one edge |
| VDD / VSS rails + taps | 2 | ~254 taps + 127 cap bottoms | |
| IN / OUT / inv internal | ~4 | ~8 | |
**Total distinct routed nets ~260, endpoints ~800.** Hand-scripting this with
no autorouter is the bottleneck (the mid bus tree and the 127-net control
strap channel dominate). This is a scoping fact, not a DRC problem: the
placement is KLayout-0.

## Wire-cap estimate for the mid bus (order of magnitude, not extracted)
The mid node must span the whole bank: spine ~120 um + 127 stubs ~3 um each
~ 380 um of metal.  At a typical SG13G2 Metal2/3 value ~0.15-0.25 fF/um this
is ~**60-95 fF on mid**, vs the SPICE element deck's `Cmid 0.96 fF`.
So the SPICE mid-wire assumption is ~2 orders of magnitude low.  BUT the mid
node already carries the bank cap (~127 x 12.8 fF = 1.6 pF), so the wire is
~4-6% of the node: the delay impact is ~+4-6% (tens of ps on 660 ps), not a
blow-up.  This must be confirmed by PEX, but it says the 0.96 fF/node number
is about the inter-element tap node, NOT the mid bus - they are different
nodes and should not be compared directly.

## Environment
  KL=/nix/store/1whjbzm6gw6l4h0sjxdv92lyw7lq1ar8-klayout-0.30.12/bin/klayout
  LD_LIBRARY_PATH=<qtbase-5.15.19>/lib:<klayout-0.30.12>/lib:$LD_LIBRARY_PATH

## Recommended next
Use an autorouter for the bank (Magic `route`/`iroute`, or OpenROAD
detail-route on the macro), or accept a scripted partial (mid spine + rails +
control strap, drain-gate as abutted M1) and run KLayout LVS on that.  LVS +
PEX remain undone, so the extracted BASE/mid delay and the real per-node C
are NOT yet available.
