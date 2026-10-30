#!/usr/bin/env bash
# KLayout DEF->GDS + DRC/LVS runner for ETRI050.
# Usage: klayout_check.sh <input.def> <topcell> [outdir] [reference.cdl]
set -euo pipefail
def_file=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
topcell=$2
outdir=${3:-$(pwd)/klayout_out}
ref_cdl=${4:-}
pdk_root=${PDK_ROOT:-/grid}
pdk=${PDK:-ETRI050}
tech_lef="$pdk_root/$pdk/libs.ref/ETRI050_fd_sc_12t/lef/ETRI050_fd_sc_12t_tech_librelane.lef"
# Prefer the project-local tech LEF (vendor via enclosure + no-stack rules).
script_dir=$(cd "$(dirname "$0")" && pwd)
[[ -f "$script_dir/tech/ETRI050_fd_sc_12t_tech_librelane.lef" ]] && \
  tech_lef="$script_dir/tech/ETRI050_fd_sc_12t_tech_librelane.lef"
cell_lef="$pdk_root/$pdk/libs.ref/ETRI050_fd_sc_12t/lef/ETRI050_fd_sc_12t.lef"
cell_gds="$pdk_root/$pdk/libs.ref/ETRI050_fd_sc_12t/gds/ETRI050_fd_sc_12t.gds"
cell_cdl="$pdk_root/$pdk/libs.ref/ETRI050_fd_sc_12t/cdl/ETRI050_fd_sc_12t.cdl"
drc_deck="$pdk_root/$pdk/libs.tech/klayout/etri_05um_converted_final.drc"
# Versioned copy of the KLayout LVS deck with the ETRI/Calibre semantics fixes.
# Fall back to the PDK copy only if the local deck is absent.
lvs_deck="$script_dir/etri_05um.lvs"
[[ -f "$lvs_deck" ]] || lvs_deck="$pdk_root/$pdk/libs.tech/klayout/etri_05um.lvs"
mkdir -p "$outdir"
gds="$outdir/$topcell.gds"
# The routed top CDL only instantiates the standard cells; the vendor cell CDL
# must be appended so the SPICE reader sees real named pins instead of treating
# each cell as an implicit black box with numeric pins 1..N.
lvs_ref=""
if [[ -n "$ref_cdl" ]]; then
  if [[ -f "$cell_cdl" ]]; then
    lvs_ref="$outdir/reference.cdl"
    cat "$ref_cdl" "$cell_cdl" > "$lvs_ref"
  else
    lvs_ref="$ref_cdl"
  fi
fi
tmp_ruby=$(mktemp --suffix=.rb)
trap "rm -f $tmp_ruby" EXIT
cat > "$tmp_ruby" <<RUBY
l = RBA::Layout::new
cfg = RBA::LEFDEFReaderConfiguration::new
cfg.lef_files = ["$tech_lef", "$cell_lef"]
cfg.read_lef_with_def = true
cfg.macro_layout_files = ["$cell_gds"]
cfg.produce_labels = true
cfg.produce_pins = true
opts = RBA::LoadLayoutOptions::new
opts.lefdef_config = cfg
l.read("$def_file", opts)
# Remove top-level LEF abstract device geometry; the real cell geometry lives
# in the standard-cell GDS.  Keeping the abstracts creates duplicate active
# shapes and false DRC/LVS devices at abutted cell boundaries.
top = l.top_cell
# The top cell contains LEF pin/via abstracts, not standard-cell device
# geometry.  Clear only the top-level device layers; do NOT clear 11/13,
# because KLayout maps the DEF MET2/MET3 routing to those ordinals.
[2, 3, 12, 14, 15].each { |ln| top.shapes(l.layer(ln, 0)).clear }
# KLayout maps LEF routing and pin layers to ordinals 9/11/13:
#   datatype 0 -> routing, datatype 2 -> pin abstracts.
# Move both onto the vendor GDS metal layers.
[[9, 0, 32], [11, 0, 34], [13, 0, 36],
 [9, 2, 32], [11, 2, 34], [13, 2, 36]].each do |old_ln, dt, new_ln|
  src = l.layer(old_ln, dt); dst = l.layer(new_ln, 0)
  top.shapes(src).each { |sh| top.shapes(dst).insert(sh) }
  top.shapes(src).clear
end
# Move each top-level pin label to the text layer of the metal it annotates.
# Do NOT copy one label onto all three text layers: that creates duplicate
# top-level pins (e.g. VDD and VDD$1) and makes strict LVS pin mapping fail.
[[9, 42], [11, 44], [13, 46]].each do |old_ln, txt_ln|
  src = l.layer(old_ln, 1); dst = l.layer(txt_ln, 0)
  top.shapes(src).each do |sh|
    next unless sh.is_text?
    top.shapes(dst).insert(sh)
  end
  top.shapes(src).clear
end
# KLayout DEF reader emits the LEF VIA macros on the LEF layer ordinals
# instead of the ETRI GDS layer numbers.  Remap them before streamout.
{"VIA_V12" => {9 => 32, 10 => 33, 11 => 34},
 "VIA_V23" => {11 => 34, 12 => 35, 13 => 36}}.each do |cname, mp|
  next unless l.cell(cname)
  c = l.cell(cname)
  mp.each do |old_ln, new_ln|
    src = l.layer(old_ln, 0); dst = l.layer(new_ln, 0)
    c.shapes(src).each { |sh| c.shapes(dst).insert(sh) }
    c.shapes(src).clear
  end
end
# KLayout's deep LVS does not reliably propagate connectivity through the
# one-pin LEF VIA macro cells.  Flatten only those via instances into the top
# cell; standard-cell instances stay hierarchical.
via_cells = ["VIA_V12", "VIA_V23"]
keep_insts = []
via_insts = []
top.each_inst do |inst|
  if via_cells.include?(inst.cell.name)
    via_insts << [inst.cell, inst.trans]
  else
    keep_insts << [inst.cell, inst.trans]
  end
end
via_insts.each do |cell, trans|
  l.flatten_into(cell.cell_index, top.cell_index, RBA::ICplxTrans::new(trans), 1)
end
top.clear_insts
keep_insts.each do |cell, trans|
  top.insert(RBA::CellInstArray::new(cell, trans))
end
via_cells.each do |cn|
  c = l.cell(cn)
  l.delete_cell(c.cell_index) if c
end
l.write("$gds")
RUBY
klayout -b -r "$tmp_ruby"
klayout -b -r "$drc_deck" -rd gdsfile="$gds" -rd resultsfile="$outdir/drc.lyrdb"
if [[ -n "$lvs_ref" ]]; then
  klayout -b -r "$lvs_deck" -rd gdsfile="$gds" -rd circuit="$lvs_ref" \
    -rd topcell="$topcell" -rd reportfile="$outdir/lvs.lyrdb" \
    -rd netlistfile="$outdir/extracted.spice"
else
  klayout -b -r "$lvs_deck" -rd gdsfile="$gds" -rd topcell="$topcell" \
    -rd reportfile="$outdir/lvs.lyrdb" -rd netlistfile="$outdir/extracted.spice"
fi
