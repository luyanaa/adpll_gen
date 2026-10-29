#!/usr/bin/env bash
# KLayout DEF->GDS + DRC/LVS runner for ETRI050.
# Usage: klayout_check.sh <input.def> <topcell> [outdir] [reference.cdl]
set -euo pipefail
def_file=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
topcell=$2
outdir=${3:-$(pwd)/klayout_out}
ref_cdl=${4:-}
pdk_root=${PDK_ROOT:-/grid/OpenRAM/technology}
pdk=${PDK:-ETRI050}
tech_lef="$pdk_root/$pdk/libs.ref/ETRI050_fd_sc_12t/lef/ETRI050_fd_sc_12t_tech_librelane.lef"
cell_lef="$pdk_root/$pdk/libs.ref/ETRI050_fd_sc_12t/lef/ETRI050_fd_sc_12t.lef"
cell_gds="$pdk_root/$pdk/libs.ref/ETRI050_fd_sc_12t/gds/ETRI050_fd_sc_12t.gds"
drc_deck="$pdk_root/$pdk/libs.tech/klayout/etri_05um_converted_final.drc"
lvs_deck="$pdk_root/$pdk/libs.tech/klayout/etri_05um.lvs"
mkdir -p "$outdir"
gds="$outdir/$topcell.gds"
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
[2, 3, 11, 12, 13, 14, 15].each { |ln| top.shapes(l.layer(ln, 0)).clear }
# KLayout DEF reader emits the LEF VIA macros on the LEF layer ordinals
# instead of the ETRI GDS layer numbers.  Remap them before streamout.
{"VIA_V12" => {11 => 32, 9 => 33, 10 => 34},
 "VIA_V23" => {11 => 34, 12 => 35, 13 => 36}}.each do |cname, mp|
  next unless l.cell(cname)
  c = l.cell(cname)
  mp.each do |old_ln, new_ln|
    src = l.layer(old_ln, 0); dst = l.layer(new_ln, 0)
    reg = RBA::Region::new(c.begin_shapes_rec(src))
    c.shapes(src).clear
    c.shapes(dst).insert(reg)
  end
end
l.write("$gds")
RUBY
klayout -b -r "$tmp_ruby"
klayout -b -r "$drc_deck" -rd gdsfile="$gds" -rd resultsfile="$outdir/drc.lyrdb"
if [[ -n "$ref_cdl" ]]; then
  klayout -b -r "$lvs_deck" -rd gdsfile="$gds" -rd circuit="$ref_cdl" \
    -rd topcell="$topcell" -rd reportfile="$outdir/lvs.lyrdb" \
    -rd netlistfile="$outdir/extracted.spice"
else
  klayout -b -r "$lvs_deck" -rd gdsfile="$gds" -rd topcell="$topcell" \
    -rd reportfile="$outdir/lvs.lyrdb" -rd netlistfile="$outdir/extracted.spice"
fi
