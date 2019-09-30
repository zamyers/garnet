puts "Starting Genus Synthesis"

set_attr lp_insert_clock_gating true /
set_attr library [list \
/tsmc16/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn16ffcllbwp16p90_100a/tcbn16ffcllbwp16p90ssgnp0p72vm40c.lib \
/tsmc16/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tphn16ffcllgv18e_110c/tphn16ffcllgv18essgnp0p72v1p62vm40c.lib \
/tsmc16/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn16ffcllbwp16p90pm_100a/tcbn16ffcllbwp16p90pmssgnp0p72vm40c.lib \
/sim/ajcars/mc/ts1n16ffcllsblvtc512x16m8s_130a/NLDM/ts1n16ffcllsblvtc512x16m8s_130a_ssgnp0p72vm40c.lib \
/sim/ajcars/mc/ts1n16ffcllsblvtc256x32m4sw_130a/NLDM/ts1n16ffcllsblvtc256x32m4sw_130a_ssgnp0p72vm40c.lib \
/sim/ajcars/mc/ts1n16ffcllsblvtc256x32m8sw_130a/NLDM/ts1n16ffcllsblvtc256x32m8sw_130a_ssgnp0p72vm40c.lib \
/sim/ajcars/mc/ts1n16ffcllsblvtc2048x32m8sw_130a/NLDM/ts1n16ffcllsblvtc2048x32m8sw_130a_ssgnp0p72vm40c.lib \
/sim/ajcars/mc/ts1n16ffcllsblvtc2048x64m8sw_130a/NLDM/ts1n16ffcllsblvtc2048x64m8sw_130a_ssgnp0p72vm40c.lib \
] 

set_attr lef_library [list \
/tsmc16/download/TECH16FFC/N16FF_PRTF_Cad_1.2a/PR_tech/Cadence/LefHeader/Standard/VHV/N16_Encounter_9M_2Xa1Xd3Xe2Z_UTRDL_9T_PODE_1.2a.tlef \
/tsmc16/TSMCHOME/digital/Back_End/lef/tcbn16ffcllbwp16p90_100a/lef/tcbn16ffcllbwp16p90.lef \
/tsmc16/TSMCHOME/digital/Back_End/lef/tcbn16ffcllbwp16p90pm_100a/lef/tcbn16ffcllbwp16p90pm.lef \
/tsmc16/TSMCHOME/digital/Back_End/lef/tpbn16v_090a/fc/fc_lf_bu/APRDL/lef/tpbn16v.lef \
/tsmc16/TSMCHOME/digital/Back_End/lef/tphn16ffcllgv18e_110e/mt_1/9m/9M_2XA1XD_H_3XE_VHV_2Z/lef/tphn16ffcllgv18e_9lm.lef \
/tsmc16/pdk/2016.09.15_MOSIS/FFC/T-N16-CL-DR-032/N16_DTCD_library_kit_20160111/N16_DTCD_library_kit_20160111/lef/topMxyMxe_M9/N16_DTCD_v1d0a.lef \
/sim/ajcars/mc/ts1n16ffcllsblvtc512x16m8s_130a/LEF/ts1n16ffcllsblvtc512x16m8s_130a_m4xdh.lef \
/sim/ajcars/mc/ts1n16ffcllsblvtc256x32m4sw_130a/LEF/ts1n16ffcllsblvtc256x32m4sw_130a_m4xdh.lef \
/sim/ajcars/mc/ts1n16ffcllsblvtc256x32m8sw_130a/LEF/ts1n16ffcllsblvtc256x32m8sw_130a_m4xdh.lef \
/sim/ajcars/mc/ts1n16ffcllsblvtc2048x32m8sw_130a/LEF/ts1n16ffcllsblvtc2048x32m8sw_130a_m4xdh.lef \
/sim/ajcars/mc/ts1n16ffcllsblvtc2048x64m8sw_130a/LEF/ts1n16ffcllsblvtc2048x64m8sw_130a_m4xdh.lef \
/tsmc16/pdk/2016.09.15_MOSIS/FFC/T-N16-CL-DR-032/N16_ICOVL_library_kit_FF+_20150528/N16_ICOVL_library_kit_FF+_20150528/lef/topMxMxaMxc_M9/N16_ICOVL_v1d0a.lef]

set_attr qrc_tech_file [list /tsmc16/download/TECH16FFC/cworst/Tech/cworst_CCworst_T/qrcTechFile]

#read_hdl -sv [glob -directory ../../genesis_verif -type f *.v *.sv]
if {$::env(DESIGN) eq "Tile_PE"} {
  read_hdl -mixvlog ../PE/rtl_syn.v
}
read_hdl -sv [glob -directory ../../genesis_verif -type f *.v *.sv]
elaborate $::env(DESIGN)
uniquify $::env(DESIGN)

if $::env(PWR_AWARE) {
    read_power_intent -1801 ../../scripts/upf_$::env(DESIGN).tcl -module $::env(DESIGN)
    apply_power_intent -design $::env(DESIGN) -module $::env(DESIGN)
    commit_power_intent -design $::env(DESIGN)
    write_power_intent -1801 -design $::env(DESIGN)
    source -verbose ../../scripts/upf_constraints_$::env(DESIGN).tcl
}

set_attribute avoid true [get_lib_cells {*/E* */G* *D16* *D20* *D24* *D28* *D32* SDF* *DFM*}]
# don't use Scan enable D flip flops
set_attribute avoid true [get_lib_cells {*SEDF*}]

regsub {_unq\d*} $::env(DESIGN) {} base_design
set_load 0.0025 [all_outputs]
set_max_transition 0.1
set_driving_cell -lib_cell INVD4BWP16P90 -from_pin I -pin ZN -input_transition_rise 0.14 -input_transition_fall 0.14 [all_inputs] 
source -verbose "../../scripts/constraints_${base_design}.tcl"
set_path_adjust -0.4 -from [get_clocks clk] -to [get_clocks clk]
#set_attr auto_ungroup none
syn_gen
set_attr syn_map_effort high
syn_map
syn_opt 

#redirect syn.area {report_area}
redirect syn.area {report_area -depth 4 -detail}
#redirect syn.area2 {report_area -detail -show_leaf_cells -depth 10}

write_snapshot -directory results_syn -tag final
write_design -innovus -basename results_syn/syn_out

#set values {conv_3_3a conv_3_3b harrisa harrisb harrisc avg_poola avg_poolb avg_poolc avg_poold upsample strided_conva strided_convb strided_convc strided_convd strided_conve strided_convf unet_examplea unet_exampleb unet_examplec unet_exampled unet_examplee unet_examplef}
set values {conv_3_3a}
foreach v $values {
    read_saif ../../activity_files/${v}.saif
    report_power -depth 3 -full_instance_names Tile_MemCore > ${v}.power
}

#foreach v $values {
#    read_saif -update -instance Tile_MemCore ../../activity_files/${v}.saif
#}
#report_power -depth 3 -full_instance_names Tile_MemCore > average.power

#report_power -depth 10 -full_instance_names Tile_MemCore/MemCore_inst0/memory_core_inst0/doublebuffer_control > syn.power1
#report_power -hier -depth 10 -full_instance_names -detail > syn.power1


exit
