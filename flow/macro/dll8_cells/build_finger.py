import sys, json
PDK='/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2'
sys.path.insert(0, PDK+"/libs.tech/klayout/python")
sys.path.insert(0, PDK+"/libs.tech/klayout/python/pycell4klayout-api/source/python")
import sg13g2_pycell_lib, pya
ly=pya.Layout(); ly.dbu=0.001; ly.technology_name="sg13g2"
mcn=ly.create_cell("moscap_n","SG13_dev",{"w":"1.0u","l":"1.0u","m":"1"})
ns=ly.create_cell("nmos","SG13_dev",{"w":"0.5u","l":"0.45u","ng":"1","guardRingType":"psub","guardRingDistance":"1u"})
m1=ly.layer(8,0); m1p=ly.layer(8,2); v1=ly.layer(19,0); m2=ly.layer(10,0); m2p=ly.layer(10,2); cont=ly.layer(6,0); gp=ly.layer(5,0); gp2=ly.layer(5,2)
f=ly.create_cell("DLL8_FINGER")
f.insert(pya.CellInstArray(mcn.cell_index(),pya.Trans()))
DX=3000
f.insert(pya.CellInstArray(ns.cell_index(),pya.Trans(pya.Vector(DX,0))))
def box(l,x1,y1,x2,y2): f.shapes(l).insert(pya.Box(int(x1),int(y1),int(x2),int(y2)))
def txt(l,x,y,s): f.shapes(l).insert(pya.Text(s,pya.Trans(pya.Vector(int(x),int(y)))))
# CN: moscap gate contact at (950,250) (clear poly between S/D straps), M1 pad, V1, M2 bridge
box(cont, 870,170, 1030,330)
box(m1, 800,100, 1100,400)
box(v1, 855,155, 1045,345)
box(m2, 800,100, 1100,400)
# switch drain M1 exists (3900..4060,0..500): V1 + M2
box(v1, DX+870,155, DX+1060,345)
# M2 CN bridge gate->drain
box(m2, 950,150, DX+1060,350)
txt(m2p, 2000, 250, "CN")
# switch gate control: cont + m1 pad + label (poly 340..790 at DX)
box(cont, DX+340+130, 120, DX+340+290, 280)
box(m1, DX+400, 80, DX+720, 360)
txt(m1p, DX+560, 220, "CTRL")
# source (mid) m1 exists (DX+70..DX+230,0..500): label
txt(m1p, DX+150, 250, "MID")
# cap bottom (VSS) m1: label
txt(m1p, 500, 1250, "VSS")
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write("/grid/adpll_gen/flow/macro/dll8_cells/dll8_finger.gds",opts)
top=ly.create_cell("dll8_finger_top"); top.insert(pya.CellInstArray(f.cell_index(),pya.Trans()))
ly.write("/grid/adpll_gen/flow/macro/dll8_cells/dll8_finger.gds",opts)
print(json.dumps({"finger_bbox":f.bbox().to_s()}))
