#=========================================================================
# Design Constraints File
#=========================================================================

# This constraint sets the target clock period for the chip in
# nanoseconds. Note that the first parameter is the name of the clock
# signal in your verlog design. If you called it something different than
# clk you will need to change this. You should set this constraint
# carefully. If the period is unrealistically small then the tools will
# spend forever trying to meet timing and ultimately fail. If the period
# is too large the tools will have no trouble but you will get a very
# conservative implementation.

set clock_net  clk
set clock_name ideal_clock

create_clock -name ${clock_name} \
             -period ${dc_clock_period} \
             [get_ports ${clock_net}]

set pt_clock_net  clk_pass_through
set pt_clock_name ideal_clock_pt

create_clock -name ${pt_clock_name} \
             -period ${dc_clock_period} \
             [get_ports ${pt_clock_net}]

create_generated_clock -name clk_out \
                       -source [get_ports ${pt_clock_net}] \
                       -multiply_by 1 \
                       [get_ports clk_out]

create_generated_clock -name pt_clk_out \
                       -source [get_ports ${pt_clock_net}] \
                       -multiply_by 1 \
                       [get_ports clk_pass_through_out]

# This constraint sets the load capacitance in picofarads of the
# output pins of your design.

set_load -pin_load $ADK_TYPICAL_ON_CHIP_LOAD [all_outputs]

# This constraint sets the input drive strength of the input pins of
# your design. We specifiy a specific standard cell which models what
# would be driving the inputs. This should usually be a small inverter
# which is reasonable if another block of on-chip logic is driving
# your inputs.

#set_driving_cell -no_design_rule \
  -lib_cell $ADK_DRIVING_CELL [all_inputs]

# set_input_delay constraints for input ports
#
# - make this non-zero to avoid hold buffers on input-registered designs
set input_delay [expr ${dc_clock_period}/2.0]
set_input_delay -clock ${clock_name} $input_delay [all_inputs]

# set_output_delay constraints for output ports
set output_delay 0
set_output_delay -clock ${clock_name} $output_delay [all_outputs]

# Make all signals limit their fanout

set_max_fanout 20 $dc_design_name

# Make all signals meet good slew
set max_trans_time 0.1
set_max_transition $max_trans_time $dc_design_name
set_input_transition $max_trans_time [all_inputs]

# Set min/max delay for feedthrough signals
set pass_through_inputs [get_ports {config_config* config_read* config_write* reset stall}]
set pass_through_outputs [get_ports {config_out* stall_out* reset_out*}]
set pass_through_clock_inputs [get_ports clk_pass_through]
set pass_through_clock_outputs [get_ports {clk_out clk_pass_through_out}]

reset_path -from $pass_through_inputs -to $pass_through_outputs

set pass_through_max_delay 0.17
set_max_delay -from $pass_through_inputs -to $pass_through_outputs [expr $pass_through_max_delay + $input_delay + $output_delay]
set_max_delay -from $pass_through_clock_inputs -to $pass_through_clock_outputs [expr $pass_through_max_delay + $input_delay + $output_delay]
set pass_through_min_delay 0.1
set_min_delay -from $pass_through_inputs -to $pass_through_outputs [expr $pass_through_min_delay + $input_delay + $output_delay]
set_min_delay -from $pass_through_clock_inputs -to $pass_through_clock_outputs [expr $pass_through_min_delay]

if $::env(PWR_AWARE) {
    source inputs/dc-dont-use-constraints.tcl
    source inputs/pe-constraints.tcl
    set_dont_touch [get_cells -hierarchical *u_mux_logic*]
} 
