#!/usr/bin/env python3
"""Apply an explicit cell-internal DRC waiver and report remaining items.

Only items whose KLayout cell tag is NOT the top cell are eligible.  A top
level item can never be waived by this script.
"""
from __future__ import annotations

import argparse
import collections
import fnmatch
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--lyrdb", type=Path, required=True)
    ap.add_argument("--waiver", type=Path, required=True)
    ap.add_argument("--top", default="PLL_ANALOG_MACRO")
    ap.add_argument("--instances", type=Path, default=None,
                    help="JSON from dump_instances.rb for top-tagged NP holes")
    ap.add_argument("--json-out", type=Path, required=True)
    ap.add_argument("--md-out", type=Path, required=True)
    args = ap.parse_args()

    waiver = json.loads(args.waiver.read_text())
    rules = waiver.get("waivers", [])
    instances = json.loads(args.instances.read_text()) if args.instances else []
    root = ET.parse(args.lyrdb).getroot()
    items = root.findall(".//item")

    waived = collections.Counter()
    remaining = collections.Counter()
    unwaived_examples = []
    for it in items:
        cell = (it.findtext("cell") or "?").split(":")[0]
        cat = (it.findtext("category") or "?").strip("'\"")
        is_cell = cell != args.top
        if not is_cell and instances:
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
                    cell = best["cell"]
                    is_cell = True
        matched = None
        if is_cell:
            for r in rules:
                if r.get("scope") != "cell_internal":
                    continue
                cells = r.get("cells", [])
                cats = r.get("categories", [])
                if not any(fnmatch.fnmatch(cell, c) for c in cells):
                    continue
                if not any(fnmatch.fnmatch(cat, c) for c in cats):
                    continue
                matched = r.get("id", "unnamed")
                break
        if matched:
            waived[(matched, cell, cat)] += 1
        else:
            remaining[("top" if not is_cell else "cell", cell, cat)] += 1
            if len(unwaived_examples) < 10:
                unwaived_examples.append((cell, cat, it.findtext("values/value", "")))

    waived_by_rule = collections.Counter()
    for (rule, _cell, _cat), n in waived.items():
        waived_by_rule[rule] += n

    out = {
        "lyrdb": str(args.lyrdb),
        "waiver": str(args.waiver),
        "top": args.top,
        "total": len(items),
        "waived": sum(waived.values()),
        "remaining": sum(remaining.values()),
        "waived_by_rule": dict(waived_by_rule),
        "remaining_by_cell_category": {f"{k[0]}:{k[1]}:{k[2]}": v for k, v in remaining.items()},
    }
    args.json_out.write_text(json.dumps(out, indent=2) + "\n")

    lines = [
        "# DRC waiver report",
        "",
        f"- total: **{len(items)}**",
        f"- waived (cell-internal): **{sum(waived.values())}**",
        f"- remaining: **{sum(remaining.values())}**",
        "",
        "## Remaining items",
        "",
        "| Scope | Cell | Category | Count |",
        "|---|---|---|---|",
    ]
    for (scope, cell, cat), n in remaining.most_common():
        lines.append(f"| {scope} | {cell} | {cat} | {n} |")
    if not remaining:
        lines.append("| — | — | — | 0 |")
    lines += ["", "## Waived groups", "", "| Rule | Count |", "|---|---|"]
    for rule, n in waived_by_rule.most_common():
        lines.append(f"| {rule} | {n} |")
    args.md_out.write_text("\n".join(lines) + "\n")
    print(f"total={len(items)} waived={sum(waived.values())} remaining={sum(remaining.values())}")
    return 0 if not remaining else 1


if __name__ == "__main__":
    raise SystemExit(main())
