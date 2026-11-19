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

    # cifinput column 1 must be a name `planes` declares.  The IHP planes
    # section says "metal1,m1", while cifinput says "layer MET1 ..." -- a GDS
    # stream name with no plane behind it.  The tech LEF in turn says
    # "LAYER Metal1", which then matches nothing:
    #
    #   LEF read: Don't know how to parse layer "Metal1"
    #
    # sky130 does it consistently: planes "metal1,m1", cifinput "layer m1",
    # tech LEF "LAYER met1".  So rename each routing layer's cifinput entry to
    # the plane alias and keep the GDS name and LEF spelling as extra names.
    plane = {}
    pm = re.search(r"^planes\s*$", gds, re.M)
    if pm:
        rest = gds[pm.end():]
        pend = re.search(
            r"^(tech|styles|types|contact|compose|connect|cifinput|lef|edit)\s*$",
            rest, re.M)
        for line in rest[: pend.start() if pend else len(rest)].splitlines():
            names = [n.strip() for n in line.strip().split(",") if n.strip()]
            if len(names) == 2 and re.match(r"^(metal|via)\d+$", names[0]):
                plane[names[0]] = names[1]          # metal1 -> m1, via1 -> v1

    for _kind, _alias, _lef_name, _tech_name in LEF_MAP:
        if _tech_name not in available:
            continue
        # MET1 -> metal1 -> m1
        plane_key = _tech_name.replace("MET", "metal").replace("VIA", "via")
        plane_key = re.sub(r"(metal|via)$", r"\g<1>" + "1", plane_key) \
            if plane_key in ("metal", "via") else plane_key
        if plane_key not in plane:
            plane_key = {"MET1": "metal1", "MET2": "metal2", "MET3": "metal3",
                         "MET4": "metal4", "MET5": "metal5", "MET6": "metal6",
                         "MET7": "metal7", "VIA1": "via1", "VIA2": "via2",
                         "VIA3": "via3", "VIA4": "via4"}.get(_tech_name, "")
        newname = plane.get(plane_key, _tech_name)
        pat = re.compile(r"^(\s*layer\s+)" + re.escape(_tech_name) + r"(\s+)([^\n]*)$", re.M)

        def _repl(m, newname=newname, lef=_lef_name, tech=_tech_name):
            keep = [n.strip() for n in m.group(3).split(",") if n.strip()]
            for extra in (tech, lef):
                if extra not in keep:
                    keep.append(extra)
            return f"{m.group(1)}{newname}{m.group(2)}" + ",".join(keep)

        gds, n = pat.subn(_repl, gds)
        if n == 0:
            print(f"WARNING: no cifinput layer line for {_tech_name}", file=sys.stderr)

    # ---------------------------------------------------------------------
    # GDS layer numbers
    # ---------------------------------------------------------------------
    # The routed GDS stores layers as bare numbers (8/0, 10/0, 19/0, ...) with
    # no embedded names, while the tech identifies layers by name, so
    # "gds read" rejects them:
    #   Error while reading cell ...: Unknown layer/datatype in boundary,
    #                                  layer=8 type=0
    # Magic binds a number to a name with the `calma` sub-command of a
    # cifinput layer entry (nmos.tech: `layer NM metal,pmc,dmc,glass` then
    # `calma 3 1`).  The authoritative number->name table is KLayout's layer
    # properties file, which the IHP PDK ships.
    calma_lines = []
    lyp = MAGIC.parent / "klayout/tech/sg13g2.lyp"   # MAGIC = .../libs.tech/magic
    if lyp.exists():
        lyp_text = lyp.read_text()
        number_name = {}
        for blk in re.findall(r"<properties>.*?</properties>", lyp_text, re.S):
            src = re.search(r"<source>(\d+)/(\d+)</source>", blk)
            nm = re.search(r"<name>([^<.]+)\.", blk)
            if src and nm:
                number_name.setdefault(int(src.group(1)), nm.group(1))
        # map the KLayout name (Metal1) to the tech layer name we just bound
        lef_to_tech = {lef: tech for _k, _a, lef, tech in LEF_MAP}
        seen = set()
        for num, kname in sorted(number_name.items()):
            tech = lef_to_tech.get(kname)
            if tech is None or tech not in available or tech in seen:
                continue
            seen.add(tech)
            calma_lines.append(f"  calma {tech} {num} 0")
        if calma_lines:
            gds = gds.rstrip() + (
                "\n\n# GDS layer numbers (from klayout/tech/sg13g2.lyp); the routed\n"
                "# GDS carries numbers only, so each must be bound to a tech layer.\n"
                + "\n".join(calma_lines) + "\n"
            )
            print(f"  calma bindings: {len(calma_lines)}")
    else:
        print(f"  WARNING: no layer properties at {lyp}", file=sys.stderr)

    lines = [
        "lef",
        "# Format from sky130A.tech:  routing m1  met1 MET1 m1",
        "# Columns after the alias are accepted spellings for the layer.  The",
        "# tech LEF used by this flow says Metal1/Via1/..., the tech file's",
        "# cifinput says MET1/VIA1/..., and planes names them metal1/m1, so all",
        "# three spellings are listed on one line.",
    ]
    missing = []
    for kind, alias, lef_name, tech_name in LEF_MAP:
        if tech_name not in available:
            missing.append(tech_name)
            continue
        lines.append(f"{kind} {alias}\t{tech_name} {lef_name}")
    lines.append("end")
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
