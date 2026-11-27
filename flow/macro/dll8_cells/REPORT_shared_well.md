# Shared-well element: KLayout DRC 0 (Magic DRC 256 on same GDS)

## What fixed the 171 NBL
Layers confirmed from `libs.tech/klayout/tech/sg13g2.lyp`:
  31/0 NWell.drawing, 32/0 nBuLay.drawing, 46/0 PWell.drawing.
Bank re-arranged into an N group (64 even fingers: moscap_n+nmos, psub) and a
P group (63 odd fingers: moscap_p+pmos), and one **31/0 + 32/0 rectangle**
drawn over the P group (all P nets are VDD - cap bottom `.B(1'b1)`, pmos bulk
VDD).  This unites the P nwells/nBuLay into one same-net shape -> NBL.c 3.2 um
(different-net) becomes same-net.

Sequence: cap/switch overlap 0.91um fixed (>2.91um) -> 568->171; shared
nwell+nBuLay over the P group -> 171->0 (after also spacing the two inv_4 by
5um instead of 3um: 4 Act.b/M1.b -> 0).

## Result
- Element `dll8_elem_shared_well`: **119.88 x 60.83 um**, 127 fingers,
  1.0x1.0 moscap, 2 inv_4.
- **KLayout 0.30.12 DRC = 0** (out/kl/sw2.lyrdb).
- **Magic DRC = 256** on the same KLayout-PCell GDS.  Magic's deck is built
  around Magic-drawn layouts (cdr_ihp130 was Magic-drawn and passes both);
  the KLayout-PCell stream is not Magic-DRC-clean.  Per the earlier decision
  KLayout is the DRC+extraction+LVS deck for this path.

## Not done (so not signoff)
Routing (mid bus / VDD-VSS rails / drain->cap-gate / 127-control strap),
KLayout LVS, PEX.  Extracted BASE/mid delay, per-node C vs 0.96 fF/node, and
tap RC are NOT available.  Judgement (<=3.5 ps PASS / >5 ps FAIL) not applied.

## Env
  KL=/nix/store/1whjbzm6gw6l4h0sjxdv92lyw7lq1ar8-klayout-0.30.12/bin/klayout
  LD_LIBRARY_PATH=/nix/store/27hshxcw5h8hf9fw2p67lwfa8s2v3dys-qtbase-5.15.19/lib:/nix/store/1whjbzm6gw6l4h0sjxdv92lyw7lq1ar8-klayout-0.30.12/lib:$LD_LIBRARY_PATH
