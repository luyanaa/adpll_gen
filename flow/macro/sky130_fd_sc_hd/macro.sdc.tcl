# Macro-level constraints for PLL_ANALOG_MACRO.
# These are planning values for P&R, not characterized DCO timing.

create_clock -name REF -period 20.000 [get_ports REF]
create_clock -name OUT -period 2.500 [get_ports OUT]
create_clock -name MID_OUT -period 2.500 [get_ports MID_OUT]
create_clock -name INJ_EDGE -period 20.000 [get_ports INJ_EDGE]

set_clock_groups -asynchronous \
    -group {REF} \
    -group {OUT} \
    -group {MID_OUT} \
    -group {INJ_EDGE}

set_clock_uncertainty -setup 0.250 [all_clocks]
set_clock_uncertainty -hold  0.050 [all_clocks]

# Quasi-static DCO control buses.
set_input_delay -max 5.000 -clock REF [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*] DCO_EN INJ_EN}]
set_input_delay -min 1.000 -clock REF [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*] DCO_EN INJ_EN}]

# SS-BBPD is sampled by the digital loop filter on negedge INJ_EDGE.
set_output_delay -max 2.000 -clock INJ_EDGE [get_ports {SS_BBPD[*]}]
set_output_delay -min 0.000 -clock INJ_EDGE [get_ports {SS_BBPD[*]}]

set_load 0.050 [all_outputs]
