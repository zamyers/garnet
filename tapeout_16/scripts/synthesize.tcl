puts "Starting Genus Synthesis"

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

read_hdl -sv [glob -directory ../../genesis_verif -type f *.v *.sv]
elaborate $::env(DESIGN)
uniquify $::env(DESIGN)

if $::env(PWR_AWARE) {
    read_power_intent -1801 ../../scripts/upf.port.fix.tcl -module $::env(DESIGN)
    apply_power_intent -design $::env(DESIGN) -module $::env(DESIGN)
    commit_power_intent -design $::env(DESIGN)
    write_power_intent -1801 -design $::env(DESIGN)
}

set_attribute avoid true [get_lib_cells {*/E* */G* *D16* *D20* *D24* *D28* *D32* SDF* *DFM*}]

if $::env(PWR_AWARE) {
    create_base_cell_set -name avoid -base_cells [get_lib_cells {*IAO21* *IAO22* *IAOI21* *IOAI21* *IIND* *IINR* *IND* *INR* }]
    set_attribute dont_use_base_cell_set avoid [find / -inst *u_mux_logic*]
    set_dont_touch [find [find / -inst *u_mux_logic*] -net *I*]
}

regsub {_unq\d*} $::env(DESIGN) {} base_design
source -verbose "../../scripts/constraints_${base_design}.tcl"
set_load 0.0025 [all_outputs]
set_driving_cell -lib_cell INVD4BWP16P90 -from_pin I -pin ZN -input_transition_rise 0.2 -input_transition_fall 0.2 [all_inputs] 
set_path_adjust -0.4 -from [get_clocks clk] -to [get_clocks clk]
#set_attr auto_ungroup none
syn_gen
set_attr syn_map_effort high
syn_map
syn_opt 

write_snapshot -directory results_syn -tag final
write_design -innovus -basename results_syn/syn_out
exit