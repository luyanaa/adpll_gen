import sys, json
PDK='/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2'
sys.path.insert(0, PDK+"/libs.tech/klayout/python")
sys.path.insert(0, PDK+"/libs.tech/klayout/python/pycell4klayout-api/source/python")
import sg13g2_pycell_lib, pya
D='/grid/adpll_gen/flow/macro/dll8_cells'
ly=pya.Layout(); ly.dbu=0.001
ly.read(D+"/dll8_finger.gds"); ly.read(D+"/dll8_finger_p.gds")
ly.read(PDK+"/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds")
U=1000
fn=ly.cell("DLL8_FINGER"); fp=ly.cell("DLL8_FINGER_P"); inv=ly.cell("sg13g2_inv_4")
m1=ly.layer(8,0); m2=ly.layer(10,0); nw=ly.layer(31,0); nb=ly.layer(32,0); v1=ly.layer(19,0)
c=ly.create_cell("DLL8_LINE_ARRAY")
NY=5000; PY=5500; PX=7500
# N block: 64 even fingers (0..126 even), sources at DX+150=3550
for n in range(64):
    c.insert(pya.CellInstArray(fn.cell_index(),pya.Trans(pya.Vector(0,n*NY))))
nb_top=63*NY+1900
# P block: 63 odd fingers, at x=PX
for n in range(63):
    c.insert(pya.CellInstArray(fp.cell_index(),pya.Trans(pya.Vector(PX,n*PY))))
pb_top=62*PY+2660
def box(l,x1,y1,x2,y2): c.shapes(l).insert(pya.Box(int(x1),int(y1),int(x2),int(y2)))
# shared 31/0 + 32/0 over the P block (+ margin)
box(nw, PX-1500,-1500, PX+3870+1500, pb_top+1500)
box(nb, PX-1500,-1500, PX+3870+1500, pb_top+1500)
# mid M1 bus: vertical over N sources (x 3450..3650) and P sources (PX+3450..PX+3650)
box(m1, 3450,-1500, 3650, nb_top+500)
box(m1, PX+3450,-1500, PX+3650, pb_top+500)
box(m1, 3450,-1200, PX+3650, -600)   # tie the two source columns (horizontal)
# inv_4 x2 at the bottom, spaced 5um
box(m1, 3450,-2500, 3650,-1500)  # extend mid to the inv area (placeholder)
for k in range(2):
    c.insert(pya.CellInstArray(inv.cell_index(),pya.Trans(pya.Vector(3450+k*5000,-2600))))
top=ly.create_cell("dll8_line_array_top"); top.insert(pya.CellInstArray(c.cell_index(),pya.Trans()))
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write(D+"/dll8_line_array.gds",opts)
print(json.dumps({"bbox":top.bbox().to_s(),"w":top.bbox().width()/1000,"h":top.bbox().height()/1000}))
