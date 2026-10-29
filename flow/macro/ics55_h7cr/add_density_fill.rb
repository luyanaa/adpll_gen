# Add PDK-approved dummy fill shapes to an ics55 macro GDS.
#
# The PDK density checks count ACTDUM (2/2), POLYDUM (41/2), MET1DUM..MET5DUM
# (81/2..85/2), and T4M2DUM (103/2).  Dummy shapes are only placed in empty
# die area: all standard-cell/via instance bboxes and existing shapes on the
# relevant conductor/implant layers are keepouts.  The rectangle sizes are the
# exact whitelisted sizes from ics55_rules.json; spacing to real geometry is
# handled by the keepout expansion, not by a full foundry fill deck.
#
# Usage:
#   klayout -b -r add_density_fill.rb \
#     -rd gds=in.gds -rd top=PLL_ANALOG_MACRO -rd out=out.gds \
#     -rd dbu=0.001
#
layout = RBA::Layout::new
layout.read($gds)
top = layout.cell($top)
raise "top #{top} not found" unless top

def um(v)
  (v * 1000).round
end

def rec_region(layout, top, layer, datatype, halo_um)
  li = layout.layer(layer, datatype)
  r = RBA::Region::new
  it = top.begin_shapes_rec(li)
  while !it.at_end
    r.insert(it.trans * it.shape.bbox)
    it.next
  end
  halo_um > 0 ? r.sized(um(halo_um)) : r
end

# Keep out every placed cell/via instance, including its internal shapes.
instances = RBA::Region::new
walk = lambda do |cell, trans|
  cell.each_inst do |inst|
    t = trans * inst.trans
    child = inst.cell
    instances.insert(t * child.bbox)
    walk.call(child, t)
  end
end
walk.call(top, RBA::Trans::new)

die = RBA::Region::new(top.bbox)
inset = um(($inset || 1.0).to_f)
die = die.sized(-inset)

# layer, datatype, width, height, pitch_x, pitch_y, use_cell_bboxes, keepout layers
# The keepout lists include the real layer and nearby layers that could be
# shorted/overlapped by the dummy shape.  Implant/poly fill is kept outside
# all cell bboxes; metal fill is allowed inside cell rows but must clear the
# real metal, via and contact geometry.
fills = [
  [2, 2, 3.0, 3.0, 3.7, 3.7, true, [[2, 1], [41, 1], [72, 1]]],
  [41, 2, 2.4, 2.4, 3.3, 3.3, true, [[41, 1], [2, 1], [72, 1]]],
  [81, 2, 2.0, 2.0, 2.4, 2.4, false, [[81, 1], [91, 1], [92, 1], [72, 1]]],
  [82, 2, 2.0, 2.0, 2.4, 2.4, false, [[82, 1], [91, 1], [92, 1], [93, 1]]],
  [83, 2, 2.0, 2.0, 2.4, 2.4, false, [[83, 1], [92, 1], [93, 1], [94, 1]]],
  [84, 2, 2.0, 2.0, 2.4, 2.4, false, [[84, 1], [93, 1], [94, 1]]],
  [85, 2, 2.0, 2.0, 2.4, 2.4, true, [[85, 1], [94, 1]]],
  [103, 2, 1.0, 1.0, 1.2, 1.2, false, [[103, 1], [113, 1]]]
]

wanted = ($fill_layers || "").split(",").reject(&:empty?)
fills.each do |layer, datatype, w, h, px, py, use_cells, keep_layers|
  next if !wanted.empty? && !wanted.include?("#{layer}/#{datatype}")
  keep = RBA::Region::new
  keep.insert(instances) if use_cells
  keep_layers.each do |kl, kd|
    keep.insert(rec_region(layout, top, kl, kd, 0.5))
  end
  available = die.not(keep)
  li = layout.layer(layer, datatype)
  shapes = top.shapes(li)
  box_w = um(w)
  box_h = um(h)
  added = 0
  x0 = die.bbox.left + um(0.5)
  y0 = die.bbox.bottom + um(0.5)
  x = x0
  while x + box_w <= die.bbox.right - um(0.5)
    y = y0
    while y + box_h <= die.bbox.top - um(0.5)
      box = RBA::Box::new(x, y, x + box_w, y + box_h)
      if (available & RBA::Region::new(box)).area == box.area
        shapes.insert(box)
        added += 1
      end
      y += um(py)
    end
    x += um(px)
  end
  puts format("fill %d/%d %.2fx%.2f pitch %.2f: %d shapes, %.1f um2",
              layer, datatype, w, h, px, added, added * w * h)
end

layout.write($out)
puts "wrote #{$out}"
