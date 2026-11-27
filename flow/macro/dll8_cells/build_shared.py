import sys, json
PDK='/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2'
sys.path.insert(0, PDK+"/libs.tech/klayout/python")
sys.path.insert(0, PDK+"/libs.tech/klayout/python/pycell4klayout-api/source/python")
import sg13g2_pycell_lib, pya
ly=pya.Layout(); ly.dbu=0.001; ly.technology_name="sg13g2"
ly.read(PDK+"/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds")
U=1000
mcn=ly.create_cell("moscap_n","SG13_dev",{"w":"1.0u","l":"1.0u","m":"1"})
mcp=ly.create_cell("moscap_p","SG13_dev",{"w":"1.0u","l":"1.0u","m":"1"})
ns=ly.create_cell("nmos","SG13_dev",{"w":"0.5u","l":"0.45u","ng":"1","guardRingType":"psub","guardRingDistance":"1u"})
ps=ly.create_cell("pmos","SG13_dev",{"w":"1.0u","l":"0.13u","ng":"1","guardRingType":"nwell","guardRingDistance":"1u"})
inv=ly.cell("sg13g2_inv_4")
L_NW=ly.layer(31,0); L_NB=ly.layer(32,0); L_PW=ly.layer(46,0)
c=ly.create_cell("elem_shared_well")
NCOL=8; P=7000; SW=3500
def place(x0, cap, sw, idxs):
    for n,j in enumerate(idxs):
        cx=x0+(n%NCOL)*P; cy=(n//NCOL)*P
        c.insert(pya.CellInstArray(cap.cell_index(),pya.Trans(pya.Vector(cx,cy))))
        c.insert(pya.CellInstArray(sw.cell_index(),pya.Trans(pya.Vector(cx+SW,cy))))
    rows=(len(idxs)-1)//NCOL+1
    return (x0-1500, -1500, x0+(NCOL-1)*P+SW+3000, (rows-1)*P+3000)
# N group (even), P group (odd) separated
nb=place(0, mcn, ns, list(range(0,127,2)))
px0=nb[2]+8000
pb=place(px0, mcp, ps, list(range(1,127,2)))
# shared nwell + nbulay over the P group (all P nets are VDD)
c.shapes(L_NW).insert(pya.Box(int(pb[0]),int(pb[1]),int(pb[2]),int(pb[3])))
c.shapes(L_NB).insert(pya.Box(int(pb[0]),int(pb[1]),int(pb[2]),int(pb[3])))
# inv_4 chain at the bottom
ybot=max(nb[3],pb[3])+3000
for k in range(2):
    c.insert(pya.CellInstArray(inv.cell_index(),pya.Trans(pya.Vector(k*5*U,ybot))))
top=ly.create_cell("dll8_elem_shared_well_top"); top.insert(pya.CellInstArray(c.cell_index(),pya.Trans()))
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write("/grid/adpll_gen/flow/macro/dll8_cells/dll8_elem_shared_well.gds",opts)
print(json.dumps({"bbox":top.bbox().to_s(),"w":top.bbox().width()/1000,"h":top.bbox().height()/1000,"P_rect":pb}))
