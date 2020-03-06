for {set x 0} {$x < ${array_width}} {incr x} {
  set pin_name Tile_X0${x}_Y01/clk
  set_ccopt_property -pin $pin_name sink_type stop
  set_ccopt_property -pin ${pin_name}_pass_through sink_type stop
}
