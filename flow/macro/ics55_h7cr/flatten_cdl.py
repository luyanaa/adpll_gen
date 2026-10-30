#!/usr/bin/env python3
"""Flatten a hierarchical CDL/SPICE netlist with parameter substitution.

KLayout's LVS SPICE reader does not resolve parameters on subcircuit
instances (the ics55 cell CDL uses W=nw/L=nl with nw/nl/pw/pl passed by the
parent).  This script expands every X instance recursively and emits a flat
SUBCKT containing only M devices, so KLayout can compare device sizes.

Usage:
  python3 flatten_cdl.py --cells cells.cdl --macro macro.cdl \
      --top PLL_ANALOG_MACRO --out flat.spice [--drop-top-ports VDD VSS]
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from typing import Any

IDENT = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def join_continuations(path: Path) -> list[str]:
    lines: list[str] = []
    for raw in path.read_text(errors="ignore").splitlines():
        line = raw.rstrip()
        if not line or line.lstrip().startswith("*"):
            continue
        if line.lstrip().startswith("+"):
            if not lines:
                raise ValueError(f"orphan continuation in {path}: {line}")
            lines[-1] += " " + line.lstrip()[1:].strip()
        else:
            lines.append(line.strip())
    return lines


def parse_cdl(path: Path) -> dict[str, dict[str, Any]]:
    lines = join_continuations(path)
    subckts: dict[str, dict[str, Any]] = {}
    current: dict[str, Any] | None = None
    for line in lines:
        upper = line.upper()
        if upper.startswith(".SUBCKT"):
            parts = line.split()
            if current is not None:
                raise ValueError(f"nested SUBCKT in {path}: {line}")
            current = {"name": parts[1], "ports": parts[2:], "body": []}
        elif upper.startswith(".ENDS"):
            if current is None:
                raise ValueError(f"ENDS without SUBCKT in {path}")
            subckts[current["name"]] = current
            current = None
        elif current is not None:
            current["body"].append(line)
    if current is not None:
        raise ValueError(f"unterminated SUBCKT {current['name']} in {path}")
    return subckts


def parse_params(tokens: list[str], inherited: dict[str, Any]) -> dict[str, Any]:
    out = dict(inherited)
    for tok in tokens:
        if "=" not in tok:
            continue
        key, val = tok.split("=", 1)
        out[key] = resolve(val, out)
    return out


def resolve(value: str, params: dict[str, Any]) -> Any:
    value = value.strip().strip("'\"")
    if value in params:
        return params[value]
    if IDENT.match(value):
        return params.get(value, value)
    return value


def parse_x(
    line: str, params: dict[str, Any], known: set[str]
) -> tuple[list[str], str, dict[str, Any]]:
    toks = line.split()
    # Cell CDL uses "Xname nodes / CELL params"; OpenROAD write_cdl uses
    # "Xname nodes CELL" (no slash).  The instance name itself may contain '/',
    # so only an exact '/' token is the CDL separator.
    if "/" in toks[1:]:
        idx = toks.index("/", 1)
        nodes = toks[1:idx]
        if idx + 1 >= len(toks):
            raise ValueError(f"missing cell name: {line}")
        cell = toks[idx + 1]
        inst_params = parse_params(toks[idx + 2 :], params)
        return nodes, cell, inst_params
    for idx, tok in enumerate(toks[1:], start=1):
        if tok in known:
            nodes = toks[1:idx]
            cell = tok
            inst_params = parse_params(toks[idx + 1 :], params)
            return nodes, cell, inst_params
    raise ValueError(f"cannot find cell name in X line: {line}")


def parse_m(
    line: str, map_node: Any, params: dict[str, Any], prefix: str = ""
) -> str:
    toks = line.split()
    if len(toks) < 6:
        raise ValueError(f"short M device: {line}")
    name, nd, ng, ns, nb, model = toks[:6]
    # Flattened cells repeat device names (MMN0, MMP0, ...); make them unique.
    global dev_counter
    dev_counter += 1
    name = f"M{dev_counter}_{name[1:]}"
    out = [name, map_node(nd), map_node(ng), map_node(ns), map_node(nb), model]
    for tok in toks[6:]:
        if "=" not in tok:
            out.append(tok)
            continue
        k, v = tok.split("=", 1)
        v = resolve(v, params)
        out.append(f"{k}={v}")
    return " ".join(out)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cells", type=Path, required=True)
    ap.add_argument("--macro", type=Path, required=True)
    ap.add_argument("--top", default="PLL_ANALOG_MACRO")
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--drop-top-ports", nargs="*", default=[])
    ap.add_argument("--preserve-top-nets", action="store_true",
                    help="Keep top-level internal net names (for SPEF/PEX back-annotation)")
    args = ap.parse_args()

    subckts = parse_cdl(args.cells)
    subckts.update(parse_cdl(args.macro))
    if args.top not in subckts:
        raise SystemExit(f"top {args.top} not found")

    devices: list[str] = []
    node_id = 0
    global dev_counter
    dev_counter = 0

    def new_node() -> str:
        nonlocal node_id
        node_id += 1
        return f"n{node_id}"

    def expand(cell: str, port_nodes: list[str], params: dict[str, Any], path: str, depth: int = 0) -> None:
        nonlocal devices
        if depth > 40:
            raise ValueError(f"recursion too deep at {path}/{cell}")
        sub = subckts.get(cell)
        if sub is None:
            raise ValueError(f"unknown cell {cell} at {path}")
        if len(port_nodes) != len(sub["ports"]):
            raise ValueError(
                f"{path}/{cell}: port count {len(port_nodes)} != {len(sub['ports'])}"
            )
        node_map = dict(zip(sub["ports"], port_nodes))
        # Every internal net must be unique per instance.  Do not leave a
        # device's internal node as its cell-local name: otherwise all
        # instances of the same cell are shorted together.
        local_nodes: dict[str, str] = {}
        global_nodes = {"VDD", "VSS"}

        def map_node(n: str) -> str:
            if n in node_map:
                return node_map[n]
            if n in global_nodes:
                return n
            if n not in local_nodes:
                # For PEX back-annotation keep the top-level net names
                # (coarse/FCHAIN_..., mid/..., fine/...); child-cell internal
                # nets must still be uniquified.
                local_nodes[n] = n if (args.preserve_top_nets and depth == 0) else new_node()
            return local_nodes[n]

        local = dict(params)
        for line in sub["body"]:
            if not line or line.startswith("*"):
                continue
            if line.upper().startswith(".PININFO"):
                continue
            if line.upper().startswith(".PARAM"):
                local = parse_params(line.split()[1:], local)
                continue
            if line[0] in "Xx":
                nodes, child, cparams = parse_x(line, local, set(subckts))
                child_nodes = [map_node(n) for n in nodes]
                expand(child, child_nodes, cparams, f"{path}/{cell}", depth + 1)
            elif line[0] in "Mm":
                devices.append(parse_m(line, map_node, local))
            else:
                raise ValueError(f"unsupported line in {path}/{cell}: {line}")

    top = subckts[args.top]
    ports = [p for p in top["ports"] if p not in set(args.drop_top_ports)]
    top_nodes = [p if p in ports else new_node() for p in top["ports"]]
    # Top-level nodes for dropped ports still exist internally but are not exported.
    expand(args.top, top_nodes, {}, "top")
    out = [f".SUBCKT {args.top} {' '.join(ports)}"]
    out.extend(devices)
    out.append(f".ENDS {args.top}")
    args.out.write_text("\n".join(out) + "\n")
    print(f"wrote {args.out}: {len(devices)} devices, {len(ports)} top ports")
    return 0


if __name__ == "__main__":
    sys.exit(main())
