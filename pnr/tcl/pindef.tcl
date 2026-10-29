####################################
## Pin sides (OpenROAD)
####################################
# Only the side of each pin is constrained, place_pins decides the exact location.
# taken from the tech so this works with any PDK.

# Some tops (for example the PLL_ANALOG hard macro) do not have all the
# full-PLL ports.  Constrain only the ports that actually exist.
proc set_existing_pin_constraint {region pins} {
  set found {}
  foreach p $pins {
    if {[llength [get_ports -quiet $p]] > 0} {
      lappend found $p
    }
  }
  if {[llength $found] > 0} {
    set_io_pin_constraint -region $region -pin_names $found
  }
}

set_existing_pin_constraint top:*    {LOCKED ERR}
set_existing_pin_constraint bottom:* {REF RST_N FCW[*]}
set_existing_pin_constraint left:*   {KP[*] KI[*]}
set_existing_pin_constraint right:*  {OUT SET_DIV[*] LOAD_DIV INJ_EN DSM_EN_DT \
                                      DSM_EN_SHDT DSM_ORDER[*] OUT_DIV}

# Macro-only top ports (PLL_ANALOG_MACRO).  These are not present in the full
# pll top, so the block is skipped there.
if {[llength [get_ports -quiet {COARSE_MUX[*]}]] > 0} {
  set_existing_pin_constraint top:*    {SS_BBPD[*]}
  set_existing_pin_constraint bottom:* {DCO_EN}
  set_existing_pin_constraint left:*   {COARSE_MUX[*] MID_MUX[*]}
  set_existing_pin_constraint right:*  {FINE_MUX[*] MID_OUT INJ_EDGE}
}

place_pins -hor_layers $::env(IO_PIN_H_LAYER) -ver_layers $::env(IO_PIN_V_LAYER)
