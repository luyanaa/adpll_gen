# Counter DCO macro timing

`sta.rpt` is an OpenSTA report at the nominal ics55 H7CR TT/1.2 V/25 C corner
using the macro Liberty model and TICK/REF planning constraints.

The report shows a clean setup/hold check for the digital macro at TICK = 1 ns
and REF = 10 ns.  It is **not** a multi-corner signoff, and the DCO frequency
range/PVT/KDCO are not characterized by timing analysis.
