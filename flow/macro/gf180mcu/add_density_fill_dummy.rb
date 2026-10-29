# GF180MCU global metal-density fill for PLL_ANALOG_MACRO.
# The GF180 density deck requires >30% global coverage on Metal1..Metal5 and
# the top metal.  Fill is placed outside cell bboxes and existing same-layer
# metal/via geometry.  This is a flow fill, not a foundry-qualified fill deck.
layout = RBA::Layout::new
layout.read($gds)
top = layout.cell($top)
raise "top #{top} not found" unless top

def um(v)
  (v * 1000).round
end

def rec(layout, top, l, d, halo)
  r = RBA::Region::new
  it = top.begin_shapes_rec(layout.layer(l, d))
  while !it.at_end
    r.insert(it.trans * it.shape.bbox)
    it.next
  end
  halo > 0 ? r.sized(um(halo)) : r
end

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

die = RBA::Region::new(top.bbox).sized(-um(0.1))
# 4 x 4 um at 8 um pitch; 25% before occupancy.  Same-layer metal and all vias
# are keepouts; cell bboxes keep fill out of the routed cells.
layers = [[34, 4], [36, 4], [42, 4], [46, 4], [81, 4]]
vias = [[35, 0], [38, 0], [40, 0], [41, 0]]
layers.each do |l, d|
  keep = RBA::Region::new
  keep.insert(rec(layout, top, l, 0, 0.5))
  keep.insert(rec(layout, top, l, 4, 0.5))
  vias.each { |vl, vd| keep.insert(rec(layout, top, vl, vd, 0.5)) }
  available = die.not(keep)
  shapes = top.shapes(layout.layer(l, d))
  added = 0
  x = die.bbox.left + um(0.1)
  while x + um(2.0) <= die.bbox.right - um(0.1)
    y = die.bbox.bottom + um(0.1)
    while y + um(2.0) <= die.bbox.top - um(0.1)
      box = RBA::Box::new(x, y, x + um(2.0), y + um(2.0))
      if (available & RBA::Region::new(box)).area == box.area
        shapes.insert(box)
        added += 1
      end
      y += um(2.5)
    end
    x += um(2.5)
  end
  puts "fill Metal#{l}: #{added} shapes"
end
layout.write($out)
puts "wrote #{$out}"
