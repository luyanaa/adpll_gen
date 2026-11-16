#!/usr/bin/env python3
"""Remove SDF blocks Icarus's SDF parser rejects (COND, TIMINGCHECK).

COND is unwrapped rather than deleted: OpenSTA writes flop CK->Q and RN->Q
arcs under COND, and deleting them left the flop CELL empty (and therefore
dropped), so the period-capture flops had no SDF timing.
"""
import re
import sys


def unwrap_cond(text: str) -> str:
    """Replace (COND <expr> (IOPATH ...) ...) with its child groups."""
    out = []
    i = 0
    n = len(text)
    while True:
        j = text.find("(COND", i)
        if j < 0:
            out.append(text[i:])
            break
        out.append(text[i:j])
        depth = 0
        k = j
        while k < n:
            if text[k] == "(":
                depth += 1
            elif text[k] == ")":
                depth -= 1
                if depth == 0:
                    break
            k += 1
        body = text[j + 5:k]
        m = re.search(r"\((IOPATH|PORT|COND)\b", body)
        if m:
            child = body[m.start():]
            out.append(unwrap_cond(child))
        i = k + 1
    return "".join(out)

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

def strip_empty_cells(text: str) -> str:
    """Drop CELL blocks that carry no numeric delays (Icarus rejects empty
    (ABSOLUTE) blocks)."""
    out = []
    i = 0
    n = len(text)
    tag = "(CELL\n"
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
        block = text[j:k]
        import re
        if re.search(r"[0-9]+\.[0-9]+", block):
            out.append(block)
        i = k
    return ''.join(out)

def main() -> int:
    if len(sys.argv) != 3:
        print("usage: strip_sdf_cond.py <in.sdf> <out.sdf>")
        return 2
    text = open(sys.argv[1], encoding="utf-8").read()
    text = unwrap_cond(text)
    text = strip_group(text, "(TIMINGCHECK")
    text = strip_group(text, '(CELL\n  (CELLTYPE "DLL_FULL_PERIOD_TOP")')
    text = strip_empty_cells(text)
    open(sys.argv[2], "w", encoding="utf-8").write(text)
    print(f"wrote {sys.argv[2]}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
