#!/usr/bin/env python3
"""Build the DLL8 moscap/switch PnR cells (IHP SG13G2) from the PDK PCells.

Run:  klayout -zz -r build_cells.py
Env:  PDK_ROOT, PDK=ihp-sg13g2, IHP_ROOT, KLAYOUT_PATH=<pdk>/libs.tech/klayout
      (KLayout 0.30 needs LD_LIBRARY_PATH=/usr/lib/klayout for the pya module
       when run via /usr/bin/python3; `klayout -zz -r` is self-contained.)

Cells (fixed drawn size, from the SPICE element):
  sg13g2_moscap_n  moscap_n w=1.0 l=1.1  (PDK legal min is 1.0; element used
                   0.9 -> nearest legal 1.0 x 1.1, +11% area/C), pins G,B
  sg13g2_moscap_p  moscap_p w=1.0 l=1.1, pins G,B
  sg13g2_lv_nmos   nmos w=0.5 l=0.45, pins G,D,S,B
  sg13g2_lv_pmos   pmos w=1.0 l=0.13, pins G,D,S,B

Pins are labelled on Metal2 (same convention as the tx_macro recipe).
"""
import json
import sys

PDK = ("/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
       "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2")
sys.path.insert(0, PDK + "/libs.tech/klayout/python")
sys.path.insert(0, PDK + "/libs.tech/klayout/python/pycell4klayout-api/source/python")

OUT = "/grid/adpll_gen/flow/macro/dll8_cells/dll8_cells.gds"
META = "/grid/adpll_gen/flow/macro/dll8_cells/dll8_cells.layout.json"

import sg13g2_pycell_lib  # noqa: E402
import pya  # noqa: E402

ly = pya.Layout()
ly.dbu = 0.001
ly.technology_name = "sg13g2"

LAY = {
    "m1": (8, 0), "m1p": (8, 2), "v1": (19, 0),
    "m2": (10, 0), "m2p": (10, 2), "gp": (5, 0), "cont": (6, 0),
    "dif": (1, 0),
}


def lay(cell, name):
    l, d = LAY[name]
    return cell.shapes(ly.layer(l, d))


def box(cell, name, x1, y1, x2, y2):
    lay(cell, name).insert(pya.Box(int(x1), int(y1), int(x2), int(y2)))


def txt(cell, name, x, y, s):
    lay(cell, name).insert(pya.Text(s, pya.Trans(pya.Vector(int(x), int(y)))))


def uniq(cell, name):
    li = ly.layer(*LAY[name])
    out = []
    for s in cell.shapes(li).each():
        if s.is_box() and not any(s.box == b for b in out):
            out.append(s.box)
    return out


def add_pad(cell, x, y, net, size=150):
    box(cell, "m1", x - size, y - size, x + size, y + size)
    box(cell, "v1", x - 95, y - 95, x + 95, y + 95)
    box(cell, "m2", x - size, y - size, x + size, y + size)
    txt(cell, "m2p", x, y, net)


def build_device_cell(top_name, kind, w, l, ng=1, guard=None):
    """nmos/pmos: S/D/G/B from the PDK PCell + M2 pin pads/labels."""
    params = {"w": f"{w}u", "l": f"{l}u", "ng": str(ng)}
    if guard:
        params["guardRingType"] = guard
        params["guardRingDistance"] = "1u"
    c = ly.create_cell(kind, "SG13_dev", params)
    boxes = uniq(c, "m1")
    minw = min(b.width() for b in boxes)
    sd = sorted([b for b in boxes if b.width() <= minw + 10],
                key=lambda b: b.center().x)
    src, drn = sd[0], sd[-1]
    poly = uniq(c, "gp")[0]
    gcy = poly.center().y
    # S/D pads
    for term, b in (("S", src), ("D", drn)):
        add_pad(c, b.center().x, b.center().y, term)
    # gate pad above the channel
    gx = poly.center().x
    gy = poly.top + 350
    box(c, "gp", gx - 300, gcy - 300, gx + 300, gcy + 300)
    box(c, "cont", gx - 80, gcy - 80, gx + 80, gcy + 80)
    add_pad(c, gx, gy, "G")
    # body: bulk tie (ring bottom or a diff tap) - label the lowest m1 ring box
    ring = [b for b in boxes if b not in sd]
    if ring:
        rb = min(ring, key=lambda b: b.bottom)
        add_pad(c, rb.center().x, rb.center().y, "B")
    c.name = top_name
    return c


def build_moscap_cell(top_name, kind, w, l):
    """moscap: gate = poly, bottom = the S/D/bulk tie (Metal1)."""
    c = ly.create_cell(kind, "SG13_dev", {"w": f"{w}u", "l": f"{l}u", "m": "1"})
    m1 = uniq(c, "m1")
    gp = uniq(c, "gp")[0]
    # gate pad on the poly
    gx, gy = gp.center().x, gp.top + 350
    box(c, "gp", gx - 300, gp.center().y - 300, gx + 300, gp.center().y + 300)
    box(c, "cont", gx - 80, gp.center().y - 80, gx + 80, gp.center().y + 80)
    add_pad(c, gx, gy, "G")
    # bottom pad on the widest Metal1 strap
    bb = max(m1, key=lambda b: b.area())
    add_pad(c, bb.center().x, bb.center().y, "B")
    c.name = top_name
    return c


meta = {"cells": {}, "gds": OUT}
moscap_n = build_moscap_cell("sg13g2_moscap_n", "moscap_n", 1.0, 1.1)
moscap_p = build_moscap_cell("sg13g2_moscap_p", "moscap_p", 1.0, 1.1)
nmos = build_device_cell("sg13g2_lv_nmos", "nmos", 0.5, 0.45, 1, "psub")
pmos = build_device_cell("sg13g2_lv_pmos", "pmos", 1.0, 0.13, 1, "nwell")
for c, d in ((moscap_n, {"kind": "moscap", "w": 1.0, "l": 1.1}),
             (moscap_p, {"kind": "moscap", "w": 1.0, "l": 1.1}),
             (nmos, {"kind": "nmos", "w": 0.5, "l": 0.45}),
             (pmos, {"kind": "pmos", "w": 1.0, "l": 0.13})):
    meta["cells"][c.name] = {**d, "bbox": c.bbox().to_s()}

top = ly.create_cell("dll8_cells")
x = 0
for c in (moscap_n, moscap_p, nmos, pmos):
    top.insert(pya.CellInstArray(c.cell_index(), pya.Trans(pya.Vector(x, 0))))
    x += 4000
for c in (moscap_n, moscap_p, nmos, pmos):
    c.flatten(True)
opts = pya.SaveLayoutOptions()
try:
    opts.format = "GDS2"
except Exception:
    pass
ly.write(OUT, opts)
open(META, "w").write(json.dumps(meta, indent=1) + "\n")
print(json.dumps(meta, indent=1))
