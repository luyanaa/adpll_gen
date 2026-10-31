# Ring-DCO symmetry constraints

The current ring macro is a physical placement/routing artifact, not a
symmetry-optimized oscillator.  The following constraints are the required
contract for the next layout iteration; they are not claimed as applied to the
checked-in GDS.

1. The fixed `BASE_NDELS` inverter bank is split into two mirror halves around
   the coarse/mid/fine tuning core.  Each half has the same stage count, cell
   type, orientation and output load.
2. Coarse, mid and fine banks are placed centrally with matched wire lengths to
   the two ring halves; no tuning cell is on only one side of the loop.
3. The SS-BBPD/mux and output observation path are placed symmetrically with
   matched parasitics on the two output branches, or their asymmetry is modeled
   explicitly.
4. Dummy cells and fill are placed symmetrically; no asymmetric metal fill over
   one half of the delay bank.
5. Power/ground straps and substrate/well taps are mirrored; the two halves
   have equal IR-drop and decap distribution.
6. The output divider/observation buffer is outside the oscillator loop and is
   not used to compensate a deliberate layout asymmetry.

Because COARSE is path-select, MID/FINE are controlled loads, and the mux /
SS-BBPD / injection path are not a simple M-stage ring, do not derive an ISF by
assuming 2*pi/M phase shifts across all nodes.  Use `src/isf_sampling.py` to
compare independently measured node ISFs and gate any reuse on the numerical
error limits.
