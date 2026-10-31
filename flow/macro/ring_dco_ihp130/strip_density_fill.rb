l=RBA::Layout::new; l.read($gds); t=l.cell($top)
[[1,22],[5,22],[8,22],[10,22],[30,22],[50,22],[67,22],[126,22],[134,22]].each { |a,b| t.shapes(l.layer(a,b)).clear }
t.shapes(l.layer(62,0)).clear
l.write($out)
