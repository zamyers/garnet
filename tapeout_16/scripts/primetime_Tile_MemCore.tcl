# INFO: You may need to `limit stacksize unlimited` for the top-level
# Garnet to work correctly.
# TODO: update this path
set BASE /aha/thofstee/asplos2020/
set TOP_VCD $BASE/results/VCD_OUT
# set LOCAL_APP $::env(CGRA_APPLICATION)
# set LOCAL_APP "100000_conv_3_3"
set LOCAL_APP "test"
# TODO: change this
source -echo -verbose $BASE/results/scripts/tsmc16_setup.tcl
set report_dir "./reports/${LOCAL_APP}"
# set design_name "Tile_MemCore"
# set saif_file "~/xrun_Tile_MemCore.saif"
set design_name "Garnet"
# set design_name "GarnetSOC_pad_frame"
# set dut "Tile_MemCore"
# set dut "Garnet"
set FILES_TOP $BASE/results/KATHLEEN_netlists
#########################################################
lappend search_path . ..
set power_enable_analysis true
set power_analysis_mode averaged
# set power_analysis_mode time_based
# set power_clock_network_include_clock_gating_network true
# set power_clock_network_include_register_clock_pin_power true
# set power_enable_multi_rail_analysis true
# set power_limit_extrapolation_range true
#########################################################
# Define variables and setup libraries          #
#########################################################
# read_verilog $FILES_TOP/flow-pnr-Tile_PE.v
# read_verilog $FILES_TOP/flow-pnr-Tile_MemCore.v
read_verilog $FILES_TOP/renamed-flow-pnr-Tile_PE.v
read_verilog $FILES_TOP/renamed-flow-pnr-Tile_MemCore.v
read_verilog $FILES_TOP/flow-syn-Garnet.v
# Max's custom tiles with adjustments to clock-gated registers
# read_verilog $FILES_TOP/pnr_netlist_Tile_MemCore.v
# read_verilog $FILES_TOP/pnr_netlist_Tile_PE.v
# read_verilog /home/ankitan/garnet/tapeout_16/synth_08_24_power/Tile_PE/pnr.v
# read_verilog /home/ankitan/garnet/tapeout_16/synth_08_24_power/Tile_MemCore/pnr.v
# read_verilog $FILES_TOP/old/Tile_PE_syn.v
# read_verilog $FILES_TOP/old/Tile_MemCore_syn.v
# read_verilog $FILES_TOP/old/GarnetSOC_pad_frame_syn_v2.v
#########################################################
# Read in design                    #
#########################################################
# set link_create_black_boxes false
# list_designs
# exit
current_design $design_name
set LINK_STATUS [link_design]
if {$LINK_STATUS == 0} {
  echo [concat [format "%s%s" [join [concat "Err" "or"] ""] {: unresolved references. Exiting ...}]]
  quit
}
#########################################################
# Constraints                                          #
#########################################################
# Tile
# create_clock -name clk -period 2.3 -waveform {0 1.15} [get_ports clk]
# Garnet
create_clock -name clk -period 2.3 -waveform {0 1.15} [get_ports clk_in]
# GarnetSOC_Pad_Frame
# create_clock -name clk -period 2.3 -waveform {0 1.15} [get_ports pad_cgra_clk_i]
set_input_delay 0.0 -clock clk [all_inputs]
set_output_delay 0.0 -clock clk [all_outputs]
set_input_delay -min 0.0 -clock clk [all_inputs]
set_output_delay -min 0.0 -clock clk [all_outputs]
#########################################################
# Read VCD                                              #
#########################################################
while {[get_license {"PrimeTime-PX"}] == 0} {
  echo {Waiting for PrimeTime-PX license...}
  sh sleep 120
}
puts "LICENSE ACQUIRED"
# read_sdc ../KATHLEEN_netlists/flow-syn_out-Garnet.sdc
# asdfasdf
# source "/aha/thofstee/asplos2020/results/power/top.sdc"
# if {[read_sdc "/aha/thofstee/asplos2020/results/power/top.sdc"] == 0} {
# error_info
# }
# Ignore all paths through tiles
# TODO: fix this to be a more reasonable constraint
# foreach in collection x [get_cells {Interconnect*/*PE* Interconnect*/Mem*}] {
#   set cn [get_attribute $x full_name]
#   set_disable_timing -from "$cn/*SB_IN*" -to "$cn/*SB_OUT*" $cn
# }
# foreach_in_collection x [get_cells {*/*PE* */*Mem*}] {
# get_attribute $x full_name
# }
# foreach_in_collection x [get_cells {*X1E_Y01*/*PE*}] {
# set cn [get_attribute $x full_name]
# puts [get_pins "$cn/*SB_IN*"]
# # puts $cn
# }
proc format_float {number {format_str "%.2f"}} {
    switch -exact -- $number {
        UNINIT { }
        INFINITY { }
        default {set number [format $format_str $number]}
    }
    return $number;
}
proc show_arcs {args} {
    set arcs [eval [concat get_timing_arcs $args]]
    echo [format "%15s      %-15s" "from_pin" "to_pin"]
    echo [format "%15s      %-15s" "--------" "------" \
              "----" "----" "----------"]
    # echo [format "%15s      %-15s   %8s %8s   %s" "from_pin" "to_pin" \
    #           "rise" "fall" "is_cellarc"]
    # echo [format "%15s      %-15s   %8s %8s   %s" "--------" "------" \
    #           "----" "----" "----------"]
    foreach_in_collection arc $arcs {
        set fpin [get_attribute $arc from_pin]
        set tpin [get_attribute $arc to_pin]
        # set is_cellarc [get_attribute $arc is_cellarc]
        # set rise [get_attribute $arc delay_max_rise]
        # set fall [get_attribute $arc delay_max_fall]
        set from_pin_name [get_attribute $fpin full_name]
        set to_pin_name [get_attribute $tpin full_name]
        echo [format "%15s -> %-15s" \
                  $from_pin_name $to_pin_name]
        # echo [format "%15s -> %-15s   %8s %8s   %s" \
        #           $from_pin_name $to_pin_name \
        #           [format_float $rise] [format_float $fall] \
        #           $is_cellarc]
    }
}
# Fatal: An exceptionally long combinational path with greater than 50,000 pins through 'Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139138/A1' is encountered. PrimeTime will exit its current session.  (PTE-097)
asdfasdfasdfas
# foreach_in_collection tile [get_cells -hierarchical {*Tile*}] {
#     set tile_id [get_attribute $tile full_name]
#     puts $tile_id
#     # Only one of PE or Mem will ever match so suppress the warnings.
#     suppress_message SEL-004
#     set ports_i [get_pins "$tile_id/*PE*/*SB_IN* $tile_id/*Mem*/*SB_IN*"]
#     set ports_o [get_pins "$tile_id/*PE*/*SB_OUT* $tile_id/*Mem*/*SB_OUT*"]
#     unsuppress_message SEL-004
#     # TODO: This doesn't work for whatever reason, always blank.
#     # set arcs [get_timing_arcs -from $ports_i -to $ports_o]
#     # puts $arcs
#     # HACK: disable everything
#     set_disable_timing [get_timing_arcs -from $ports_i]
#     set_disable_timing [get_timing_arcs -to $ports_o]
#     # set_disable_timing $ports_i
#     # set_disable_timing $ports_o
# }
# set tile_id [get_attribute [get_cells -hierarchical *Tile_X1C_Y08*] full_name]
### Option 2 (does not work) ###
# Fatal: An exceptionally long combinational path with greater than
# 50,000 pins through
# 'Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139138/A1'
# is encountered. PrimeTime will exit its current session.  (PTE-097)
# Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139138/A1 -> Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139138/ZN
# Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139138/A1 -> Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139138/ZN
# Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139138/A1 -> Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139138/ZN
# Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139321/ZN -> Interconnect_inst0_Tile_X1C_Y08/PE_inst0_WrappedPE_inst0_PE_inst0/g139138/A1
foreach_in_collection tile [get_cells -hierarchical {*Tile*}] {
    set tile_id [get_attribute $tile full_name]
    puts $tile_id
    # we're going to just work within a tile
    current_instance $tile_id
    set ports_i [get_pins -hierarchical *SB_IN*]
    set ports_o [get_pins -hierarchical *SB_OUT*]
    set arcs [get_timing_arcs -from $ports_i -to $ports_o]
    echo [sizeof_collection $arcs]
    set_disable_timing $arcs
    # set instance back to top-level
    suppress_message DES-070
    current_instance
    unsuppress_message DES-070
}
###
### Option 3 (reports power) ###
# HACK: nuclear option
set_disable_timing [get_cells -hierarchical]
set_disable_timing [get_pins -hierarchical]
set_disable_timing [get_ports]
###
#########################################################
# Iterate over switching activity files to generate     #
# average or time based power reports per diag          #
#########################################################
# update_timing -full
# source $FILES_TOP/converted_flow-pnr-${design_name}.namemap
source $FILES_TOP/converted_random-${design_name}.namemap
# asdfasdfsadf
# weoisoidafsoidf
# current_instance "/"
# source $FILES_TOP/converted_GarnetSOC_pad_frame_v2.namemap
# current_design $dut
# read_saif ${saif_file} -strip_path ${design_name}
# Tile_PE
# Tile_MemCore
# read_vcd -rtl ~/conv_3_3-2p3ns.vcd -strip_path Garnet_TB/DUT/Interconnect_inst0/Tile_X0B_Y07 -time {10087.8 19568.4}
# Garnet
read_vcd -rtl ~/conv_3_3-2p3ns.vcd -strip_path Garnet_TB/DUT -time {10087.8 19568.4}
# read_saif /aha/empty_Tile_PE.saif
# set_switching_activity -toggle_rate 0 -static_probability 0 -base_clock clk -type non_clock_network [all_inputs]
# set_switching_activity -toggle_rate 0 -static_probability 0 -base_clock clk [remove_from_collection [all_inputs] clk]
# set_switching_activity -toggle_rate 0 -static_probability 0 -base_clock clk -type non_clock_network -hierarchy
# current_instance "core_cgra_subsystem"
# read_saif ${TOP_VCD}/${LOCAL_APP}.saif -strip_path "Garnet_tb/dut"
# current_instance "/"
# read_saif ${TOP_VCD}/${LOCAL_APP}.saif -strip_path "Garnet_tb/dut" -path "core_cgra_subsystem"
# read_saif ${TOP_VCD}/${LOCAL_APP}.saif -strip_path "Garnet_TB/DUT"
# read_saif ${TOP_VCD}/${LOCAL_APP}.saif -strip_path "Garnet_TB/DUT" -path "core/cgra_subsystem"
# read_saif ${TOP_VCD}/${LOCAL_APP}.saif -strip_path "Garnet_TB/DUT" -path "GarnetSOC_pad_frame/core_cgra_subsystem"
# read_saif ${TOP_VCD}/${LOCAL_APP}.saif -strip_path "Garnet_TB/DUT/GlobalBuffer_32_8_8_17_32_32_32_12_inst0" -path "core_cgra_subsystem/GlobalBuffer_inst0"
# write_saif "test.saif"
report_switching_activity
report_switching_activity > "switching_activity.rpt"
report_power
report_power > "power.rpt"
report_switching_activity
report_switching_activity > "switching_activity2.rpt"
report_power -nosplit -hierarchy -leaf > "$report_dir/${LOCAL_APP}_hierarchy.rpt"
# report_power -nosplit > "$report_dir/${LOCAL_APP}_TOP.rpt"
# report_power -nosplit -hierarchy > "$report_dir/${LOCAL_APP}_hierarchy.rpt"
# report_power -nosplit -hierarchy -levels 50 > "$report_dir/${LOCAL_APP}_hierarchy_DEEP.rpt"
# report_power -nosplit -hierarchy -levels 2 > "$report_dir/${LOCAL_APP}_hierarchy_TILES.rpt"
#report_power -nosplit -cell_power [get_cells -hierarchical {*Tile_MemCore*}] > "$report_dir/${LOCAL_APP}_MEMTILE.rpt"
#report_power -nosplit -cell_power [get_cells -hierarchical {*Tile_PE*}] > "$report_dir/${LOCAL_APP}_PETILE.rpt"
#report_power -nosplit -cell_power [get_cells -hierarchical {*cb* *sb*}] > "$report_dir/${LOCAL_APP}_INTERCONNECT.rpt"
exit
