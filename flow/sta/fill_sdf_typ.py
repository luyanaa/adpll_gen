#!/usr/bin/env python3
"""Fill empty SDF typical values written by OpenSTA (min::max)."""
import re
import sys

def repl(m):
    a, b = float(m.group(1)), float(m.group(2))
    t = (a + b) / 2.0
    return f"({a:.6f}:{t:.6f}:{b:.6f})"

def main() -> int:
    if len(sys.argv) != 3:
        print("usage: fill_sdf_typ.py <in.sdf> <out.sdf>")
        return 2
    text = open(sys.argv[1], encoding="utf-8").read()
    out = re.sub(r"\(([0-9]+\.[0-9]+)::([0-9]+\.[0-9]+)\)", repl, text)
    open(sys.argv[2], "w", encoding="utf-8").write(out)
    print(f"wrote {sys.argv[2]}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
