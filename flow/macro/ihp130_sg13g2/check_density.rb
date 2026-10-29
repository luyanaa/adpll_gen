layout = RBA::Layout::new
layout.read($gds)
top = layout.cell($top)
die = RBA::Region::new(top.bbox)
def area(layout, top, l, d, die)
  r = RBA::Region::new
  it = top.begin_shapes_rec(layout.layer(l,d))
  while !it.at_end
    r.insert(it.shape.polygon.transformed(it.trans))
    it.next
  end
  r.area.to_f / die.area.to_f * 100.0
end
puts "die=#{die.area/1e6} um2"
[[1,0,"ACT"],[1,22,"ACTFil"],[8,0,"M1"],[8,22,"M1Fil"],[10,0,"M2"],[10,22,"M2Fil"],[30,0,"M3"],[30,22,"M3Fil"],[50,0,"M4"],[50,22,"M4Fil"],[67,0,"M5"],[67,22,"M5Fil"],[126,0,"TM1"],[126,22,"TM1Fil"],[134,0,"TM2"],[134,22,"TM2Fil"]].each do |l,d,n|
  puts "%s %.2f" % [n, area(layout,top,l,d,die)]
end
