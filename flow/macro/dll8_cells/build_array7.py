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
NY=4000; PY=5500; PX=9000; NN=64; NP=63

for n in range(NN):
    c.insert(pya.CellInstArray(fn.cell_index(),pya.Trans(pya.Vector(0,n*NY))))
for n in range(NP):
    c.insert(pya.CellInstArray(fp.cell_index(),pya.Trans(pya.Vector(PX,n*PY))))

def box(l,x1,y1,x2,y2): c.shapes(l).insert(pya.Box(int(x1),int(y1),int(x2),int(y2)))
nbb=fn.bbox(); pbb=fp.bbox()
Ntop=(NN-1)*NY+nbb.top; Ptop=(NP-1)*PY+pbb.top

# shared nWell + nBuLay enclosing the P group (no internal notch)
sx1=PX+pbb.left-100; sx2=PX+pbb.right+100
sy1=pbb.bottom-100; sy2=Ptop+100
box(nw, sx1,sy1,sx2,sy2); box(nb, sx1,sy1,sx2,sy2)

# MID vertical M3 buses at each column's escape landing
box(m3, 2940, -400, 3230, Ptop+1200)          # N column MID
box(m3, PX+2280, -400, PX+2610, Ptop+1200)    # P column MID
# top tie N<->P
ytie=Ptop+1000
box(m3, 2940, ytie, PX+2610, ytie+200)

# CTRL: one M3 horizontal per finger, exiting to the right at the finger's
# own row y (distinct y -> no cross).  N lands (3820..4110,660..930);
# P lands (3630..3950,1330..1590).
RIGHTN=6500; RIGHTP=PX+6500
for n in range(NN):
    y=n*NY
    box(m3, 3820, y+660, RIGHTN, y+930)
for n in range(NP):
    y=n*PY
    box(m3, PX+3630, y+1330, RIGHTP, y+1590)


# VDD / VSS rails: vertical M1 straps merging the per-row guard-ring taps
box(m1, 2400, nbb.bottom-300, 2560, Ntop+300)     # VSS (N psub ring left rail at 2400..2700)
box(m1, 5360, pbb.bottom-300, 5520, Ptop+300)     # VDD (P nwell ring right rail at 5220..5520)
yt=ly.layer(8,2)
c.shapes(yt).insert(pya.Text("VSS",pya.Trans(pya.Vector(2480,Ntop+150))))
c.shapes(yt).insert(pya.Text("VDD",pya.Trans(pya.Vector(5450,Ptop+150))))
c.shapes(ly.layer(10,2)).insert(pya.Text("MID",pya.Trans(pya.Vector(3080,Ptop+600))))

# ---- tie moscap bulk/plate taps to VSS(N)/VDD(P) ----
for n in range(NN):
    y=n*NY
    box(m1, 1830, y-100, 2400, y+100)          # N: moscap psub tap -> nmos psub guard (span y-980..1380)
for n in range(NP):
    y=n*PY
    box(m1, PX+1800, y+500, PX+2120, y+700)    # P: moscap nwell tap -> pmos left nwell guard
top=ly.create_cell("dll8_line_array_top"); top.insert(pya.CellInstArray(c.cell_index(),pya.Trans()))
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write(D+"/dll8_line_array.gds",opts)
print(json.dumps({"bbox":top.bbox().to_s(),"w":top.bbox().width()/1000,"h":top.bbox().height()/1000}))
