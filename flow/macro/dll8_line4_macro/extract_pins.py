#!/usr/bin/env python3
"""Extract the exact pin-label inventory from the signed-off dll8_line4 GDS.

Reads /grid/adpll_gen/flow/macro/dll8_cells/dll8_line4.gds (READ ONLY) and
walks the dll8_line4_top hierarchy for text shapes on the pin/label layers
(datatype 2 = *.pin, datatype 25 = *.text) of Metal1..Metal5.

For every label it records: name, GDS layer, datatype, cell, text position,
and the bbox of the metal DRAWING (datatype 0) shape under the label (the
LEF port geometry candidate).  Reports duplicates and missing names against
the signoff contract:
    4 elements x 127 fingers = 508 ENk_j + IN + OUT + TAP0..3 + VDD + VSS
    = 516 unique names (the lane brief's "515" undercounts by one: it omits
    one of IN/OUT/VDD/VSS).  Each label is written twice, on the *.pin and the
    *.text purpose, by construction (build_line4.py T() calls) -- so the raw
    text count is 2x515 = 1030 and the dedup key is (name, gds_layer).

Output: pin_inventory.json next to this script.
"""
import json
import os
import sys

import klayout.db as db

GDS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "dll8_line4.gds")
TOP = "dll8_line4"
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "pin_inventory.json")

PIN_LAYERS = {
    (8, 2): "Metal1", (8, 25): "Metal1",
    (10, 2): "Metal2", (10, 25): "Metal2",
    (30, 2): "Metal3", (30, 25): "Metal3",
    (50, 2): "Metal4", (50, 25): "Metal4",
    (67, 2): "Metal5", (67, 25): "Metal5",
}
DRAW = {(8, 0): "Metal1", (10, 0): "Metal2", (30, 0): "Metal3",
        (50, 0): "Metal4", (67, 0): "Metal5"}


def collect_labels(ly, top):
    labels = []
    for (l, d), lef_layer in sorted(PIN_LAYERS.items()):
        li = ly.find_layer(l, d)
        if li is None:
            continue
        it = top.begin_shapes_rec(li)
        while not it.at_end():
            s = it.shape()
            if s.is_text():
                t = s.text
                pt = it.trans() * t.trans.disp
                labels.append({
                    "name": t.string,
                    "gds_layer": "%d/%d" % (l, d),
                    "purpose": "pin" if d == 2 else "text",
                    "lef_layer": lef_layer,
                    "x_um": round(pt.x * ly.dbu, 4),
                    "y_um": round(pt.y * ly.dbu, 4),
                    "cell": it.cell().name,
                })
            it.next()
    return labels


def attach_metal(ly, top, labels, dbu):
    # Per-shape (unmerged) drawing boxes: the LEF PORT geometry must be the
    # exact rect the label sits on, NOT the bbox of the merged region (a
    # merged M1 polygon can be L-shaped and its bbox would wrongly swallow
    # neighbouring pins -- LVS already proved IN and VSS are not shorted).
    boxes = {}
    for (l, d), name in DRAW.items():
        li = ly.find_layer(l, d)
        if li is None:
            continue
        bl = []
        it = top.begin_shapes_rec(li)
        while not it.at_end():
            s = it.shape()
            if s.is_box() or s.is_polygon() or s.is_path():
                bl.append(it.trans() * s.polygon.bbox() if not s.is_box()
                          else it.trans() * s.box)
            it.next()
        boxes[name] = bl

    for lab in labels:
        pt = db.Point(int(round(lab["x_um"] / dbu)),
                      int(round(lab["y_um"] / dbu)))
        bl = boxes.get(lab["lef_layer"], [])
        hit = [b for b in bl if b.contains(pt)]
        src = "containing"
        if not hit:
            # label on a seam between abutting rects: nearest within 0.5 um
            best, bestd = None, None
            for b in bl:
                dx = max(b.left - pt.x, 0, pt.x - b.right)
                dy = max(b.bottom - pt.y, 0, pt.y - b.top)
                d2 = dx * dx + dy * dy
                if bestd is None or d2 < bestd:
                    bestd, best = d2, b
            if best is not None and bestd <= 500 * 500:
                hit, src = [best], "nearest_0.5um"
        lab["metal_bbox_um"] = (
            [round(hit[0].left * dbu, 4), round(hit[0].bottom * dbu, 4),
             round(hit[0].right * dbu, 4), round(hit[0].top * dbu, 4)]
            if hit else None
        )
        lab["metal_rects_um"] = [
            [round(b.left * dbu, 4), round(b.bottom * dbu, 4),
             round(b.right * dbu, 4), round(b.top * dbu, 4)] for b in hit
        ]
        lab["metal_source"] = src if hit else "none"


def main():
    ly = db.Layout()
    ly.read(GDS)
    dbu = ly.dbu
    top = ly.cell(TOP)
    if top is None:
        sys.exit("top cell %s not found" % TOP)

    labels = collect_labels(ly, top)
    attach_metal(ly, top, labels, dbu)

    by_name = {}
    for lab in labels:
        by_name.setdefault(lab["name"], []).append(lab)

    expected = set("EN%d_%d" % (k, j) for k in range(4) for j in range(127))
    expected.update(["IN", "OUT", "VDD", "VSS"])
    expected.update("TAP%d" % k for k in range(4))

    names = set(by_name)
    missing = sorted(expected - names)
    extra = sorted(names - expected)

    dup = {}
    for name, labs in by_name.items():
        seen = {}
        for lab in labs:
            key = (lab["gds_layer"], lab["purpose"])
            seen[key] = seen.get(key, 0) + 1
        real_dup = {"%s/%s" % k: v for k, v in seen.items() if v > 1}
        if real_dup:
            dup[name] = real_dup

    inconsistent = []
    no_metal = []
    for name, labs in by_name.items():
        bbs = {tuple(lab["metal_bbox_um"]) if lab["metal_bbox_um"] else None
               for lab in labs}
        if len(bbs) > 1:
            inconsistent.append(name)
        if any(lab["metal_bbox_um"] is None for lab in labs):
            no_metal.append(name)

    names_by_lef = {}
    for lab in labels:
        names_by_lef.setdefault(lab["lef_layer"], set()).add(lab["name"])

    counts_by_layer = {}
    for lab in labels:
        counts_by_layer[lab["gds_layer"]] = counts_by_layer.get(lab["gds_layer"], 0) + 1

    top_bb = top.bbox()
    chk = {
        "Metal1 == {IN,OUT,VDD,VSS}": names_by_lef.get("Metal1", set()) ==
            {"IN", "OUT", "VDD", "VSS"},
        "Metal2 == {TAP0..TAP3}": names_by_lef.get("Metal2", set()) ==
            {"TAP0", "TAP1", "TAP2", "TAP3"},
        "Metal3 EN count == 63 (E3 odd P-group)": len(
            names_by_lef.get("Metal3", set())) == 63 and
            all(n.startswith("EN3_") for n in names_by_lef.get("Metal3", set())),
        "EN total on M3+M4+M5 == 508": len(set().union(
            names_by_lef.get("Metal3", set()),
            names_by_lef.get("Metal4", set()),
            names_by_lef.get("Metal5", set()))) == 508,
        "M4+M5 staircase EN == 445": len(set().union(
            names_by_lef.get("Metal4", set()),
            names_by_lef.get("Metal5", set()))) == 445,
        # 508 EN + IN + OUT + 4 TAP + VDD + VSS = 516 (the lane brief's
        # "515" is an off-by-one; verified against build_line4.py: the four
        # boundary M1 labels IN/OUT/VDD/VSS are all present).
        "unique names == 516": len(names) == 516,
        "no missing": not missing,
        "no extra": not extra,
        "no duplicate same (layer,purpose)": not dup,
        "metal bbox consistent across pin/text purposes": not inconsistent,
        "every label sits on metal": not no_metal,
        "raw text count == 1032 (516 names x pin+text)": len(labels) == 1032,
    }

    summary = {
        "gds": GDS,
        "top_cell": TOP,
        "dbu_um": dbu,
        "top_bbox_um": [round(top_bb.left * dbu, 4), round(top_bb.bottom * dbu, 4),
                        round(top_bb.right * dbu, 4), round(top_bb.top * dbu, 4)],
        "size_um": [round(top_bb.width() * dbu, 4), round(top_bb.height() * dbu, 4)],
        "raw_label_texts": len(labels),
        "unique_names": len(names),
        "expected_names": len(expected),
        "missing": missing,
        "extra": extra,
        "duplicate_same_purpose": dup,
        "metal_bbox_inconsistent": sorted(inconsistent),
        "labels_without_metal": sorted(no_metal),
        "counts_by_gds_layer": counts_by_layer,
        "unique_names_by_lef_layer": {k: len(v) for k, v in sorted(names_by_lef.items())},
        "checks": chk,
    }

    with open(OUT, "w") as f:
        json.dump({"summary": summary, "labels": labels}, f, indent=1)

    print(json.dumps(summary, indent=1))
    ok = all(chk.values())
    print("ALL CHECKS PASS" if ok else "CHECK FAILURES PRESENT")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
