source /home/yanlu/.ciel/ciel/gf180mcu/versions/792ef67037d74c8c51811eab3ce23cf793491296/gf180mcuD/libs.tech/librelane/config.tcl
# LibreLane 3: vendor defines CELL_LIBS as a Tcl dict; the flow needs LIB
# (list of liberty files keyed by corner glob).  Rebuild cleanly for the
# single tt corner this harness signs off at.
set ::env(LIB) [dict create "*_tt_025C_5v00" [list \
  "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/lib/$::env(STD_CELL_LIBRARY)__tt_025C_5v00.lib"]]
