proc route_phy_bumps {} {
    set TEST 0; if {$TEST} {
        # Delete previous attempts
        editDelete -net net:pad_frame/CVDD
        editDelete -net net:pad_frame/CVSS

        editDelete -net net:pad_frame/ext_Vcm
        editDelete -net net:pad_frame/ext_Vcal

        editDelete -net net:pad_frame/AVDD
        editDelete -net net:pad_frame/AVSS
    }
    puts "@file_info: PHY bumps 0: add nets CVDD, CVSS etc."
    source inputs/analog-bumps/build-phy-nets.tcl
    # source ../../pad_frame/3-netlist-fixing/outputs/netlist-fixing.tcl
    # source /sim/steveri/soc/components/cgra/garnet/mflowgen/common/fc-netlist-fixing/outputs/netlist-fixing.tcl
    if {$TEST} {
        source inputs/analog-bumps/build-phy-nets.tcl
        source inputs/analog-bumps/route-phy-bumps.tcl
        source inputs/analog-bumps/bump-connect.tcl
    }

    # FIXME I guess these should never have been assigned in the first place...!
    puts "@file_info: PHY bumps 0.1: remove prev bump assignments"
    foreach net {CVDD CVSS AVDD AVSS} {
        foreach bumpname [dbGet [dbGet -p2 top.bumps.net.name $net].name] { 
            if { $bumpname == 0x0 } { continue }
            echo unassignBump -byBumpName $bumpname
            unassignBump -byBumpName $bumpname
        }
    }

    puts "@file_info: PHY bumps 1: route bump S1 to CVDD"
    # bump2stripe CVDD *26.3 "1100 4670  1590 4800" ; # Cool! but it runs over icovl cells
    bump2stripe 30.0 CVDD *26.3 "1100 4670  1590 4750"; # munch better

    puts "@file_info: PHY bumps 2: route bump S2 to CVSS"
    bump2stripe 30.0 CVSS *26.4 "770 4800  1590 4900"

    puts "@file_info: PHY bumps 3: Remainder of CVDD"
    sleep 1; bump_connect_diagonal   CVDD *26.3 *25.4 *24.5 *23.6 *22.7
    sleep 1; bump_connect_orthogonal CVDD *23.5 *23.6
    sleep 1; bump_connect_orthogonal CVDD *22.6 *22.7 *22.8 *22.9

    puts "@file_info: PHY bumps 3: Remainder of CVSS"
    sleep 1; bump_connect_diagonal   CVSS Bump_629.25.5 Bump_654.26.4
    sleep 1; bump_connect_orthogonal CVSS *25.5 *25.6 *25.7 *25.8
    sleep 1; bump_connect_orthogonal CVSS *25.8 *24.8 *23.8
    sleep 1; bump_connect_orthogonal CVSS *23.8 *23.7
    sleep 1; bump2wire_up  CVSS Bump_631.25.7 Bump_657.26.7
    sleep 1; bump2wire_up  CVSS Bump_659.26.9

    puts "@file_info: PHY bumps 4: ext_Vcm and ext_Vcal"
    bump2aio ext_Vcal *26.16 "2340  4670   2800 4774"
    bump2aio ext_Vcm  *26.15

    puts "@file_info: PHY bumps 5: AVDD and AVSS"
    # Note blockage b/c AVDD needs extra help finding its way
    create_route_blockage -layer AP  -name temp -box "1800 4200 2440 4683"
    redraw; sleep 1
    bump2stripe 20.0 AVDD     *25.14 "2710 4230  2880 4900"
    bump2stripe 20.0 AVSS     *25.13
}


#     puts "@file_info: PHY bumps 4: ext_Vcm and ext_Vcal"
#     # DP3 26.15 => ext_Vcm
#     # DP4 26.26 => ext_Vcal
#     bump2aio ext_Vcal *26.16
#     bump2aio ext_Vcm  *26.15
# 
# #    sleep 1; bump_connect_orthogonal CVSS *25.7  ERROR?
# 
# 
# # Try this order instead:
# bump2aio         ext_Vcal *26.16 "2340  4670   2800 4774"
# 
# #     bump2aio         ext_Vcm  *26.15 "1900  4670   2600 4720"
# bump2aio         ext_Vcm  *26.15
# 
# #     bump2stripe 20.0 AVDD     *25.14
# # create_route_blockage -layer AP  -name temp -box "1800 4200 2420 4670"
# # create_route_blockage -layer AP  -name temp -box "1800 4200 2440 4690"
# create_route_blockage -layer AP  -name temp -box "1800 4200 2440 4683"
# redraw; sleep 1
# bump2stripe 20.0 AVDD     *25.14 "2710 4230  2880 4900"
# 
# bump2stripe 20.0 AVSS     *25.13









# Procedure for routing PHY bumps
proc fcroute_phy { route_style bump args } {
    # set route_style manhattan; set bump Bump_665.26.15; set args "-routeWidth 20.0"

    setFlipChipMode -route_style $route_style
    setFlipChipMode -connectPowerCellToBump true

    # For phy bump routing this must be TRUE
    setFlipChipMode -honor_bump_connect_target_constraint true

    # setFlipChipMode -route_style 45DegreeRoute
    # setFlipChipMode -route_style manhattan

    set save_selected [get_db selected]; # SAVE
    echo FOOO; echo [get_db selected .*]

#     # Only works if net is power or ground NOT
#     if { [dbGet selected.net.isPwrOrGnd] != 1} {
#         echo ERROR trying to fcroute_phy on non-power/ground net
#     }

    deselectAll; select_obj $bump; sleep 1
    fcroute -type signal -selected \
        -layerChangeBotLayer AP \
        -layerChangeTopLayer AP \
        {*}$args

    deselectAll; select_obj $save_selected; # RESTORE
}

# Connect bump 'b' to net 'net' stripe
proc bump2stripe { wire_width net b args } {
    # Can include an optional blockage box to direct the routing
    # Examples:
    #     bump2stripe CVDD *26.3
    #     bump2stripe CVSS *26.4 "770 4800  1590 4900"
    set blockage "none"; if {[llength $args]} { set blockage $args }

    # Cut'n' paste for interactive test
    set TEST 0; if {$TEST} {
        # Set up to route bumps interactively
        set wire_width 30.0
        set b *26.3; set net CVDD; set blockage "none"
        set b *26.4; set net CVSS; set blockage "770 4800  1590 4900"
        set b *25.14; set net AVDD; set wire_width 20.0
        set b *25.13; set net AVSS; set wire_width 20.0

        # Delete ALL RDL layer routes
        # deselectAll; editSelect -layer AP; deleteSelectedFromFPlan

        # Remove previous attempt(s) if necessary
        editDelete -net net:pad_frame/$net; # Removes (all) prev routes related to $net
        unassignBump -byBumpName $bump
    }
    # Get targeted bump, net, pad
    # Note we use ANAIOPAD_$net as the pad; we may want to change this at some 
    # point and e.g. route both CVDD and CVSS bumps to different ports on e.g. ANAIOPAD_CVDD
    echo "@file_info b=$b net=$net blockage=$blockage"
    set pad ANAIOPAD_$net

    # Do the old switcheroo for AV wires
    switch $net {
        CVSS { set pad ANAIOPAD_$net }
        CVDD { set pad ANAIOPAD_$net }
        AVSS { set pad ANAIOPAD_AVDD }
        AVDD { set pad ANAIOPAD_AVSS }
    }

    set bump [dbGet top.bumps.name $b]
    echo "@file_info bump=$bump pad=$pad"

    # Assign the bump to the net, show flightline resulting from assignment
    assignPGBumps -nets $net -bumps $bump
    viewBumpConnection -bump $bump; sleep 1

    # Find and assign more precise bump target
    findPinPortNumber -instName $pad -netName $net; # ANAIOPAD_CVDD:TACVDD:1
    set ppn [findPinPortNumber -instName $pad -netName $net]
    set pin_name [lindex [split $ppn ":"] 1]
    set port_num [lindex [split $ppn ":"] 2]
    echo addBumpConnectTargetConstraint -bump $bump \
        -instName $pad \
        -pinName $pin_name \
        -portNum $port_num
    addBumpConnectTargetConstraint -bump $bump \
        -instName $pad \
        -pinName $pin_name \
        -portNum $port_num

    # Verify constraint for bump $bump, show new flight line
    dbGet [dbGet -p top.bumps.name $bump].props.??
    viewBumpConnection -bump $bump; sleep 1

    # Use optional blockage to direct the routing. Useful blocks may include
    #   "960 4670 1480 4730"    "770 4800 1630 4900"    "770 4800 1590 4900"
    if { $blockage != "none" } {
        echo create_route_blockage -layer AP -box $blockage -name temp
        create_route_blockage -layer AP -box $blockage -name temp
        redraw; sleep 1
    }

    # Route the bump, then delete temporary blockage and flightlines
    fcroute_phy manhattan $bump -routeWidth $wire_width
    viewBumpConnection -remove
    if { $blockage != "none" } { deleteRouteBlk -name temp }
}

# set TEST 1; if {$TEST} { bump2stripe ext_Vcm *26.15 }



# Useful tests for proc bump2stripe
if {0} {
    # Cut'n'paste for interactive testing
    deselectAll; select_obj [ get_db markers ]; deleteSelectedFromFPlan
    deselectAll; editSelect -layer AP; deleteSelectedFromFPlan; sleep 1

    unassignBump -byBumpName Bump_653.26.3
    bump2stripe CVDD *26.3
    bump2stripe CVSS *26.4 "770 4800  1590 4900"
}

# Connect bump 'b' to net 'net' via AIO terminal on pad
proc bump2aio { net b args } {
    # Can include an optional blockage box to direct the routing
    # Examples:
    #     bump2aio ext_Vcal *26.16
    #     bump2aio ext_Vcm  *26.15 "770 4800  1590 4900"
    set blockage "none"; if {[llength $args]} { set blockage $args }
    proc get_term_net { inst term } {
        # Find the net attached to the given term on the given inst
        # Example: [get_term_net ANAIOPAD_ext_Vcm AIO]
        set iptr [dbGet -p top.insts.name $inst]; # dbGet $iptr.??
        set tptr [dbGet -p $iptr.instTerms.name *$term]; # dbGet $tptr.??
        dbGet $tptr.net.name
    }
    # Cut'n' paste for interactive test
    set TEST 0; if {$TEST} {
        # Set up to route bumps interactively

        set term AIO; set blockage "2710 4230  2880 4900"
        set net ext_Vcal; set b *26.16; # set bump Bump_666.26.16

        set term AIO; set blockage "none"
        set net ext_Vcm;  set b *26.15; # set bump Bump_665.26.15

        # Delete ALL RDL layer routes
        # deselectAll; editSelect -layer AP; deleteSelectedFromFPlan

        # Remove previous attempt(s) if necessary
        set bump [dbGet top.bumps.name $b]; # this way arg can be wildcard e.g. '*26.15'
        editDelete -net net:pad_frame/$net; # Removes (all) prev routes related to $net
        unassignBump -byBumpName $bump
        detachTerm $pad $term
        get_term_net $pad $term; # Should be null
        deleteNet $net
    }
    # Identify pad, net, terminal, bump
    echo "@file_info b=$b net=$net blockage=$blockage"
    set bump [dbGet top.bumps.name $b]; # this way arg can be wildcard e.g. '*26.15'
    set pad ANAIOPAD_$net; set term AIO
    echo "@file_info b=$bump pad=$pad terminal=$term"

    # Build the new net
    set n [dbGet top.nets.name $net]
    if {$n == 0} {
        # deleteNet $net
        echo $net
        # back and forth, back and forth...!!!
        # addNet $net -power -physical; # ? this one? or...? Yes, seems to be this one
        addNet $net; # I mean...it's a power net but not a power net?
    }
    dbGet [dbGet -p top.nets.name $net].isPwrOrGnd


    # Attach net to appropriate terminal on pad
    get_term_net $pad $term; # First time should be null (unassigned)
    attachTerm $pad $term $net
    get_term_net $pad $term; # Should be $net now

    # FIXME Could do a check here but we don't :(
    # Assert {[get_term_net $pad $term] == $net}

    # Assign bump to net---try signal first
    # assignSigToBump -bumps $bump -net $net; 
    # **ERROR: (IMPSIP-7356): Signal net 'ext_Vcm' is dangling.
    # NOPE breaks if use signal

    # Assign bump to net as power bump
    assignPGBumps -nets $net -bumps $bump
    # **WARN: (IMPDB-1291):   Top cell power port 'ext_Vcm' is connected to a non-power net 'ext_Vcm'.  The type of this net will be changed to POWER net.
    # **WARN: (IMPSYC-1265):  FTerm was not found for net 'ext_Vcm'. 'ext_Vcm' has been created.
    # **WARN: (IMPSIP-7355):  PG net 'ext_Vcm' is dangling.
    viewBumpConnection -bump $bump; # See if we got a good flight line
    redraw; sleep 1; # So flight line will show up during script execution

    # Use optional blockage to direct the routing. Useful blocks may include
    #   "960 4670 1480 4730"    "770 4800 1630 4900"    "770 4800 1590 4900"
    if { $blockage != "none" } {
        echo create_route_blockage -layer AP -box $blockage -name temp
        create_route_blockage -layer AP -box $blockage -name temp
        redraw; sleep 1
    }
    echo FOOOO $bump

    # Route the bump, then delete temporary blockage and flightlines
    fcroute_phy manhattan $bump -routeWidth 20.0
    viewBumpConnection -remove
    if { $blockage != "none" } { deleteRouteBlk -name temp }
}