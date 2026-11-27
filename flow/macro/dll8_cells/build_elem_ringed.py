import sys, json
PDK='/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2'
sys.path.insert(0, PDK+"/libs.tech/klayout/python")
sys.path.insert(0, PDK+"/libs.tech/klayout/python/pycell4klayout-api/source/python")
import sg13g2_pycell_lib, pya
ly=pya.Layout(); ly.dbu=0.001; ly.technology_name="sg13g2"
ly.read(PDK+"/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds")
U=1000
P=int(sys.argv[1])*U if len(sys.argv)>1 else 7*U
mcn=ly.create_cell("moscap_n","SG13_dev",{"w":"1.0u","l":"1.0u","m":"1"})
mcp=ly.create_cell("moscap_p","SG13_dev",{"w":"1.0u","l":"1.0u","m":"1"})
ns=ly.create_cell("nmos","SG13_dev",{"w":"0.5u","l":"0.45u","ng":"1","guardRingType":"psub","guardRingDistance":"1u"})
ps=ly.create_cell("pmos","SG13_dev",{"w":"1.0u","l":"0.13u","ng":"1","guardRingType":"nwell","guardRingDistance":"1u"})
inv=ly.cell("sg13g2_inv_4")
c=ly.create_cell("elem_ringed")
NCOL=16
for j in range(127):
    cx=(j%NCOL)*P; cy=(j//NCOL)*P
    cap=mcn if j%2==0 else mcp
    sw=ns if j%2==0 else ps
    c.insert(pya.CellInstArray(cap.cell_index(),pya.Trans(pya.Vector(cx,cy))))
    c.insert(pya.CellInstArray(sw.cell_index(),pya.Trans(pya.Vector(cx+2*U,cy))))
ny=(126//NCOL)*P
for k in range(2):
    c.insert(pya.CellInstArray(inv.cell_index(),pya.Trans(pya.Vector(k*3*U,ny+5*U))))
top=ly.create_cell("dll8_elem_ringed_top")
top.insert(pya.CellInstArray(c.cell_index(),pya.Trans(pya.Vector(0,0))))
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write("/grid/adpll_gen/flow/macro/dll8_cells/dll8_elem_ringed.gds",opts)
print(json.dumps({"pitch_um":P/1000,"bbox":top.bbox().to_s(),"w_um":top.bbox().width()/1000,"h_um":top.bbox().height()/1000}))
