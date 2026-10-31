ROOT ?= /opt/adpll_gen
PDK := ihp-sg13g2
SCL := sg13g2_stdcell
TOP := PLL_RING_DCO_PHYS
DIGTOP := pll_logic
SYN_SRC := $(ROOT)/src/pll_ring_dco_phys.v \
           $(ROOT)/src/il_dco.v \
           $(ROOT)/src/coarse_delay.v \
           $(ROOT)/src/mid_delay.v \
           $(ROOT)/src/fine_delay.v \
           $(ROOT)/src/sym.v \
           $(ROOT)/src/sym_mux.v \
           $(ROOT)/src/ssbbpd.v \
           $(ROOT)/src/pll_cells_ihp-sg13g2.v
SYN_DIG_SRC := $(ROOT)/src/pll_logic_bb.v
LEFS := $(PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef \
        $(PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef
GDSS := $(PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds
CDLS := $(PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl
COMMON := PDK=$(PDK) SCL=$(SCL) TOP=$(TOP) DIGTOP=$(DIGTOP) \
          SYN_SRC="$(SYN_SRC)" SYN_DIG_SRC="$(SYN_DIG_SRC)" \
          SKIP_CTS=1 SKIP_PLL_POS=1 SKIP_CLK_ISOLATE=1 NO_IO=1 \
          LEFS="$(LEFS)" GDSS="$(GDSS)" CDLS="$(CDLS)"
KLAYOUT ?= klayout
export NO_IO = 1
.PHONY: all syn pnr gds lvs-view clean
all: gds
syn:
	$(MAKE) -C $(ROOT)/syn all $(COMMON)
pnr: syn
	$(MAKE) -C $(ROOT)/pnr all $(COMMON) SRC_DIR=$(CURDIR)
GDS := $(ROOT)/signoff/outputs/ihp-sg13g2-sg13g2_stdcell/$(TOP).gds
gds: pnr
	rm -f $(GDS)
	$(MAKE) -C $(ROOT)/signoff gds $(COMMON)
	$(KLAYOUT) -b -r $(CURDIR)/add_density_fill.rb \
	  -rd gds=$(GDS) -rd top=$(TOP) -rd out=$(GDS).filled.gds
	mv $(GDS).filled.gds $(GDS)
lvs-view: gds
	$(KLAYOUT) -b -r $(CURDIR)/strip_density_fill.rb \
	  -rd gds=$(GDS) -rd top=$(TOP) -rd out=$(GDS:.gds=_lvs.gds)
clean:
	$(MAKE) -C $(ROOT)/syn clean PDK=$(PDK) SCL=$(SCL)
	$(MAKE) -C $(ROOT)/pnr clean PDK=$(PDK) SCL=$(SCL)
	$(MAKE) -C $(ROOT)/signoff clean PDK=$(PDK) SCL=$(SCL)
