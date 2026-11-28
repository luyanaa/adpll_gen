#!/usr/bin/env python3
# Generate the reference CDL for dll8_line4 from the KLayout flat extraction.
# v2: switch gates wire DIRECTLY to the EN<k>_<i> top ports (v1 declared EN
# ports but left them dangling and used private ng* gate nets -> 120+ EN
# mismatches).  strip->plate/sub!/welltie mapping is READ from the extraction
# (not guessed): each switch line carries its EN port name (gives strip k) and
# its cn net; the C line with that cn gives the strip's plate port; pmos B
# gives the strip's NWELLTIE net; R lines give tap device areas.
import re, collections
D = '/grid/adpll_gen/flow/macro/dll8_cells'
NN, NP = 64, 63
src = open(D + '/out/lvs/line4_cur_extracted.cir').read()
# unfold devices
devs = []; cur = ''
for l in src.split('\n'):
    s = l.rstrip('\n')
    if s.startswith('+'): cur += ' ' + s[1:].strip()
    else:
        if cur.strip(): devs.append(cur)
        cur = s
if cur.strip(): devs.append(cur)
# ports
ports = []; started = False
for l in src.split('\n'):
    if not started:
        if l.startswith('.SUBCKT'): ports += l.split()[2:]; started = True
        continue
    if l.startswith('+'): ports += l[1:].split()
    else: break
def unesc(n): return n.replace('\\', '')
# maps
n_sub = {}      # strip -> sub! port
p_plate = {}    # strip -> P plate port
n_cnk = {}      # strip -> ordered cn nets (by finger index from EN name)
p_cnk = {}
nwell_of = {}   # strip -> NWELLTIE net
gateN = collections.defaultdict(dict)  # k -> i -> cn net (gate already ENk_i)
gateP = collections.defaultdict(dict)
capA2B = {}     # cap gate net -> plate port/net
for d in devs:
    t = d.split()
    if not t: continue
    if t[0].startswith('C$'):
        capA2B[unesc(t[1])] = unesc(t[2])
for d in devs:
    t = d.split()
    if not t or not t[0].startswith('M') or len(t) < 6: continue
    g = unesc(t[2]); s = unesc(t[3]); Dn = unesc(t[1]); B = unesc(t[4])
    m = re.match(r'^EN(\d)_(\d+)$', g)
    if not m: continue
    k, i = int(m.group(1)), int(m.group(2))
    if t[5] == 'sg13_lv_nmos' and 'W=0.5u' in d:
        n_cnk.setdefault(k, {})[i] = s   # S = cn for N switch
        n_sub[k] = capA2B.get(s)         # that cn's cap plate port
    elif t[5] == 'sg13_lv_pmos' and 'W=1u' in d:
        p_cnk.setdefault(k, {})[i] = s   # S = cn for P switch
        p_plate[k] = capA2B.get(s)
        nwell_of[k] = B                  # pmos bulk = NWELLTIE_k
assert all(k in n_sub for k in range(4)), n_sub
assert all(k in p_plate for k in range(4)), p_plate
assert all(k in nwell_of for k in range(4)), nwell_of
# R lines
rs = [l.split() for l in src.split('\n') if l.startswith('R$')]
nt = [r for r in rs if 'ntap1' in r]; assert len(nt) == 4
pt = next(r for r in rs if 'ptap1' in r)
# R terminal net -> strip via nwell_of
r_nt_by_strip = {}
for r in nt:
    tie = unesc(r[2])
    ks = [k for k in range(4) if nwell_of[k] == tie]
    assert len(ks) == 1, (tie, ks)
    r_nt_by_strip[ks[0]] = (r[1], tie, r[4], r[5])
assert len(r_nt_by_strip) == 4
out = []
w = out.append
w('* Reference CDL for dll8_line4 (gen_line4_cdl.py v2; from line4_cur_extracted.cir)')
w('* switch gates wire directly to EN<k>_<i> top ports; strip-local nets read')
w('* from the extraction: sub!N=%s; PLATE_P=%s; NWELL=%s' %
  tuple([tuple(sorted((k, v) for k, v in d.items())) for d in (n_sub, p_plate, nwell_of)]))
w('* chain IN -> E0 -> TAP0 -> TAP1 -> TAP2 -> OUT|TAP3; MID_k internal.')
w('* N-gate = thermo bit as-is (EN high=ON); P-gate needs inverting drive at')
w('* the decoder (integration contract; no buf/inv devices in layout).')
w('.SUBCKT dll8_line4_top ' + ' '.join(ports))
for k in range(4):
    m = 'mid%d' % k
    ain = 'IN' if k == 0 else 'TAP%d' % (k - 1)
    outn = 'OUT|TAP3' if k == 3 else 'TAP%d' % k
    w('M_inv1n_%d VSS %s %s VSS sg13_lv_nmos L=0.13u W=2.96u' % (k, ain, m))
    w('M_inv1p_%d VDD %s %s VDD sg13_lv_pmos L=0.13u W=4.48u' % (k, ain, m))
    w('M_inv2n_%d VSS %s %s VSS sg13_lv_nmos L=0.13u W=2.96u' % (k, m, outn))
    w('M_inv2p_%d VDD %s %s VDD sg13_lv_pmos L=0.13u W=4.48u' % (k, m, outn))
    for n in range(NN):
        i = 2 * n                      # N fingers = even EN index
        en = 'EN%d_%d' % (k, i)
        w('Mn_%d_%d %s %s %s VSS sg13_lv_nmos L=0.45u W=0.5u' % (k, n, m, en, n_cnk[k][i]))
        w('Cn_%d_%d %s %s sg13_moscap_n w=1u l=1u' % (k, n, n_cnk[k][i], n_sub[k]))
    for n in range(NP):
        i = 2 * n + 1                  # P fingers = odd EN index
        en = 'EN%d_%d' % (k, i)
        w('Mp_%d_%d %s %s %s %s sg13_lv_pmos L=0.13u W=1u' %
          (k, n, m, en, p_cnk[k][i], nwell_of[k]))
        w('Cp_%d_%d %s %s sg13_moscap_p w=1u l=1u' % (k, n, p_cnk[k][i], p_plate[k]))
    n1, tie, a, p = r_nt_by_strip[k]
    w('R_nt1_%d %s %s ntap1 %s %s' % (k, n1, tie, a, p))
w('R_pt1 %s %s ptap1 %s %s' % (unesc(pt[1]), unesc(pt[2]), pt[4], pt[5]))
w('.ENDS dll8_line4_top')
path = D + '/dll8_line4.cdl'
open(path, 'w').write('\n'.join(out) + '\n')
print('wrote', path, len(out), 'lines;', len(ports), 'ports')
print('n_sub:', n_sub); print('p_plate:', p_plate); print('nwell:', nwell_of)
