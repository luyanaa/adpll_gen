# Build PLL_ANALOG_MACRO with the ckdur OpenROAD flow.
#
#   make syn       analog netlist: pll_analog + cells -> PLL_ANALOG_MACRO_net.v
#   make pnr       fixed-placement P&R; writes LEF/Liberty/SPEF/SDF/CDL/Verilog/DEF
#   make gds       streamout + ics55 dummy density fill
#   make signoff   GDS + flat-reference LVS
#   make drc       KLayout DRC (expected nonzero: 7T cell-internal)
#
# The existing src/syn/pnr/signoff flows are NOT modified.  The macro-only
# build is selected with command-line variables (TOP/SYN_SRC/SYN_DIG_SRC/
# SRC_DIR), plus a local SDC file.

ROOT     ?= /opt/adpll_gen
KLAYOUT  ?= klayout
PDK      ?= ics55
SCL      ?= ics55_LLSC_H7CR
TOP      := PLL_ANALOG_MACRO
DIGTOP   := pll_logic
# Layers that actually need fill for this 160x100 macro.  M4/M5 are not below
# their local-density thresholds; adding them would create floating metal nets
# that the provisional LVS deck does not purge.  Override for another floorplan.
FILL_LAYERS ?= 2/2,41/2,81/2,82/2,83/2,103/2

SYN_SRC  := $(CURDIR)/pll_analog_macro.v \
            $(ROOT)/src/pll_analog.v \
            $(ROOT)/src/injection.v \
            $(ROOT)/src/il_dco.v \
            $(ROOT)/src/coarse_delay.v \
            $(ROOT)/src/mid_delay.v \
            $(ROOT)/src/fine_delay.v \
            $(ROOT)/src/sym.v \
            $(ROOT)/src/sym_mux.v \
            $(ROOT)/src/ssbbpd.v \
            $(ROOT)/src/pll_cells_ics55.v

SYN_DIG_SRC := $(ROOT)/src/pll_logic_bb.v

COMMON := PDK=$(PDK) SCL=$(SCL) TOP=$(TOP) DIGTOP=$(DIGTOP) \
          SYN_SRC="$(SYN_SRC)" SYN_DIG_SRC="$(SYN_DIG_SRC)" SKIP_CTS=1

.PHONY: all syn pnr gds signoff drc waiver lvs_flat clean
export SKIP_CTS = 1

all: signoff

syn:
	$(MAKE) -C $(ROOT)/syn all $(COMMON)

pnr: syn
	$(MAKE) -C $(ROOT)/pnr all $(COMMON) SRC_DIR=$(CURDIR)

signoff: gds
	ROOT=$(ROOT) PDK_ROOT=$(PDK_ROOT) TOP=$(TOP) SCL=$(SCL) \
	  bash $(CURDIR)/run_lvs_flat.sh

# DRC still has 7T cell-internal items; this target exits non-zero on
# violations via signoff/tcl/drc_summary.py.  Top-level DRC is 0.
drc: gds
	$(MAKE) -C $(ROOT)/signoff drc $(COMMON)

# Apply the explicit 7T cell-internal waiver; top-level DRC is never waived.
waiver: gds
	$(KLAYOUT) -b -r $(CURDIR)/dump_instances.rb \
	  -rd gds=$(GDS) -rd top=$(TOP) -rd out=/tmp/$(TOP)_instances.json
	python3 $(CURDIR)/waive_drc.py \
	  --lyrdb $(ROOT)/signoff/reports/ics55/$(TOP).lyrdb \
	  --waiver $(CURDIR)/drc_waiver.json --top $(TOP) \
	  --instances /tmp/$(TOP)_instances.json \
	  --json-out $(CURDIR)/drc_waiver_report.json \
	  --md-out $(CURDIR)/drc_waiver_report.md

GDS := $(ROOT)/signoff/outputs/ics55/$(TOP).gds

# Stream out, then add the ics55 dummy density fill.  The fill is required
# because the 160 x 100 um die is still sparse; without it the top-level
# density checks fail even though all routing/geometry is clean.
gds: pnr
	rm -f $(GDS)
	$(MAKE) -C $(ROOT)/signoff gds $(COMMON)
	$(KLAYOUT) -b -r $(CURDIR)/add_density_fill.rb \
	  -rd gds=$(GDS) -rd top=$(TOP) -rd out=$(GDS).filled.gds \
	  -rd fill_layers=$(FILL_LAYERS)
	mv $(GDS).filled.gds $(GDS)

# Repro for the flat-reference LVS; the default signoff/LVS target uses the
# hierarchical cell CDL, which KLayout cannot resolve.
lvs_flat: gds
	ROOT=$(ROOT) PDK_ROOT=$(PDK_ROOT) TOP=$(TOP) SCL=$(SCL) \
	  bash $(CURDIR)/run_lvs_flat.sh

clean:
	$(MAKE) -C $(ROOT)/syn clean PDK=$(PDK) SCL=$(SCL)
	$(MAKE) -C $(ROOT)/pnr clean PDK=$(PDK) SCL=$(SCL)
	$(MAKE) -C $(ROOT)/signoff clean PDK=$(PDK) SCL=$(SCL)
