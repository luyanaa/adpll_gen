#!/usr/bin/env python3
"""Convert SkyWater sky130 per-cell ``.lib.json`` timing dumps to a Liberty ``.lib``.

The sky130 JSON files are a Liberty-AST-like dump:

  * ``timing/<lib>__common.lib.json``  -- library defaults (units, templates, ...)
  * ``timing/<lib>__<corner>.lib.json`` -- library header for one PVT corner
                                          (templates, operating conditions, defines)
  * ``cells/<base>/<lib>__<cell>__<corner>.lib.json`` -- one cell group body
                                          (no enclosing ``cell (...)`` group)

Each JSON object maps a key to a value:

  * ``key`` without a comma            -> simple attribute (scalar or list)
  * ``key,instance``                   -> group ``key`` with instance name ``instance``
  * a value that is a dict             -> group body (or a single unnamed group)
  * a list of dicts                    -> repeated groups of the same type
  * a list of scalars for ``index_N``  -> Liberty index list
  * a list of scalars for ``values``   -> Liberty value row(s)
  * a list of scalars for ``table``    -> repeated ``table : "..."`` rows (statetable)

The converter emits one Liberty library: header attributes, templates,
operating conditions, then every cell for the requested corner.

Usage:
    python3 convert_libjson.py --lib sky130_fd_sc_ms --corner ss_n40C_1v28 \
        --out out/sky130_fd_sc_ms_ss_n40C_1v28.lib

The output is a reconstruction of the source data, not a vendor-signed-off
Liberty file.  See README.md for the completeness/quality notes.
"""

from __future__ import annotations

import argparse
import json
import math
import os
import re
import sys
from collections import Counter, OrderedDict

PROG = "convert_libjson.py"
VERSION = "1.0.0"

# ---------------------------------------------------------------------------
# Liberty formatting tables
# ---------------------------------------------------------------------------

# Attributes whose values are Liberty keywords/identifiers.  Emitting these
# unquoted matches the formatting of the vendor/reference .lib files.
BARE_ATTRS = {
    "base_type",
    "data_type",
    "default_constraint_arc_mode",
    "default_operating_conditions",
    "direction",
    "down_to",
    "in_place_swap_mode",
    "input_voltage",
    "min_pulse_width_mode",
    "output_voltage",
    "pg_type",
    "physical_connection",
    "related_bias_pin",
    "related_ground_pin",
    "related_power_pin",
    "timing_sense",
    "timing_type",
    "tree_type",
    "variable_1",
    "variable_2",
    "variable_3",
    "variable_4",
    "voltage_name",
}

# Boolean attributes (JSON stores them as the strings "true"/"false").
BOOL_ATTRS = {
    "clock",
    "dont_touch",
    "dont_use",
    "down_to",
    "downto",
    "is_inverting",
    "is_needed",
    "simulation",
    "switching_power_split_model",
}

# Table/transition group names that reference an lu_table_template.
LU_TABLE_GROUPS = {
    "cell_rise",
    "cell_fall",
    "rise_transition",
    "fall_transition",
    "rise_constraint",
    "fall_constraint",
    "ocv_sigma_cell_rise",
    "ocv_sigma_cell_fall",
    "ocv_sigma_rise_transition",
    "ocv_sigma_fall_transition",
    "ocv_sigma_rise_constraint",
    "ocv_sigma_fall_constraint",
    "dc_current",
}

# Groups that reference a power_lut_template.
POWER_TABLE_GROUPS = {
    "rise_power",
    "fall_power",
    "rise_power_range",
    "fall_power_range",
}

# Ordering of library-level groups (Liberty parsers resolve templates while
# parsing, so templates and operating conditions must precede their users).
GROUP_RANK = {
    "lu_table_template": 0,
    "power_lut_template": 1,
    "output_current_template": 2,
    "normalized_driver_waveform": 3,
    "operating_conditions": 4,
    "type": 5,
    "input_voltage": 6,
    "output_voltage": 7,
}

# Library attributes emitted before everything else, in this order.
LIB_ATTR_ORDER = [
    "delay_model",
    "time_unit",
    "voltage_unit",
    "current_unit",
    "leakage_power_unit",
    "pulling_resistance_unit",
    "nom_process",
    "nom_temperature",
    "nom_voltage",
    "default_operating_conditions",
    "default_cell_leakage_power",
    "default_fanout_load",
    "default_inout_pin_cap",
    "default_input_pin_cap",
    "default_leakage_power_density",
    "default_output_pin_cap",
    "default_max_transition",
    "input_threshold_pct_fall",
    "input_threshold_pct_rise",
    "output_threshold_pct_fall",
    "output_threshold_pct_rise",
    "slew_lower_threshold_pct_fall",
    "slew_lower_threshold_pct_rise",
    "slew_upper_threshold_pct_fall",
    "slew_upper_threshold_pct_rise",
    "slew_derate_from_library",
    "bus_naming_style",
    "revision",
    "simulation",
    "in_place_swap_mode",
    "default_arc_mode",
    "default_constraint_arc_mode",
    "driver_model",
    "switching_power_split_model",
    "tran_timestep",
    "min_pulse_width_mode",
    "snps_predriver_ratio",
]

INDEX_RE = re.compile(r"^index_\d+$")
IDENT_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
NUMBER_RE = re.compile(r"^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$")


class ConversionError(RuntimeError):
    """Fatal conversion problem (missing data, invalid structure, ...)."""


# ---------------------------------------------------------------------------
# Value formatting
# ---------------------------------------------------------------------------


def fmt_num(value) -> str:
    """Format a Liberty number.

    ``repr()`` of a Python float gives the shortest round-tripping decimal,
    which preserves the source values exactly.  Fib: reject NaN/inf, which
    Liberty cannot represent.
    """
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        if math.isnan(value) or math.isinf(value):
            raise ConversionError("non-finite number in table data: %r" % value)
        return repr(value)
    if isinstance(value, str):
        # A few dumps store numbers as strings; keep them verbatim if numeric.
        if NUMBER_RE.match(value.strip()):
            return value.strip()
        raise ConversionError("expected a number, got string %r" % value)
    raise ConversionError("expected a number, got %r" % (value,))


def quote(value: str) -> str:
    """Quote a Liberty string, escaping backslashes and double quotes."""
    text = str(value)
    text = text.replace("\\", "\\\\").replace('"', '\\"')
    return '"%s"' % text


def fmt_attr_value(name: str, value) -> str:
    """Format a scalar attribute value."""
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return fmt_num(value)
    text = str(value)
    if name in BOOL_ATTRS and text.lower() in ("true", "false"):
        return text.lower()
    if name in BARE_ATTRS and IDENT_RE.match(text):
        return text
    return quote(text)


def fmt_paren_number(value) -> str:
    """Number formatting inside a parenthesised Liberty attribute."""
    if isinstance(value, str):
        return value
    if isinstance(value, float) and value.is_integer() and abs(value) < 1e15:
        # capacitive_load_unit (1,pf) rather than (1.0,pf)
        return str(int(value))
    return fmt_num(value)


def fmt_paren_name(value: str) -> str:
    text = str(value)
    if IDENT_RE.match(text) or NUMBER_RE.match(text):
        return text
    return quote(text)


def _qm_minimize(nbits: int, minterms) -> list:
    """Small Quine-McCluskey cover for <= 8 input variables.

    Returns a list of cubes, each a tuple of 0/1/'-' values.  Used only by the
    opt-in ``--derive-icg-functions`` mode.
    """
    minterms = set(minterms)
    if not minterms:
        return []
    terms = [(tuple((m >> (nbits - 1 - i)) & 1 for i in range(nbits)), {m}) for m in minterms]
    primes = []
    while terms:
        used = set()
        merged = {}
        for i in range(len(terms)):
            for j in range(i + 1, len(terms)):
                c1, s1 = terms[i]
                c2, s2 = terms[j]
                diff = [k for k in range(nbits) if c1[k] != c2[k]]
                if len(diff) == 1 and "-" not in (c1[diff[0]], c2[diff[0]]):
                    cube = list(c1)
                    cube[diff[0]] = "-"
                    merged.setdefault(tuple(cube), set()).update(s1 | s2)
                    used.add(i)
                    used.add(j)
        for i, (cube, covered) in enumerate(terms):
            if i not in used:
                primes.append((cube, set(covered)))
        terms = [(cube, set(covered)) for cube, covered in merged.items()]

    uncovered = set(minterms)
    chosen = []
    while uncovered:
        best = None
        best_cover = set()
        for cube, covered in primes:
            cover = covered & uncovered
            if len(cover) > len(best_cover):
                best, best_cover = cube, cover
        if not best_cover:
            break
        chosen.append(best)
        uncovered -= best_cover
    return chosen


def _cube_to_expr(cube, names) -> str:
    literals = []
    for bit, name in zip(cube, names):
        if bit == 1:
            literals.append(name)
        elif bit == 0:
            literals.append("!" + name)
    if not literals:
        return "1"
    if len(literals) == 1:
        return literals[0]
    return "(" + " & ".join(literals) + ")"


def derive_icg_functions(body: dict, stats: Counter) -> None:
    """Opt-in Yosys-plain compatibility: derive ICG output/internal functions.

    The JSON contains ``state_function`` on the clock-gate output and a
    ``statetable`` for the internal latch node.  This derives a purely
    combinational function for the internal node (the latch data input), so
    that plain ``yosys read_liberty`` accepts the cell.  Timing data is not
    touched.  This is off by default; see README.
    """
    pins = {key[4:]: value for key, value in body.items()
            if key.startswith("pin,") and isinstance(value, dict)}
    input_names = [name for name, value in pins.items() if value.get("direction") == "input"]

    for key, value in body.items():
        if not key.startswith("statetable,") or not isinstance(value, dict):
            continue
        instance = key.split(",", 1)[1]
        if "," not in instance:
            continue
        inputs_part, state_name = instance.split(",", 1)
        inputs_part = inputs_part.strip()
        state_name = state_name.strip()
        signal_names = inputs_part.split()
        if not signal_names or state_name not in pins:
            continue
        if "function" in pins[state_name]:
            continue
        rows = value.get("table", [])
        if not isinstance(rows, list) or not rows:
            continue

        # Identify the gating clock so it can be projected out: the latch data
        # function is defined while the clock is transparent (all non-"N" rows).
        clock_name = None
        for name in signal_names:
            pin = pins.get(name, {})
            if pin.get("clock_gate_clock_pin"):
                clock_name = name
                break
        keep = [name for name in signal_names if name != clock_name]
        if not keep or len(keep) > 8:
            continue

        table = {}
        inconsistent = False
        for row in rows:
            text = str(row)
            fields = [part.strip() for part in text.split(":")]
            if len(fields) != 3:
                continue
            values = fields[0].split()
            nxt = fields[2].strip()
            if len(values) != len(signal_names):
                continue
            if nxt == "N":
                continue
            if nxt not in ("L", "H"):
                continue
            key_bits = tuple(values[signal_names.index(name)] for name in keep)
            if "-" in key_bits:
                continue
            bit = 1 if nxt == "H" else 0
            if key_bits in table and table[key_bits] != bit:
                inconsistent = True
                break
            table[key_bits] = bit
        if inconsistent or not table:
            continue

        minterms = []
        for combo, bit in table.items():
            if bit == 0:
                continue
            index = 0
            for value_bit in combo:
                index = (index << 1) | (1 if value_bit == "H" else 0)
            minterms.append(index)
        if not minterms:
            continue
        cubes = _qm_minimize(len(keep), minterms)
        if not cubes:
            continue
        expr = " | ".join(_cube_to_expr(cube, keep) for cube in cubes)
        pins[state_name]["function"] = expr
        stats["derived_internal_functions"] += 1

    for name, value in pins.items():
        if value.get("direction") not in ("output", "inout"):
            continue
        if "function" in value:
            continue
        if value.get("clock_gate_out_pin") and "state_function" in value:
            value["function"] = value["state_function"]
            stats["derived_icg_outputs"] += 1



# ---------------------------------------------------------------------------
# Structure helpers
# ---------------------------------------------------------------------------


def split_group_key(key: str):
    """Split ``group,instance`` keys.  Returns (group, instance) or None."""
    if "," not in key:
        return None
    group, instance = key.split(",", 1)
    return group, instance


def is_scalar(value) -> bool:
    return isinstance(value, (str, int, float, bool))


def is_list_of_dicts(value) -> bool:
    return isinstance(value, list) and bool(value) and all(isinstance(e, dict) for e in value)


def natural_key(text: str):
    return [int(part) if part.isdigit() else part for part in re.split(r"(\d+)", text)]


def flatten_rows(values) -> list:
    """Normalise a ``values`` payload to a list of rows (each a list of nums).

    1-D data becomes one row.  Deeper nesting (CCS vectors with index_3) is
    flattened row-major into the enclosing row; documented as a limitation.
    """
    if not isinstance(values, list):
        raise ConversionError("'values' is not a list: %r" % (values,))
    if not values:
        return [[]]
    if is_scalar(values[0]):
        return [list(values)]
    rows = []
    for element in values:
        if isinstance(element, list):
            if element and isinstance(element[0], list):
                flat = []
                for sub in element:
                    flat.extend(sub)
                rows.append(flat)
            else:
                rows.append(list(element))
        else:
            rows.append([element])
    return rows


def count_table_dim_mismatches(name, data):
    """Return a list of human readable dimension problems for one table."""
    problems = []
    if not isinstance(data, dict):
        return problems
    n_index1 = len(data.get("index_1", []) or [])
    n_index2 = len(data.get("index_2", []) or [])
    if "values" not in data:
        return problems
    rows = flatten_rows(data["values"])
    if n_index2:
        for i, row in enumerate(rows):
            if len(row) != n_index2:
                problems.append(
                    "%s: row %d has %d values, index_2 has %d" % (name, i, len(row), n_index2)
                )
                break
        if n_index1 and len(rows) != n_index1:
            problems.append(
                "%s: %d value rows, index_1 has %d" % (name, len(rows), n_index1)
            )
    elif n_index1:
        # 1-D table: values are one flat row of index_1 points.
        total = sum(len(row) for row in rows)
        if total != n_index1:
            problems.append(
                "%s: %d values, index_1 has %d" % (name, total, n_index1)
            )
    return problems


# ---------------------------------------------------------------------------
# Emitter
# ---------------------------------------------------------------------------


class LibertyWriter:
    """Streams Liberty text and collects conversion statistics."""

    def __init__(self, fh, include_power=True):
        self.fh = fh
        self.include_power = include_power
        self.indent = 0
        self.stats = Counter()
        self.tables_seen = Counter()

    # -- low level ------------------------------------------------------
    def line(self, text: str = "") -> None:
        if text:
            self.fh.write("  " * self.indent + text + "\n")
        else:
            self.fh.write("\n")

    def open_group(self, header: str) -> None:
        self.line(header + " {")
        self.indent += 1

    def close_group(self) -> None:
        self.indent -= 1
        self.line("}")

    # -- attribute helpers ---------------------------------------------
    def attr(self, name: str, value) -> None:
        if name == "table" and isinstance(value, list):
            # statetable: one quoted string holding all rows, comma separated
            # (same representation as the reference sky130 .lib files).
            rows = [str(row).strip() for row in value]
            self.line("table : %s;" % quote(",".join(rows)))
            self.stats["statetable_rows"] += len(value)
            return
        self.line("%s : %s;" % (name, fmt_attr_value(name, value)))
        self.stats["attributes"] += 1

    def attr_index(self, name: str, value: list) -> None:
        payload = ", ".join(fmt_num(v) for v in value)
        self.line('%s ("%s");' % (name, payload))
        self.stats["index_values"] += len(value)

    def attr_values(self, value) -> None:
        rows = flatten_rows(value)
        if len(rows) == 1:
            row_text = ", ".join(fmt_num(v) for v in rows[0])
            self.line('values ("%s");' % row_text)
        else:
            self.line("values ( \\")
            for i, row in enumerate(rows):
                row_text = ", ".join(fmt_num(v) for v in row)
                suffix = "," if i + 1 < len(rows) else ""
                self.line('  "%s"%s \\' % (row_text, suffix))
            self.line(");")
        self.stats["table_values"] += sum(len(r) for r in rows)
        self.stats["table_rows"] += len(rows)

    def attr_paren_list(self, name: str, value: list) -> None:
        payload = ", ".join(fmt_num(v) for v in value)
        self.line("%s (%s);" % (name, payload))
        self.stats["attributes"] += 1

    def attr_repeated(self, name: str, value: list) -> None:
        # Unknown repeated scalar attribute.  Emitting one line per value is
        # the Liberty idiom for repeated attributes.
        for element in value:
            self.line("%s : %s;" % (name, fmt_attr_value(name, element)))
            self.stats["attributes"] += 1

    # -- groups ---------------------------------------------------------
    def group_header(self, group: str, instance: str) -> str:
        if not instance:
            return "%s ()" % group
        parts = [p.strip() for p in instance.split(",")]
        rendered = []
        for part in parts:
            if IDENT_RE.match(part) or NUMBER_RE.match(part) or re.match(r"^[A-Za-z_][\w\[\]:./-]*$", part):
                rendered.append(part)
            else:
                rendered.append(quote(part))
        return "%s (%s)" % (group, ", ".join(rendered))

    def emit_group(self, group: str, body: dict, instance: str = "") -> None:
        self.open_group(self.group_header(group, instance))
        self.emit_body(body)
        self.close_group()
        self.stats["groups"] += 1
        self.stats["group_" + group] += 1

    def emit_group_key(self, key: str, value) -> None:
        group, instance = split_group_key(key)
        if isinstance(value, dict):
            bodies = [value]
        elif isinstance(value, list) and all(isinstance(e, dict) for e in value):
            bodies = value
        else:
            raise ConversionError(
                "group %r has non-group value of type %s" % (key, type(value).__name__)
            )
        for body in bodies:
            self.emit_group(group, body, instance)

    def emit_comp_attribute(self, key: str, value) -> None:
        """Handle non-standard ``comp_attribute,...`` entries.

        ``capacitive_load_unit``, ``library_features`` and ``technology`` are
        real Liberty attributes; ``voltage_map`` is emitted in Liberate's
        parenthesised style.  Anything else is preserved as a comment.
        """
        name = key.split(",", 1)[1]
        if name == "capacitive_load_unit":
            if isinstance(value, list) and len(value) == 2:
                self.line(
                    "capacitive_load_unit (%s,%s);"
                    % (fmt_paren_number(value[0]), quote(str(value[1])))
                )
                self.stats["attributes"] += 1
                return
        elif name == "library_features":
            self.line("library_features (%s);" % fmt_paren_name(str(value)))
            self.stats["attributes"] += 1
            return
        elif name == "technology":
            self.line("technology (%s);" % fmt_paren_name(str(value)))
            self.stats["attributes"] += 1
            return
        elif name == "voltage_map":
            pairs = []
            if isinstance(value, dict):
                pairs = list(value.items())
            elif isinstance(value, list):
                for element in value:
                    if isinstance(element, (list, tuple)) and len(element) == 2:
                        pairs.append((element[0], element[1]))
                    elif isinstance(element, dict):
                        pairs.extend(element.items())
            for pname, pvalue in pairs:
                self.line(
                    "voltage_map (%s, %s);"
                    % (fmt_paren_name(str(pname)), fmt_num(pvalue))
                )
                self.stats["attributes"] += 1
            if pairs:
                return
        self.line("/* unsupported %s : %s */" % (key, json.dumps(value)[:200]))
        self.stats["unsupported_comp_attributes"] += 1

    # -- generic body walker -------------------------------------------
    def emit_body(self, entries: dict) -> None:
        for key, value in entries.items():
            self.emit_entry(key, value)

    def emit_entry(self, key: str, value) -> None:
        if key == "define":
            self.emit_define(value)
            return
        if key.startswith("comp_attribute,"):
            self.emit_comp_attribute(key, value)
            return
        if key == "values":
            self.attr_values(value)
            return
        if INDEX_RE.match(key) and isinstance(value, list):
            self.attr_index(key, value)
            return
        split = split_group_key(key)
        if split is not None:
            self.emit_group_key(key, value)
            return
        if isinstance(value, dict):
            # Unnamed group, e.g. timing (), internal_power (), test_cell ().
            if key == "internal_power" and not self.include_power:
                self.stats["skipped_power_groups"] += 1
                return
            self.emit_group(key, value)
            return
        if isinstance(value, list):
            if is_list_of_dicts(value):
                if key == "internal_power" and not self.include_power:
                    self.stats["skipped_power_groups"] += len(value)
                    return
                for body in value:
                    self.emit_group(key, body)
                return
            if key == "table":
                self.attr(key, value)
                return
            if all(is_scalar(v) for v in value):
                if key in ("index_1", "index_2", "index_3", "index_4", "index_5",
                           "index_6", "index_7", "index_8", "index_9"):
                    self.attr_index(key, value)
                else:
                    self.attr_repeated(key, value)
                return
            # Mixed/unknown list: serialise as a string to stay valid.
            self.attr(key, ", ".join(str(v) for v in value))
            return
        self.attr(key, value)

    def emit_define(self, value) -> None:
        if not isinstance(value, list):
            self.line("/* define : %s */" % json.dumps(value))
            return
        for element in value:
            if not isinstance(element, dict):
                continue
            name = element.get("attribute_name", "")
            atype = element.get("attribute_type", "string")
            group = element.get("group_name", "library")
            self.line(
                "define(%s, %s, %s);"
                % (fmt_paren_name(str(name)), fmt_paren_name(str(group)), fmt_paren_name(str(atype)))
            )
            self.stats["defines"] += 1


# ---------------------------------------------------------------------------
# Loading
# ---------------------------------------------------------------------------


def load_json(path: str) -> dict:
    try:
        with open(path, "r", encoding="utf-8") as fh:
            data = json.load(fh)
    except FileNotFoundError:
        raise ConversionError("file not found: %s" % path)
    except json.JSONDecodeError as exc:
        raise ConversionError("invalid JSON in %s: %s" % (path, exc))
    if not isinstance(data, dict):
        raise ConversionError("top-level JSON value in %s is not an object" % path)
    return data


def list_corners(libdir: str, lib: str) -> list:
    timing_dir = os.path.join(libdir, "timing")
    prefix = lib + "__"
    corners = []
    if not os.path.isdir(timing_dir):
        return corners
    for name in os.listdir(timing_dir):
        if not name.startswith(prefix) or not name.endswith(".lib.json"):
            continue
        rest = name[len(prefix):-len(".lib.json")]
        if rest == "common":
            continue
        corners.append(rest)
    return sorted(corners, key=natural_key)


def discover_cell_files(libdir: str, lib: str, corner: str,
                        only_cells=None, limit=None):
    """Return [(cell_name, path)] for one corner, plus dirs without data."""
    cells_root = os.path.join(libdir, "cells")
    if not os.path.isdir(cells_root):
        raise ConversionError("cell directory not found: %s" % cells_root)
    prefix = lib + "__"
    suffix = "__" + corner + ".lib.json"
    found = {}
    empty_dirs = []
    for entry in sorted(os.listdir(cells_root)):
        base_dir = os.path.join(cells_root, entry)
        if not os.path.isdir(base_dir):
            continue
        matched = False
        try:
            names = sorted(os.listdir(base_dir))
        except OSError:
            continue
        for name in names:
            if not (name.startswith(prefix) and name.endswith(suffix)):
                continue
            cell = name[len(prefix):-len(suffix)]
            if not cell:
                continue
            matched = True
            if cell in found:
                raise ConversionError(
                    "duplicate cell %r in %s and %s" % (cell, found[cell], os.path.join(base_dir, name))
                )
            found[cell] = os.path.join(base_dir, name)
        if not matched:
            empty_dirs.append(entry)
    if only_cells:
        wanted = set()
        for name in only_cells:
            want = name[len(prefix):] if name.startswith(prefix) else name
            wanted.add(want)
        missing = wanted - set(found)
        if missing:
            raise ConversionError("requested cell(s) not found: %s" % ", ".join(sorted(missing)))
        found = {k: v for k, v in found.items() if k in wanted}
    items = sorted(found.items(), key=lambda kv: natural_key(kv[0]))
    if limit is not None:
        items = items[:limit]
    return items, empty_dirs


# ---------------------------------------------------------------------------
# Pre-flight validation
# ---------------------------------------------------------------------------


def collect_table_refs(obj, refs):
    """Collect (group_name, template_name) pairs from a cell/header body."""
    if isinstance(obj, dict):
        for key, value in obj.items():
            split = split_group_key(key)
            if split is not None:
                group, instance = split
                if group in LU_TABLE_GROUPS or group in POWER_TABLE_GROUPS:
                    refs.add((group, instance))
            if isinstance(value, dict):
                if "index_1" in value or "values" in value:
                    continue
                collect_table_refs(value, refs)
            elif isinstance(value, list):
                for element in value:
                    if isinstance(element, dict):
                        collect_table_refs(element, refs)
    elif isinstance(obj, list):
        for element in obj:
            collect_table_refs(element, refs)


def validate_templates(common, header, cell_items):
    """Check that every referenced table template is defined.

    Returns (missing, dim_problems) and a count of referenced templates.
    """
    defs_lu = set()
    defs_power = set()
    for source in (common, header):
        for key in source:
            split = split_group_key(key)
            if split is None:
                continue
            group, instance = split
            if group == "lu_table_template":
                defs_lu.add(instance)
            elif group == "power_lut_template":
                defs_power.add(instance)

    refs = set()
    dim_problems = []
    for cell, path in cell_items:
        body = load_json(path)
        collect_table_refs(body, refs)
        # Dimension check for every table body.
        def walk_tables(obj, context):
            if isinstance(obj, dict):
                for key, value in obj.items():
                    split = split_group_key(key)
                    if split is not None and split[0] in (LU_TABLE_GROUPS | POWER_TABLE_GROUPS):
                        for problem in count_table_dim_mismatches(
                            "%s/%s(%s)" % (context, split[0], split[1]), value
                        ):
                            dim_problems.append(problem)
                        continue
                    if isinstance(value, dict):
                        if "index_1" in value or "values" in value:
                            continue
                        walk_tables(value, context)
                    elif isinstance(value, list):
                        for element in value:
                            if isinstance(element, dict):
                                walk_tables(element, context)
        walk_tables(body, cell)

    missing = []
    for group, template in sorted(refs):
        if template == "scalar":
            continue
        if group in POWER_TABLE_GROUPS:
            if template not in defs_power:
                missing.append("%s -> power_lut_template %r" % (group, template))
        else:
            if template not in defs_lu:
                missing.append("%s -> lu_table_template %r" % (group, template))
    return missing, dim_problems, refs


def merge_sources(common: dict, header: dict):
    """Merge common + corner header (corner wins), reporting conflicts."""
    merged = OrderedDict()
    conflicts = []
    for source_name, source in (("common", common), ("corner", header)):
        for key, value in source.items():
            if key in merged and merged[key] != value and isinstance(merged[key], (dict, list)):
                conflicts.append(key)
            merged[key] = value
    return merged, conflicts


# ---------------------------------------------------------------------------
# Library emission
# ---------------------------------------------------------------------------


def emit_library_header(writer: LibertyWriter, merged: dict, lib_name: str,
                        meta: dict, include_defines: bool = True) -> None:
    writer.line("/*")
    writer.line(" * Liberty file reconstructed from SkyWater per-cell .lib.json dumps.")
    writer.line(" * Generated by %s %s on %s." % (PROG, VERSION, meta["generated"]))
    writer.line(" *")
    writer.line(" * library : %s" % meta["lib"])
    writer.line(" * corner  : %s" % meta["corner"])
    writer.line(" * source  : %s" % meta["libdir"])
    writer.line(" * cells   : %d timing JSON files" % meta["cell_count"])
    writer.line(" *")
    writer.line(" * NOTE: this is a reconstruction, not vendor-signed-off Liberty.")
    writer.line(" *       See README.md for known data gaps.")
    if meta["missing_cell_dirs"]:
        writer.line(" *")
        writer.line(" * Cell directories without a JSON file for this corner:")
        writer.line(" *   %s" % ", ".join(meta["missing_cell_dirs"]))
    if meta.get("derive_icg"):
        writer.line(" *")
        writer.line(" * Yosys-plain compatibility mode: functions on integrated clock-gate")
        writer.line(" * outputs/internal nodes were derived from state_function/statetable.")
    writer.line(" */")
    writer.open_group("library (%s)" % lib_name)

    # Simple attributes, in a deterministic order.  default_operating_conditions
    # is emitted after the operating_conditions groups (OpenSTA resolves it
    # eagerly and warns if the group has not been seen yet).
    scalar_keys = [
        k for k, v in merged.items()
        if "," not in k and k not in ("define", "default_operating_conditions")
        and is_scalar(v)
    ]
    ordered = [k for k in LIB_ATTR_ORDER if k in scalar_keys]
    ordered += [k for k in scalar_keys if k not in ordered]
    for key in ordered:
        writer.attr(key, merged[key])

    # Non-standard compiler attributes (technology, capacitive_load_unit, ...).
    for key, value in merged.items():
        if key.startswith("comp_attribute,"):
            writer.emit_comp_attribute(key, value)

    # define(...) statements.
    if include_defines and "define" in merged:
        writer.emit_define(merged["define"])

    # Library-level groups: templates first, then operating conditions, then
    # bus type / voltage declarations.
    groups = []
    for key, value in merged.items():
        split = split_group_key(key)
        if split is None or key.startswith("comp_attribute,"):
            continue
        group = split[0]
        groups.append((GROUP_RANK.get(group, 50), natural_key(key), key, value))
    groups.sort(key=lambda item: (item[0], item[1]))
    for _, _, key, value in groups:
        writer.emit_group_key(key, value)

    if "default_operating_conditions" in merged:
        writer.attr("default_operating_conditions", merged["default_operating_conditions"])


def write_library(libdir: str, lib: str, corner: str, out_path: str,
                  lib_name: str = None, include_power: bool = True,
                  include_defines: bool = True, derive_icg: bool = False,
                  only_cells=None, limit=None, strict: bool = False,
                  stats_json: str = None, verbose: bool = True) -> dict:
    timing_dir = os.path.join(libdir, "timing")
    header_path = os.path.join(timing_dir, "%s__%s.lib.json" % (lib, corner))
    common_path = os.path.join(timing_dir, "%s__common.lib.json" % (lib))

    if not os.path.isfile(header_path):
        available = list_corners(libdir, lib)
        raise ConversionError(
            "corner file not found: %s\navailable corners: %s"
            % (header_path, ", ".join(available) if available else "(none)")
        )

    header = load_json(header_path)
    common = load_json(common_path) if os.path.isfile(common_path) else {}
    merged, conflicts = merge_sources(common, header)

    cell_items, empty_dirs = discover_cell_files(libdir, lib, corner, only_cells, limit)
    if not cell_items:
        raise ConversionError("no cell JSON files found for %s / %s" % (lib, corner))

    missing_templates, dim_problems, refs = validate_templates(common, header, cell_items)
    if missing_templates:
        message = "missing table template definitions:\n  " + "\n  ".join(missing_templates)
        if strict:
            raise ConversionError(message)
        sys.stderr.write("WARNING: %s\n" % message)
    if dim_problems:
        sample = "\n  ".join(dim_problems[:10])
        sys.stderr.write(
            "WARNING: %d table dimension mismatch(es):\n  %s\n" % (len(dim_problems), sample)
        )

    if lib_name is None:
        lib_name = "%s__%s" % (lib, corner)

    out_dir = os.path.dirname(os.path.abspath(out_path))
    os.makedirs(out_dir, exist_ok=True)

    generated = __import__("datetime").datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    meta = {
        "generated": generated,
        "lib": lib,
        "corner": corner,
        "libdir": libdir,
        "cell_count": len(cell_items),
        "missing_cell_dirs": empty_dirs,
        "derive_icg": derive_icg,
    }

    stats = Counter()
    template_stats = Counter()
    for group, template in refs:
        template_stats[group] += 1

    with open(out_path, "w", encoding="utf-8", buffering=1024 * 1024) as fh:
        writer = LibertyWriter(fh, include_power=include_power)
        emit_library_header(writer, merged, lib_name, meta,
                            include_defines=include_defines)
        for cell, path in cell_items:
            body = load_json(path)
            if derive_icg:
                derive_icg_functions(body, writer.stats)
            # SkyWater cell names carry the library prefix, while the JSON
            # file name separates library, cell and corner with "__".
            writer.open_group("cell (%s__%s)" % (lib, cell))
            writer.emit_body(body)
            writer.close_group()
            writer.stats["cells"] += 1
        writer.close_group()
        stats = writer.stats
        stats["tables"] = sum(
            v for k, v in stats.items() if k.startswith("group_")
            and (k[len("group_"):] in LU_TABLE_GROUPS or k[len("group_"):] in POWER_TABLE_GROUPS)
        )

    size = os.path.getsize(out_path)
    report = OrderedDict()
    report["library"] = lib
    report["corner"] = corner
    report["liberty_name"] = lib_name
    report["source"] = libdir
    report["output"] = os.path.abspath(out_path)
    report["bytes"] = size
    report["cells"] = stats.get("cells", 0)
    report["cell_json_files"] = len(cell_items)
    report["groups"] = stats.get("groups", 0)
    report["pins"] = stats.get("group_pin", 0)
    report["pg_pins"] = stats.get("group_pg_pin", 0)
    report["timing_groups"] = stats.get("group_timing", 0)
    report["internal_power_groups"] = stats.get("group_internal_power", 0)
    report["leakage_power_groups"] = stats.get("group_leakage_power", 0)
    report["ff_groups"] = stats.get("group_ff", 0)
    report["latch_groups"] = stats.get("group_latch", 0)
    report["statetable_groups"] = stats.get("group_statetable", 0)
    report["tables"] = stats.get("tables", 0)
    report["table_values"] = stats.get("table_values", 0)
    report["attributes"] = stats.get("attributes", 0)
    report["defines"] = stats.get("defines", 0)
    report["missing_templates"] = missing_templates
    report["dimension_mismatches"] = len(dim_problems)
    report["dimension_mismatch_examples"] = dim_problems[:10]
    report["cell_dirs_without_json"] = empty_dirs
    report["common_header_conflicts"] = conflicts
    report["reference_counts"] = dict(sorted(template_stats.items()))
    report["skipped_power_groups"] = stats.get("skipped_power_groups", 0)
    report["derived_icg_outputs"] = stats.get("derived_icg_outputs", 0)
    report["derived_internal_functions"] = stats.get("derived_internal_functions", 0)
    report["derive_icg_functions"] = derive_icg

    if stats_json:
        os.makedirs(os.path.dirname(os.path.abspath(stats_json)), exist_ok=True)
        with open(stats_json, "w", encoding="utf-8") as fh:
            json.dump(report, fh, indent=2, sort_keys=False)
            fh.write("\n")

    if verbose:
        sys.stderr.write(
            "wrote %s\n  %d cells, %d pins, %d timing groups, %d tables, %.1f MiB\n"
            % (
                report["output"],
                report["cells"],
                report["pins"],
                report["timing_groups"],
                report["tables"],
                size / (1024.0 * 1024.0),
            )
        )
        if empty_dirs:
            sys.stderr.write(
                "  cell dirs without JSON for this corner: %s\n" % ", ".join(empty_dirs)
            )

    return report


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog=PROG,
        description="Convert SkyWater sky130 per-cell .lib.json dumps into one Liberty .lib",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "examples:\n"
            "  %(prog)s --lib sky130_fd_sc_ms --corner ss_n40C_1v28 \\\n"
            "      --out out/sky130_fd_sc_ms_ss_n40C_1v28.lib\n"
            "  %(prog)s --lib sky130_fd_sc_ms --list-corners\n"
        ),
    )
    parser.add_argument("--lib", required=True, help="library name, e.g. sky130_fd_sc_ms")
    parser.add_argument("--corner", help="corner name, e.g. ss_n40C_1v28")
    parser.add_argument("--out", help="output Liberty file path")
    parser.add_argument(
        "--root", default="/grid/sky130",
        help="root directory containing the sky130 libraries (default: /grid/sky130)",
    )
    parser.add_argument("--name", help="Liberty library name (default: <lib>__<corner>)")
    parser.add_argument(
        "--only-cell", action="append", default=None, metavar="CELL",
        help="convert only this cell (may be repeated; debugging aid)",
    )
    parser.add_argument(
        "--limit", type=int, default=None, metavar="N",
        help="convert at most N cells (debugging aid)",
    )
    parser.add_argument("--no-power", action="store_true", help="omit internal_power groups")
    parser.add_argument("--no-defines", action="store_true", help="omit define(...) statements")
    parser.add_argument(
        "--derive-icg-functions", action="store_true",
        help="derive combinational functions for integrated clock-gate internal nodes so that "
             "plain `yosys read_liberty` accepts the output (off by default; timing data unchanged)",
    )
    parser.add_argument("--stats-json", metavar="PATH", help="write conversion statistics as JSON")
    parser.add_argument(
        "--strict", action="store_true",
        help="treat missing table templates as fatal",
    )
    parser.add_argument("--list-corners", action="store_true", help="list available corners and exit")
    parser.add_argument("--quiet", action="store_true", help="suppress progress output")
    return parser


def main(argv=None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    libdir = os.path.join(args.root, args.lib)
    if not os.path.isdir(libdir):
        parser.error("library directory not found: %s" % libdir)

    if args.list_corners:
        corners = list_corners(libdir, args.lib)
        print("\n".join(corners) if corners else "(no corners found)")
        return 0

    if not args.corner:
        parser.error("--corner is required (or use --list-corners)")
    if not args.out:
        parser.error("--out is required")

    try:
        report = write_library(
            libdir=libdir,
            lib=args.lib,
            corner=args.corner,
            out_path=args.out,
            lib_name=args.name,
            include_power=not args.no_power,
            include_defines=not args.no_defines,
            derive_icg=args.derive_icg_functions,
            only_cells=args.only_cell,
            limit=args.limit,
            strict=args.strict,
            stats_json=args.stats_json,
            verbose=not args.quiet,
        )
    except ConversionError as exc:
        sys.stderr.write("ERROR: %s\n" % exc)
        return 2

    if args.strict and (report["dimension_mismatches"] or report["missing_templates"]):
        sys.stderr.write("ERROR: strict mode: validation problems present\n")
        return 3
    return 0


if __name__ == "__main__":
    sys.exit(main())
