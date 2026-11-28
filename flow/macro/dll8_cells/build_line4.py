import sys, json
D='/grid/adpll_gen/flow/macro/dll8_cells'
import pya
ly=pya.Layout(); ly.dbu=0.001
ly.read(D+"/dll8_elem_macro.gds")
el=ly.cell("DLL8_ELEM_MACRO")
m1=ly.layer(8,0); m1p=ly.layer(8,2); m1t=ly.layer(8,25)
m2=ly.layer(10,0); m2p=ly.layer(10,2); m2t=ly.layer(10,25)
m3=ly.layer(30,0); m3p=ly.layer(30,2); m3t=ly.layer(30,25)
m4=ly.layer(50,0); m4p=ly.layer(50,2); m4t=ly.layer(50,25)
v1=ly.layer(19,0); v3=ly.layer(49,0)

# ---- strip inherited labels: keep device-cell markers (63/0) only ----
for cn in ["sg13g2_inv_4","DLL8_LINE_ARRAY","DLL8_ELEM_MACRO","DLL8_FINGER","DLL8_FINGER_P"]:
    cc=ly.cell(cn)
    if cc:
        for li in list(ly.layer_indexes()):
            for s in [s for s in cc.shapes(li).each() if s.is_text()]:
                cc.shapes(li).erase(s)

c=ly.create_cell("DLL8_LINE4")
PITCH=17000
for k in range(4):
    c.insert(pya.CellInstArray(el.cell_index(),pya.Trans(pya.Vector(k*PITCH,0))))
def B(l,x1,y1,x2,y2): c.shapes(l).insert(pya.Box(int(x1),int(y1),int(x2),int(y2)))
def T(l,x,y,s): c.shapes(l).insert(pya.Text(s,pya.Trans(pya.Vector(int(x),int(y)))))

# ---- inter-element chain: E[k].OUT -> E[k+1].IN (V1 at OUT, M2, V1 at IN) ----
for k in range(3):
    ox=k*PITCH; ix=(k+1)*PITCH
    B(v1, ox+5500,-9560, ox+5690,-9370)
    B(v1, ix+250,-4820, ix+440,-4630)
    B(m2, ox+5400,-9570, ix+360,-9360)
    B(m2, ix+150,-9570, ix+360,-4620)
    B(m2, ix+150,-4840, ix+450,-4620)

# ---- TAP[3:0]: identical straight M2 drops (length-match by construction) ----
TAPLEN = 9360-13500   # negative; abs used in report
for k in range(4):
    ox=k*PITCH
    B(v1, ox+5500,-9560, ox+5690,-9370)
    B(m2, ox+5445,-13500, ox+5655,-9360)
    B(m2, ox+5250,-13670, ox+5840,-13460)
    T(m2p, ox+5300,-13580, "TAP%d"%k)
    T(m2t, ox+5300,-13580, "TAP%d"%k)

# ============================================================================
# Power distribution respin 2026-11-28 (REPORT_power.md):
# the old inter-strip M1/V1 chain hops (single via, 0.44 um M2, cumulative
# current up to 1.5-2.0 mA over cross-sections rated 0.36-0.4 mA) are REPLACED
# by independent per-strip feeds from M4 trunks.  EM basis (SG13G2 process
# spec 2.15, 11y@105C): JMAXM1 = 1 mA/um (w>0.36), JMAXMn(2-5) = 2 mA/um
# (w>0.3), JMAXVIA = 0.4 mA/via.  Worst case = FF 500 MHz full bank:
# 0.50 mA/strip, 2.0 mA per line4.
#
#   VDD trunk: M4 y[-2600..-1400] (1.2 um = 2.4 mA cap.), x 5000..67500
#   VSS trunk: M4 y[-4400..-3400] (1.0 um = 2.0 mA cap.), x -1700..67500
#   per strip: via stack M1->M4, 2x3 arrays each level (6 vias = 2.4 mA cap.)
#   end pads: M1..M5 stack + 2x3 arrays, labels on M5 (pin = pad bbox)
# M4/M5 in the channel below the array verified empty (probed 2026-11-28).
# ============================================================================
v2layer=ly.layer(29,0)
v4=ly.layer(66,0)
m5l=ly.layer(67,0)
def viarray(l, x0, y0, nx, ny, pitch=450):
    for i in range(nx):
        for j in range(ny):
            B(l, x0+i*pitch, y0+j*pitch, x0+i*pitch+190, y0+j*pitch+190)

# ---- per-strip VDD feed: stack at x ox+5100..+5950, y -2460..-1530 ----
# M1 pad overlaps the strip's widened drop (x +5040..+6200, y -7240..-1960)
for k in range(4):
    ox=k*PITCH
    B(m1, ox+5040,-2620, ox+6010,-1460)   # merges drop + tie bar (same net)
    B(m2, ox+5085,-2615, ox+5915,-1535)
    B(m3, ox+5085,-2615, ox+5915,-1535)
    viarray(v1, ox+5185,-2515, 2, 3)
    viarray(v2layer, ox+5185,-2515, 2, 3)
    viarray(v3,  ox+5185,-2515, 2, 3)

# ---- per-strip VSS feed: stack at x ox-1700..ox-700, y -4460..-3340 ----
# M1 pad overlaps the strip's widened left vertical (x -1700..-640)
for k in range(4):
    ox=k*PITCH
    B(m1, ox-1760,-4560, ox-640,-3240)    # merges left vertical (same net)
    B(m2, ox-1705,-4455, ox-875,-3345)
    B(m3, ox-1705,-4455, ox-875,-3345)
    viarray(v1, ox-1605,-4355, 2, 3)
    viarray(v2layer, ox-1605,-4355, 2, 3)
    viarray(v3,  ox-1605,-4355, 2, 3)

# ---- M4 trunks (continuous; double as the M4 landing pads) ----
B(m4, 5000,-2600, 67500,-1400)            # VDD trunk
B(m4, -1700,-4400, 67500,-3400)           # VSS trunk

# ---- end pads: full M1..M5 stack at the right edge, 2x3 via arrays ----
# VDD pad y -2600..-1400; VSS pad y -4400..-3400 (trunk heights extended)
for (y1, y2) in [(-2660,-1340), (-4460,-3340)]:
    B(m1, 65900,y1, 67500,y2)
    B(m2, 65930,y1+30, 67470,y2-30)
    B(m3, 65930,y1+30, 67470,y2-30)
    B(m5l,65850,y1-30, 67500,y2+30)
    viarray(v1, 66030,y1+130, 2, 3)
    viarray(v2layer, 66030,y1+130, 2, 3)
    viarray(v3, 66030,y1+130, 2, 3)
    viarray(v4, 66030,y1+130, 2, 3)
# trunk-end M4 pad merge: trunks already reach x 67500 (continuous to pads).

# ---- control escape to the common right edge ----
# Plane M4: groups g0..g2 (E0N,E0P,E1N); Plane M5: groups g3..g6
# (E1P,E2N,E2P,E3N) via stacked Via4. M5 and M4 tracks never interact,
# which halves the crossing pressure on each layer.
EDGE = 3*PITCH+15500           # 66500
W=300; P=550                   # track width / pitch (space 250 >= 0.21)
m5=m5l
m5p=ly.layer(67,2); m5t=ly.layer(67,25)
tracks=[]                      # dicts: src, xv, g, pl, name
for k in range(4):
    ox=k*PITCH
    for n in range(64):
        cy=n*5000+795
        B(m3, ox+4240, n*5000+600, ox+4600, n*5000+990)      # M3 pad on N strap
        xv=ox+4300
        B(v3, xv, cy-95, xv+190, cy+95)                      # Via3
        B(m4, xv-80, cy-150, xv+270, cy+150)                  # M4 landing
        pl=0 if 2*k<3 else 1
        if pl==1:
            B(v4, xv, cy-95, xv+190, cy+95)                  # stacked Via4
            B(m5, xv-160, cy-150, xv+350, cy+150)            # M5 landing (area ok)
        tracks.append(dict(src=cy, xv=xv, g=2*k, pl=pl, name="EN%d_%d"%(k,2*n)))
    for n in range(63):
        cy=n*5500+1460
        if k<3:
            B(m3, ox+12940, n*5500+1270, ox+13300, n*5500+1650)
            xv=ox+13000
            B(v3, xv, cy-95, xv+190, cy+95)
            B(m4, xv-80, cy-150, xv+270, cy+150)
            pl=0 if 2*k+1<3 else 1
            if pl==1:
                B(v4, xv, cy-95, xv+190, cy+95)
                B(m5, xv-160, cy-150, xv+350, cy+150)
            tracks.append(dict(src=cy, xv=xv, g=2*k+1, pl=pl, name="EN%d_%d"%(k,2*n+1)))
        else:
            # E3 P straps already end on the boundary: pin directly on M3
            T(m3p, EDGE-150, cy, "EN%d_%d"%(k,2*n+1))
            T(m3t, EDGE-150, cy, "EN%d_%d"%(k,2*n+1))

# -- solver: reverse x-order greedy with exact-geometry keepout intervals --
# Track shape (per plane): flat at src [x0 -> xv+J1], diagonal [xv+J1 ->
# xv+J2] (slope<=0.82), flat at tgt [xv+J2 -> EDGE].
# Keepout of an assigned track j seen by my flat at cand:
#   cand not in [src_j - (padh+360), tgt_j + 510]
#   (padh+150+210 = landing clearance; 510 = 150+150+210 flat clearance,
#    also covers the diagonal corner: slope 0.82 -> cos 0.773 -> 0.707*510=360>210)
# own group monotone: cand >= last + 511
# candidate window: cand = src + off, off in [530, step-530]
J1m=420; J2=6420
J15=490                          # M5 jog start (landing right edge xv+350)
PADH={0:150, 1:150}
X0 ={0:270,  1:350}
# M4 landings of the M5 plane are obstacles for M4-plane flats (cross-plane):
plane1_srcs=[t['src'] for t in tracks if t['pl']==1]
def solve(plane, J1, extra_keep=()):
    pl_tracks=[t for t in tracks if t['pl']==plane]
    groups=sorted(set(t['g'] for t in pl_tracks))
    by_g={g:sorted([t for t in pl_tracks if t['g']==g], key=lambda t:t['src']) for g in groups}
    xv_g={g:by_g[g][0]['xv'] for g in groups}
    STEP={}
    for g in groups:
        s=[t['src'] for t in by_g[g]]
        STEP[g]=s[1]-s[0] if len(s)>1 else 4000
    padh=PADH[plane]; x0o=X0[plane]
    # jog must clear the next landing (left edge) by 210; flat covers EDGE
    for a,b in zip(groups, groups[1:]):
        assert xv_g[b]-xv_g[a] >= J1, (a,b)
        assert (xv_g[b]-160 if plane else xv_g[b]-80) - (xv_g[a]+J2) >= 210, (a,b)
    assert EDGE-(xv_g[max(groups)]+J2) >= 210
    assigned=[]; fail=[]
    for g in reversed(groups):
        last=None; step=STEP[g]
        for t in by_g[g]:
            src=t['src']
            iv=[(a['src']-(padh+150+210), a['tgt']+510) for a in assigned]
            for s in extra_keep: iv.append((s-(padh+150+210), s+(padh+150+210)))
            if last is not None: iv.append((-10**18, last+510))
            iv.sort()
            merged=[]
            for lo,hi in iv:
                if merged and lo<=merged[-1][1]+1: merged[-1]=(merged[-1][0],max(merged[-1][1],hi))
                else: merged.append((lo,hi))
            ok=None; p=0
            for off in range(530, step-529, 10):
                cand=src+off
                while p<len(merged) and merged[p][1]<cand: p+=1
                if p<len(merged) and merged[p][0]<=cand<=merged[p][1]: continue
                ok=cand; break
            if ok is None:
                if not fail:
                    print("DEBUG fail plane",plane, t['name'], "src", src,
                          "window", src+530, src+step-530)
                    for lo,hi in merged:
                        if hi>=src+530 and lo<=src+step-530: print("   iv",lo,hi)
                fail.append((t['name'],src,g)); continue
            t['tgt']=ok; last=ok
            assigned.append(dict(src=src,tgt=ok,g=g))
    return fail
fail=solve(0, J1m, plane1_srcs) + solve(1, J15)
if fail:
    print("SOLVER FAIL", len(fail))
    for f in fail[:8]: print("  ",f)
    sys.exit(1)

# -- emit escape tracks (plane-aware, Manhattan staircase) --
# flat at src [x0 -> xv+720] | vertical connector [xv+420, xv+720] |
# flat at tgt [xv+420 -> EDGE]  (45-degree metal is DRC-forbidden)
for t in tracks:
    src=t['src']; tgt=t['tgt']; xv=t['xv']; h=W//2
    L,LP,LT = (m4,m4p,m4t) if t['pl']==0 else (m5,m5p,m5t)
    x0=xv+X0[t['pl']]
    B(L, x0, src-h, xv+720, src+h)                     # flat at src
    B(L, xv+420, src-h, xv+720, tgt+h)                 # vertical connector
    B(L, xv+420, tgt-h, EDGE, tgt+h)                   # flat at tgt
    T(LP, EDGE-250, tgt, t['name'])
    T(LT, EDGE-250, tgt, t['name'])

# ---- boundary signal/power pins ----
T(m1p, 150,-4800,"IN");   T(m1t, 150,-4800,"IN")
T(m1p, 3*PITCH+5750,-9350,"OUT"); T(m1t, 3*PITCH+5750,-9350,"OUT")
# Power pins on the M5 end pads (power respin 2026-11-28: full M1..M5 stack,
# 2x3 via arrays per level = 2.4 mA per level; the old 0.16 um M1 label-point
# pins could not even enclose a single via).
T(m5p, 66650,-3900,"VSS"); T(m5t, 66650,-3900,"VSS")
T(m5p, 66650,-2000,"VDD"); T(m5t, 66650,-2000,"VDD")

top=ly.create_cell("dll8_line4_top"); top.insert(pya.CellInstArray(c.cell_index(),pya.Trans()))
opts=pya.SaveLayoutOptions()
try: opts.format="GDS2"
except: pass
ly.write(D+"/dll8_line4.gds",opts)
mn=[t['tgt']-t['src'] for t in tracks]
print(json.dumps({"bbox":top.bbox().to_s(),"w":top.bbox().width()/1000,
 "tracks":len(tracks),"tgt_min":min(t['tgt'] for t in tracks),
 "tgt_max":max(t['tgt'] for t in tracks),
 "jog_max_um":max(abs(m) for m in mn)/1000.0}))
