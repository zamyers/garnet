create_clock -name clk -period 2.2 [get_ports clk*]
set_input_delay -max 0.2 -clock clk [all_inputs]
set_output_delay -max 0.2 -clock clk [all_outputs]
set_input_delay -min 0 -clock clk [all_inputs]
set_output_delay -min 0 -clock clk [all_outputs]

set_input_transition 0.2 [all_inputs]

set_false_path -through [get_ports {config* tile_id* reset}]  -to [all_outputs]

set_attribute ungroup_ok false [get_cells *]
set_attribute ungroup_ok true [get_cells -hier PE_inst0]