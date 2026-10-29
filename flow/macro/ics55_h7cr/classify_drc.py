#!/usr/bin/env python3
"""Classify a KLayout .lyrdb into top-level vs standard-cell-internal DRC.

7T library cells can carry their own DRC violations.  This script keeps those
separate from macro-level (PLL_ANALOG_MACRO) violations so a library issue is
not attributed to the macro layout.
"""

from __future__ import annotations

import argparse
import collections
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--lyrdb", type=Path, required=True)
    ap.add_argument("--top", default="PLL_ANALOG_MACRO")
    ap.add_argument("--instances", type=Path, default=None,
                    help="JSON from dump_instances.rb; maps top-tagged geometry "
                         "inside a std-cell instance to that cell.")
    ap.add_argument("--via-prefix", default="VIA_",
                    help="instance cells with this prefix are LEF via cells, "
                         "counted as top-level/via, not standard cells.")
    ap.add_argument("--json-out", type=Path, default=Path("drc_summary.json"))
    ap.add_argument("--md-out", type=Path, default=Path("drc_summary.md"))
    args = ap.parse_args()

    instances: list[dict] = []
    if args.instances:
        instances = json.loads(args.instances.read_text())
    root = ET.parse(args.lyrdb).getroot()
    items = root.findall(".//item")
    by_class = collections.Counter()
    by_cat = {k: collections.Counter() for k in ("top", "via", "cell")}
    by_cell = collections.Counter()
    for it in items:
        cell = it.findtext("cell") or "?"
        cat = it.findtext("category") or "?"
        base = cell.split(":")[0]
        cls = "top" if base == args.top else "cell"
        owner = base
        if cls == "top" and instances:
            value = it.findtext("values/value") or ""
            nums = [float(x) for x in re.findall(r"-?\d+(?:\.\d+)?", value)]
            if len(nums) >= 4:
                xs, ys = nums[0::2], nums[1::2]
                bx0, bx1 = min(xs), max(xs)
                by0, by1 = min(ys), max(ys)
                best = None
                for inst in instances:
                    x0, y0, x1, y1 = inst["bbox"]
                    if x0 <= bx0 and y0 <= by0 and x1 >= bx1 and y1 >= by1:
                        if best is None or inst["depth"] > best["depth"]:
                            best = inst
                if best is not None:
                    if best["cell"].startswith(args.via_prefix):
                        cls = "via"
                    else:
                        cls = "cell"
                    owner = best["cell"]
        by_class[cls] += 1
        by_cat[cls][cat] += 1
        if cls in ("cell", "via"):
            by_cell[(cls, owner)] += 1

    out = {
        "lyrdb": str(args.lyrdb),
        "top": args.top,
        "total": len(items),
        "top_level": by_class["top"],
        "via_level": by_class["via"],
        "cell_internal": by_class["cell"],
        "top_categories": dict(by_cat["top"].most_common()),
        "via_categories": dict(by_cat["via"].most_common()),
        "cell_categories": dict(by_cat["cell"].most_common()),
        "cells": {f"{k[0]}:{k[1]}": v for k, v in by_cell.most_common()},
    }
    args.json_out.write_text(json.dumps(out, indent=2) + "\n")

    lines = [
        "# DRC classification",
        "",
        f"- total: **{len(items)}**",
        f"- top-level macro (`{args.top}`): **{by_class['top']}**",
        f"- via-cell / LEF-via: **{by_class['via']}**",
        f"- standard-cell internal: **{by_class['cell']}**",
        ("- classification uses absolute instance boxes from "
         "`dump_instances.rb` for top-tagged geometry." if args.instances else ""),
        "",
        "## Top-level categories",
        "",
        "| Category | Count |",
        "|---|---|",
    ]
    for k, v in by_cat["top"].most_common():
        lines.append(f"| {k} | {v} |")
    lines += ["", "## Cell-internal categories", "", "| Category | Count |", "|---|---|"]
    for k, v in by_cat["cell"].most_common():
        lines.append(f"| {k} | {v} |")
    lines += ["", "## Via-cell categories", "", "| Category | Count |", "|---|---|"]
    for k, v in by_cat["via"].most_common():
        lines.append(f"| {k} | {v} |")
    lines += ["", "## Cells with internal violations", "", "| Class:Cell | Count |", "|---|---|"]
    for k, v in by_cell.most_common():
        lines.append(f"| {k[0]}:{k[1]} | {v} |")
    args.md_out.write_text("\n".join(lines) + "\n")
    print(f"total={len(items)} top={by_class['top']} cell={by_class['cell']}")
    print(f"wrote {args.json_out}, {args.md_out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
