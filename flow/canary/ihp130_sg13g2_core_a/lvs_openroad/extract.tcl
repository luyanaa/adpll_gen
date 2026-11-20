read_db /grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/runs/RUN_2026-11-20_09-19-04/final/odb/pll_macro_top.odb
if {[file exists /grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/runs/RUN_2026-11-20_09-19-04/final/sdc/pll_macro_top.sdc]} { read_sdc /grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/runs/RUN_2026-11-20_09-19-04/final/sdc/pll_macro_top.sdc }
write_cdl -masters {/grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/build/pdk_root/ihp-sg13g2/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl} /grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/lvs_openroad/pll_macro_top.cdl.raw
puts "CDL_WRITTEN"
exit
