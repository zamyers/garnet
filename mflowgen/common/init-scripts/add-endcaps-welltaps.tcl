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
    adk_set_end_cap_mode_pwr_domains
    
    # Manaully add boundary taps
    # TODO(ankita): clean up
    source inputs/adk/params.tcl
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst top_endcap_tap_1
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst top_endcap_tap_2
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst top_endcap_tap_3
    set num_polypitch_x 112
    set edge_offset 2.2
    placeInstance top_endcap_tap_1 -fixed [expr $edge_offset + 1*$num_polypitch_x * $polypitch_x]  [expr $savedvars(height) - 2*$polypitch_y]
    placeInstance top_endcap_tap_2 -fixed [expr $edge_offset + 3*$num_polypitch_x * $polypitch_x]  [expr $savedvars(height) - 2*$polypitch_y]
    placeInstance top_endcap_tap_3 -fixed [expr $edge_offset + 5*$num_polypitch_x * $polypitch_x]  [expr $savedvars(height) - 2*$polypitch_y]
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst bot_endcap_tap_1
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst bot_endcap_tap_2
    addInst -cell BOUNDARY_PTAPBWP16P90_VPP_VSS -inst bot_endcap_tap_3
    placeInstance bot_endcap_tap_1 -fixed [expr $edge_offset + 1*$num_polypitch_x * $polypitch_x]  $polypitch_y
    placeInstance bot_endcap_tap_2 -fixed [expr $edge_offset + 3*$num_polypitch_x * $polypitch_x]  $polypitch_y
    placeInstance bot_endcap_tap_3 -fixed [expr $edge_offset + 5*$num_polypitch_x * $polypitch_x]  $polypitch_y
  } else {
    adk_set_end_cap_mode
    adk_set_well_tap_mode
    adk_add_well_taps
  }
  adk_add_end_caps
}

