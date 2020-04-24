#=========================================================================
# add-endcaps-welltaps.tcl
#=========================================================================
# Author : 
# Date   : 

#-------------------------------------------------------------------------
# Endcap and well tap specification
#-------------------------------------------------------------------------
# TSMC16 requires specification of different taps/caps for different
# locations/orientations, which the foundation flow does not natively support

if {[expr {$ADK_END_CAP_CELL == ""} && {$ADK_WELL_TAP_CELL == ""}]} {
 if {$::env(PWR_AWARE)} {
    
    source /home/ankitan/params.tcl
    deleteInst *TAP*
    deleteInst *ENDCAP*
    deleteInst *tap* 
    #TODO: check cell types
    addInst -cell BOUNDARY_NTAPBWP16P90_VPP_VSS -inst top_endcap_tap_1
    addInst -cell BOUNDARY_NTAPBWP16P90_VPP_VSS -inst top_endcap_tap_2
    addInst -cell BOUNDARY_NTAPBWP16P90_VPP_VSS -inst top_endcap_tap_3
    
    set edge_offset 12.91
    placeInstance top_endcap_tap_1 -fixed [expr $edge_offset + 0*28      ] 84.864
    placeInstance top_endcap_tap_2 -fixed [expr $edge_offset + 1*28 + 1.4] 84.864
    placeInstance top_endcap_tap_3 -fixed [expr $edge_offset + 2*28 + 1.4] 84.864 
    
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst bot_endcap_tap_1
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst bot_endcap_tap_2
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst bot_endcap_tap_3
    
    placeInstance bot_endcap_tap_1 -fixed [expr $edge_offset + 0*28      ] $polypitch_y 
    placeInstance bot_endcap_tap_2 -fixed [expr $edge_offset + 1*28 + 1.4] $polypitch_y 
    placeInstance bot_endcap_tap_3 -fixed [expr $edge_offset + 2*28 + 1.4] $polypitch_y 

    #For memory tile
    addInst -cell BOUNDARY_NTAPBWP16P90_VPP_VSS -inst top_endcap_tap_4
    addInst -cell BOUNDARY_NTAPBWP16P90_VPP_VSS -inst top_endcap_tap_5
    #addInst -cell BOUNDARY_NTAPBWP16P90_VPP_VSS -inst top_endcap_tap_3
    
    placeInstance top_endcap_tap_4 -fixed [expr $edge_offset + 3*28 + 1.4] 84.864
    placeInstance top_endcap_tap_5 -fixed [expr $edge_offset + 4*28 + 1.4] 84.864

    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst bot_endcap_tap_4
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst bot_endcap_tap_5
    #addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst bot_endcap_tap_3

    placeInstance bot_endcap_tap_4 -fixed [expr $edge_offset + 3*28 + 1.4] $polypitch_y
    placeInstance bot_endcap_tap_5 -fixed [expr $edge_offset + 4*28 + 1.4] $polypitch_y
    #placeInstance bot_endcap_tap_3 -fixed [expr $edge_offset + 56 + 1.4] $polypitch_y
  
    adk_add_endcap_well_taps_sd_pwr_domains
    adk_add_end_caps
    #adk_add_well_taps
    adk_add_endcap_well_taps_aon_pwr_domains  
    #------------------------------------------------------------------------
    # Add power switches for power aware flow
    # ------------------------------------------------------------------------
    source /home/ankitan/params.tcl
    #set left_offset 10.51
    #set horiz_pitch [expr 224 * $polypitch_x]
    #set horiz_pitch [expr 224 * $polypitch_x]
    #set horiz_pitch [expr 180 * $polypitch_x]
    #set horiz_pitch [expr 300 * $polypitch_x]
    
    ## PE TILE SETUP ####
    #set horiz_pitch [expr 260 * $polypitch_x]
    #set left_offset 8
    
    # MEM TILE SETUP ####
    # orig: 420/444
    set horiz_pitch [expr 420 * $polypitch_x] 
    # orig: 8/16
    set left_offset 20 
 
    set switch_name "HDR10XSICWDPDTD1BWP16P90"
    addPowerSwitch -column -powerDomain TOP \
         -leftOffset $left_offset            \
         -horizontalPitch $horiz_pitch       \
         -checkerBoard                       \
         -loopBackAtEnd                      \
         -enableNetOut PSenableNetOut        \
         -noFixedStdCellOverlap              \
         -globalSwitchCellName $switch_name
    globalNetConnect VDD -type pgpin -pin TVDD -inst *HDR*
} else {
  adk_set_end_cap_mode
  adk_set_well_tap_mode
  adk_add_end_caps
  adk_add_well_taps
}
}

