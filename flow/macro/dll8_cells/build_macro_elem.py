import sys, json
PDK='/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2'
sys.path.insert(0, PDK+"/libs.tech/klayout/python")
sys.path.insert(0, PDK+"/libs.tech/klayout/python/pycell4klayout-api/source/python")
import sg13g2_pycell_lib, pya
D='/grid/adpll_gen/flow/macro/dll8_cells'
ly=pya.Layout(); ly.dbu=0.001
ly.read(D+"/dll8_line_array.gds")
ly.read(PDK+"/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds")
arr=ly.cell("DLL8_LINE_ARRAY"); inv=ly.cell("sg13g2_inv_4")
m1=ly.layer(8,0); m1p=ly.layer(8,2); m2=ly.layer(10,0); m3=ly.layer(30,0); v1=ly.layer(19,0); v2=ly.layer(29,0)

# inv placements (origin nm)
O1=(400,-6500); O2=(2750,-11000)
def addbox(cell,l,x1,y1,x2,y2): cell.shapes(l).insert(pya.Box(int(x1),int(y1),int(x2),int(y2)))
def txt(l,x,y,s): c.shapes(l).insert(pya.Text(s,pya.Trans(pya.Vector(int(x),int(y)))))

# put invs + wiring in a new cell that instances the array, so we keep the array cell intact
c=ly.create_cell("DLL8_ELEM_MACRO")
c.insert(pya.CellInstArray(arr.cell_index(),pya.Trans()))
c.insert(pya.CellInstArray(inv.cell_index(),pya.Trans(pya.Vector(*O1))))
c.insert(pya.CellInstArray(inv.cell_index(),pya.Trans(pya.Vector(*O2))))
B=lambda l,x1,y1,x2,y2: addbox(c,l,x1,y1,x2,y2)

# ---- MID bus extension down between the invs (M3, merges array MID bus) ----
B(m3, 2940,-9800, 3230,-400)
# inv1.Y -> MID : M1 ext, V1, M2, V2 to bus
B(m1, 2700,-5200, 3200,-4800)
B(v1, 2800,-5150, 2990,-4960)
B(m2, 2740,-5210, 3050,-4900)
B(v2, 2800,-5150, 2990,-4960)
# inv2.A <- MID : V2 on bus, M2, V1 to A
B(v2, 3000,-9400, 3190,-9210)
B(m2, 2940,-9460, 3450,-9150)
B(v1, 3250,-9400, 3440,-9210)
# ---- IN : inv1.A ----
B(m1, 0,-4980, 900,-4600)
txt(m1p, 150,-4800,"IN")
# ---- OUT : inv2.Y ----
B(m1, 5200,-9900, 6000,-8800)
txt(m1p, 5750,-9350,"OUT")
# ---- VDD (M1, right side) ----
# Power respin 2026-11-28 (EM: JMAXM1 1 mA/um for w>0.36 um, JMAXVIA 0.4 mA):
# FF worst = 0.5 mA per strip element -> all series cross-sections >= 0.5 um.
B(m1, 5360,-2460, 6200,-1960)          # tie array VDD rail out to x6.2 (0.5 um tall)
B(m1, 5040,-7240, 6200,-1960)          # right vertical drop (1.16 um wide; probed: only same-net neighbors west)
B(m1, 400,-2960, 6200,-2760)           # inv1 VDD + join
B(m1, 2750,-7240, 6200,-7040)          # inv2 VDD + join
B(m1, 5360,-2460, 9000+5960, -1960)    # extend to P-column VDD rail (14360..14960 abs) -- ties inv VDD to P bulk strap
txt(m1p, 6120,-4600,"VDD")
# ---- VSS (M1, left side x~-0.8) ----
# Power respin: single merged connector+out piece 0.76 um tall, bottom edge at
# y=-2120 (the original connector bottom): inv1's internal VDD rail reaches
# y=-2500 abs at x0.4..3.28, and an earlier 0.8/0.6 um version extending below
# -2480 SHORTED VSS to it (LVS netlist showed VDD|VSS merged; M1-on-M1 overlap
# is invisible to same-layer DRC spacing because the polygons merge).
# y[-2120,-1360] keeps a 380 nm gap to the inv1 rail top.
B(m1, -1700,-2120, 2560,-1360)         # connector+out merged (0.76 um tall)
B(m1, -1700,-11260, -640,-2060)        # left vertical (1.06 um wide)
B(m1, -800,-6700, 3280,-6500)          # inv1 VSS
B(m1, -800,-11160, 5630,-10960)        # inv2 VSS
txt(m1p, -760,-9300,"VSS")

top=ly.create_cell("dll8_elem_macro_top"); top.insert(pya.CellInstArray(c.cell_index(),pya.Trans()))
top.shapes(m1p).insert(pya.Text("CODE[0..63]",pya.Trans(pya.Vector(6600,253900))))
top.shapes(m1p).insert(pya.Text("CODE[64..126]",pya.Trans(pya.Vector(15600,300000))))
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write(D+"/dll8_elem_macro.gds",opts)
print(json.dumps({"bbox":top.bbox().to_s(),"w":top.bbox().width()/1000,"h":top.bbox().height()/1000}))
