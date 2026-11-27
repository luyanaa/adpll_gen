# Shared-well step attempt + status (KLayout 0.30.12)

## Reproducible env (record this)
  KL=/nix/store/1whjbzm6gw6l4h0sjxdv92lyw7lq1ar8-klayout-0.30.12/bin/klayout
  export LD_LIBRARY_PATH=/nix/store/27hshxcw5h8hf9fw2p67lwfa8s2v3dys-qtbase-5.15.19/lib:\
/nix/store/1whjbzm6gw6l4h0sjxdv92lyw7lq1ar8-klayout-0.30.12/lib:$LD_LIBRARY_PATH
  $KL -b -r .../klayout/tech/drc/ihp-sg13g2.drc \
      -rd input=<gds> -rd topcell=<cell> -rd report=<lyrdb>

## State reached
- cap/switch overlap fixed (+3.5 um offset): KLayout 568 -> 171.
- single moscap 1.0x1.0: KLayout 0.
- Remaining 171 = NBL.e 56 / NBL.f 56 / NBL.c 55 (different-net nBuLay 3.2)
  + Act.b 2 / M1.b 2.

## Shared-well blocker
The PDK PCell GDS for moscap_p/pmos exposes NO explicit nwell or nBuLay
drawing layer (moscap_p layers: gp, activ, m1, cont, and block layers
14/31/63).  The well/nBuLay is implied by PDK block layers, so a scripted
"shared nwell/nBuLay rectangle" cannot be placed by layer number without the
PDK layer map (not found at libs.tech/klayout/tech/sg13g2.map).  Doing this
correctly requires locating the layer map and drawing the shared well plus
VDD taps - a real layout step, not a one-line change, and it must not be
guessed.

## Not done
Shared-well layout, routing (mid/rails/drain-gate/127 control strap),
KLayout LVS, PEX.  Extracted BASE/mid delay, per-node C vs 0.96 fF/node, and
tap RC are NOT available.  Judgement (<=3.5 ps PASS / >5 ps FAIL) not applied.
