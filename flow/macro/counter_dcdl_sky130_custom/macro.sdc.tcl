# ADDLL_TOP: two clock domains.  TICK clocks the loop filter / lock
# counters; CLK_IN is the reference being delayed through the DCDL.
# They are asynchronous (PD front-end is a level latch), so group them.
create_clock -name TICK   -period 10.000 [get_ports TICK]
create_clock -name CLK_IN -period 10.000 [get_ports CLK_IN]
set_clock_groups -asynchronous -group {TICK} -group {CLK_IN}
set_clock_uncertainty -setup 0.100 [all_clocks]
set_clock_uncertainty -hold 0.020 [all_clocks]

# Control/config inputs are quasi-static, referenced to TICK.
set_input_delay -max 1.000 -clock TICK [get_ports {EN KI[*] PHASE_OFFS[*] DLY_INIT[*] RST_N}]
# The delayed output is a clock, not a synchronous data output.
set_output_delay -max 1.000 -clock TICK [get_ports {LOCKED ERR DLY_CODE[*]}]
set_load 0.020 [all_outputs]

# The PHASE_OFFS/DLY_INIT/KI config words feed the thermometer-decode
# chain (constant-divisor subtract/compare logic) into the delay-tap
# registers.  They change only while EN=0 and settle for many TICKs, so
# they are not single-cycle critical.  Give the decode paths 4 cycles.
set_multicycle_path 4 -setup -from [get_ports {PHASE_OFFS[*] DLY_INIT[*] KI[*]}]
set_multicycle_path 3 -hold  -from [get_ports {PHASE_OFFS[*] DLY_INIT[*] KI[*]}]

# The DCDL delay-line cells are quasi-static select structures, not a
# synchronous datapath: the tap code (coarse/mid/fine_n) only changes
# while EN=0 and settles over many TICKs before the edge is re-measured.
# The code feeds the stage MUX selects, and the select path ripples
# through the delay cells themselves (u_slow/u_sel/u_out).  These are
# analog-delay arcs, not single-cycle reg-reg paths — disable the DCDL
# stage cells for STA so the real reg-reg paths are checked.
foreach sub {u_slow u_sel u_out upp} {
    set_disable_timing [get_cells -hierarchical -regexp ".*\\.${sub}"]
}
# Also kill the legacy PLL_CELL-based coarse/fine stage internals.
set_disable_timing [get_cells -hierarchical -regexp {.*\.stage.*\.impl\..*impl}]
