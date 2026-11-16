# OpenSTA per-bank DCDL sensitivity sweep (sampled codes).
# Environment:
#   STD_LIB : ics55 stdcell Liberty
#   NETLIST : Yosys gate netlist of DCDL_RANGE_MEAS
read_liberty $env(STD_LIB)
read_verilog $env(NETLIST)
link_design DCDL_RANGE_MEAS

create_clock -name CLK_IN -period 5.0 [get_ports CLK_IN]
set_input_transition 0.05 [get_ports CLK_IN]

proc clear_all {} {
    foreach bank {COARSE_MUX MID_MUX FINE_MUX} {
        if {$bank == "FINE_MUX"} { set n 31 } else { set n 15 }
        for {set i 0} {$i < $n} {incr i} {
            set_case_analysis 0 [get_ports "${bank}\[$i\]"]
        }
    }
}

proc report_delay {tag} {
    puts "=== $tag ==="
    report_checks -unconstrained -path_delay min_max \
        -from [get_ports CLK_IN] -to [get_ports CLK_OUT] \
        -format full_clock_expanded
}

clear_all
report_delay "ZERO"

foreach bank {COARSE_MUX MID_MUX FINE_MUX} {
    if {$bank == "FINE_MUX"} {
        set codes {0 1 2 4 8 16 31}
    } else {
        set codes {0 1 2 4 8 15}
    }
    foreach code $codes {
        clear_all
        for {set i 0} {$i < $code} {incr i} {
            set_case_analysis 1 [get_ports "${bank}\[$i\]"]
        }
        report_delay "$bank $code"
    }
}
