# ihp130 SG13G2 (1.2 V) + Core A canary
#
# Targets:
#   make synth-digital      Yosys synthesis of pll_logic -> sg13g2_stdcell (runnable now)
#   make pdk-root           assemble the local build/pdk_root from ORFS views
#   make librelane-digital  LibreLane digital-only run (needs the local PDK root)
#   make librelane-macro    LibreLane full-top run (blocked: macro views absent)
#   make clean              remove build/
#
# This directory is self-contained; nothing outside it is modified.

CANARY_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# SG13G2 views come from the OpenROAD-flow-scripts platform.  A full IHP PDK
# root with libs.tech/librelane is NOT installed in this environment; the
# locally authored minimal config lives in pdk/ihp-sg13g2.
ORFS_PLATFORM ?= /opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2
PDK           ?= ihp-sg13g2
SCL           ?= sg13g2_stdcell
PDK_ROOT      ?= $(CANARY_DIR)/build/pdk_root
SRC_DIR       ?= $(abspath $(CANARY_DIR)/../../../src)
SG13G2_LIB    ?= $(ORFS_PLATFORM)/lib/sg13g2_stdcell_typ_1p20V_25C.lib
YOSYS         ?= yosys

export ORFS_PLATFORM PDK SCL PDK_ROOT SRC_DIR SG13G2_LIB YOSYS

.PHONY: all help synth-digital pdk-root librelane-digital librelane-macro clean

all: synth-digital

help:
	@echo "ihp130 SG13G2 (1.2 V) + Core A canary"
	@echo "  make synth-digital      Yosys pll_logic -> sg13g2_stdcell (needs yosys)"
	@echo "  make pdk-root           assemble build/pdk_root/ihp-sg13g2"
	@echo "  make librelane-digital  LibreLane digital-only (needs librelane + PDK root)"
	@echo "  make librelane-macro    LibreLane full top (needs librelane + macro views)"
	@echo "  make clean              remove build/"

synth-digital:
	@./scripts/run_canary.sh synth-digital

pdk-root:
	@./scripts/run_canary.sh pdk-root

librelane-digital:
	@./scripts/run_canary.sh librelane-digital

librelane-macro:
	@./scripts/run_canary.sh librelane-macro

clean:
	@./scripts/run_canary.sh clean
