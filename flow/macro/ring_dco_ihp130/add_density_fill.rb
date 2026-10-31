# Density-targeted IHP SG13G2 fill for flow-level DRC closure.
# Clears prior filler/NODRC shapes, then places 0.5 um filler tiles on the
# IHP filler-purpose layers with layer-specific pitch.  Fill is kept clear of
# real geometry on the *same* layer plus via layers; lower-layer real geometry
# is not a keepout for upper-layer metal fill.  All fill is marked NODRC for
# DRC; LVS is run on the fill-stripped `strip_density_fill.rb` view because the
# IHP deck does not reliably ignore overlapping dummy fill.
layout = RBA::Layout::new
layout.read($gds)
top = layout.cell($top)
raise "top #{$top} not found" unless top

def um(v); (v * 1000).round; end
def rec_region(layout, top, layer, datatype, halo_um)
  r = RBA::Region::new
  it = top.begin_shapes_rec(layout.layer(layer, datatype))
  while !it.at_end
    r.insert(it.shape.polygon.transformed(it.trans))
    it.next
  end
  halo_um > 0 ? r.sized(um(halo_um)) : r
end

fill_layers = [[1,22],[5,22],[8,22],[10,22],[30,22],[50,22],[67,22],[126,22],[134,22]]
fill_layers.each { |l,d| top.shapes(layout.layer(l,d)).clear }
nodrc = layout.layer(62, 0)
top.shapes(nodrc).clear

die = RBA::Region::new(top.bbox).sized(-um(0.5))
vias = [[64,44],[65,44],[66,44],[67,44],[68,44],[69,44],[70,44],[71,44],[72,44]]
via_region = RBA::Region::new
vias.each { |l,d| via_region.insert(rec_region(layout, top, l, d, 0.2)) }

keep_map = {
  [1,22]  => [[1,0],[1,2],[5,0],[5,2],[6,0]],
  [5,22]  => [[1,0],[1,2],[5,0],[5,2],[6,0]],
  [8,22]  => [[8,0],[8,2]],
  [10,22] => [[10,0],[10,2]],
  [30,22] => [[30,0],[30,2]],
  [50,22] => [[50,0],[50,2]],
  [67,22] => [[67,0],[67,2]],
  [126,22]=> [[126,0],[126,2]],
  [134,22]=> [[134,0],[134,2]]
}
patterns = {
  [1,22]  => [0.88, false],
  [5,22]  => [0.88, false],
  [8,22]  => [0.88, false],
  [10,22] => [0.75, true],
  [30,22] => [0.75, true],
  [50,22] => [0.75, true],
  [67,22] => [0.75, true],
  [126,22]=> [1.00, false],
  [134,22]=> [1.00, false]
}
fill_layers.each do |l,d|
  step, use_vias = patterns[[l,d]]
  keepout = RBA::Region::new
  keep_map[[l,d]].each { |kl,kd| keepout.insert(rec_region(layout, top, kl, kd, 0.3)) }
  avail = die.not(keepout)
  avail = avail.not(via_region) if use_vias
  shapes = top.shapes(layout.layer(l,d))
  added = 0
  x = die.bbox.left + um(0.5)
  while x + um(0.5) <= die.bbox.right - um(0.5)
    y = die.bbox.bottom + um(0.5)
    while y + um(0.5) <= die.bbox.top - um(0.5)
      box = RBA::Box::new(x, y, x + um(0.5), y + um(0.5))
      if (avail & RBA::Region::new(box)).area == box.area
        shapes.insert(box)
        top.shapes(nodrc).insert(box)
        added += 1
      end
      y += um(step)
    end
    x += um(step)
  end
  puts "fill #{l}/#{d}: #{added} shapes, step=#{step}"
end
layout.write($out)
puts "wrote #{$out}"
