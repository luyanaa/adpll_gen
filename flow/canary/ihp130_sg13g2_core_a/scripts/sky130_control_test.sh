#!/bin/bash
# Control experiment: does `lef read` work at all in this container, using the
# reference PDK whose tech is known-good?  If sky130 succeeds here, the IHP
# failure is in my merged tech; if it fails too, `lef read` needs something
# else entirely.
set -u
SKY=/foss/pdks/ciel/sky130/versions/1689ac3f2dc763876eaf967227c7dfe831b031ae/sky130A
cat > /tmp/opencode/drc_out/sky_test.tcl <<EOF
puts "START"
tech load $SKY/libs.tech/magic/sky130A.tech
puts "TECH_OK"
tech unlock *
lef read $SKY/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
puts "CELLLEF_DONE"
lef read $SKY/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef
puts "TECHLEF_DONE"
quit
EOF
timeout 200s docker run --rm --entrypoint /bin/bash -v /grid:/grid -v /tmp/opencode:/tmp/opencode \
  -e PATH=/foss/tools/bin:/usr/bin:/bin \
  hpretl/iic-osic-tools:latest -lc \
  "magic -dnull -noconsole /tmp/opencode/drc_out/sky_test.tcl" 2>&1 \
  | grep -E "START|TECH_OK|CELLLEF_DONE|TECHLEF_DONE|parse layer|Unknown layer|No layer defined" | head -10
