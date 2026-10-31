# Physical Core B ring-DCO macro using the ckdur OpenROAD flow.
ROOT     ?= /opt/adpll_gen
PDK      := ics55
SCL      := ics55_LLSC_H7CR
TOP      := PLL_RING_DCO_PHYS
DIGTOP   := pll_logic
PDK_ROOT ?= /grid

SYN_SRC  := $(ROOT)/src/pll_ring_dco_phys.v \
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
          SYN_SRC="$(SYN_SRC)" SYN_DIG_SRC="$(SYN_DIG_SRC)" \
          SKIP_CTS=1 SKIP_PLL_POS=1 SKIP_CLK_ISOLATE=1 NO_IO=1 PDK_ROOT=$(PDK_ROOT)
export NO_IO = 1

.PHONY: all syn pnr gds clean
all: gds

syn:
	$(MAKE) -C $(ROOT)/syn all $(COMMON)

pnr: syn
	$(MAKE) -C $(ROOT)/pnr all $(COMMON) SRC_DIR=$(CURDIR)

GDS := $(ROOT)/signoff/outputs/ics55/$(TOP).gds

gds: pnr
	rm -f $(GDS)
	$(MAKE) -C $(ROOT)/signoff gds $(COMMON)

clean:
	$(MAKE) -C $(ROOT)/syn clean PDK=$(PDK) SCL=$(SCL)
	$(MAKE) -C $(ROOT)/pnr clean PDK=$(PDK) SCL=$(SCL)
	$(MAKE) -C $(ROOT)/signoff clean PDK=$(PDK) SCL=$(SCL)
