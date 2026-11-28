#!/usr/bin/env python3
"""Create the derived, origin-shifted GDS view of the signed-off dll8_line4 macro.

Input : /grid/adpll_gen/flow/macro/dll8_cells/dll8_line4.gds  (READ ONLY --
        the signed-off tapeout view is never modified or rewritten here)
Output: dll8_line4.gds next to this script

Derivations from the signed-off stream:
  1. Top cell renamed dll8_line4_top -> dll8_line4: stream_out matches GDS
     cells to LEF/DEF cells by name, and the LEF MACRO name / Verilog module
     name / MACROS key is dll8_line4.
  2. Origin shift (+0.88, +13.67) um applied inside the DLL8_LINE4 cell:
     the signed-off stream places ALL functional geometry in DLL8_LINE4,
     instantiated exactly once at (0,0) in the top wrapper -- so shifting
     that one cell's shapes/instances/labels is a pure frame translation
     of the whole macro.  The signed-off GDS bbox starts at (-0.88,-13.67)
     (strip rails / TAP drops extend below-left of the placement origin),
     and LEF pins outside the macro bbox are not reliably handled by the
     OpenROAD flow; the derived view puts the bbox origin at (0,0) and the
     LEF is emitted in the same frame.  Internal hierarchy below
     DLL8_LINE4 is untouched, so DRC/LVS validity is preserved exactly.
"""
import os
import sys

sys.path.insert(0, "/grid/adpll_gen/build/pdk_root/ihp-sg13g2/libs.tech/klayout/python")
import klayout.db as db

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = "/grid/adpll_gen/flow/macro/dll8_cells/dll8_line4.gds"
DST = os.path.join(HERE, "dll8_line4.gds")
OLD_TOP = "dll8_line4_top"
NEW_TOP = "dll8_line4"
INNER = "DLL8_LINE4"
DX_NM, DY_NM = 880, 13670   # shift = -bbox_origin of the signed-off stream


def main():
    src = db.Layout()
    src.read(SRC)
    old = src.cell(OLD_TOP)
    if old is None:
        sys.exit("top cell %s not found in %s" % (OLD_TOP, SRC))

    dst = db.Layout()
    dst.dbu = src.dbu
    new = dst.create_cell(NEW_TOP)
    new.copy_tree(old)

    inner = dst.cell(INNER)
    if inner is None:
        sys.exit("inner cell %s missing after copy" % INNER)
    # single-instantiation sanity: the shift must not affect any other parent
    callers = set()
    for c in dst.each_cell():
        for inst in c.each_inst():
            if inst.cell_index == inner.cell_index():
                callers.add(c.name)
    if callers != {NEW_TOP}:
        sys.exit("DLL8_LINE4 instantiated from unexpected parents: %s" % callers)

    # Shift = -bbox origin of the copied content, computed fresh every time:
    # the power respin changed the signed-off bbox (M4 trunks extend the
    # negative-x reach), so no hardcoded constants.
    pre_bb = new.bbox()
    dx, dy = -pre_bb.left, -pre_bb.bottom
    tr = db.Trans(db.Vector(dx, dy))
    shapes_out = []
    for inst in inner.each_inst():
        inst.trans = tr * inst.trans
    n_moved = 0
    for li in dst.layer_indexes():
        for s in inner.shapes(li).each():
            s.transform(tr)
            n_moved += 1

    bb = new.bbox()
    dst.write(DST)
    print("wrote %s" % DST)
    print("  bbox (um)      : %s"
          % [round(v * dst.dbu, 3) for v in
             (bb.left, bb.bottom, bb.right, bb.top)])
    print("  moved shapes   : %d" % n_moved)
    if (bb.left, bb.bottom) != (0, 0):
        sys.exit("bbox origin is not (0,0)")
    top_cells = [c.name for c in dst.top_cells()]
    if top_cells != [NEW_TOP]:
        sys.exit("unexpected top cells %s" % top_cells)
    return 0


if __name__ == "__main__":
    sys.exit(main())
