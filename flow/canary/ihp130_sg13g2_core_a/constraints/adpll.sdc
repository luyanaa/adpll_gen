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
# ---------------------------------------------------------------------------
# Gated clocks produced by PLL_CLKGATE
# ---------------------------------------------------------------------------
# When PLL_USE_ICS55_ICG is defined, flock.REF_G and dsm_impl.DSM_CK_G are
# driven by real ICGNX1H7R cells and CTS builds them as separate clock nets.
# Without a generated-clock declaration STA treats those nets as ordinary
# data: every REF -> REF_G transfer becomes a synchronous path and repair
# fills it with delay cells (measured: DLY4X2H7R 15 -> 201, hold -0.1161).
#
# The gates are transparent while enabled, so both clocks are the same
# frequency as their source with a small insertion delay.
# create_generated_clock wants a pin/port, not a net: resolve the driver of
# each gated-clock net first.  The driver is either the ICG's ECK pin
# (PLL_USE_ICS55_ICG) or the fallback AND gate's Y pin.
proc _drv_pin {net} {
    set drv [get_pins -quiet -of_objects $net -filter "direction==output"]
    if {[llength $drv] > 0} { return [lindex $drv 0] }
    return ""
}

if {[llength [get_clocks -quiet REF_G_CLK]] == 0} {
    set refg_net [lindex [get_nets -quiet *flock.REF_G*] 0]
    if {$refg_net ne ""} {
        set refg_pin [_drv_pin $refg_net]
        if {$refg_pin ne ""} {
            create_generated_clock -name REF_G_CLK -source [get_ports REF] \
                -divide_by 1 $refg_pin
        }
    }
}

# DSM_CK is MID_OUT divided by DSM_DIV (a pll_fix_divider instance; DSM_DIV
# defaults to 2 in pll_macro_top).  DSM_CK_G is the same clock through the ICG,
# so no further division.
#
# The previous version derived DSM_CK_G_CLK with -divide_by 1 from the *divider
# register's Q pin*, which made STA report a 2.500 ns period -- the same as
# MID_OUT.  That is half the real period, and it is what turned the DSM adder
# into a 49-stage path against a 2.5 ns budget at all three corners.  The
# divider register is real (_4277_ in the routed netlist: D from the counter
# logic, CLK = clknet_1_0__leaf_MID_OUT, Q = pll_dig.dsm_impl.DSM_CK), so the
# divided clock is genuinely MID_OUT/DSM_DIV.
#
# Anchor must be MID_OUT itself, not the divider's Q: -source takes a clock
# source pin, and the Q pin of a flop is data, not a clock root.
set dsm_div 2
if {[llength [get_clocks -quiet DSM_CK_G_CLK]] == 0} {
    set dsmg_net [lindex [get_nets -quiet *dsm_impl.DSM_CK_G*] 0]
    set mid_src [get_ports -quiet MID_OUT]
    if {[llength $mid_src] == 0} {
        set mid_src [get_pins -quiet *pll_ana/MID_OUT]
    }
    if {$dsmg_net ne "" && [llength $mid_src] > 0} {
        set dsmg_pin [_drv_pin $dsmg_net]
        if {$dsmg_pin ne ""} {
            create_generated_clock -name DSM_CK_G_CLK \
                -source [lindex $mid_src 0] -divide_by $dsm_div $dsmg_pin
        }
    }
}

# REF_G is REF gated by the FLL ICG: same frequency, small insertion delay.
# It stays in the REF group so REF -> REF_G transfers are analysed (the ICG
# setup requirement is real), while the CDC synchronizers inside both domains
# are exempted separately below.
set_clock_groups -asynchronous \
    -group {REF REF_G_CLK} \
    -group {OUT} \
    -group {MID_OUT DSM_CK_G_CLK} \
    -group {INJ_EDGE}

# ---------------------------------------------------------------------------
# CDC synchronizers: exempt the first stage from hold repair
# ---------------------------------------------------------------------------
# The RTL marks every 2FF synchronizer first stage (* ASYNC_REG = "TRUE" *),
# and set_clock_groups below declares the four clocks asynchronous.  OpenROAD's
# repair_design still inserts hold buffers on them: 42 of the 55 DLY4X2H7R
# cells in run RUN_2026-11-18_11-55-44 sit on cnt_gray_s1/s2,
# out_edges_g1/g2, watch_s1/s2 and clr_r1/r2.  That is 7.6% of the die in
# timing_repair cells, and it is also what breaks functional gate-level
# simulation of the P&R netlist: a delay inserted into a 2FF shifts the loop
# timing against the behavioural DCO.
#
# A metastable first stage cannot be fixed by added delay -- the requirement is
# MTBF, not hold.
#
# Mechanism: hierarchical pin names are gone after synthesis, but the *net*
# names survive (the netlist keeps flock.cnt_gray_s1[12] etc.).  Resolve each
# synchronizer net to its sink pins and exempt those.  set_max_delay is not
# used: OpenSTA rejects -datapath_only on this netlist (STA-0563), and the
# hold exemption alone is what removes the delay cells.
#
# Verified with OpenROAD on RUN_2026-11-18_11-55-44: 93 sink pins resolved,
# set_false_path -hold accepted for all of them.
proc cdc_exempt_hold {patterns} {
    set total 0
    foreach pat $patterns {
        set nets [get_nets -quiet $pat]
        set sinks {}
        foreach n $nets {
            set sinks [concat $sinks \
                [get_pins -quiet -of_objects $n -filter "direction==input"]]
        }
        if {[llength $sinks] > 0} {
            set_false_path -hold -to $sinks
            set total [expr {$total + [llength $sinks]}]
        }
    }
    if {$total > 0} {
        puts "adpll.sdc: CDC hold exemption applied to $total sink pins"
    }
}

cdc_exempt_hold {
    *cnt_gray_s1*  *cnt_gray_s2*
    *out_edges_g1* *out_edges_g2*
    *watch_s1*     *watch_s2*
    *clr_r1*       *clr_r2*
    *ref_ok_s1*    *ref_ok_s2*
    *locked_dsm_s1* *locked_dsm_s2*
}

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

# Divider ratio interface: quasi-static straps, not OUT-synchronous data.
set_false_path -from [get_ports {SET_DIV[*] LOAD_DIV}]
set_input_delay -max 5.000 -clock REF [get_ports {SET_DIV[*] LOAD_DIV}]
set_input_delay -min 1.000 -clock REF [get_ports {SET_DIV[*] LOAD_DIV}]

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
# OUT_DIV is the divider's *clock* output, not a data output.  The last
# stage is a clock mux: `use_clk` is a falling-edge flop (the /1 bypass
# select), and the mux output is the divided clock that feeds ddr_ck_gate.
# Constraining it with set_output_delay made STA treat a half-period clock-mux
# path as a data path and reported it as the SS/TT/FF setup violator
# (~-0.99 ns SS).  Declare it as a generated clock instead; the mux select is
# already guaranteed to move only while clk is low (see conf_div.v).
# The nominal waveform uses DIV_INIT=2 (the divider's power-on ratio); the
# runtime SET_DIV value changes the real period, which a static SDC cannot
# express.  That is acceptable for a canary because the divider's own
# reg->reg timing (the use_clk -> high_count path) is checked separately in
# the OUT group.
if {[llength [get_clocks -quiet OUT_DIV_CLK]] == 0} {
    create_generated_clock -name OUT_DIV_CLK -source [get_ports OUT] \
        -divide_by 2 [get_ports OUT_DIV]
}
# CK (the DDR pad clock) is the same divided clock, gated by LOCKED.
if {[llength [get_clocks -quiet CK_CLK]] == 0} {
    create_generated_clock -name CK_CLK -source [get_ports OUT] \
        -divide_by 2 [get_ports CK]
}


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
