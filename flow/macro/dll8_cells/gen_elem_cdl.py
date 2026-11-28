#!/usr/bin/env python3
# Generate the reference CDL for the dll8 element macro, transcribed 1:1 from
# the KLayout flat extraction (taps ON).  Deck net/partition facts (measured):
#   ports A A|Y VDD VSS Y sub!
#   A|Y=MID (127 switch D + inv1 S + inv2 G), A=inv1 G, Y=inv2 S
#   VDD={inv pmos D/B, ntap1 TIE}, VSS={nmos B+inv, ptap1 both terminals}
#   $6 (NW_SHARED) = {63 pmos bulk, ntap1 WELL}   (tap R splits tie/well)
#   $4 (PLATEP)   = {63 moscap_p NW terminals}   (deck bulk_port isolated)
#   sub! = {64 moscap_n SUB} (global psub)
#   64 N cn nets + 63 P cn nets, all distinct; 127 distinct gate straps
import sys, re
D = '/grid/adpll_gen/flow/macro/dll8_cells'
NN, NP = 64, 63
src = open(D + '/out/lvs/elem_cur_tap_on.cir').read()
rs = [l for l in src.split('\n') if l.startswith('R$')]
r_nt = next(l for l in rs if ' ntap1 ' in l).split()
r_pt = next(l for l in rs if ' ptap1 ' in l).split()
# R<id> n1 n2 model A=.. P=..  -> normalize terminal nets to the CDL names
nt_line = 'R_nt1 %s %s ntap1 %s %s' % ('VDD', 'NW_SHARED', r_nt[4], r_nt[5])
pt_line = 'R_pt1 %s %s ptap1 %s %s' % ('VSS', 'VSS', r_pt[4], r_pt[5])
out = []
w = out.append
w('* Reference CDL for dll8_elem_macro (gen_elem_cdl.py; transcribed from')
w('* KLayout flat extraction elem_cur, taps ON, NY=5000)')
w('* 127 fingers: even=N sg13_lv_nmos 0.5/0.45 + sg13_moscap_n 1.0x1.0')
w('*               odd =P sg13_lv_pmos 1.0/0.13 + sg13_moscap_p 1.0x1.0')
w('* 2x inv_4 flattened (nmos W=2.96u / pmos W=4.48u, L=0.13u).')
w('* No buf_8/inv_8: control straps drive switch gates directly (quasi-static).')
w('* Port contract: A=IN, A|Y=MID, Y=OUT, sub!=psub global,')
w('*   NW_SHARED=P guard nwell net (31/25 label -> top port),')
w('*   PLATEP=P cap NW ports (deck-isolated bulk_port net).')
w('.SUBCKT dll8_elem_macro_top A A|Y NW_SHARED VDD VSS Y sub!')
w('M_inv1_n VSS A A|Y VSS sg13_lv_nmos L=0.13u W=2.96u')
w('M_inv1_p VDD A A|Y VDD sg13_lv_pmos L=0.13u W=4.48u')
w('M_inv2_n VSS A|Y Y VSS sg13_lv_nmos L=0.13u W=2.96u')
w('M_inv2_p VDD A|Y Y VDD sg13_lv_pmos L=0.13u W=4.48u')
for i in range(NN):
    w('Mn_%d A|Y ng%d cn%d VSS sg13_lv_nmos L=0.45u W=0.5u' % (i, i, i))
    w('Cn_%d cn%d sub! sg13_moscap_n w=1u l=1u' % (i, i))
for i in range(NP):
    w('Mp_%d A|Y pg%d cp%d NW_SHARED sg13_lv_pmos L=0.13u W=1u' % (i, i, i))
    w('Cp_%d cp%d PLATEP sg13_moscap_p w=1u l=1u' % (i, i))
w(nt_line)
w(pt_line)
w('.ENDS dll8_elem_macro_top')
path = D + '/dll8_elem.cdl'
open(path, 'w').write('\n'.join(out) + '\n')
print('wrote', path, len(out), 'lines')
print('R lines:', nt_line, '|', pt_line)
