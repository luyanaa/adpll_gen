#!/usr/bin/env python3
"""Generate the dll8_line4 stub Liberties (tt/ss/ff corners).

Stub timing only: the macro is analog-meaningful, not logic-timing-meaningful
-- IN->OUT/TAP get constant combinational arcs so OpenROAD can link and STA
does not error out.  Phase accuracy signoff lives in SPICE
(flow/characterization/dll8_pex2 + docs/dco_8phase_decision.md), not here.
Pin names match the LEF mterms exactly: IN, OUT, TAP0..TAP3 scalar,
EN0..EN3 as 127-bit buses (bit_from 126 bit_to 0), VDD/VSS pg_pins.
Yosys/Verilog/liberty consistency verified 2026-11-28 (the TAP[i] bus-style
variant crashes the Yosys liberty reader).
"""


def emit(voltage, temp, fname):
    parts = []
    parts.append(f"""library (dll8_line4) {{
  delay_model : table_lookup;
  capacitive_load_unit (1,pF);
  leakage_power_unit : 1pW;
  current_unit : "1uA";
  pulling_resistance_unit : "1kohm";
  time_unit : "1ns";
  voltage_unit : "1v";
  input_threshold_pct_rise : 50;
  input_threshold_pct_fall : 50;
  output_threshold_pct_rise : 50;
  output_threshold_pct_fall : 50;
  slew_lower_threshold_pct_rise : 20;
  slew_lower_threshold_pct_fall : 20;
  slew_upper_threshold_pct_rise : 80;
  slew_upper_threshold_pct_fall : 80;
  slew_derate_from_library : 1.0;
  nom_process : 1.0;
  nom_temperature : {temp};
  nom_voltage : {voltage};
  default_cell_leakage_power : 0;
  lu_table_template(tt) {{
    variable_1 : total_output_net_capacitance;
    index_1("0.001, 0.01, 0.1");
  }}
  lu_table_template(ti) {{
    variable_1 : input_net_transition;
    index_1("0.001, 0.01, 0.1");
  }}
  type ("EN_T") {{
    base_type : array;
    data_type : bit;
    bit_width : 127;
    bit_from : 126;
    bit_to : 0;
  }}
  cell (dll8_line4) {{
    area : 24150;
    dont_use : true;
    dont_touch : true;
    pg_pin (VDD) {{ pg_type : primary_power; voltage_name : VDD; }}
    pg_pin (VSS) {{ pg_type : primary_ground; voltage_name : VSS; }}
    pin (IN) {{
      direction : input;
      capacitance : 0.01;
      max_transition : 0.5;
    }}
""")
    for k in range(4):
        parts.append(f"""    bus (EN{k}) {{
      bus_type : EN_T;
      direction : input;
      capacitance : 0.002;
    }}
""")
    for i in range(4):
        parts.append(f"""    pin (TAP{i}) {{
      direction : output;
      function : "IN";
      max_capacitance : 0.05;
      timing () {{
        related_pin : "IN";
        timing_type : combinational;
        cell_rise (tt) {{ values ("0.1, 0.1, 0.1"); }}
        cell_fall (tt) {{ values ("0.1, 0.1, 0.1"); }}
        rise_transition (ti) {{ values ("0.02, 0.02, 0.02"); }}
        fall_transition (ti) {{ values ("0.02, 0.02, 0.02"); }}
      }}
    }}
""")
    parts.append(f"""    pin (OUT) {{
      direction : output;
      function : "IN";
      max_capacitance : 0.05;
      timing () {{
        related_pin : "IN";
        timing_type : combinational;
        cell_rise (tt) {{ values ("0.2, 0.2, 0.2"); }}
        cell_fall (tt) {{ values ("0.2, 0.2, 0.2"); }}
        rise_transition (ti) {{ values ("0.02, 0.02, 0.02"); }}
        fall_transition (ti) {{ values ("0.02, 0.02, 0.02"); }}
      }}
    }}
  }}
  voltage_map (VDD, {voltage});
  voltage_map (VSS, 0.0);
}}
""")
    with open(fname, "w") as f:
        f.write("".join(parts))
    print("wrote", fname)


if __name__ == "__main__":
    import os
    here = os.path.dirname(os.path.abspath(__file__))
    emit("1.20", "25.0", os.path.join(here, "dll8_line4__tt.lib"))
    emit("1.08", "125.0", os.path.join(here, "dll8_line4__ss.lib"))
    emit("1.32", "-40.0", os.path.join(here, "dll8_line4__ff.lib"))
