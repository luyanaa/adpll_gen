# Single source of truth for the synthesizable digital RTL.
# Keep this list in sync with src/lock_detector.v and the RTL manifest used by
# simulations and canary synthesis.
DIGITAL_RTL_SRCS := \
	$(ROOT_DIR)/src/pll_logic.v \
	$(ROOT_DIR)/src/lock_detector.v \
	$(ROOT_DIR)/src/digital_loop_filter.v \
	$(ROOT_DIR)/src/term_decoder.v \
	$(ROOT_DIR)/src/freq_lock.v \
	$(ROOT_DIR)/src/delta_sigma.v \
	$(ROOT_DIR)/src/fix_div.v \
	$(ROOT_DIR)/src/conf_div.v
