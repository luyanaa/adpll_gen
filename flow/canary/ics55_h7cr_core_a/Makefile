# ics55 H7CR + Core A canary
#
# Targets:
#   make synth-digital      Yosys synthesis of pll_logic -> H7CR cells (runnable now)
#   make librelane-digital  LibreLane digital-only run  (blocked: librelane absent)
#   make librelane-macro    LibreLane full-top run      (blocked: macro views absent)
#   make clean              remove build/
#
# This directory is self-contained; nothing outside it is modified.

CANARY_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# This checkout is flat: the PDK lives directly under /grid/icsprout55-pdk
# (there is no .../ics55/ level).  LibreLane's ics55 config.tcl assumes
# $PDK_ROOT/$PDK/libs.ref, so a LibreLane run needs $PDK_ROOT/$PDK to resolve
# to this tree (e.g. PDK_ROOT=/grid and an /grid/ics55 symlink).  See README.
PDK_ROOT     ?= /grid/icsprout55-pdk
PDK_REF_ROOT ?= $(PDK_ROOT)/libs.ref
PDK          ?= ics55
SCL          ?= ics55_LLSC_H7CR
SRC_DIR      ?= $(abspath $(CANARY_DIR)/../../../src)
H7CR_LIB     ?= $(PDK_REF_ROOT)/$(SCL)/liberty/$(SCL)_typ_tt_1p2_25_nldm.lib
YOSYS        ?= yosys

export PDK_ROOT PDK_REF_ROOT PDK SCL SRC_DIR H7CR_LIB YOSYS

.PHONY: all help synth-digital librelane-digital librelane-macro clean

all: synth-digital

help:
	@echo "ics55 H7CR + Core A canary"
	@echo "  make synth-digital      Yosys pll_logic -> ics55_LLSC_H7CR (needs yosys)"
	@echo "  make librelane-digital  LibreLane digital-only (needs librelane)"
	@echo "  make librelane-macro    LibreLane full top (needs librelane + macro views)"
	@echo "  make clean              remove build/"

synth-digital:
	@./scripts/run_canary.sh synth-digital

librelane-digital:
	@./scripts/run_canary.sh librelane-digital

librelane-macro:
	@./scripts/run_canary.sh librelane-macro

clean:
	@./scripts/run_canary.sh clean
