# adpll.sdc -- practical canary constraints for ihp130 (SG13G2, 1.2 V) + Core A
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
#   - The numbers below are planning assumptions (50 MHz REF, FCW=8 nominal
#     OUT), not measured DCO behavior.
#
# Do not copy this file into a signoff run.  The ckdur `src/pll.sdc.tcl` is
# also not signoff-grade (it creates 1 ns clocks on analog internal pins and
# says nothing about INJ_EDGE or the generated digital clocks).

# ---------------------------------------------------------------------------
# Clocks
# ---------------------------------------------------------------------------
# REF is normally created by LibreLane from CLOCK_PORT/CLOCK_PERIOD.  Create
# it only if the flow has not already done so (keeps this file usable
# standalone and avoids a duplicate definition).
if {[llength [get_clocks -quiet REF]] == 0} {
    create_clock -name REF -period 20.000 [get_ports REF]
}

# OUT / MID_OUT / INJ_EDGE: ports in the digital-only top, macro pins in the
# full top.  Nominal periods are STA assumptions:
#   OUT/MID_OUT : 2.5 ns (FCW=8 => 8 x 50 MHz); real period is set by the DCO
#   INJ_EDGE    : 20 ns, a delayed copy of REF
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
        create_clock -name OUT -period 2.500 $out_src
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
        create_clock -name MID_OUT -period 2.500 $mid_src
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
        create_clock -name INJ_EDGE -period 20.000 $inj_src
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
# The ORFS ihp-sg13g2 platform does not publish these limits.  The values
# below are the generic LibreLane/ORFS assumptions also used by the ics55 and
# sky130 configs; they are canary assumptions, not characterised IHP limits.
# The hold value in particular is a placeholder.
set_clock_uncertainty -setup 0.250 [all_clocks]
set_clock_uncertainty -hold  0.050 [all_clocks]
# set_max_transition 0.15 [current_design]

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
# - VDDO/IO 3.3 V domain: not present.  This canary uses only the 1.2 V core
#   library; the 3.3 V sg13g2_stdcell_hv library is intentionally not mixed in.
