# Reconstruct top-level pin metal + labels from the DEF PINS section.
#
# KLayout's LEF/DEF reader puts the top-level pin labels on OUTLINE (12/1)
# and does not emit the MET2/MET3 pin rectangles as top-level shapes in this
# flat-PDK setup.  The ics55 LVS deck needs a text label on the same conductor
# layer as a top-level shape.  This script:
#   1. parses each DEF pin (layer, rectangle, placement),
#   2. creates the pin rectangle on the conductor layer, and
#   3. copies the existing label onto that layer at the pin location.
#
# All PLL_ANALOG_MACRO pins are N-oriented in the current DEF; S/E/W are
# rejected explicitly so a future floorplan change does not silently pass.

layout = RBA::Layout::new
layout.read($gds)
top = layout.cell($topcell)
raise "top cell not found" unless top

pins = {}
pin_boxes = []
current = nil
pending_layer = nil
pending_rect = nil
in_pins = false

File.foreach($def) do |line|
  in_pins = true if line =~ /^PINS\s/
  break if in_pins && line =~ /^END PINS/
  next unless in_pins

  if line =~ /^\s*-\s+(\S+)\s+\+\s+NET\s+/
    current = $1
    pending_layer = nil
    pending_rect = nil
  elsif current && line =~ /^\s*\+\s+LAYER\s+(\w+)\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)\s*\(\s*(-?\d+)\s+(-?\d+)\s*\)/
    pending_layer = $1
    pending_rect = [$2.to_i, $3.to_i, $4.to_i, $5.to_i]
    pins[current] = pending_layer
  elsif current && pending_layer && line =~ /^\s*\+\s*PLACED\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)\s+(\w+)/
    x = $1.to_i
    y = $2.to_i
    orient = $3
    raise "unsupported pin orientation #{orient} on #{current}" unless orient == 'N'
    pin_boxes << [current, pending_layer, x, y, pending_rect]
    pending_layer = nil
    pending_rect = nil
    current = nil
  end
end
puts "pins with layers: #{pins.size}; pin boxes: #{pin_boxes.size}"

layer_num = {
  'MET1' => 81, 'MET2' => 82, 'MET3' => 83, 'MET4' => 84, 'MET5' => 85,
  'T4M1' => 102, 'T4M2' => 103, 'ALPAD' => 122
}

# 1. Add the pin rectangles on the conductor layer.
made = 0
pin_boxes.each do |name, layer_name, x, y, rect|
  next unless layer_num[layer_name] && rect
  li = layout.layer(layer_num[layer_name], 1)
  lx, ly, ux, uy = rect
  box = RBA::Box.new(x + lx, y + ly, x + ux, y + uy)
  top.shapes(li).insert(box)
  made += 1
end
puts "created pin rectangles: #{made}"

# 2. Create a label for EVERY pin at the center of its DEF rectangle.
# Do not rely on the OUTLINE labels: six pins (DCO_EN/REF/SS_BBPD/VDD/VSS)
# have no OUTLINE text, which previously left LVS with 65 layout ports vs
# 70 reference ports.
labelled = 0
pin_boxes.each do |name, layer_name, x, y, rect|
  next unless layer_num[layer_name] && rect
  li = layout.layer(layer_num[layer_name], 1)
  lx, ly, ux, uy = rect
  cx = x + (lx + ux) / 2
  cy = y + (ly + uy) / 2
  top.shapes(li).insert(RBA::Text::new(name, RBA::Trans.new(RBA::Point.new(cx, cy))))
  labelled += 1
end
puts "created labels: #{labelled}"

# VDD/VSS are global power pins in the DEF and have no PLACED rectangle.
# Put their labels on the MET4 core-ring/strap shapes so LVS can see them.
top.shapes(layout.layer(84, 1)).insert(
  RBA::Text::new("VDD", RBA::Trans.new(RBA::Point.new(134700, 60000)))
)
top.shapes(layout.layer(84, 1)).insert(
  RBA::Text::new("VSS", RBA::Trans.new(RBA::Point.new(136700, 60000)))
)
puts "created VDD/VSS labels on MET4"
layout.write($out)
