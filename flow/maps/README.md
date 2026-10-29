# LEF/DEF layer maps

`ics55_lefdef.map` is a KLayout **LEF/DEF** map, not a GDS-import map.

Format:

```text
<LEF layer name> <purpose-list> <GDS layer> <GDS datatype>
```

Example:

```text
MET1 NET,PIN,LABEL,LEFPIN,LEFOBS,SPNET,VIA,BLOCKAGE 81 1
MET2 NET,PIN,LABEL,LEFPIN,LEFOBS,SPNET,VIA,BLOCKAGE 82 1
...
VIA1 VIA 91 1
```

The PDK file `libs.tech/klayout/tech/ics55.map` uses the GDS-import format
`<GDS layer> <datatype> <name>` and must **not** be passed to
`lefdef_config.map_file`.  Doing so silently drops DEF routing and SPNET
shapes onto auto layers (8/10/12/14/16), which invalidates KLayout DRC/LVS.

`settings.mk` points `PDK_KLAYOUT_MAPFILE` at this file for ics55.  The
`NAME <layer>/<purpose> <layer> <datatype>` entries keep pin/label text on the
same conductor layer as the pin geometry.
