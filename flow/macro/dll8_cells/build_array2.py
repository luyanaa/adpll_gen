import sys, json
PDK='/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2'
sys.path.insert(0, PDK+"/libs.tech/klayout/python")
sys.path.insert(0, PDK+"/libs.tech/klayout/python/pycell4klayout-api/source/python")
import sg13g2_pycell_lib, pya
D='/grid/adpll_gen/flow/macro/dll8_cells'
ly=pya.Layout(); ly.dbu=0.001
ly.read(D+"/dll8_finger.gds"); ly.read(D+"/dll8_finger_p.gds")
ly.read(PDK+"/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds")
fn=ly.cell("DLL8_FINGER"); fp=ly.cell("DLL8_FINGER_P")
m1=ly.layer(8,0); m2=ly.layer(10,0); m3=ly.layer(30,0)
nw=ly.layer(31,0); nb=ly.layer(32,0)
c=ly.create_cell("DLL8_LINE_ARRAY")

NY=4000          # N finger row pitch (finger height 3.11um -> ~0.9um gap)
PY=5500          # P finger row pitch (finger height 4.32um -> ~1.18um gap)
PX=9000          # x offset of P column
NN=64; NP=63

# --- N stack (even fingers) at x=0 ---
for n in range(NN):
    c.insert(pya.CellInstArray(fn.cell_index(),pya.Trans(pya.Vector(0,n*NY))))
# --- P stack (odd fingers) at x=PX ---
for n in range(NP):
    c.insert(pya.CellInstArray(fp.cell_index(),pya.Trans(pya.Vector(PX,n*PY))))

def box(l,x1,y1,x2,y2): c.shapes(l).insert(pya.Box(int(x1),int(y1),int(x2),int(y2)))

# finger local bboxes
nbb=fn.bbox(); pbb=fp.bbox()
Ntop=(NN-1)*NY+nbb.top; Nbot=nbb.bottom
Ptop=(NP-1)*PY+pbb.top; Pbot=pbb.bottom

# --- shared nWell + nBuLay fully enclosing the P group (no internal notches) ---
sx1=PX+pbb.left-100; sx2=PX+pbb.right+100
sy1=Pbot-100; sy2=Ptop+100
box(nw, sx1,sy1,sx2,sy2)
box(nb, sx1,sy1,sx2,sy2)

# --- MID vertical M1 columns at the source pad x (pad 3470..3630); keep
# clear of the CTRL pad at x3820 by staying <=3610 ---
box(m1, 3490, Nbot-200, 3610, Ntop+1000)         # N source bus
box(m1, PX+3490, Pbot-200, PX+3610, Ptop+1000)   # P source bus
# --- horizontal MID tie at the top, above both stacks (clear of all finger M1) ---
ytie=max(Ntop,Ptop)+600
box(m1, 3490, ytie, PX+3610, ytie+200)

top=ly.create_cell("dll8_line_array_top"); top.insert(pya.CellInstArray(c.cell_index(),pya.Trans()))
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write(D+"/dll8_line_array.gds",opts)
print(json.dumps({"bbox":top.bbox().to_s(),"w":top.bbox().width()/1000,"h":top.bbox().height()/1000,
                  "Ntop":Ntop,"Ptop":Ptop}))
