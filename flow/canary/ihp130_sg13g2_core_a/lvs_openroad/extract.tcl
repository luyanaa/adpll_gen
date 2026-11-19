read_db /grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/runs/RUN_2026-11-19_23-01-46/final/odb/pll_macro_top.odb
if {[file exists /grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/runs/RUN_2026-11-19_23-01-46/final/sdc/pll_macro_top.sdc]} { read_sdc /grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/runs/RUN_2026-11-19_23-01-46/final/sdc/pll_macro_top.sdc }
write_cdl -include_fillers -masters {/grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/build/pdk_root/ihp-sg13g2/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl} /grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/lvs_openroad/pll_macro_top.cdl
puts "CDL_WRITTEN"
exit
