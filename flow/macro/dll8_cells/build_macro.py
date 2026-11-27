#!/usr/bin/env python3
"""Placement/area study for the DLL8 8-element line macro.

Run:  klayout -zz -r build_macro.py
Reads the PDK stdcell GDS for sg13g2_inv_4, instantiates 8 elements, each =
2 x sg13g2_inv_4 + 127 moscap/switch fingers (1.0x1.0 moscap, stock inv_4),
lays them on a grid with DRC spacing, adds a boundary + pin labels.

This is a PLACEMENT (no routing): it gives the macro area and lets DRC run on
the PCell bodies.  Routing / LVS / PEX are the remaining (large) step.
"""
import json
import sys

PDK = ("/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
       "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2")
sys.path.insert(0, PDK + "/libs.tech/klayout/python")
sys.path.insert(0, PDK + "/libs.tech/klayout/python/pycell4klayout-api/source/python")

OUT = "/grid/adpll_gen/flow/macro/dll8_cells/dll8_line_macro.gds"
META = "/grid/adpll_gen/flow/macro/dll8_cells/dll8_line_macro.layout.json"
STD = PDK + "/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds"

import sg13g2_pycell_lib  # noqa: E402
import pya  # noqa: E402

ly = pya.Layout()
ly.dbu = 0.001
ly.technology_name = "sg13g2"
ly.read(STD)          # brings in sg13g2_inv_4 etc.

# DBU helpers
U = 1000  # 1 um = 1000 dbu
PITCH = 5 * U   # device pitch (um) - > bbox + spacing

mcn = ly.create_cell("moscap_n", "SG13_dev", {"w": "1.0u", "l": "1.0u", "m": "1"})
mcp = ly.create_cell("moscap_p", "SG13_dev", {"w": "1.0u", "l": "1.0u", "m": "1"})
ns = ly.create_cell("nmos", "SG13_dev", {"w": "0.5u", "l": "0.45u", "ng": "1",
                                         "guardRingType": "psub",
                                         "guardRingDistance": "1u"})
ps = ly.create_cell("pmos", "SG13_dev", {"w": "1.0u", "l": "0.13u", "ng": "1",
                                         "guardRingType": "nwell",
                                         "guardRingDistance": "1u"})
inv4 = ly.cell("sg13g2_inv_4")

# one element: 127 fingers in a 16-wide grid + 2 inv_4
NCOL = 16
def build_elem(name):
    c = ly.create_cell(name)
    for j in range(127):
        cx = (j % NCOL) * PITCH
        cy = (j // NCOL) * PITCH
        cap = mcn if j % 2 == 0 else mcp
        sw = ns if j % 2 == 0 else ps
        c.insert(pya.CellInstArray(cap.cell_index(), pya.Trans(pya.Vector(cx, cy))))
        c.insert(pya.CellInstArray(sw.cell_index(), pya.Trans(pya.Vector(cx + 2 * U, cy))))
    ny = (126 // NCOL) * PITCH
    for k in range(2):
        c.insert(pya.CellInstArray(inv4.cell_index(),
                                   pya.Trans(pya.Vector(k * 3 * U, ny + 4 * U))))
    return c

elem = build_elem("dll8_elem_place")
top = ly.create_cell("dll8_line_macro")
EX = 8
for e in range(EX):
    top.insert(pya.CellInstArray(elem.cell_index(),
                                 pya.Trans(pya.Vector(e * 90 * U, 0))))

# boundary + pin plan: IN, CODE[6:0], TAP[7:0], VDD, VSS  (18 pins)
# decoder sits INSIDE the macro (7-bit CODE in, 127-wire fan stays internal);
# no per-element trim pins; optional single 3-bit global trim (not included
# here).  TAP[7:0] are buffered outputs.
b = top.bbox()
lay4 = ly.layer(50, 0)
lay4p = ly.layer(50, 2)
top.shapes(lay4).insert(pya.Box(b.left, b.bottom, b.right, b.top))
pins = [("IN", b.left, b.bottom + 2*U), ("VDD", b.right, b.top),
        ("VSS", b.right, b.bottom)]
for i in range(7):
    pins.append((f"CODE{i}", b.left, b.bottom + (4 + i) * U))
for i in range(8):
    pins.append((f"TAP{i}", b.left + (10 + i * 10) * U, b.bottom))
for nm, x, y in pins:
    top.shapes(lay4p).insert(pya.Text(nm, pya.Trans(pya.Vector(int(x), int(y)))))

opts = pya.SaveLayoutOptions()
try:
    opts.format = "GDS2"
except Exception:
    pass
ly.write(OUT, opts)
bb = top.bbox()
meta = {"gds": OUT, "bbox_dbu": bb.to_s(),
        "w_um": bb.width() / 1000.0, "h_um": bb.height() / 1000.0,
        "area_um2": (bb.width() / 1000.0) * (bb.height() / 1000.0),
        "elements": EX, "devices": EX * (127 * 2 + 2)}
open(META, "w").write(json.dumps(meta, indent=1) + "\n")
print(json.dumps(meta, indent=1))
