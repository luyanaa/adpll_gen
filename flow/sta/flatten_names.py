#!/usr/bin/env python3
"""Flatten Yosys escaped hierarchical names in a gate netlist and its SDF.

Yosys keeps flattened cell instance names as escaped identifiers that still
contain dots and brackets (e.g. \\tdc_phys.u_tdc.u_acq.phys.stage[0].u_cell).
Icarus reads an SDF INSTANCE "a.b[0].c" as hierarchy, so it can never annotate
those cells.  This renames every escaped identifier to a plain flat identifier
and rewrites the SDF INSTANCE names with the same mapping.
"""
import re
import sys


def flat(name: str) -> str:
    return re.sub(r"[^A-Za-z0-9_]", "_", name)


def main() -> int:
    if len(sys.argv) != 4:
        print("usage: flatten_names.py <net.v> <in.sdf> <out_prefix>")
        return 2
    net_path, sdf_path, prefix = sys.argv[1:4]
    net = open(net_path, encoding="utf-8").read()

    names = sorted(set(re.findall(r"\\([^\s]+)", net)))
    mapping = {}
    used = set()
    for n in names:
        f = flat(n)
        base = f
        k = 1
        while f in used:
            f = f"{base}_{k}"
            k += 1
        used.add(f)
        mapping[n] = f

    net = re.sub(r"\\([^\s]+)", lambda m: mapping[m.group(1)], net)
    open(prefix + "_net.v", "w", encoding="utf-8").write(net)

    sdf = open(sdf_path, encoding="utf-8").read()

    def inst(m):
        raw = m.group(1).strip()
        plain = raw.replace("\\", "")
        if plain in mapping:
            return "(INSTANCE " + mapping[plain] + ")"
        return m.group(0)

    sdf = re.sub(r"\(INSTANCE\s+([^\)]+)\)", inst, sdf)
    open(prefix + "_sdf.sdf", "w", encoding="utf-8").write(sdf)
    print(f"renamed {len(mapping)} escaped names -> {prefix}_net.v / {prefix}_sdf.sdf")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
