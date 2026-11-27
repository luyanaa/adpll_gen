import sys, json
PDK='/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2'
sys.path.insert(0, PDK+"/libs.tech/klayout/python")
sys.path.insert(0, PDK+"/libs.tech/klayout/python/pycell4klayout-api/source/python")
import sg13g2_pycell_lib, pya
ly=pya.Layout(); ly.dbu=0.001; ly.technology_name="sg13g2"
mcn=ly.create_cell("moscap_p","SG13_dev",{"w":"1.0u","l":"1.0u","m":"1"})
ns=ly.create_cell("pmos","SG13_dev",{"w":"1.0u","l":"0.13u","ng":"1","guardRingType":"nwell","guardRingDistance":"1u"})
m1=ly.layer(8,0); m1p=ly.layer(8,2); v1=ly.layer(19,0); m2=ly.layer(10,0); m2p=ly.layer(10,2); cont=ly.layer(6,0)
f=ly.create_cell("DLL8_FINGER_P")
f.insert(pya.CellInstArray(mcn.cell_index(),pya.Trans()))
DX=3400
f.insert(pya.CellInstArray(ns.cell_index(),pya.Trans(pya.Vector(DX,0))))
def box(l,x1,y1,x2,y2): f.shapes(l).insert(pya.Box(int(x1),int(y1),int(x2),int(y2)))
def txt(l,x,y,s): f.shapes(l).insert(pya.Text(s,pya.Trans(pya.Vector(int(x),int(y)))))
# CN gate contact high above ring and top S/D contacts
f.shapes(ly.layer(5,0)).insert(pya.Box(300,1350,700,2320))
box(cont, 420,2080, 580,2240)
box(m1, 380,2020, 620,2300)
box(v1, 405,2070, 595,2260)
box(m2, 370,1990, 630,2330)
# switch drain M1 (DX+900..DX+1060,0..500): V1 + M2
box(m1, DX+420,80, DX+820,500)
box(v1, DX+565,195, DX+755,385)
# M2 CN bridge gate->drain
box(m2, 500,150, DX+820,350)
box(m2, 450,150, 750,2150)
txt(m2p, 2000, 900, "CN")
# CTRL: cont on switch gate poly (DX+340..DX+790), M1 pad narrowed
f.shapes(ly.layer(5,0)).insert(pya.Box(DX+280,1180,DX+580,1620))
box(cont, DX+350,1360, DX+510,1520)
box(m1, DX+300,1320, DX+560,1600)
txt(m1p, DX+430, 1290, "CTRL")
txt(m1p, DX+150, 250, "MID")
txt(m1p, 500, 1250, "VDD")

# ---- array escape tracks ----
m3=ly.layer(30,0); v2=ly.layer(20,0)
# MID: extend source (3470..3630,0..1000) left into guard interior, via up, M3 landing
box(m1, 2200,0, 3630,1000)
box(m1, 2240,600, 2900,1300)
box(v1, 2350,750, 2540,940)
box(m2, 2200,700, 2600,1050)
box(v2, 2350,750, 2540,940)
box(m3, 2280,700, 2610,1000)
# CTRL: widen/extend pad up, via up, M3 landing
box(m1, 3660,1300, 4010,1800)
box(v1, 3690,1360, 3880,1550)
box(m2, 3650,1310, 3920,1580)
box(v2, 3690,1360, 3880,1550)
box(m3, 3630,1330, 3950,1590)
top=ly.create_cell("dll8_finger_p_top"); top.insert(pya.CellInstArray(f.cell_index(),pya.Trans()))
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write("/grid/adpll_gen/flow/macro/dll8_cells/dll8_finger_p.gds",opts)
print(json.dumps({"bbox":f.bbox().to_s()}))
