#!/usr/bin/env python3
"""Build the merged Magic tech for IHP SG13G2 signoff work.

Why this file exists
--------------------
The IHP PDK ships its Magic collateral split across techs that cannot be used
individually for a full flow:

* `ihp-sg13g2-GDS.tech` is a complete tech (tech, planes, styles, types,
  contact, compose, connect, cifinput, cifoutput) but its `lef` section is
  absent, so Magic cannot match the LEF/DEF layer names used by the flow.
* `ihp-sg13g2.tech` has the `lef` section (Metal1, Via1, ...) but no
  cifinput/cifoutput, so it cannot read or write GDS.

This script concatenates the complete GDS tech with a `lef` section rewritten
to bind the LEF names to the names the GDS tech actually defines (MET1, VIA1,
MET2, ...).  Without that binding Magic rejects every routing layer:

    LEF read: Don't know how to parse layer "Metal1"
    LEF read: Try adding this name to the LEF techfile section

and then the DEF read drops the pins ("Pin specified without layer, was not
placed" x419), which is what left the written LEF as `MACRO (UNNAMED)`.

Idempotent: regenerates the file from the two sources each run.
"""
import re
import sys
from pathlib import Path

MAGIC = Path("/grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/build/pdk_root"
             "/ihp-sg13g2/libs.tech/magic")
GDS_TECH = MAGIC / "ihp-sg13g2-GDS.tech"
MAIN_TECH = MAGIC / "ihp-sg13g2.tech"
OUT_TECH = MAGIC / "ihp-sg13g2-signoff.tech"
OUT_RC = MAGIC / "ihp-sg13g2-signoff.magicrc"

# LEF name -> GDS tech layer name
LEF_MAP = [
    ("routing", "m1", "Metal1", "MET1"),
    ("routing", "m2", "Metal2", "MET2"),
    ("routing", "m3", "Metal3", "MET3"),
    ("routing", "m4", "Metal4", "MET4"),
    ("routing", "m5", "Metal5", "MET5"),
    ("routing", "m6", "TopMetal1", "MET6"),
    ("routing", "m7", "TopMetal2", "MET7"),
    ("cut", "via1", "Via1", "VIA1"),
    ("cut", "via2", "Via2", "VIA2"),
    ("cut", "via3", "Via3", "VIA3"),
    ("cut", "via4", "Via4", "VIA4"),
]


def gds_layer_names(tech: str) -> set[str]:
    """Layer names declared in the tech's cifinput section."""
    m = re.search(r"^cifinput\s*$", tech, re.M)
    if not m:
        return set()
    rest = tech[m.end():]
    end = re.search(r"^(cifoutput|lef|planes|tech|edit)\s*$", rest, re.M)
    body = rest[: end.start() if end else len(rest)]
    names = set()
    for line in body.splitlines():
        lm = re.match(r"\s*layer\s+(\S+)", line)
        if lm:
            names.add(lm.group(1))
    return names


def main() -> int:
    if not GDS_TECH.exists() or not MAIN_TECH.exists():
        print(f"missing source techs under {MAGIC}", file=sys.stderr)
        return 1
    gds = GDS_TECH.read_text()
    available = gds_layer_names(gds)
    if not available:
        print("no cifinput layers found in the GDS tech", file=sys.stderr)
        return 1

    # Format follows sky130A.tech, which is the reference Magic tech in this
    # container:
    #     routing m1  met1 MET1 m1
    # i.e. columns 2..N are all *tech layer names*, not LEF-style names.  Magic
    # resolves the LEF/DEF layer string against these columns; listing only
    # "Metal1" is what produced
    #     LEF read: Don't know how to parse layer "Metal1"
    lines = [
        "lef",
        "# LEF/DEF layer string -> tech layer name(s).",
        "# The IHP GDS tech calls its layers MET1, VIA1, MET2, ... while the LEF",
        "# and DEF say Metal1, Via1, Metal2, ...  Magic resolves the LEF string",
        "# against these columns (format taken from sky130A.tech):",
        "#     routing m1  met1 MET1 m1",
        "# Without the TECH column every routing layer is rejected and the DEF",
        "# read then drops the pins.",
    ]
    missing = []
    for kind, alias, lef_name, tech_name in LEF_MAP:
        if tech_name not in available:
            missing.append(tech_name)
            continue
        lines.append(f"{kind} {alias}\t{tech_name} {tech_name} {lef_name}")
    lef = "\n".join(lines) + "\n"

    OUT_TECH.write_text(gds.rstrip() + "\n\n" + lef)
    OUT_RC.write_text(
        "set techdir $env(PDK_ROOT)/ihp-sg13g2/libs.tech/magic\n"
        "tech load $techdir/ihp-sg13g2-signoff.tech\n"
        "tech unlock *\n"
    )
    print(f"wrote {OUT_TECH.name} ({OUT_TECH.stat().st_size} bytes)")
    print(f"wrote {OUT_RC.name}")
    print(f"  lef bindings: {len(LEF_MAP) - len(missing)}")
    if missing:
        print(f"  MISSING tech layers: {missing}", file=sys.stderr)
        return 1
    print("OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
