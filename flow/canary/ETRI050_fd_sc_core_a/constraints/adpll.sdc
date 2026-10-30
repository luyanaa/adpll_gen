# adpll.sdc -- practical canary constraints for gf180mcu 3.3 V + Core A
#
# Scope
# -----
# This one file is used by BOTH canary configs:
#   config.digital.yaml : top = pll_logic; REF/OUT/MID_OUT/INJ_EDGE are ports
#   config.macro.yaml   : top = pll; OUT/MID_OUT/INJ_EDGE come from the
#                         PLL_ANALOG instance `pll_ana`
#
# It is a canary, not signoff.  In particular:
#   - PLL_ANALOG has no Liberty model yet, so macro->digital paths (SS_BBPD)
#     are not constrained at all.
#   - CKR (a flop retiming REF into the MID_OUT domain) and DSM_CK (MID_OUT
#     divided by DSM_DIV) are internally generated clocks in pll_logic.  They
#     are NOT declared here because their post-synthesis hierarchical names are
#     not stable.  CTS/STA must add create_generated_clock for them before any
#     timing claim.
#   - The numbers below are planning assumptions for a 3.3 V / 180 nm
#     portability exercise, not measured DCO behavior.
#
# The ckdur `src/pll.sdc.tcl` was used as a starting point for the ics55
# canary; this file is the gf180 adaptation.  Its internal 1 ns OUT/MID_OUT
# clocks are not signoff-grade: it creates clocks on analog internal pins and
# says nothing about INJ_EDGE or the generated digital clocks.  Do not copy it
# into a signoff run.
#
# 180 nm note
# -----------
# The RTL's FCW=8 nominal ratio implies OUT = 8 x REF = 400 MHz (2.5 ns) with
# REF = 10 MHz.  ETRI050 is a 5 V/0.5 um, single-corner library; the routed canary did
# not close timing at 20 ns.  This file uses 200 ns (5 MHz) only as a
# flow-qualification planning value, not a signoff claim.
# The real period is a DCO characterization result either way.

# ---------------------------------------------------------------------------
# Clocks
# ---------------------------------------------------------------------------
# REF is normally created by LibreLane from CLOCK_PORT/CLOCK_PERIOD.  Create
# it only if the flow has not already done so (keeps this file usable
# standalone and avoids a duplicate definition).
if {[llength [get_clocks -quiet REF]] == 0} {
    create_clock -name REF -period 200.000 [get_ports REF]
}

# OUT / MID_OUT / INJ_EDGE: ports in the digital-only top, macro pins in the
# full top.  Nominal periods are STA assumptions:
#   OUT/MID_OUT : 200 ns (5 MHz) flow-qualification value
#   INJ_EDGE    : 200 ns (5 MHz), a delayed copy of REF
# Prefer the macro pin in the full top: OUT/MID_OUT/INJ_EDGE are top-level
# *outputs* there, and a clock defined on an output port would not propagate
# back into the design.  In the digital-only top the pins do not exist and the
# ports are inputs, so the fallback is correct.
if {[llength [get_clocks -quiet OUT]] == 0} {
    set out_src [get_pins -quiet pll_ana/OUT]
    if {[llength $out_src] == 0} {
        set out_src [get_ports -quiet OUT]
    }
    if {[llength $out_src] > 0} {
        create_clock -name OUT -period 200.000 $out_src
    } else {
        puts "WARNING: adpll.sdc: OUT not found as pll_ana/OUT or a port"
    }
}

if {[llength [get_clocks -quiet MID_OUT]] == 0} {
    set mid_src [get_pins -quiet pll_ana/MID_OUT]
    if {[llength $mid_src] == 0} {
        set mid_src [get_ports -quiet MID_OUT]
    }
    if {[llength $mid_src] > 0} {
        create_clock -name MID_OUT -period 200.000 $mid_src
    } else {
        puts "WARNING: adpll.sdc: MID_OUT not found as pll_ana/MID_OUT or a port"
    }
}

if {[llength [get_clocks -quiet INJ_EDGE]] == 0} {
    set inj_src [get_pins -quiet pll_ana/INJ_EDGE]
    if {[llength $inj_src] == 0} {
        set inj_src [get_ports -quiet INJ_EDGE]
    }
    if {[llength $inj_src] > 0} {
        create_clock -name INJ_EDGE -period 200.000 $inj_src
    } else {
        puts "WARNING: adpll.sdc: INJ_EDGE not found as pll_ana/INJ_EDGE or a port"
    }
}

# REF and INJ_EDGE are physically related (INJ_EDGE is a delayed REF), but
# the insertion delay is unknown until the macro is characterized.  Treat all
# four as asynchronous for the canary.  Replace the REF/INJ_EDGE split with a
# create_generated_clock + -edge_shift once the macro Liberty provides the
# injection delay.
set_clock_groups -asynchronous \
    -group {REF} \
    -group {OUT} \
    -group {MID_OUT} \
    -group {INJ_EDGE}

# ---------------------------------------------------------------------------
# Clock quality
# ---------------------------------------------------------------------------
# Planning values for the 180 nm canary; not PDK-qualified limits.  LibreLane
# also applies MAX_TRANSITION_CONSTRAINT from the PDK Tcl.
set_clock_uncertainty -setup 0.250 [all_clocks]
set_clock_uncertainty -hold  0.050 [all_clocks]
# set_max_transition 0.50 [current_design]

# ---------------------------------------------------------------------------
# Inputs
# ---------------------------------------------------------------------------
# REF-sampled configuration.  KP/KI/FCW are quasi-static during lock; DSM_* are
# mode straps.  They are timed as if driven by a REF-domain register; false-path
# them instead if they are hard-tied in the final SoC.
set_input_delay -max 5.000 -clock REF [get_ports {KP[*] KI[*] FCW[*]}]
set_input_delay -min 1.000 -clock REF [get_ports {KP[*] KI[*] FCW[*]}]
set_input_delay -max 5.000 -clock REF [get_ports {DSM_EN_DT DSM_EN_SHDT DSM_ORDER[*]}]
set_input_delay -min 1.000 -clock REF [get_ports {DSM_EN_DT DSM_EN_SHDT DSM_ORDER[*]}]

# OUT-sampled divider interface.
set_input_delay -max 0.500 -clock OUT [get_ports {SET_DIV[*] LOAD_DIV}]
set_input_delay -min 0.100 -clock OUT [get_ports {SET_DIV[*] LOAD_DIV}]

# Async reset and static enables are not data paths.
set_false_path -from [get_ports RST_N]
if {[llength [get_ports -quiet INJ_EN]] > 0} {
    set_false_path -from [get_ports INJ_EN]
}

# ---------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------
# LOCKED/ERR are launched on negedge INJ_EDGE (20 ns domain).
set_output_delay -max 5.000 -clock INJ_EDGE [get_ports {LOCKED ERR}]
set_output_delay -min 0.000 -clock INJ_EDGE [get_ports {LOCKED ERR}]
# OUT_DIV is launched by the OUT-clock divider.
set_output_delay -max 0.500 -clock OUT [get_ports OUT_DIV]
set_output_delay -min 0.000 -clock OUT [get_ports OUT_DIV]

# DCO control buses only exist as ports in the digital-only top.  In the full
# top they are internal nets feeding pll_ana and must be constrained by the
# macro Liberty instead (not by an output delay).  They are quasi-static:
# COARSE/MID change at most once per REF cycle, FINE once per DSM cycle.
if {[llength [get_ports -quiet {COARSE_MUX[*]}]] > 0} {
    set_output_delay -max 0.500 -clock MID_OUT [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*]}]
    set_output_delay -min 0.000 -clock MID_OUT [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*]}]
    set_output_delay -max 2.000 -clock INJ_EDGE [get_ports DCO_EN]
    set_output_delay -min 0.000 -clock INJ_EDGE [get_ports DCO_EN]
}

# Load used by ckdur is 0.22 pF for every output.  That is too pessimistic and
# too uniform for a canary: use a small default and replace it with the actual
# macro input caps from PLL_ANALOG.lib when the macro exists.
set_load 0.050 [all_outputs]

# ---------------------------------------------------------------------------
# Explicitly NOT constrained (open items)
# ---------------------------------------------------------------------------
# - SS_BBPD -> loop filter: no macro Liberty yet.  When it exists, this must be
#   a real setup/hold check against negedge INJ_EDGE, not a false path.
# - CKR and DSM_CK: internally generated clocks; add create_generated_clock
#   after synthesis/CTS names are stable.
# - COARSE_MUX/MID_MUX/FINE_MUX in the full top: constrain at the macro pins
#   from PLL_ANALOG.lib (input caps + setup/hold), not as top-level outputs.
