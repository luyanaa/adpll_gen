# Delay characterization tests
test_fine_delay: $(SIM_OUT)/test_fine_delay.raw

$(SIM_OUT)/test_fine_delay.raw: $(SIM_OUT)/FINE_DELAY.sp $(SRC_DIR)/test_fine_delay.sp $(SRC_DIR)/measure_delay.sp $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(SRC_DIR)/test_fine_delay.sp $(SIM_OUT)/test_fine_delay.sp
	cp $(SRC_DIR)/measure_delay.sp $(SIM_OUT)/measure_delay.sp
	cd $(SIM_OUT) && $(NGSPICE) -o test_fine_delay.log test_fine_delay.sp < /dev/null

view_test_fine_delay: $(SIM_OUT)/test_fine_delay.raw
	$(WAVEVIEW) $(SIM_OUT)/test_fine_delay.raw

test_mid_delay: $(SIM_OUT)/test_mid_delay.raw

$(SIM_OUT)/test_mid_delay.raw: $(SIM_OUT)/MID_DELAY.sp $(SRC_DIR)/test_mid_delay.sp $(SRC_DIR)/measure_delay.sp $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(SRC_DIR)/test_mid_delay.sp $(SIM_OUT)/test_mid_delay.sp
	cp $(SRC_DIR)/measure_delay.sp $(SIM_OUT)/measure_delay.sp
	cd $(SIM_OUT) && $(NGSPICE) -o test_mid_delay.log test_mid_delay.sp < /dev/null

view_test_mid_delay: $(SIM_OUT)/test_mid_delay.raw
	$(WAVEVIEW) $(SIM_OUT)/test_mid_delay.raw

test_coarse_delay: $(SIM_OUT)/test_coarse_delay.raw

$(SIM_OUT)/test_coarse_delay.raw: $(SIM_OUT)/COARSE_DELAY.sp $(SRC_DIR)/test_coarse_delay.sp $(SRC_DIR)/measure_delay.sp $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(SRC_DIR)/test_coarse_delay.sp $(SIM_OUT)/test_coarse_delay.sp
	cp $(SRC_DIR)/measure_delay.sp $(SIM_OUT)/measure_delay.sp
	cd $(SIM_OUT) && $(NGSPICE) -o test_coarse_delay.log test_coarse_delay.sp < /dev/null

view_test_coarse_delay: $(SIM_OUT)/test_coarse_delay.raw
	$(WAVEVIEW) $(SIM_OUT)/test_coarse_delay.raw

# Delay characterization tests... but in digital (using sdf files)
test_fine_delay_digital: $(SIM_OUT)/test_fine_delay.vcd

$(SIM_OUT)/test_fine_delay.vcd: $(SYN_OUT)/FINE_DELAY_net.v $(SRC_DIR)/test_fine_delay.v $(SRC_DIR)/measure_delay.v $(SRC_DIR)/sim_mux.v $(CELLS_SRC)
	mkdir -p $(SIM_OUT)
	cp $(SYN_OUT)/FINE_DELAY.sdf $(SIM_OUT)/FINE_DELAY.sdf
	cp $(SYN_OUT)/FINE_DELAY_net.v $(SIM_OUT)/FINE_DELAY_net.v
	cp $(SRC_DIR)/measure_delay.v $(SIM_OUT)/measure_delay.v
	cd $(SIM_OUT) && $(IVERILOG) -ginterconnect -gspecify -T max -o a.out -D SIMULATION=1 $(CELLS_ADD_DEF) $(SRC_DIR)/test_fine_delay.v $(SRC_DIR)/sim_mux.v $(CELLS_SRC) && $(VVP) a.out

view_test_fine_delay_digital: $(SIM_OUT)/test_fine_delay.vcd
	gtkwave $(SIM_OUT)/test_fine_delay.vcd

test_mid_delay_digital: $(SIM_OUT)/test_mid_delay.vcd

$(SIM_OUT)/test_mid_delay.vcd: $(SYN_OUT)/MID_DELAY_net.v $(SRC_DIR)/test_mid_delay.v $(SRC_DIR)/measure_delay.v $(SRC_DIR)/sim_mux.v $(CELLS_SRC)
	mkdir -p $(SIM_OUT)
	cp $(SYN_OUT)/MID_DELAY.sdf $(SIM_OUT)/MID_DELAY.sdf
	cp $(SYN_OUT)/MID_DELAY_net.v $(SIM_OUT)/MID_DELAY_net.v
	cp $(SRC_DIR)/measure_delay.v $(SIM_OUT)/measure_delay.v
	cd $(SIM_OUT) && $(IVERILOG) -ginterconnect -gspecify -T max -o a.out -D SIMULATION=1 $(CELLS_ADD_DEF) $(SRC_DIR)/test_mid_delay.v $(SRC_DIR)/sim_mux.v $(CELLS_SRC) && $(VVP) a.out

view_test_mid_delay_digital: $(SIM_OUT)/test_mid_delay.vcd
	gtkwave $(SIM_OUT)/test_mid_delay.vcd

test_coarse_delay_digital: $(SIM_OUT)/test_coarse_delay.vcd

$(SIM_OUT)/test_coarse_delay.vcd: $(SYN_OUT)/COARSE_DELAY_net.v $(SRC_DIR)/test_coarse_delay.v $(SRC_DIR)/measure_delay.v $(CELLS_SRC)
	mkdir -p $(SIM_OUT)
	cp $(SYN_OUT)/COARSE_DELAY.sdf $(SIM_OUT)/COARSE_DELAY.sdf
	cp $(SYN_OUT)/COARSE_DELAY_net.v $(SIM_OUT)/COARSE_DELAY_net.v
	cp $(SRC_DIR)/measure_delay.v $(SIM_OUT)/measure_delay.v
	cd $(SIM_OUT) && $(IVERILOG) -ginterconnect -gspecify -T max -o a.out -D SIMULATION=1 $(CELLS_ADD_DEF) $(SRC_DIR)/test_coarse_delay.v $(CELLS_SRC) && $(VVP) a.out

view_test_coarse_delay_digital: $(SIM_OUT)/test_coarse_delay.vcd
	gtkwave $(SIM_OUT)/test_coarse_delay.vcd

# PLL injection test
test_pll_injection: $(SIM_OUT)/test_pll_injection.raw

$(SIM_OUT)/test_pll_injection.raw: $(SIM_OUT)/PLL_INJECTION.sp $(SRC_DIR)/test_pll_injection.sp $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(SRC_DIR)/test_pll_injection.sp $(SIM_OUT)/test_pll_injection.sp
	cd $(SIM_OUT) && $(NGSPICE) -o test_pll_injection.log test_pll_injection.sp < /dev/null

view_test_pll_injection: $(SIM_OUT)/test_pll_injection.raw
	$(WAVEVIEW) $(SIM_OUT)/test_pll_injection.raw

# Symmetrical circuit delay test
test_sym_delay: $(SIM_OUT)/test_sym_delay.raw

$(SIM_OUT)/test_sym_delay.raw: $(SIM_OUT)/PLL_SYM.sp $(SRC_DIR)/test_sym_delay.sp $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(SRC_DIR)/test_sym_delay.sp $(SIM_OUT)/test_sym_delay.sp
	cd $(SIM_OUT) && $(NGSPICE) -o test_sym_delay.log test_sym_delay.sp < /dev/null

view_test_sym_delay: $(SIM_OUT)/test_sym_delay.raw
	$(WAVEVIEW) $(SIM_OUT)/test_sym_delay.raw

# DCO phase noise test
test_dco: $(SIM_OUT)/test_dco_tran.raw
	$(PYTHON) $(SRC_DIR)/test_dco_get_stable_time.py $(SIM_OUT)/test_dco_tran.raw

$(SIM_OUT)/test_dco_tran.raw: $(SIM_OUT)/PLL_ILDCO.sp $(SRC_DIR)/test_dco.sp $(SRC_DIR)/test_dco_tran.sp $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(SRC_DIR)/test_dco.sp $(SIM_OUT)/test_dco.sp
	cp $(SRC_DIR)/test_dco_tran.sp $(SIM_OUT)/test_dco_tran.sp
	cd $(SIM_OUT) && $(NGSPICE) -o test_dco_tran.log test_dco_tran.sp < /dev/null

view_test_dco: $(SIM_OUT)/test_dco_tran.raw
	$(WAVEVIEW) $(SIM_OUT)/test_dco_tran.raw

# DCO phase noise with the ISF method (Hajimiri & Lee). See src/create_isf.py and src/isf_phase_noise.py
# 1. Steady-state waveforms of the DCO
# 2. One run per oscillating net injecting small charges at ISF_NPHASE phases of the period,
#    plus the drain current noise (.noise) of each kind of transistor. Runs ISF_JOBS in parallel
# 3. Phase noise from the ISFs and the cyclostationary noise of the transistors
ISF_TWARM?=15n
ISF_NPHASE?=128
ISF_NPER?=3
ISF_DQ?=50e-18
ISF_JOBS?=$(shell sysctl -n hw.ncpu 2>/dev/null || nproc)

test_dco_noise: $(SIM_OUT)/test_dco_noise.csv

view_test_dco_noise: $(SIM_OUT)/test_dco_noise.csv
	open $(SIM_OUT)/test_dco_noise.pdf 2>/dev/null || xdg-open $(SIM_OUT)/test_dco_noise.pdf

$(SIM_OUT)/test_dco_isf_wave.raw: $(SIM_OUT)/PLL_ILDCO.sp $(SRC_DIR)/test_dco.sp $(SRC_DIR)/create_isf.py $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(SRC_DIR)/test_dco.sp $(SIM_OUT)/test_dco.sp
	cd $(SIM_OUT) && $(PYTHON) $(SRC_DIR)/create_isf.py wave --twarm $(ISF_TWARM)
	cd $(SIM_OUT) && $(NGSPICE) -o test_dco_isf_wave.log test_dco_isf_wave.sp < /dev/null

$(SIM_OUT)/isf_runs.txt: $(SIM_OUT)/test_dco_isf_wave.raw $(SRC_DIR)/spice_netlist.py
	cd $(SIM_OUT) && $(PYTHON) $(SRC_DIR)/create_isf.py runs --twarm $(ISF_TWARM) --nphase $(ISF_NPHASE) --nper $(ISF_NPER) --dq $(ISF_DQ)

$(SIM_OUT)/isf_done: $(SIM_OUT)/isf_runs.txt
	cd $(SIM_OUT) && xargs -P $(ISF_JOBS) -I{} sh -c '$(NGSPICE) -o {}.log {}.sp < /dev/null > /dev/null && echo "Done {}"' < isf_runs.txt
	touch $@

$(SIM_OUT)/test_dco_noise.csv: $(SIM_OUT)/isf_done $(SRC_DIR)/isf_phase_noise.py
	cd $(SIM_OUT) && $(PYTHON) $(SRC_DIR)/isf_phase_noise.py | tee test_dco_noise.txt

# Main PLL test
test_pll: $(SIM_OUT)/test_pll_tran.raw

$(SIM_OUT)/test_pll_tran.raw: $(SIM_OUT)/pll.sp $(SRC_DIR)/test_pll_tran.sp $(SRC_DIR)/pll_inst_declr.sp $(SRC_DIR)/test_pll.sp $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(SRC_DIR)/test_pll.sp $(SIM_OUT)/test_pll.sp
	cp $(SRC_DIR)/test_pll_tran.sp $(SIM_OUT)/test_pll_tran.sp
	cp $(SRC_DIR)/pll_inst_declr.sp $(SIM_OUT)/pll_inst_declr.sp
	cd $(SIM_OUT) && $(NGSPICE) -o test_pll_tran.log test_pll_tran.sp < /dev/null

view_test_pll: $(SIM_OUT)/test_pll_tran.raw
	$(WAVEVIEW) $(SIM_OUT)/test_pll_tran.raw

test_pll_noise: $(SIM_OUT)/test_pll_noise.raw $(SRC_DIR)/test_pll_plot_phase_noise.py
	$(PYTHON) $(SRC_DIR)/test_pll_plot_phase_noise.py $(SIM_OUT)/test_pll_noise.raw

view_test_pll_noise: $(SIM_OUT)/test_pll_noise.raw $(SRC_DIR)/test_pll_plot_phase_noise.py
	$(WAVEVIEW) $(SIM_OUT)/test_pll_noise.raw

$(SIM_OUT)/test_pll_noise.raw: $(SIM_OUT)/pll.sp $(SRC_DIR)/test_pll_noise.sp $(SRC_DIR)/pll_inst_declr.sp $(SRC_DIR)/test_pll.sp $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(SRC_DIR)/test_pll.sp $(SIM_OUT)/test_pll.sp
	cp $(SRC_DIR)/test_pll_noise.sp $(SIM_OUT)/test_pll_noise.sp
	cp $(SRC_DIR)/pll_inst_declr.sp $(SIM_OUT)/pll_inst_declr.sp
	cd $(SIM_OUT) && $(NGSPICE) -o test_pll_noise.log test_pll_noise.sp < /dev/null

test_pll_rcx: $(PRJ_DIR)/ver/rcx/rundir/xrc_lay.dist.sp $(PRJ_DIR)/ver/rcx/rundir/xrc_lay.dist.sp.pll.pxi $(PRJ_DIR)/src/pll_inst_declr_xrc.sp $(SRC_DIR)/test_pll.sp $(SIM_OUT)/models.inc $(SIM_OUT)/.spiceinit
	cp $(PRJ_DIR)/ver/rcx/rundir/xrc_lay.dist.sp $(SIM_OUT)/pll.sp
	cp $(PRJ_DIR)/ver/rcx/rundir/xrc_lay.dist.sp.pll.pxi $(SIM_OUT)/xrc_lay.dist.sp.pll.pxi
	cp $(PRJ_DIR)/src/pll_inst_declr_xrc.sp $(SIM_OUT)/pll_inst_declr.sp
	cp $(SRC_DIR)/test_pll.sp $(SIM_OUT)/test_pll_rcx.sp
	cd $(SIM_OUT) && $(NGSPICE) -o test_pll_rcx.log test_pll_rcx.sp < /dev/null

view_test_pll_rcx:
	$(WAVEVIEW) $(SIM_OUT)/test_pll_rcx.raw

# Frequency locking RTL simulation
# The legacy target uses the generated sim_dco.v; this stub target is for CI
# when the delay-characterization logs are not available.
test_freq_lock_stub: $(SIM_OUT)/freq_lock_stub.vcd

view_test_freq_lock_stub: $(SIM_OUT)/freq_lock_stub.vcd
	gtkwave $(SIM_OUT)/freq_lock_stub.vcd

$(SIM_OUT)/freq_lock_stub.vcd: $(SRC_DIR)/freq_lock.v $(SRC_DIR)/freq_lock_tb.v $(SRC_DIR)/sim_dco_lock.v $(SRC_DIR)/frequency_counter_frontend.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

test_freq_lock: $(SIM_OUT)/freq_lock_tb.vcd

view_test_freq_lock: $(SIM_OUT)/freq_lock_tb.vcd
	gtkwave $(SIM_OUT)/freq_lock_tb.vcd

$(SIM_OUT)/freq_lock_tb.vcd: $(SRC_DIR)/freq_lock.v $(SRC_DIR)/freq_lock_tb.v $(SIM_OUT)/sim_dco.v $(SRC_DIR)/frequency_counter_frontend.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1 $^ && $(VVP) a.out

# Frequency-counter range and multi-period window regression
test_freq_lock_overflow: $(SIM_OUT)/freq_lock_overflow.vcd

view_test_freq_lock_overflow: $(SIM_OUT)/freq_lock_overflow.vcd
	gtkwave $(SIM_OUT)/freq_lock_overflow.vcd

$(SIM_OUT)/freq_lock_overflow.vcd: $(SRC_DIR)/freq_lock.v $(SRC_DIR)/freq_lock_overflow_tb.v $(SRC_DIR)/frequency_counter_frontend.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1 $^ && $(VVP) a.out

# Digital loop filter RTL simulation
test_dlf: $(SIM_OUT)/digital_loop_filter_tb.vcd

view_test_dlf: $(SIM_OUT)/digital_loop_filter_tb.vcd
	gtkwave $(SIM_OUT)/digital_loop_filter_tb.vcd

$(SIM_OUT)/digital_loop_filter_tb.vcd: $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/digital_loop_filter_tb.v $(SIM_OUT)/sim_dco.v $(SRC_DIR)/sim_SSBBPD.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -ginterconnect -gspecify -T max -o a.out -D SIMULATION=1 $^ && $(VVP) a.out

# Termometer decoder RTL simulation
test_term_decoder: $(SIM_OUT)/term_decoder_tb.vcd

view_test_term_decoder: $(SIM_OUT)/term_decoder_tb.vcd
	gtkwave $(SIM_OUT)/term_decoder_tb.vcd

$(SIM_OUT)/term_decoder_tb.vcd: $(SRC_DIR)/term_decoder_tb.v $(SRC_DIR)/term_decoder.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -ginterconnect -gspecify -T max -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# Delta-sigma modulator RTL simulation
test_delta_sigma: $(SIM_OUT)/delta_sigma_tb.vcd

view_test_delta_sigma: $(SIM_OUT)/delta_sigma_tb.vcd
	gtkwave $(SIM_OUT)/delta_sigma_tb.vcd

$(SIM_OUT)/delta_sigma_tb.vcd: $(SRC_DIR)/delta_sigma_tb.v $(SRC_DIR)/delta_sigma.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -ginterconnect -gspecify -T max -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# Delta-sigma saturation/width regression
test_delta_sigma_sat: $(SIM_OUT)/delta_sigma_sat_tb.vcd

view_test_delta_sigma_sat: $(SIM_OUT)/delta_sigma_sat_tb.vcd
	gtkwave $(SIM_OUT)/delta_sigma_sat_tb.vcd

$(SIM_OUT)/delta_sigma_sat_tb.vcd: $(SRC_DIR)/delta_sigma_sat_tb.v $(SRC_DIR)/delta_sigma.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# SS-BBPD fine-stage lock detector
test_lock_detector: $(SIM_OUT)/lock_detector_tb.vcd

view_test_lock_detector: $(SIM_OUT)/lock_detector_tb.vcd
	gtkwave $(SIM_OUT)/lock_detector_tb.vcd

$(SIM_OUT)/lock_detector_tb.vcd: $(SRC_DIR)/lock_detector_tb.v $(SRC_DIR)/lock_detector.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# REF watchdog liveness and the FCW=1 integer-ratio limitation
test_ref_watchdog: $(SIM_OUT)/ref_watchdog_tb.vcd

view_test_ref_watchdog: $(SIM_OUT)/ref_watchdog_tb.vcd
	gtkwave $(SIM_OUT)/ref_watchdog_tb.vcd

$(SIM_OUT)/ref_watchdog_tb.vcd: $(SRC_DIR)/ref_watchdog_tb.v $(SRC_DIR)/ref_watchdog.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# SS-BBPD four-state contract at both sampling edges
test_ssbbpd_contract: $(SIM_OUT)/ssbbpd_contract_tb.vcd

view_test_ssbbpd_contract: $(SIM_OUT)/ssbbpd_contract_tb.vcd
	gtkwave $(SIM_OUT)/ssbbpd_contract_tb.vcd

$(SIM_OUT)/ssbbpd_contract_tb.vcd: $(SRC_DIR)/ssbbpd_contract_tb.v $(SRC_DIR)/sim_SSBBPD.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# Frequency-count CDC smoke
test_freq_lock_cdc: $(SIM_OUT)/freq_lock_cdc_tb.vcd

view_test_freq_lock_cdc: $(SIM_OUT)/freq_lock_cdc_tb.vcd
	gtkwave $(SIM_OUT)/freq_lock_cdc_tb.vcd

$(SIM_OUT)/freq_lock_cdc_tb.vcd: $(SRC_DIR)/freq_lock_cdc_tb.v $(SRC_DIR)/freq_lock.v $(SRC_DIR)/frequency_counter_frontend.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# Live FCW window, separate from sticky FREQ_LOCKED
test_freq_ok: $(SIM_OUT)/freq_ok_tb.vcd

view_test_freq_ok: $(SIM_OUT)/freq_ok_tb.vcd
	gtkwave $(SIM_OUT)/freq_ok_tb.vcd

$(SIM_OUT)/freq_ok_tb.vcd: $(SRC_DIR)/freq_ok_tb.v $(SRC_DIR)/freq_lock.v $(SRC_DIR)/frequency_counter_frontend.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# DDR CK gate contract (pre-lock quiet, even-ratio duty, fail-closed fault)
test_ddr_ck: $(SIM_OUT)/ddr_ck_tb.vcd

view_test_ddr_ck: $(SIM_OUT)/ddr_ck_tb.vcd
	gtkwave $(SIM_OUT)/ddr_ck_tb.vcd

$(SIM_OUT)/ddr_ck_tb.vcd: $(SRC_DIR)/ddr_ck_tb.v $(SRC_DIR)/ddr_ck.v $(SRC_DIR)/conf_div.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# Lock FSM / LOCKED semantics
test_lock_fsm: $(SIM_OUT)/lock_fsm_tb.vcd

view_test_lock_fsm: $(SIM_OUT)/lock_fsm_tb.vcd
	gtkwave $(SIM_OUT)/lock_fsm_tb.vcd

$(SIM_OUT)/lock_fsm_tb.vcd: $(SRC_DIR)/lock_fsm_tb.v $(SRC_DIR)/pll_logic.v $(SRC_DIR)/ref_watchdog.v $(SRC_DIR)/lock_detector.v $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/term_decoder.v $(SRC_DIR)/freq_lock.v $(SRC_DIR)/delta_sigma.v $(SRC_DIR)/fix_div.v $(SRC_DIR)/conf_div.v $(SRC_DIR)/frequency_counter_frontend.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# Gear shifting: KP/KI switch port->tracking at state 011 and back on loss
test_gear: $(SIM_OUT)/tb_gear.vcd

$(SIM_OUT)/tb_gear.vcd: $(SRC_DIR)/tb_gear.v $(SRC_DIR)/pll_logic.v $(SRC_DIR)/ref_watchdog.v $(SRC_DIR)/lock_detector.v $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/term_decoder.v $(SRC_DIR)/freq_lock.v $(SRC_DIR)/delta_sigma.v $(SRC_DIR)/fix_div.v $(SRC_DIR)/conf_div.v $(SRC_DIR)/frequency_counter_frontend.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# Divider boundary regression
test_divider: $(SIM_OUT)/divider_tb.vcd

view_test_divider: $(SIM_OUT)/divider_tb.vcd
	gtkwave $(SIM_OUT)/divider_tb.vcd

$(SIM_OUT)/divider_tb.vcd: $(SRC_DIR)/divider_tb.v $(SRC_DIR)/conf_div.v $(SRC_DIR)/fix_div.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# PLL fine test
test_pll_fine: $(SIM_OUT)/pll_fine_test.vcd

view_test_pll_fine: $(SIM_OUT)/pll_fine_test.vcd
	gtkwave $(SIM_OUT)/pll_fine_test.vcd

$(SIM_OUT)/pll_fine_test.vcd: $(SRC_DIR)/pll_fine_test.v $(SRC_DIR)/pll_analog.v $(SIM_OUT)/sim_injection.v $(SRC_DIR)/il_dco.v $(SIM_OUT)/sim_dco.v $(SIM_OUT)/sim_sym.v $(SRC_DIR)/sim_SSBBPD.v $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/delta_sigma.v $(SRC_DIR)/term_decoder.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -ginterconnect -gspecify -T max -o a.out -D SIMULATION=1 $^ && $(VVP) a.out

# Main PLL RTL simulation (pre and post-synthesis)
test_pll_digital: $(SIM_OUT)/test_pll.vcd

view_test_pll_digital: $(SIM_OUT)/test_pll.vcd
	gtkwave $(SIM_OUT)/test_pll.vcd

$(SIM_OUT)/test_pll.vcd: $(SRC_DIR)/pll_test.v $(SRC_DIR)/pll.v $(SRC_DIR)/pll_logic.v $(SRC_DIR)/ref_watchdog.v $(SRC_DIR)/ddr_ck.v $(SRC_DIR)/lock_detector.v $(SRC_DIR)/pll_analog.v $(SIM_OUT)/sim_injection.v $(SRC_DIR)/il_dco.v $(SIM_OUT)/sim_dco.v $(SIM_OUT)/sim_sym.v $(SRC_DIR)/sim_SSBBPD.v $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/term_decoder.v $(SRC_DIR)/freq_lock.v $(SRC_DIR)/conf_div.v $(SRC_DIR)/fix_div.v $(SRC_DIR)/delta_sigma.v $(SRC_DIR)/frequency_counter_frontend.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -ginterconnect -gspecify -T max -o a.out -D SIMULATION=1 -D WITH_POWER=1 $^ && $(VVP) a.out

test_pll_digital_postsyn: $(SIM_OUT)/test_pll_postsyn.vcd

view_test_pll_digital_postsyn: $(SIM_OUT)/test_pll_postsyn.vcd
	gtkwave $(SIM_OUT)/test_pll_postsyn.vcd

$(SIM_OUT)/test_pll_postsyn.vcd: $(CELLS_SRC) $(SRC_DIR)/pll_test.v $(SRC_DIR)/pll.v $(SYN_OUT)/pll_logic_net.v $(SRC_DIR)/pll_analog.v $(SIM_OUT)/sim_injection.v $(SRC_DIR)/il_dco.v $(SIM_OUT)/sim_dco.v $(SIM_OUT)/sim_sym.v $(SRC_DIR)/sim_SSBBPD.v $(SRC_DIR)/conf_div.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -ginterconnect -gspecify -T max -o a.out -D SIMULATION=1 $(CELLS_ADD_DEF) $^ && $(VVP) a.out

$(SIM_OUT)/%.sp: $(SYN_OUT)/%.sp
	mkdir -p $(SIM_OUT)
	cp $^ $@

$(SYN_OUT)/%.sp: $(SYN_OUT)/%_net.v
	make -C $(SYN_DIR) TOP=$* gen

# Also on the sources (RTL and the PLL_CELL_* map of the PDK), as the netlists of syn/Makefile
$(SYN_OUT)/%_net.v: $(SYN_DIR)/Makefile $(SYN_SRC)
	make -C $(SYN_DIR) TOP=$* all
	make -C $(SYN_DIR) TOP=$* sdf

$(SIM_OUT)/sim_dco.v: $(SIM_OUT)/test_fine_delay.raw $(SIM_OUT)/test_mid_delay.raw $(SIM_OUT)/test_coarse_delay.raw $(SRC_DIR)/create_sim_dco.py
	$(PYTHON) $(SRC_DIR)/create_sim_dco.py $(SIM_OUT)/test_fine_delay.log $(SIM_OUT)/test_mid_delay.log $(SIM_OUT)/test_coarse_delay.log > $(SIM_OUT)/sim_dco.v

$(SIM_OUT)/sim_injection.v: $(SIM_OUT)/test_pll_injection.raw $(SRC_DIR)/create_sim_inj.py
	$(PYTHON) $(SRC_DIR)/create_sim_inj.py $(SIM_OUT)/test_pll_injection.log > $(SIM_OUT)/sim_injection.v

$(SIM_OUT)/sim_sym.v: $(SIM_OUT)/test_sym_delay.raw $(SRC_DIR)/create_sim_sym.py
	$(PYTHON) $(SRC_DIR)/create_sim_sym.py $(SIM_OUT)/test_sym_delay.log > $(SIM_OUT)/sim_sym.v

# Some metric tests
show_delay_overlap: $(SIM_OUT)/test_mid_delay.raw $(SIM_OUT)/test_fine_delay.raw $(SIM_OUT)/test_coarse_delay.raw $(SRC_DIR)/delay_char.py
	$(PYTHON) $(SRC_DIR)/delay_char.py $(SIM_OUT)/test_fine_delay.log $(SIM_OUT)/test_mid_delay.log $(SIM_OUT)/test_coarse_delay.log

show_delay_overlap_digital: $(SIM_OUT)/test_mid_delay.vcd $(SIM_OUT)/test_fine_delay.vcd $(SIM_OUT)/test_coarse_delay.vcd $(SRC_DIR)/delay_char.py
	$(PYTHON) $(SRC_DIR)/delay_char.py $(SIM_OUT)/test_fine_delay.vcd.mt0 $(SIM_OUT)/test_mid_delay.vcd.mt0 $(SIM_OUT)/test_coarse_delay.vcd.mt0

.SECONDARY:

# DDR clock PHY path: DCC -> static phase selector, fixed 200 MHz
test_ddr_clock_phy: $(SIM_OUT)/ddr_clock_phy_tb.vcd

view_test_ddr_clock_phy: $(SIM_OUT)/ddr_clock_phy_tb.vcd
	gtkwave $(SIM_OUT)/ddr_clock_phy_tb.vcd

$(SIM_OUT)/ddr_clock_phy_tb.vcd: $(SRC_DIR)/ddr_clock_phy_tb.v $(SRC_DIR)/ddr_clock_phy.v $(SRC_DIR)/ddr_ck_pad_model.v $(SRC_DIR)/adcc_top.v $(SRC_DIR)/addll_top.v $(SRC_DIR)/dll_full_period_top.v $(SRC_DIR)/dll_dcdl.v $(SRC_DIR)/dll_tdc.v $(SRC_DIR)/phase_selector_top.v $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/term_decoder.v $(SRC_DIR)/pll_counter_dcdl.v $(SRC_DIR)/sim_SSBBPD.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o a.out -D SIMULATION=1  $^ && $(VVP) a.out

# DLL_DCDL segmented line: all codes, monotonic, coarse-boundary steps.
test_dll_dcdl: $(SIM_OUT)/dll_dcdl.out
	cd $(SIM_OUT) && timeout 120s $(VVP) dll_dcdl.out
.PHONY: test_dll_dcdl

$(SIM_OUT)/dll_dcdl.out: $(SRC_DIR)/dll_dcdl_tb.v $(SRC_DIR)/dll_dcdl.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o dll_dcdl.out $^

# Route B full-period DLL: absolute range acquisition + valid-edge lock.
test_dll_full_period: $(SIM_OUT)/dll_full_period.out
	cd $(SIM_OUT) && timeout 180s $(VVP) dll_full_period.out
.PHONY: test_dll_full_period

$(SIM_OUT)/dll_full_period.out: $(SRC_DIR)/dll_full_period_tb.v $(SRC_DIR)/dll_full_period_top.v $(SRC_DIR)/dll_dcdl.v $(SRC_DIR)/dll_tdc.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o dll_full_period.out $^

# Physical delay-line TDC (behavioral cell delays) with the DLL controller.
test_dll_phys_tdc: $(SIM_OUT)/dll_phys_tdc.out
	cd $(SIM_OUT) && timeout 1200s $(VVP) dll_phys_tdc.out
.PHONY: test_dll_phys_tdc

$(SIM_OUT)/dll_phys_tdc.out: $(SRC_DIR)/dll_phys_tdc_tb.v $(SRC_DIR)/dll_full_period_top.v $(SRC_DIR)/dll_dcdl.v $(SRC_DIR)/dll_tdc.v $(SRC_DIR)/dll_tdc_phys.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o dll_phys_tdc.out $^

# Route B range revalidation (period step) and missing-edge ALIVE.
test_dll_range_reval: $(SIM_OUT)/dll_range_reval.out
	cd $(SIM_OUT) && timeout 180s $(VVP) dll_range_reval.out
.PHONY: test_dll_range_reval

$(SIM_OUT)/dll_range_reval.out: $(SRC_DIR)/dll_range_reval_tb.v $(SRC_DIR)/dll_full_period_top.v $(SRC_DIR)/dll_dcdl.v $(SRC_DIR)/dll_tdc.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o dll_range_reval.out $^

# Route B PHY integration with a uniform 200 MHz reference.
test_ddr_phy_dll: $(SIM_OUT)/ddr_clock_phy_dll.out
	cd $(SIM_OUT) && timeout 180s $(VVP) ddr_clock_phy_dll.out
.PHONY: test_ddr_phy_dll

$(SIM_OUT)/ddr_clock_phy_dll.out: $(SRC_DIR)/ddr_clock_phy_dll_tb.v $(SRC_DIR)/ddr_clock_phy.v $(SRC_DIR)/adcc_top.v $(SRC_DIR)/addll_top.v $(SRC_DIR)/dll_full_period_top.v $(SRC_DIR)/dll_dcdl.v $(SRC_DIR)/dll_tdc.v $(SRC_DIR)/phase_selector_top.v $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/term_decoder.v $(SRC_DIR)/pll_counter_dcdl.v $(SRC_DIR)/sim_SSBBPD.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o ddr_clock_phy_dll.out -D SIMULATION=1 $^

# ADPLL divider -> DCC -> selector connectivity/frequency smoke
test_ddr_clock_phy_integration: $(SIM_OUT)/ddr_clock_phy_integration.out
	cd $(SIM_OUT) && timeout 240s $(VVP) ddr_clock_phy_integration.out
.PHONY: test_ddr_clock_phy_integration

view_test_ddr_clock_phy_integration: $(SIM_OUT)/ddr_clock_phy_integration.vcd
	gtkwave $(SIM_OUT)/ddr_clock_phy_integration.vcd

$(SIM_OUT)/ddr_clock_phy_integration.out: $(SRC_DIR)/ddr_clock_phy_integration_tb.v $(SRC_DIR)/ddr_clock_phy.v $(SRC_DIR)/adcc_top.v $(SRC_DIR)/addll_top.v $(SRC_DIR)/dll_full_period_top.v $(SRC_DIR)/dll_dcdl.v $(SRC_DIR)/dll_tdc.v $(SRC_DIR)/phase_selector_top.v $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/term_decoder.v $(SRC_DIR)/pll_counter_dcdl.v $(SRC_DIR)/pll_macro_top.v $(SRC_DIR)/pll_logic.v $(SRC_DIR)/ref_watchdog.v $(SRC_DIR)/ddr_ck.v $(SRC_DIR)/lock_detector.v $(SRC_DIR)/freq_lock.v $(SRC_DIR)/delta_sigma.v $(SRC_DIR)/fix_div.v $(SRC_DIR)/conf_div.v $(SRC_DIR)/frequency_counter_frontend.v $(ROOT_DIR)/flow/macro/ics55_h7cr/pll_analog_macro.v $(SRC_DIR)/pll_analog.v $(SRC_DIR)/il_dco.v $(SRC_DIR)/sim_dco.v $(SRC_DIR)/sim_injection.v $(SRC_DIR)/sim_sym.v $(SRC_DIR)/sim_mux.v $(SRC_DIR)/sim_SSBBPD.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o ddr_clock_phy_integration.out -D SIMULATION  $^

# Non-SIMULATION structural check: phase-selector tap bus is driven by a
# real fine-delay chain, not an undriven placeholder.  The cell stubs are
# PDK-independent structural models, not timing/signoff views.
test_ddr_phy_non_sim:
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -s PHASE_SELECTOR_TOP -o phase_selector_non_sim.vvp $(SRC_DIR)/pll_cells_elab_stub.v $(SRC_DIR)/fine_delay.v $(SRC_DIR)/pll_dcdl_tap_bus_phys.v $(SRC_DIR)/phase_selector_top.v
	cd $(SIM_OUT) && $(YOSYS) -p "read_verilog $(SRC_DIR)/pll_cells_elab_stub.v $(SRC_DIR)/fine_delay.v $(SRC_DIR)/pll_dcdl_tap_bus_phys.v $(SRC_DIR)/phase_selector_top.v; synth -top PHASE_SELECTOR_TOP; stat" > phase_selector_non_sim.yosys.log
.PHONY: test_ddr_phy_non_sim

# Real ics55 cells: non-SIMULATION elaboration, Yosys synthesis, and
# OpenSTA tap-step measurement.  The default PDK path can be overridden.
ICS55_REAL_ROOT ?= /grid/icsprout55-pdk
FLOW_STA_DIR = $(ROOT_DIR)/flow/sta
STA ?= sta

test_ddr_phy_ics55_io:
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o ddr_phy_io.out -D SIMULATION=1 -D ICS55_IO $(SRC_DIR)/ddr_clock_phy_tb.v $(SRC_DIR)/ddr_clock_phy.v $(SRC_DIR)/ddr_ck_pad_model.v $(SRC_DIR)/ics55_ddr_ck_pad.v $(SRC_DIR)/adcc_top.v $(SRC_DIR)/addll_top.v $(SRC_DIR)/dll_full_period_top.v $(SRC_DIR)/dll_dcdl.v $(SRC_DIR)/dll_tdc.v $(SRC_DIR)/phase_selector_top.v $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/term_decoder.v $(SRC_DIR)/pll_counter_dcdl.v $(SRC_DIR)/sim_SSBBPD.v $(ICS55_REAL_ROOT)/libs.ref/ICsprout_55LLULP1233_IO_251013/verilog/icsIOA_N55_3P3.v
	cd $(SIM_OUT) && $(VVP) ddr_phy_io.out
.PHONY: test_ddr_phy_ics55_io

# Legacy COARSE-only physical DCDL.  Its 5 ns coverage failure is known and
# intentionally not part of the new-design signoff; this target passes only
# when the legacy gate still reports BLOCKED.
test_ddr_phy_legacy_blocked:
	@if ROOT=$(ROOT_DIR) ICS55_REAL_ROOT=$(ICS55_REAL_ROOT) SIM_OUT=$(SIM_OUT) \
	    IVERILOG='$(IVERILOG)' YOSYS='$(YOSYS)' STA='$(STA)' \
	    sh $(FLOW_STA_DIR)/run_ddr_phy_corners.sh; then \
	  echo "FAIL: legacy COARSE-only DCDL unexpectedly passed the strict gate"; \
	  exit 1; \
	else \
	  echo "PASS: legacy COARSE-only DCDL remains BLOCKED (expected)"; \
	fi
.PHONY: test_ddr_phy_legacy_blocked

# Same legacy gate, kept explicit for evidence/diagnosis.
test_ddr_phy_real_cells:
	ROOT=$(ROOT_DIR) ICS55_REAL_ROOT=$(ICS55_REAL_ROOT) SIM_OUT=$(SIM_OUT) \
	  IVERILOG='$(IVERILOG)' YOSYS='$(YOSYS)' STA='$(STA)' \
	  sh $(FLOW_STA_DIR)/run_ddr_phy_corners.sh
.PHONY: test_ddr_phy_real_cells

# 4-segment bypass DCDL coverage gate: 4.5-5.5 ns at TT/SS/FF.
test_segmented_dcdl:
	ROOT=$(ROOT_DIR) ICS55_REAL_ROOT=$(ICS55_REAL_ROOT) SIM_OUT=$(SIM_OUT) \
	  YOSYS='$(YOSYS)' STA='$(STA)' \
	  sh $(FLOW_STA_DIR)/run_segmented_corners.sh
.PHONY: test_segmented_dcdl

# Physical TDC line STA + gate-level/SDF ACQ smoke at TT/SS/FF.
test_dll_phys_tdc_gl:
	ROOT=$(ROOT_DIR) ICS55_REAL_ROOT=$(ICS55_REAL_ROOT) SIM_OUT=$(SIM_OUT) \
	  YOSYS='$(YOSYS)' STA='$(STA)' IVERILOG='$(IVERILOG)' VVP='$(VVP)' \
	  sh $(FLOW_STA_DIR)/run_tdc_phys_gl.sh
.PHONY: test_dll_phys_tdc_gl

# Full gate-level/SDF DLL closure at TT/SS/FF (LOCKED + full-period phase).
test_dll_gate:
	ROOT=$(ROOT_DIR) ICS55_REAL_ROOT=$(ICS55_REAL_ROOT) SIM_OUT=$(SIM_OUT) \
	  YOSYS='$(YOSYS)' STA='$(STA)' IVERILOG='$(IVERILOG)' VVP='$(VVP)' \
	  sh $(FLOW_STA_DIR)/run_dll_gate.sh
.PHONY: test_dll_gate

# Behavioral phys-TDC and range-revalidation calibration checks are kept as
# explicit targets: see flow/DDR_CLOCK_PHY_PATH.md for the SS pulse-width
# offset.  The gate-level/SDF closure is test_dll_phys_tdc_gl + test_dll_gate.
test_ddr_phy: test_ddr_clock_phy test_dll_dcdl test_dll_full_period test_ddr_phy_dll test_ddr_clock_phy_integration test_ddr_phy_non_sim test_ddr_phy_ics55_io test_segmented_dcdl test_ddr_phy_legacy_blocked test_dll_phys_tdc_gl test_dll_gate
.PHONY: test_ddr_phy

# P0-A correctness gate (fast RTL regressions)
test_p0: test_delta_sigma_sat test_divider test_lock_detector test_ssbbpd_contract test_ref_watchdog test_lock_fsm test_gear test_freq_ok test_freq_lock_cdc test_freq_lock_stub test_ddr_ck test_dll_dcdl test_dll_full_period test_ddr_clock_phy test_ddr_phy_dll test_ddr_clock_phy_integration test_pll_macro_smoke
.PHONY: test_p0

# Closed-loop smoke with the macro wrapper and behavioral sim_* models.
# This is an elaboration/connectivity smoke; it does not yet claim lock.
test_pll_macro_smoke: $(SIM_OUT)/pll_macro_top.out
	cd $(SIM_OUT) && timeout 180s $(VVP) pll_macro_top.out
.PHONY: test_pll_macro_smoke

$(SIM_OUT)/pll_macro_top.out: $(SRC_DIR)/pll_macro_top_tb.v $(SRC_DIR)/pll_macro_top.v $(SRC_DIR)/pll_logic.v $(SRC_DIR)/ref_watchdog.v $(SRC_DIR)/ddr_ck.v $(SRC_DIR)/lock_detector.v $(SRC_DIR)/digital_loop_filter.v $(SRC_DIR)/term_decoder.v $(SRC_DIR)/freq_lock.v $(SRC_DIR)/delta_sigma.v $(SRC_DIR)/fix_div.v $(SRC_DIR)/conf_div.v $(ROOT_DIR)/flow/macro/ics55_h7cr/pll_analog_macro.v $(SRC_DIR)/pll_analog.v $(SRC_DIR)/il_dco.v $(SRC_DIR)/sim_dco.v $(SRC_DIR)/sim_injection.v $(SRC_DIR)/sim_sym.v $(SRC_DIR)/sim_mux.v $(SRC_DIR)/sim_SSBBPD.v $(SRC_DIR)/frequency_counter_frontend.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o pll_macro_top.out -D SIMULATION  $^

# Behavioral Core B/C architecture models
test_arch_models: $(SIM_OUT)/arch_models.out

$(SIM_OUT)/arch_models.out: $(SRC_DIR)/arch_models_tb.v $(SRC_DIR)/pll_ring_dco.v $(SRC_DIR)/pll_counter_dco.v $(SRC_DIR)/sim_SSBBPD.v
	mkdir -p $(SIM_OUT)
	cd $(SIM_OUT) && $(IVERILOG) -g2012 -o arch_models.out -D SIMULATION=1 $^ && $(VVP) arch_models.out
