#!/usr/bin/env python3
"""Generate the dll8_line4 LEF abstract from pin_inventory.json.

Input : pin_inventory.json  (produced by extract_pins.py from the signed-off
        /grid/adpll_gen/flow/macro/dll8_cells/dll8_line4.gds -- READ ONLY)
Output: dll8_line4.lef  (next to this script)

Abstract content
  * MACRO name  = dll8_line4  (must equal the Verilog module name so LibreLane
    can bind the MACROS block, and must equal the derived GDS top-cell name so
    stream_out finds a matching GDS cell).
  * SIZE 67.38 BY 358.53  = the exact top-cell bbox of the signed-off GDS.
  * 516 PINs, one PORT rect each: the exact unmerged metal drawing rect that
    carries the label (verified in extract_pins.py -- every label sits on
    exactly one drawing rect, so no bbox inflation and no neighbour shorts).
      ENk[j] (k=0..3, j=0..126)  INPUT  SIGNAL   Metal3/4/5
             (bus-style names: the GDS label is ENk_j, but the LEF/MTerm name
             must match how Verilog bus ports elaborate -- EN0[126:0] ->
             EN0[0]..EN0[126] -- because OpenROAD matches netlist pins to
             LEF MTerms by name; see lef_pin_name())
      IN                         INPUT  SIGNAL   Metal1
      OUT                        OUTPUT SIGNAL   Metal1
      TAP0..TAP3                 OUTPUT SIGNAL   Metal2
      VDD                        INOUT  POWER    Metal1
      VSS                        INOUT  GROUND   Metal1
  * OBS on Metal1..Metal5: the merged drawing geometry of the macro MINUS the
    pin PORT rects (so the router can still reach every pin).  Shapes are
    trapezoid-decomposed (rectilinear input -> rectangles), which resolves any
    hole a pin cutout may open in a plane.

Geometry is emitted in the GDS coordinate frame (no shift): the bbox origin is
(-0.88, -13.67) um, so ~1 um of geometry pokes left/below the placement origin
at (0,0).  Keeping the LEF frame identical to the GDS frame is what makes the
stream-out merge correct; the excursion is recorded in REPORT.md.
"""
import json
import os
import sys

import klayout.db as db

HERE = os.path.dirname(os.path.abspath(__file__))
INV = os.path.join(HERE, "pin_inventory.json")
OUT = os.path.join(HERE, "dll8_line4.lef")

# GDS drawing layers (datatype 0) per LEF routing layer.
DRAW = {"Metal1": (8, 0), "Metal2": (10, 0), "Metal3": (30, 0),
        "Metal4": (50, 0), "Metal5": (67, 0)}
OBS_ORDER = ["Metal1", "Metal2", "Metal3", "Metal4", "Metal5"]


def fmt(v):
    """um float -> LEF number (trim trailing zeros, keep >=1 decimal)."""
    s = "%.3f" % v
    if "." in s:
        s = s.rstrip("0")
        if s.endswith("."):
            s += "0"
    return s


def lef_pin_name(name):
    """LEF/MTerm name for a GDS label (ENk_j -> ENk[j], others unchanged)."""
    if name.startswith("EN") and "_" in name:
        k, j = name[2:].split("_", 1)
        return "EN%s[%s]" % (k, j)
    return name


def direction_use(name):
    if name == "VDD":
        return "INOUT", "POWER"
    if name == "VSS":
        return "INOUT", "GROUND"
    if name.startswith("EN") or name == "IN":
        return "INPUT", "SIGNAL"
    if name == "OUT" or name.startswith("TAP"):
        return "OUTPUT", "SIGNAL"
    raise SystemExit("unknown pin %r" % name)


def pin_sort_key(name):
    # IN, EN0_0..EN3_126 (numeric), OUT, TAP0..3, VDD, VSS
    if name.startswith("EN"):
        k, j = name[2:].split("_")
        return (1, int(k), int(j))
    order = {"IN": 0, "OUT": 4, "TAP0": 5, "TAP1": 6, "TAP2": 7, "TAP3": 8,
             "VDD": 9, "VSS": 10}
    return (order[name], 0, 0)


def main():
    with open(INV) as f:
        inv = json.load(f)
    summ = inv["summary"]
    dbu = summ["dbu_um"]
    gds = summ["gds"]
    w, h = summ["size_um"]

    # ---- collect the pin list (purpose == "pin" entries only; the "text"
    # purpose duplicates carry the same rects) -----------------------------
    pins = {}
    for lab in inv["labels"]:
        if lab["purpose"] != "pin":
            continue
        name = lab["name"]
        rects = [tuple(r) for r in lab["metal_rects_um"]]
        if name in pins:
            if pins[name]["rects"] != rects or pins[name]["layer"] != lab["lef_layer"]:
                sys.exit("inconsistent geometry for pin %s" % name)
            continue
        pins[name] = {"layer": lab["lef_layer"], "rects": rects,
                      "x": lab["x_um"], "y": lab["y_um"]}
    if len(pins) != 516:
        sys.exit("expected 516 pins, got %d" % len(pins))

    # ---- OBS regions: merged drawing geometry minus pin PORT rects -------
    ly = db.Layout()
    ly.read(gds)
    top = ly.cell(summ["top_cell"])
    if top is None:
        sys.exit("top cell %s not found in %s" % (summ["top_cell"], gds))

    pin_region = {l: db.Region() for l in OBS_ORDER}
    for p in pins.values():
        reg = pin_region[p["layer"]]
        for (x1, y1, x2, y2) in p["rects"]:
            reg.insert(db.Box(int(round(x1 / dbu)), int(round(y1 / dbu)),
                              int(round(x2 / dbu)), int(round(y2 / dbu))))
    for r in pin_region.values():
        r.merge()

    obs = {}
    for lef_layer, (gl, gd) in DRAW.items():
        li = ly.find_layer(gl, gd)
        reg = db.Region(top.begin_shapes_rec(li)) if li is not None else db.Region()
        reg.merge()
        o = reg - pin_region[lef_layer]
        # rectilinear boolean output -> rectangles via trapezoid
        # decomposition (this is what resolves a hole a pin cutout opens in a
        # plane).  Do NOT merge afterwards: re-merging the rectangles would
        # rebuild the hole, which LEF POLYGON cannot express.
        o = o.decompose_trapezoids_to_region()
        obs[lef_layer] = o

    # ---- emit ------------------------------------------------------------
    L = []
    L.append("VERSION 5.8 ;")
    L.append('BUSBITCHARS "[]" ;')
    L.append('DIVIDERCHAR "/" ;')
    L.append("UNITS")
    L.append("    DATABASE MICRONS 1000 ;")
    L.append("END UNITS")
    L.append("")
    L.append("MACRO dll8_line4")
    L.append("  FOREIGN dll8_line4 0 0 ;")
    L.append("  CLASS BLOCK ;")
    L.append("  SIZE %s BY %s ;" % (fmt(w), fmt(h)))
    L.append("")

    for name in sorted(pins, key=pin_sort_key):
        p = pins[name]
        d, u = direction_use(name)
        lef_name = lef_pin_name(name)
        L.append("  PIN %s" % lef_name)
        L.append("    DIRECTION %s ;" % d)
        L.append("    USE %s ;" % u)
        L.append("    PORT")
        L.append("      LAYER %s ;" % p["layer"])
        for (x1, y1, x2, y2) in p["rects"]:
            L.append("        RECT %s %s %s %s ;"
                     % (fmt(x1), fmt(y1), fmt(x2), fmt(y2)))
        L.append("    END")
        L.append("  END %s" % lef_name)

    L.append("  OBS")
    for lef_layer in OBS_ORDER:
        region = obs[lef_layer]
        if region.is_empty():
            continue
        L.append("    LAYER %s ;" % lef_layer)
        n = 0
        for poly in region.each():
            if poly.holes():
                sys.exit("unexpected hole in OBS polygon on %s" % lef_layer)
            if poly.num_points_hull() == 4 and poly.holes() == 0:
                b = poly.bbox()
                L.append("      RECT %s %s %s %s ;"
                         % (fmt(b.left * dbu), fmt(b.bottom * dbu),
                            fmt(b.right * dbu), fmt(b.top * dbu)))
            else:
                pts = [(pt.x * dbu, pt.y * dbu) for pt in poly.each_point_hull()]
                L.append("      POLYGON " + " ".join(
                    "%s %s" % (fmt(x), fmt(y)) for x, y in pts) + " ;")
            n += 1
        print("OBS %-7s %5d shapes" % (lef_layer, n))
    L.append("  END")
    L.append("END dll8_line4")
    L.append("")
    L.append("END LIBRARY")
    L.append("")

    with open(OUT, "w") as f:
        f.write("\n".join(L))
    print("wrote %s (%d pins, %.1f KB)"
          % (OUT, len(pins), os.path.getsize(OUT) / 1024))
    return 0


if __name__ == "__main__":
    sys.exit(main())
