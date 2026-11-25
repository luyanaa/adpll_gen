##############################################################################
## Preset global variables and attributes
##############################################################################
set TOP $env(TOP)
set SYN_DIR $env(SYN_DIR)
set SYN_SRC $env(SYN_SRC)
set LOGS $env(SYN_OUT)/logs
set REPORTS $env(SYN_OUT)/reports
set OUTPUTS $env(SYN_OUT)
set ROOT_DIR $env(ROOT_DIR)

set SYN_EFF high
set MAP_EFF high
set INC_EFF high

if {![file exists $OUTPUTS]} {
  puts "Creating directory $OUTPUTS"
  file mkdir $OUTPUTS
}
if {![file exists $REPORTS]} {
  puts "Creating directory $REPORTS"
  file mkdir $REPORTS
}

yosys -import

###############################################################
## Library setup
###############################################################
source $env(ROOT_DIR)/lib/$env(PDK)_settings.tcl
source $env(SYN_DIR)/tcl/dont_use.tcl

# Prepend to all strings the -liberty
set LIBSLIB ""
foreach i $LIBS {
    append LIBSLIB "-liberty $i "
}
puts "LIBSLIB = $LIBSLIB"

# Get only the DFF library, which is the standard cell library
# TODO: Not intelligent. We assume is the first one
set LIBFF [lindex $LIBS 0]
puts "LIBFF = $LIBFF"

################################################################
## Verilog read
################################################################
foreach src $SYN_SRC {
  read_verilog -DSYNTHESIS=1 $src
}

# Optional parameter override for the analog top (e.g. BASE_NDELS on
# PLL_ILDCO, to push the ring off the SS-BBPD mode boundary).  Set the env
# var to a Tcl list of NAME=VALUE pairs; absent/empty keeps the RTL default.
# MUST run before `hierarchy -top`: hierarchy derives the top's generate
# blocks and deletes the (now unused) base modules, so a later chparam
# re-derives the top against modules that are no longer in the design and
# the next hierarchy pass dies with "referenced ... is not part of the
# design".
if {[info exists ::env(ANA_PARAMS)] && $::env(ANA_PARAMS) ne ""} {
  foreach kv $::env(ANA_PARAMS) {
    set name [lindex [split $kv =] 0]
    set val  [lindex [split $kv =] 1]
    puts "ANA_PARAMS: chparam -set $name $val $::env(TOP)"
    chparam -set $name $val $::env(TOP)
  }
}

hierarchy -check -top $::env(TOP)

####################################################################
## Load Design
####################################################################
procs
opt
fsm
opt
memory
opt
flatten
synth -run coarse 
#techmap -map $env(TECH_DIR)/verilog/yosys_techmap.v
techmap
#dffunmap -ce-only
opt

hierarchy -check

####################################################################
## Constraints Setup
####################################################################
# read_sdc $SYN_DIR/tcl/${TOP}.sdc.tcl

####################################################################################################
## Synthesizing to gates
####################################################################################################
dfflibmap {*}$DONT_USE_ARGS -liberty $LIBFF
dfflegalize
set cmd "abc $DONT_USE_ARGS $LIBSLIB"
eval $cmd

splitnets

###################################################
## TIES
###################################################
#hilomap -hicell it18_to01_0 HI -locell it18_to01_0 LO # TODO: This command fails
hilomap

######################################################################################################
## Outputs (verilog, SDC, config, etc.)
######################################################################################################
clean -purge
#write_sdc ${OUTPUTS}/${TOP}.sdc # TODO: This command fails

# For matching the verilog with the SDF (NOTE: Commented because it makes everything unreadable)
#autoname
#renames -hide */c:*\[*
#renames -enumerate -pattern instance_% */c:\$auto\$rename*

write_verilog -renameprefix ins -noexpr -noattr -nohex ${OUTPUTS}/${TOP}_net.v

