# CDR_TOP (IHP SG13G2) — SerDes CDR_MODE=4 analog back end.
#
# Two clocks, and they are genuinely different in kind:
#
#   REF      the reference / sample clock, 100 MHz (10 ns).  Everything
#            digital in this macro runs on it: the tap register, the phase-mux
#            parking FSM and the sampler hand-off.
#   REC_CLK  the selected phase of the multi-phase DCO.  It is an OUTPUT
#            clock (it drives the external sampler in the real part; here it
#            is observed), so it must be declared as a generated clock and
#            must not be timed as a data output.
#
# Contract: ../OpenSERDES/rtl/serdes_rx_digital.sv (CDR_MODE=4),
#           ../OpenSERDES/rtl/cdr_multiphase.sv, docs/dll_backend.md §2.

create_clock -name REF -period 10.000 [get_ports REF]

# REC_CLK is phase[mux_ready ? tap : parked], i.e. the same frequency as the
# DCO period, not as REF.  Anchor it on the DCO output so STA puts the mux and
# the sampler in the right domain.
# REC_CLK is a top-level OUTPUT of this macro: the selected phase leaves the
# block and drives the external sampler.  Anchoring on the port is both stable
# across ABC renaming (the internal closing-gate pin is renamed to an anonymous
# `_xxxx_p_Pin`, so a pin-based anchor silently finds nothing) and correct for
# the contract, which only ever consumes REC_CLK at the boundary.
create_generated_clock -name REC_CLK \
    -source [get_ports REF] \
    -divide_by 1 \
    [get_ports REC_CLK]

# REF and REC_CLK come from different oscillators (the DCO is free-running
# relative to REF), so they are asynchronous.  Declaring them as one group
# would make STA check the sampler hand-off against a phase that does not
# exist, and the loop would never close.
set_clock_groups -asynchronous -group {REF} -group {REC_CLK}

set_clock_uncertainty -setup 0.250 [all_clocks]
set_clock_uncertainty -hold  0.050 [all_clocks]

# DATA is an asynchronous serial line sampled by the selected DCO phase, not by
# REF.  It is a data port, not a clock, and there is nothing to check it
# against until the sampler has a characterised setup/hold.
set_false_path -from [get_ports DATA]

# The tap comes from cdr_multiphase (the digital half) and is a plain register
# slice there; across the macro boundary it is quasi-static on REF.
set_input_delay -max 2.000 -clock REF [get_ports {TAP DCO_EN RST_N}]
set_input_delay -min 0.200 -clock REF [get_ports {TAP DCO_EN RST_N}]

# Outputs: SMP is a REF-domain register, SMP_VALID likewise.
set_output_delay -max 2.000 -clock REF [get_ports {SMP SMP_VALID}]
set_output_delay -min 0.000 -clock REF [get_ports {SMP SMP_VALID}]
set_load 0.020 [all_outputs]

# REC_CLK and PHASE are the phase grid leaving the macro.  PHASE[] is
# observability only (it fans out to no logic inside), so it is not a timing
# endpoint.
set_false_path -to [get_ports REC_CLK]
set_false_path -to [get_ports PHASE]

# The multi-phase delay line is a ring of inverters with (* keep *), so ABC and
# the resizer must not touch it.  The ring is also why CTS must not balance it:
# every stage is one LSB of the phase grid and rebalancing would destroy the
# uniform spacing that pll_multiphase_dco_tb checks.
set ring_cells [get_cells -hierarchical -quiet -regexp {stage_inv.*}]
if {[llength $ring_cells] > 0} { set_dont_touch $ring_cells }
