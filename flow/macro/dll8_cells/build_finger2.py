import sys, json
PDK='/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2'
sys.path.insert(0, PDK+"/libs.tech/klayout/python")
sys.path.insert(0, PDK+"/libs.tech/klayout/python/pycell4klayout-api/source/python")
import sg13g2_pycell_lib, pya
ly=pya.Layout(); ly.dbu=0.001; ly.technology_name="sg13g2"
mcn=ly.create_cell("moscap_n","SG13_dev",{"w":"1.0u","l":"1.0u","m":"1"})
ns=ly.create_cell("nmos","SG13_dev",{"w":"0.5u","l":"0.45u","ng":"1","guardRingType":"psub","guardRingDistance":"1u"})
m1=ly.layer(8,0); m1p=ly.layer(8,2); v1=ly.layer(19,0); m2=ly.layer(10,0); m2p=ly.layer(10,2); cont=ly.layer(6,0)
f=ly.create_cell("DLL8_FINGER")
f.insert(pya.CellInstArray(mcn.cell_index(),pya.Trans()))
DX=3400
f.insert(pya.CellInstArray(ns.cell_index(),pya.Trans(pya.Vector(DX,0))))
def box(l,x1,y1,x2,y2): f.shapes(l).insert(pya.Box(int(x1),int(y1),int(x2),int(y2)))
def txt(l,x,y,s): f.shapes(l).insert(pya.Text(s,pya.Trans(pya.Vector(int(x),int(y)))))
# CN gate contact inside the poly plate (x<1000, between S/D straps)
box(cont, 820,170, 980,330)
box(m1, 760,120, 1000,380)
box(v1, 795,155, 985,345)       # 190x190 via1
box(m2, 740,110, 1020,390)
# switch drain M1 (DX+900..DX+1060,0..500): V1 + M2
box(v1, DX+885,155, DX+1075,345)
# M2 CN bridge gate->drain
box(m2, 950,150, DX+1075,350)
txt(m2p, 2000, 250, "CN")
# CTRL: cont on switch gate poly (DX+340..DX+790), M1 pad narrowed
box(cont, DX+470,120, DX+630,280)
box(m1, DX+420,80, DX+720,340)
txt(m1p, DX+560, 210, "CTRL")
txt(m1p, DX+150, 250, "MID")
txt(m1p, 500, 1250, "VSS")
top=ly.create_cell("dll8_finger_top"); top.insert(pya.CellInstArray(f.cell_index(),pya.Trans()))
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write("/grid/adpll_gen/flow/macro/dll8_cells/dll8_finger.gds",opts)
print(json.dumps({"bbox":f.bbox().to_s()}))
