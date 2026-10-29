# Dump absolute instance bounding boxes for DRC classification.
# Usage: klayout -b -r dump_instances.rb -rd gds=... -rd top=... -rd out=instances.json
require 'json'
layout = RBA::Layout::new
layout.read($gds)
top = layout.cell($top)
raise "top #{top} not found" unless top
out = []
def walk(cell, trans, depth, path, out)
  cell.each_inst do |inst|
    t = trans * inst.trans
    child = inst.cell
    bb = t * child.bbox
    out << {
      'cell' => child.name,
      'path' => path + '/' + child.name,
      'depth' => depth + 1,
      'bbox' => [bb.left / 1000.0, bb.bottom / 1000.0, bb.right / 1000.0, bb.top / 1000.0]
    }
    walk(child, t, depth + 1, path + '/' + child.name, out)
  end
end
walk(top, RBA::Trans::new, 0, top.name, out)
File.write($out, JSON.pretty_generate(out))
puts "wrote #{$out}: #{out.size} instances"
