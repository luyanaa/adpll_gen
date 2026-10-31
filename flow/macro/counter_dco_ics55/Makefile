# Physical Core C counter/NCO macro (LibreLane standard-cell flow).
#
# The generated GDS/LEF/LIB/DEF are ignored build artifacts.  Rebuild them
# before treating the macro as BUILT in a clean checkout.
ROOT     ?= /opt/adpll_gen
LIBRELANE ?= librelane
PDK_ROOT ?= /grid
PDK      := ics55
SCL      := ics55_LLSC_H7CR
TOP      := PLL_COUNTER_DCO_PHYS

.PHONY: all pnr clean

all: pnr

pnr:
	cd $(ROOT)/flow/macro/counter_dco_ics55 && \
	$(LIBRELANE) --manual-pdk --pdk-root $(PDK_ROOT) --pdk $(PDK) --scl $(SCL) \
	  --skip OpenROAD.CTS --skip OpenROAD.STAPostPNR \
	  --skip OpenROAD.IRDropReport --skip OpenROAD.RCX \
	  --skip Magic.StreamOut --skip Magic.WriteLEF --skip Magic.DRC \
	  --skip Magic.SpiceExtraction --skip Netgen.LVS --skip Checker.LVS \
	  --skip Odb.CheckDesignAntennaProperties --skip KLayout.XOR \
	  --skip Checker.XOR --skip Checker.SetupViolations \
	  --skip Checker.HoldViolations --skip Checker.MaxSlewViolations \
	  --skip Checker.MaxCapViolations --save-views-to final config.yaml

clean:
	rm -rf $(ROOT)/flow/macro/counter_dco_ics55/runs \
	       $(ROOT)/flow/macro/counter_dco_ics55/final
