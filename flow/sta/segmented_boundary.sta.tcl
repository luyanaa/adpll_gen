# OpenSTA 4-segment DCDL continuity around coarse x 56 boundaries.
# Environment:
#   STD_LIB : ics55 stdcell Liberty
#   NETLIST : Yosys gate netlist of SEGMENTED_DELAY4_MEAS
read_liberty $env(STD_LIB)
read_verilog $env(NETLIST)
link_design SEGMENTED_DELAY4_MEAS

create_clock -name CLK_IN -period 5.0 [get_ports CLK_IN]
set_input_transition 0.05 [get_ports CLK_IN]

proc clear_code {} {
    set_case_analysis 0 [get_ports {COARSE[*]}]
    set_case_analysis 0 [get_ports {FINE[*]}]
}

proc set_code {c f} {
    clear_code
    for {set i 0} {$i < 3} {incr i} {
        if {(($c >> $i) & 1) != 0} {
            set_case_analysis 1 [get_ports "COARSE\[$i\]"]
        }
    }
    for {set i 0} {$i < 6} {incr i} {
        if {(($f >> $i) & 1) != 0} {
            set_case_analysis 1 [get_ports "FINE\[$i\]"]
        }
    }
    puts "=== CODE [expr {$c * 56 + $f}] $c $f ==="
    report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
        -to [get_ports CLK_OUT] -format full_clock_expanded
}

set_code 0 0
set_code 0 54
set_code 0 55
set_code 1 0
set_code 1 1
set_code 1 54
set_code 1 55
set_code 2 0
set_code 2 1
set_code 2 54
set_code 2 55
set_code 3 0
set_code 3 1
set_code 3 54
set_code 3 55
set_code 4 0
set_code 4 1
set_code 4 55
