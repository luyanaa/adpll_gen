#!/usr/bin/env python3
"""Remove SDF blocks Icarus's SDF parser rejects (COND, TIMINGCHECK)."""
import sys

def strip_group(text: str, tag: str) -> str:
    out = []
    i = 0
    n = len(text)
    while i < n:
        j = text.find(tag, i)
        if j < 0:
            out.append(text[i:])
            break
        out.append(text[i:j])
        depth = 0
        k = j
        while k < n:
            if text[k] == '(':
                depth += 1
            elif text[k] == ')':
                depth -= 1
                if depth == 0:
                    k += 1
                    break
            k += 1
        i = k
    return ''.join(out)

def main() -> int:
    if len(sys.argv) != 3:
        print("usage: strip_sdf_cond.py <in.sdf> <out.sdf>")
        return 2
    text = open(sys.argv[1], encoding="utf-8").read()
    text = strip_group(text, "(COND")
    text = strip_group(text, "(TIMINGCHECK")
    text = strip_group(text, '(CELL\n  (CELLTYPE "DLL_FULL_PERIOD_TOP")')
    text = strip_group(text, '(CELL\n  (CELLTYPE "DLL_ACQ_PERIOD")')
    open(sys.argv[2], "w", encoding="utf-8").write(text)
    print(f"wrote {sys.argv[2]}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
