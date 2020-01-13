#=========================================================================
# floorplan.tcl
#=========================================================================
# This script is called from the Innovus init flow step.
#
# Author : Christopher Torng
# Date   : March 26, 2018
set core_width $::env(core_width)
set core_height $::env(core_height)

floorPlan -s $core_width $core_height \
             $core_margin_l $core_margin_b $core_margin_r $core_margin_t
#floorPlan -r $core_aspect_ratio $core_density_target \
#             $core_margin_l $core_margin_b $core_margin_r $core_margin_t

setFlipping s

# Use automatic floorplan synthesis to pack macros (e.g., SRAMs) together

planDesign

# Take all ports and split into halves

set all_ports       [dbGet top.terms.name -v *clk*]

set num_ports       [llength $all_ports]
set half_ports_idx  [expr $num_ports / 2]

set pins_left_half  [lrange $all_ports 0               [expr $half_ports_idx - 1]]
set pins_right_half [lrange $all_ports $half_ports_idx [expr $num_ports - 1]     ]

# Take all clock ports and place them center-left

set clock_ports     [dbGet top.terms.name *clk*]
set half_left_idx   [expr [llength $pins_left_half] / 2]

if { $clock_ports != 0 } {
  for {set i 0} {$i < [llength $clock_ports]} {incr i} {
    set pins_left_half \
      [linsert $pins_left_half $half_left_idx [lindex $clock_ports $i]]
  }
}

set tiles [get_cells *glb_tile*]
set tile_width [dbGet [dbGet -p top.insts.name *glb_tile* -i 0].cell.size_x]
set tile_start_y 20
set tile_start_x 20

set ports_layer M4
set y_loc $tile_start_y
set x_loc $tile_start_x
foreach_in_collection tile $tiles {
  set tile_name [get_property $tile full_name]
  placeInstance $tile_name $x_loc $y_loc -fixed
  createRouteBlk -inst $tile_name -cover -layer 8 -pgnetonly
  set x_loc [expr $x_loc + $tile_width]
}

editPin -layer $ports_layer -pin $pins_left_half  -side LEFT  -spreadType SIDE
editPin -layer $ports_layer -pin $pins_right_half -side RIGHT -spreadType SIDE

#source $vars(plug_dir)/tile_io_place.tcl
#set ns_io_offset [expr ($core_width - $ns_io_width) / 2] 
#set ew_io_offset [expr ($core_height - $ew_io_width) / 2]
#place_ios $width $height $ns_io_offset $ew_io_offset
