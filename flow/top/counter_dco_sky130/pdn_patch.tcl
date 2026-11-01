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

proc _bind_rail {pinname netname bb} {
    global block
    set px [expr {int(([$bb xMin]+[$bb xMax])/2.0)}]
    set py [expr {int(([$bb yMin]+[$bb yMax])/2.0)}]
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
    # Single-layer met4 PDN: jog horizontally at the pin's y to the nearest
    # same-net global met4 strap.
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

proc _bind_all {inst pinname netname} {
    global block
    set i [$block findInst $inst]
    if { $i eq "NULL" || $i eq "" } { return }
    set it [$i findITerm $pinname]
    if { $it eq "NULL" || $it eq "" } { return }
    set mterm [$it getMTerm]
    foreach mp [$mterm getMPins] {
        foreach g [$mp getGeometry] {
            set lay ""
            catch { set lay [[$g getTechLayer] getName] }
            if { $lay ne "met4" } { continue }
            _bind_rail $pinname $netname $g
        }
    }
}

_bind_all dco VPWR VPWR
_bind_all dco VGND VGND
