# Bind the hardened DCO macro's met4 power rails to the global top grid.
# Sourced by the wrapped pdngen after the standard-cell grid is generated.
set block [ord::get_db_block]
set tech  [ord::get_db_tech]

proc _layer {name} {
    return [[ord::get_db_tech] findLayer $name]
}

proc _via_between {a b} {
    set tech [ord::get_db_tech]
    set vname ""
    switch -- "$a $b" {
        "met3 met4" { set vname M3M4_PR }
        "met4 met5" { set vname M4M5_PR }
    }
    if { $vname eq "" } { return "" }
    set v [ $tech findVia $vname ]
    if { $v eq "NULL" } { return "" }
    return $v
}

proc _straps {net layname} {
    set out {}
    foreach sw [$net getSWires] {
        if { $sw eq "NULL" || $sw eq "" } { continue }
        foreach sb [$sw getWires] {
            if { $sb eq "NULL" || $sb eq "" } { continue }
            set lay ""
            catch { set lay [[$sb getTechLayer] getName] }
            if { $lay ne $layname } { continue }
            lappend out [list [$sb xMin] [$sb xMax] [$sb yMin] [$sb yMax]]
        }
    }
    return $out
}

proc _nearest_m5 {net px py} {
    set best "" ; set bd 1e30
    foreach s [_straps $net met5] {
        lassign $s x0 x1 y0 y1
        if { [expr {$x1-$x0}] < 100000 } { continue }
        set cy [expr {($y0+$y1)/2.0}]
        set d [expr {abs($cy-$py)}]
        if { $d < $bd } { set bd $d ; set best $s }
    }
    return $best
}

proc _box {sw lay x0 y0 x1 y1} {
    odb::dbSBox_create $sw [_layer $lay] \
        [expr {int($x0)}] [expr {int($y0)}] [expr {int($x1)}] [expr {int($y1)}] STRIPE
}

proc _via {sw a b x y} {
    set v [_via_between $a $b]
    if { $v ne "" } {
        odb::dbSBox_create $sw $v [expr {int($x)}] [expr {int($y)}] STRIPE
    }
}


proc _m4_at_y {net px py} {
    set best "" ; set bd 1e30
    foreach s [_straps $net met4] {
        lassign $s x0 x1 y0 y1
        if { [expr {$y1-$y0}] < 200000 } { continue }
        if { $py < $y0 || $py > $y1 } { continue }
        set d [expr {abs(($x0+$x1)/2.0 - $px)}]
        if { $d < $bd } { set bd $d ; set best $s }
    }
    return $best
}


# dbMPin geometry is in the macro MASTER frame; the instance sits at [20,20]
# orientation N, so chip coords = master coords + instance origin.  top_pnr13
# bound rails at master coords -> all bridges landed 20um down-left and shorted.
proc _bind_all {inst pinname netname} {
    global block
    set i [$block findInst $inst]
    if { $i eq "NULL" || $i eq "" } { return }
    set it [$i findITerm $pinname]
    if { $it eq "NULL" || $it eq "" } { return }
    # getLocation returns a Tcl list {x y}, not a dbPoint object.
    set loc [$i getLocation]
    set ox [lindex $loc 0]
    set oy [lindex $loc 1]
    set ori [$i getOrient]
    set mterm [$it getMTerm]
    foreach mp [$mterm getMPins] {
        foreach g [$mp getGeometry] {
            set lay ""
            catch { set lay [[$g getTechLayer] getName] }
            if { $lay ne "met4" } { continue }
            # apply instance transform (orientation N/R0: translate only)
            set x0 [$g xMin] ; set x1 [$g xMax]
            set y0 [$g yMin] ; set y1 [$g yMax]
            switch -- $ori {
                R0 - N     { set bx0 [expr {$x0+$ox}] ; set bx1 [expr {$x1+$ox}] ; set by0 [expr {$y0+$oy}] ; set by1 [expr {$y1+$oy}] }
                MX - R180  { set bx0 [expr {$ox-$x1}] ; set bx1 [expr {$ox-$x0}] ; set by0 [expr {$oy+$y0}] ; set by1 [expr {$oy+$y1}] }
                MY - R270  { set bx0 [expr {$ox+$x0}] ; set bx1 [expr {$ox+$x1}] ; set by0 [expr {$oy-$y1}] ; set by1 [expr {$oy-$y0}] }
                default    { set bx0 [expr {$x0+$ox}] ; set bx1 [expr {$x1+$ox}] ; set by0 [expr {$y0+$oy}] ; set by1 [expr {$y1+$oy}] }
            }
            _bind_rail_abs $pinname $netname $bx0 $by0 $bx1 $by1
        }
    }
}

# chip-coordinate variant of _bind_rail
proc _bind_rail_abs {pinname netname x0 y0 x1 y1} {
    global block
    set px [expr {int(($x0+$x1)/2.0)}]
    set py [expr {int(($y0+$y1)/2.0)}]
    set net [$block findNet $netname]
    if { $net eq "NULL" || $net eq "" } { return }
    set halfw 300
    set sw [odb::dbSWire_create $net ROUTED]
    set m5 [_nearest_m5 $net $px $py]
    if { $m5 ne "" } {
        lassign $m5 mx0 mx1 my0 my1
        set mcy [expr {int(($my0+$my1)/2.0)}]
        _box $sw met4 [expr {$px-$halfw}] [expr {min($py,$mcy)-$halfw}] \
                      [expr {$px+$halfw}] [expr {max($py,$mcy)+$halfw}]
        _via $sw met4 met5 $px $mcy
        puts "pdn_patch: bound $pinname rail @$px,$py -> met5 y=$my0..$my1"
        return
    }
    set m4 [_m4_at_y $net $px $py]
    if { $m4 eq "" } {
        puts "pdn_patch: no met5/met4 strap for $pinname rail at $px,$py"
        return
    }
    lassign $m4 sx0 sx1 sy0 sy1
    _box $sw met4 [expr {min($px,$sx0)-$halfw}] [expr {$py-$halfw}] \
                  [expr {max($px,$sx1)+$halfw}] [expr {$py+$halfw}]
    puts "pdn_patch: bound $pinname rail @$px,$py -> met4 strap x=$sx0..$sx1"
}

# top_pnr16: PDN_VOFFSET=4.52 lands each VPWR/VGND strap on its macro rail's x,
# but the top strap is trimmed ~0.6um ABOVE the rail top (strap starts at
# y=151.4, rail top=150.8) leaving a gap.  Bridge each rail straight UP on
# met4 to the overlapping same-net strap - a vertical run on the rail's own
# column, so it cannot cross an opposite-net strap (unlike the old horiz jog).
proc _bind_vertical {inst pinname netname} {
    global block
    set i [$block findInst $inst]
    if { $i eq "NULL" || $i eq "" } { return }
    set it [$i findITerm $pinname]
    if { $it eq "NULL" || $it eq "" } { return }
    set loc [$i getLocation]
    set ox [lindex $loc 0] ; set oy [lindex $loc 1]
    set net [$block findNet $netname]
    if { $net eq "NULL" || $net eq "" } { return }
    foreach mp [[$it getMTerm] getMPins] {
        foreach g [$mp getGeometry] {
            set lay ""
            catch { set lay [[$g getTechLayer] getName] }
            if { $lay ne "met4" } { continue }
            set rx0 [expr {[$g xMin]+$ox}] ; set rx1 [expr {[$g xMax]+$ox}]
            set ry0 [expr {[$g yMin]+$oy}] ; set ry1 [expr {[$g yMax]+$oy}]
            # Find the same-net met4 strap overlapping this rail's x whose
            # bottom edge is nearest the rail top (the aligned strap stops a
            # fraction of a um above the rail).  Bridge the gap vertically.
            set best "" ; set bd 1e30
            foreach s [_straps $net met4] {
                lassign $s sx0 sx1 sy0 sy1
                if { $sx1 < $rx0 || $sx0 > $rx1 } { continue }  ;# x no overlap
                if { $sy1 < $ry0 } { continue }   ;# strap fully below rail
                set d [expr {abs($sy0-$ry1)}]
                if { $d < $bd } { set bd $d ; set best $s }
            }
            if { $best eq "" } {
                puts "pdn_patch: no overlapping met4 strap for $pinname rail x=$rx0..$rx1"
                continue
            }
            lassign $best sx0 sx1 sy0 sy1
            set x0 [expr {max($rx0,$sx0)}] ; set x1 [expr {min($rx1,$sx1)}]
            set sw [odb::dbSWire_create $net ROUTED]
            _box $sw met4 $x0 [expr {min($ry1,$sy0)}] $x1 [expr {max($ry1,$sy0)}]
            puts "pdn_patch: $pinname rail x=$rx0..$rx1 top=$ry1 -> strap y=$sy0..$sy1"
        }
    }
}
_bind_vertical dco VPWR VPWR
_bind_vertical dco VGND VGND

# top_pnr13 lesson: do NOT add a hardcoded local met4 bridge here. The previous
# _patch_dco_local used macro-relative x (28.26/30.04/31.48) as absolute coords,
# so its VGND horizontal strap ran straight through the real VPWR vertical strap
# and shorted VGND<->VPWR in LVS. _bind_rail already routes each rail to the
# nearest same-net met4/met5 strap, and the true top straps (VPWR x=0/23.62/
# 43.62/63.62/83.62/103.62/123.62/143.62; VGND +1.44) leave a clear horizontal
# met4 channel from each rail to its same-net strap.
