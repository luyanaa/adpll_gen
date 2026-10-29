# gf180mcu 3.3 V + Core A canary
#
# Targets:
#   make synth-digital      Yosys synthesis of pll_logic -> gf180mcu_as_sc_mcu7t3v3
#   make librelane-digital  LibreLane digital-only run
#   make librelane-macro    LibreLane full-top run (blocked: macro views absent)
#   make clean              remove build/
#
# This directory is self-contained; nothing outside it is modified.

CANARY_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# PDK layout in this checkout:
#   /grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk/{libs.ref,libs.tech}
# LibreLane expects $PDK_ROOT/$PDK/libs.tech/librelane/config.tcl; the canary
# creates a local overlay under build/pdk_overlay (see scripts/run_canary.sh).
GF180_PDK           ?= /grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk
PDK_REF_ROOT        ?= $(GF180_PDK)/libs.ref
PDK                 ?= gf180mcu
SCL                 ?= gf180mcu_as_sc_mcu7t3v3
SRC_DIR             ?= $(abspath $(CANARY_DIR)/../../../src)
GF180_LIB           ?= $(PDK_REF_ROOT)/$(SCL)/lib/$(SCL)__tt_025C_3v30.lib
YOSYS               ?= yosys
LIBRELANE           ?= /nix/store/ilpnqwsl6gvk6kvavkaljbnzaz3086fd-python3.13-librelane-3.0.16/bin/librelane
LIBRELANE_PDK_ROOT  ?= $(CANARY_DIR)/pdk_overlay
LIBRELANE_SKIP      ?= Magic.StreamOut KLayout.StreamOut KLayout.Render Magic.WriteLEF Odb.CheckDesignAntennaProperties KLayout.XOR Checker.XOR Magic.DRC KLayout.DRC Checker.MagicDRC Checker.KLayoutDRC Magic.SpiceExtraction Netgen.LVS Checker.LVS OpenROAD.RCX OpenROAD.STAPostPNR OpenROAD.IRDropReport Checker.SetupViolations Checker.HoldViolations Checker.MaxSlewViolations Checker.MaxCapViolations

export GF180_PDK PDK_REF_ROOT PDK SCL SRC_DIR GF180_LIB YOSYS LIBRELANE LIBRELANE_PDK_ROOT LIBRELANE_SKIP

.PHONY: all help synth-digital librelane-digital librelane-macro clean

all: synth-digital

help:
	@echo "gf180mcu 3.3 V + Core A canary"
	@echo "  make synth-digital      Yosys pll_logic -> gf180mcu_as_sc_mcu7t3v3 (needs yosys)"
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
