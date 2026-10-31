# Adaptive ISF phase sampling

`isf_sampling.py` adds edge-dense phase sampling without assuming that the DCO
is a symmetric M-stage ring.  The existing 128/256-point uniform run remains
the reference.  Adaptive runs keep the uniform baseline and add points around
declared switching edges; the total budget is explicit (`0` means
`2*nphase`).

Workflow:

```sh
# Representative nodes: full uniform baseline
python3 src/create_isf.py runs --nphase 128

# Dense-edge experiment, same representative nodes
python3 src/create_isf.py runs --nphase 128 --adaptive \
  --edge-window 0.04 --edge-density 2 --phase-budget 192
```

`isf_setup.json` records `phases` and `sampling` metadata.  `may_reuse()`
rejects ISF reuse when the RMS or integrated `h^2` error exceeds the configured
limit.  This is a numerical sampling check, not a phase-noise signoff, and it
does not justify reusing a node ISF based only on structural symmetry.
