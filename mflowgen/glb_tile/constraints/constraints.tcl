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

# This constraint sets the load capacitance in picofarads of the
# output pins of your design.

set_load -pin_load $ADK_TYPICAL_ON_CHIP_LOAD [all_outputs]

# This constraint sets the input drive strength of the input pins of
# your design. We specifiy a specific standard cell which models what
# would be driving the inputs. This should usually be a small inverter
# which is reasonable if another block of on-chip logic is driving
# your inputs.

set_driving_cell -no_design_rule \
  -lib_cell $ADK_DRIVING_CELL [all_inputs]

# set_input_delay and output_delay
##########################
# default
##########################
# default input delay is 0.2.
set_input_delay -clock ${clock_name} [expr ${dc_clock_period}*0.2] [all_inputs]
# default output delay is 0.2
set_output_delay -clock ${clock_name} [expr ${dc_clock_period}*0.2] [all_outputs]

##########################
# proc packet
##########################
# actual value from report_timing
set_min_delay -from [get_ports proc_*i] [expr ${dc_clock_period}*0.2]
set_min_delay -to [get_ports proc_*o] [expr ${dc_clock_period}*0.2]

# input
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.2] [get_ports proc_*i]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.3] [get_ports proc_*i]

set_min_delay -to [get_ports proc_rd_addr*o] [expr ${dc_clock_period}*0.3]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.2] [get_ports proc_rd_addr*i]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports proc_rd_addr*i]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.35] [get_ports proc_rd_addr*i]

set_min_delay -to [get_ports proc_rd_data_valid*o] [expr ${dc_clock_period}*0.3]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.2] [get_ports proc_rd_data_valid*i]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports proc_rd_data_valid*i]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.35] [get_ports proc_rd_data_valid*i]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.4] [get_ports proc_rd_data_w2e_*i]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.5] [get_ports proc_rd_data_w2e_*i]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.4] [get_ports proc_rd_data_e2w_*i]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.5] [get_ports proc_rd_data_e2w_*i]
# output
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.2] [get_ports proc_*o]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.2] [get_ports proc_*o]


##########################
# configuration interface
##########################
# slave
set_min_delay -to [get_ports if_cfg_est_m_wr_en] [expr ${dc_clock_period}*0.23]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.23] [get_ports if_cfg_wst_s_wr_en]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.23] [get_ports if_cfg_wst_s_wr_en]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.3] [get_ports if_cfg_wst_s_wr_en]

set_min_delay -to [get_ports if_cfg_est_m_wr_clk_en] [expr ${dc_clock_period}*0.12] -fall
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.12] -clock_fall [get_ports if_cfg_wst_s_wr_clk_en]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.12] -clock_fall [get_ports if_cfg_wst_s_wr_clk_en]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.19] -clock_fall [get_ports if_cfg_wst_s_wr_clk_en]

set_min_delay -to [get_ports if_cfg_est_m_wr_addr] [expr ${dc_clock_period}*0.30]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.22] [get_ports if_cfg_wst_s_wr_addr]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports if_cfg_wst_s_wr_addr]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.35] [get_ports if_cfg_wst_s_wr_addr]

set_min_delay -to [get_ports if_cfg_est_m_wr_data] [expr ${dc_clock_period}*0.33]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.2] [get_ports if_cfg_wst_s_wr_data]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.33] [get_ports if_cfg_wst_s_wr_data]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports if_cfg_wst_s_wr_data]

set_min_delay -to [get_ports if_cfg_est_m_rd_en] [expr ${dc_clock_period}*0.33]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.33] [get_ports if_cfg_wst_s_rd_en]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.39] [get_ports if_cfg_wst_s_rd_en]

set_min_delay -to [get_ports if_cfg_est_m_rd_clk_en] [expr ${dc_clock_period}*0.12] -fall
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.09] -clock_fall [get_ports if_cfg_wst_s_rd_clk_en]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.12] -clock_fall [get_ports if_cfg_wst_s_rd_clk_en]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.16] -clock_fall [get_ports if_cfg_wst_s_rd_clk_en]

set_min_delay -to [get_ports if_cfg_est_m_rd_addr] [expr ${dc_clock_period}*0.24]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.18] [get_ports if_cfg_wst_s_rd_addr]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.24] [get_ports if_cfg_wst_s_rd_addr]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.3] [get_ports if_cfg_wst_s_rd_addr]

set_min_delay -from [get_ports if_cfg_est_m_rd_data] [expr ${dc_clock_period}*0.15]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.0] [get_ports if_cfg_wst_s_rd_data]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.15] [get_ports if_cfg_wst_s_rd_data]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.19] [get_ports if_cfg_wst_s_rd_data]

set_min_delay -from [get_ports if_cfg_est_m_rd_data_valid] [expr ${dc_clock_period}*0.15]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.06] [get_ports if_cfg_wst_s_rd_data_valid]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.15] [get_ports if_cfg_wst_s_rd_data_valid]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.2] [get_ports if_cfg_wst_s_rd_data_valid]

# master
set_min_delay -from [get_ports if_cfg_wst_s_wr_en] [expr ${dc_clock_period}*0.35]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.16] [get_ports if_cfg_est_m_wr_en]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.35] [get_ports if_cfg_est_m_wr_en]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.43] [get_ports if_cfg_est_m_wr_en]

set_min_delay -from [get_ports if_cfg_wst_s_wr_clk_en] [expr ${dc_clock_period}*0.3] -fall
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.0] -clock_fall [get_ports if_cfg_est_m_wr_clk_en]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.3] -clock_fall [get_ports if_cfg_est_m_wr_clk_en]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.35] -clock_fall [get_ports if_cfg_est_m_wr_clk_en]

set_min_delay -from [get_ports if_cfg_wst_s_wr_addr] [expr ${dc_clock_period}*0.42]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.38] [get_ports if_cfg_est_m_wr_addr]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.42] [get_ports if_cfg_est_m_wr_addr]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.5] [get_ports if_cfg_est_m_wr_addr]

set_min_delay -from [get_ports if_cfg_wst_s_wr_data] [expr ${dc_clock_period}*0.22]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.0] [get_ports if_cfg_est_m_wr_data]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.22] [get_ports if_cfg_est_m_wr_data]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.27] [get_ports if_cfg_est_m_wr_data]

set_min_delay -from [get_ports if_cfg_wst_s_rd_en] [expr ${dc_clock_period}*0.23]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.13] [get_ports if_cfg_est_m_rd_en]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.23] [get_ports if_cfg_est_m_rd_en]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.3] [get_ports if_cfg_est_m_rd_en]

set_min_delay -from [get_ports if_cfg_wst_s_rd_clk_en] [expr ${dc_clock_period}*0.12] -fall
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.0] -clock_fall [get_ports if_cfg_est_m_rd_clk_en]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.12] -clock_fall [get_ports if_cfg_est_m_rd_clk_en]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.17] -clock_fall [get_ports if_cfg_est_m_rd_clk_en]

set_min_delay -from [get_ports if_cfg_wst_s_rd_addr] [expr ${dc_clock_period}*0.40]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.07] [get_ports if_cfg_est_m_rd_addr]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports if_cfg_est_m_rd_addr]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.48] [get_ports if_cfg_est_m_rd_addr]

set_min_delay -to [get_ports if_cfg_wst_s_rd_data] [expr ${dc_clock_period}*0.25]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.1] [get_ports if_cfg_est_m_rd_data]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.25] [get_ports if_cfg_est_m_rd_data]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.33] [get_ports if_cfg_est_m_rd_data]

set_min_delay -to [get_ports if_cfg_wst_s_rd_data_valid] [expr ${dc_clock_period}*0.30]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.3] [get_ports if_cfg_est_m_rd_data_valid]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports if_cfg_est_m_rd_data_valid]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.33] [get_ports if_cfg_est_m_rd_data_valid]

##########################
# strm interface
##########################

# wr_en
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.20] [get_ports strm_wr_en_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.23] [get_ports strm_wr_en_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.21] [get_ports strm_wr_en_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.25] [get_ports strm_wr_en_w2e_wsti]

set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.02] [get_ports strm_wr_en_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.10] [get_ports strm_wr_en_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.14] [get_ports strm_wr_en_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.23] [get_ports strm_wr_en_w2e_esto]

# wr_strb
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.20] [get_ports strm_wr_strb_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.28] [get_ports strm_wr_strb_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.20] [get_ports strm_wr_strb_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.26] [get_ports strm_wr_strb_w2e_wsti]

set_min_delay -from [get_ports strm_wr_strb_e2w_esti] [expr ${dc_clock_period}*0.24]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.03] [get_ports strm_wr_strb_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.24] [get_ports strm_wr_strb_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.29] [get_ports strm_wr_strb_e2w_wsto]
set_min_delay -from [get_ports strm_wr_strb_w2e_wsti] [expr ${dc_clock_period}*0.32]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.10] [get_ports strm_wr_strb_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.32] [get_ports strm_wr_strb_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.38] [get_ports strm_wr_strb_w2e_esto]

# wr_addr
set_min_delay -to [get_ports strm_wr_addr_e2w_wsto] [expr ${dc_clock_period}*0.40]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.19] [get_ports strm_wr_addr_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports strm_wr_addr_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.45] [get_ports strm_wr_addr_e2w_esti]
set_min_delay -to [get_ports strm_wr_addr_w2e_esto] [expr ${dc_clock_period}*0.22]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.17] [get_ports strm_wr_addr_w2e_wsti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.22] [get_ports strm_wr_addr_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.27] [get_ports strm_wr_addr_w2e_wsti]

set_min_delay -from [get_ports strm_wr_addr_e2w_esti] [expr ${dc_clock_period}*0.25]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.02] [get_ports strm_wr_addr_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.25] [get_ports strm_wr_addr_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.31] [get_ports strm_wr_addr_e2w_wsto]
set_min_delay -from [get_ports strm_wr_addr_w2e_wsti] [expr ${dc_clock_period}*0.35]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.10] [get_ports strm_wr_addr_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.35] [get_ports strm_wr_addr_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.42] [get_ports strm_wr_addr_w2e_esto]

# wr_data
set_min_delay -to [get_ports strm_wr_data_e2w_wsto] [expr ${dc_clock_period}*0.40]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.17] [get_ports strm_wr_data_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports strm_wr_data_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.46] [get_ports strm_wr_data_e2w_esti]
set_min_delay -to [get_ports strm_wr_data_w2e_esto] [expr ${dc_clock_period}*0.24]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.16] [get_ports strm_wr_data_w2e_wsti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.24] [get_ports strm_wr_data_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports strm_wr_data_w2e_wsti]

set_min_delay -from [get_ports strm_wr_data_e2w_esti] [expr ${dc_clock_period}*0.18]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.06] [get_ports strm_wr_data_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.18] [get_ports strm_wr_data_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.24] [get_ports strm_wr_data_e2w_wsto]
set_min_delay -from [get_ports strm_wr_data_w2e_wsti] [expr ${dc_clock_period}*0.25]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.08] [get_ports strm_wr_data_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.25] [get_ports strm_wr_data_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.33] [get_ports strm_wr_data_w2e_esto]

# rd_en
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.24] [get_ports strm_rd_en_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.27] [get_ports strm_rd_en_e2w_esti]
set_max_delay -to [get_ports strm_rd_en_w2e_esto] [expr ${dc_clock_period}*0.40]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.37] [get_ports strm_rd_en_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.43] [get_ports strm_rd_en_w2e_wsti]

set_min_delay -from [get_ports strm_rd_en_e2w_esti] [expr ${dc_clock_period}*0.45]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.16] [get_ports strm_rd_en_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.45] [get_ports strm_rd_en_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.54] [get_ports strm_rd_en_e2w_wsto]
set_min_delay -from [get_ports strm_rd_en_w2e_wsti] [expr ${dc_clock_period}*0.50]
set_max_delay -from [get_ports strm_rd_en_w2e_wsti] [expr ${dc_clock_period}*0.55]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.15] [get_ports strm_rd_en_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.50] [get_ports strm_rd_en_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.60] [get_ports strm_rd_en_w2e_esto]

# rd_addr
set_min_delay -to [get_ports strm_rd_addr_e2w_wsto] [expr ${dc_clock_period}*0.20]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.12] [get_ports strm_rd_addr_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.20] [get_ports strm_rd_addr_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports strm_rd_addr_e2w_esti]
set_min_delay -to [get_ports strm_rd_addr_w2e_esto] [expr ${dc_clock_period}*0.30]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.15] [get_ports strm_rd_addr_w2e_wsti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports strm_rd_addr_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.37] [get_ports strm_rd_addr_w2e_wsti]

set_min_delay -from [get_ports strm_rd_addr_e2w_esti] [expr ${dc_clock_period}*0.30]
set_max_delay -from [get_ports strm_rd_addr_e2w_esti] [expr ${dc_clock_period}*0.45]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.05] [get_ports strm_rd_addr_e2w_wsto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.48] [get_ports strm_rd_addr_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports strm_rd_addr_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.45] [get_ports strm_rd_addr_e2w_wsto]
set_min_delay -from [get_ports strm_rd_addr_w2e_wsti] [expr ${dc_clock_period}*0.30]
set_max_delay -from [get_ports strm_rd_addr_w2e_wsti] [expr ${dc_clock_period}*0.40]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.02] [get_ports strm_rd_addr_w2e_esto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.44] [get_ports strm_rd_addr_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports strm_rd_addr_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports strm_rd_addr_w2e_esto]

# rd_data
set_min_delay -to [get_ports strm_rd_data_e2w_wsto] [expr ${dc_clock_period}*0.30]
set_max_delay -to [get_ports strm_rd_data_e2w_wsto] [expr ${dc_clock_period}*0.40]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.20] [get_ports strm_rd_data_e2w_esti]
# set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.48] [get_ports strm_rd_data_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports strm_rd_data_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports strm_rd_data_e2w_esti]
set_min_delay -to [get_ports strm_rd_data_w2e_esto] [expr ${dc_clock_period}*0.30]
set_max_delay -to [get_ports strm_rd_data_w2e_esto] [expr ${dc_clock_period}*0.40]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.18] [get_ports strm_rd_data_w2e_wsti]
# set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.49] [get_ports strm_rd_data_w2e_wsti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports strm_rd_data_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports strm_rd_data_w2e_wsti]

set_min_delay -from [get_ports strm_rd_data_e2w_esti] [expr ${dc_clock_period}*0.20]
set_max_delay -from [get_ports strm_rd_data_e2w_esti] [expr ${dc_clock_period}*0.30]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.08] [get_ports strm_rd_data_e2w_wsto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.35] [get_ports strm_rd_data_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.20] [get_ports strm_rd_data_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports strm_rd_data_e2w_wsto]
set_min_delay -from [get_ports strm_rd_data_w2e_wsti] [expr ${dc_clock_period}*0.25]
set_max_delay -from [get_ports strm_rd_data_w2e_wsti] [expr ${dc_clock_period}*0.35]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.05] [get_ports strm_rd_data_w2e_esto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.38] [get_ports strm_rd_data_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.25] [get_ports strm_rd_data_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.35] [get_ports strm_rd_data_w2e_esto]

# rd_data_valid
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.21] [get_ports strm_rd_data_valid_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.26] [get_ports strm_rd_data_valid_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports strm_rd_data_valid_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.44] [get_ports strm_rd_data_valid_w2e_wsti]

set_min_delay -from [get_ports strm_rd_data_valid_e2w_esti] [expr ${dc_clock_period}*0.15]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.11] [get_ports strm_rd_data_valid_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.15] [get_ports strm_rd_data_valid_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.22] [get_ports strm_rd_data_valid_e2w_wsto]
set_min_delay -from [get_ports strm_rd_data_valid_w2e_wsti] [expr ${dc_clock_period}*0.15]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.03] [get_ports strm_rd_data_valid_w2e_esto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.14] [get_ports strm_rd_data_valid_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.15] [get_ports strm_rd_data_valid_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.15] [get_ports strm_rd_data_valid_w2e_esto]


##########################
# pcfg interface
##########################
# rd_en
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.31] [get_ports pc_rd_en_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.42] [get_ports pc_rd_en_e2w_esti]
set_min_delay -to [get_ports pc_rd_en_w2e_esto] [expr ${dc_clock_period}*0.40]
set_max_delay -to [get_ports pc_rd_en_w2e_esto] [expr ${dc_clock_period}*0.50]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.36] [get_ports pc_rd_en_w2e_wsti]
# set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.51] [get_ports pc_rd_en_w2e_wsti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports pc_rd_en_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.50] [get_ports pc_rd_en_w2e_wsti]

set_min_delay -from [get_ports pc_rd_en_e2w_esti] [expr ${dc_clock_period}*0.35]
set_max_delay -from [get_ports pc_rd_en_e2w_esti] [expr ${dc_clock_period}*0.45]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports pc_rd_en_e2w_wsto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.48] [get_ports pc_rd_en_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.35] [get_ports pc_rd_en_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.45] [get_ports pc_rd_en_e2w_wsto]
set_min_delay -from [get_ports pc_rd_en_w2e_wsti] [expr ${dc_clock_period}*0.35]
set_max_delay -from [get_ports pc_rd_en_w2e_wsti] [expr ${dc_clock_period}*0.50]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.32] [get_ports pc_rd_en_w2e_esto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.53] [get_ports pc_rd_en_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.35] [get_ports pc_rd_en_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.50] [get_ports pc_rd_en_w2e_esto]

# rd_addr
set_min_delay -to [get_ports pc_rd_addr_e2w_wsto] [expr ${dc_clock_period}*0.38]
set_max_delay -to [get_ports pc_rd_addr_e2w_wsto] [expr ${dc_clock_period}*0.55]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.39] [get_ports pc_rd_addr_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.54] [get_ports pc_rd_addr_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.39] [get_ports pc_rd_addr_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.53] [get_ports pc_rd_addr_w2e_wsti]

set_min_delay -from [get_ports pc_rd_addr_e2w_esti] [expr ${dc_clock_period}*0.25]
set_max_delay -from [get_ports pc_rd_addr_e2w_esti] [expr ${dc_clock_period}*0.45]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.29] [get_ports pc_rd_addr_e2w_wsto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.49] [get_ports pc_rd_addr_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.29] [get_ports pc_rd_addr_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.45] [get_ports pc_rd_addr_e2w_wsto]
set_min_delay -from [get_ports pc_rd_addr_w2e_wsti] [expr ${dc_clock_period}*0.40]
set_max_delay -from [get_ports pc_rd_addr_w2e_wsti] [expr ${dc_clock_period}*0.50]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.33] [get_ports pc_rd_addr_w2e_esto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.50] [get_ports pc_rd_addr_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports pc_rd_addr_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.50] [get_ports pc_rd_addr_w2e_esto]

# rd_data
set_min_delay -to [get_ports pc_rd_data_e2w_wsto] [expr ${dc_clock_period}*0.30]
set_max_delay -to [get_ports pc_rd_data_e2w_wsto] [expr ${dc_clock_period}*0.50]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.36] [get_ports pc_rd_data_e2w_esti]
# set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.58] [get_ports pc_rd_data_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports pc_rd_data_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.55] [get_ports pc_rd_data_e2w_esti]

set_min_delay -to [get_ports pc_rd_data_w2e_esto] [expr ${dc_clock_period}*0.30]
set_max_delay -to [get_ports pc_rd_data_w2e_esto] [expr ${dc_clock_period}*0.55]
# set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.38] [get_ports pc_rd_data_w2e_wsti]
# set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.63] [get_ports pc_rd_data_w2e_wsti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports pc_rd_data_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.60] [get_ports pc_rd_data_w2e_wsti]

set_min_delay -from [get_ports pc_rd_data_e2w_esti] [expr ${dc_clock_period}*0.30]
set_max_delay -from [get_ports pc_rd_data_e2w_esti] [expr ${dc_clock_period}*0.40]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.24] [get_ports pc_rd_data_e2w_wsto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.50] [get_ports pc_rd_data_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.30] [get_ports pc_rd_data_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports pc_rd_data_e2w_wsto]
set_min_delay -from [get_ports pc_rd_data_w2e_wsti] [expr ${dc_clock_period}*0.40]
set_max_delay -from [get_ports pc_rd_data_w2e_wsti] [expr ${dc_clock_period}*0.50]
# set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.27] [get_ports pc_rd_data_w2e_esto]
# set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.55] [get_ports pc_rd_data_w2e_esto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.40] [get_ports pc_rd_data_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.50] [get_ports pc_rd_data_w2e_esto]

# rd_data_valid
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.51] [get_ports pc_rd_data_valid_e2w_esti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.55] [get_ports pc_rd_data_valid_e2w_esti]
set_input_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.41] [get_ports pc_rd_data_valid_w2e_wsti]
set_input_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.48] [get_ports pc_rd_data_valid_w2e_wsti]

set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.34] [get_ports pc_rd_data_valid_e2w_wsto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.47] [get_ports pc_rd_data_valid_e2w_wsto]
set_output_delay -min -clock ${clock_name} [expr ${dc_clock_period}*0.34] [get_ports pc_rd_data_valid_w2e_esto]
set_output_delay -max -clock ${clock_name} [expr ${dc_clock_period}*0.49] [get_ports pc_rd_data_valid_w2e_esto]

##########################
# sram configuration interface
##########################
set_input_delay -clock ${clock_name} [expr ${dc_clock_period}*0.5] [get_ports if_sram_cfg* -filter "direction==in"]
set_output_delay -clock ${clock_name} [expr ${dc_clock_period}*0.5] [get_ports if_sram_cfg* -filter "direction==out"]

# jtag sram read is multicycle path because you assert rd_en for long cycles
set_multicycle_path -setup 10 -from [get_ports if_sram_cfg*rd* -filter "direction==in"]
set_multicycle_path -setup 10 -to [get_ports if_sram_cfg*rd* -filter "direction==out"]
set_multicycle_path -setup 10 -through [get_cells -hier if_sram_cfg*rd*]
set_multicycle_path -setup 10 -through [get_cells -hier cfg_sram_rd*]
set_multicycle_path -setup 10 -to [get_cells -hier if_sram_cfg*rd*]
set_multicycle_path -setup 10 -to [get_cells -hier cfg_sram_rd*]
set_multicycle_path -setup 10 -from [get_cells -hier if_sram_cfg*rd*]
set_multicycle_path -setup 10 -from [get_cells -hier cfg_sram_rd*]
set_multicycle_path -hold 9 -from [get_ports if_sram_cfg*rd* -filter "direction==in"]
set_multicycle_path -hold 9 -to [get_ports if_sram_cfg*rd* -filter "direction==out"]
set_multicycle_path -hold 9 -through [get_cells -hier if_sram_cfg*rd*]
set_multicycle_path -hold 9 -through [get_cells -hier cfg_sram_rd*]
set_multicycle_path -hold 9 -to [get_cells -hier if_sram_cfg*rd*]
set_multicycle_path -hold 9 -to [get_cells -hier cfg_sram_rd*]
set_multicycle_path -hold 9 -from [get_cells -hier if_sram_cfg*rd*]
set_multicycle_path -hold 9 -from [get_cells -hier cfg_sram_rd*]

# jtag sram write is asserted for 4 cycles from glc
set_multicycle_path -setup 4 -from [get_ports if_sram_cfg*wr* -filter "direction==in"]
set_multicycle_path -setup 4 -to [get_ports if_sram_cfg*wr* -filter "direction==out"]
set_multicycle_path -setup 4 -through [get_cells -hier if_sram_cfg*wr*]
set_multicycle_path -setup 4 -to [get_cells -hier if_sram_cfg*wr*]
set_multicycle_path -setup 4 -from [get_cells -hier if_sram_cfg*wr*]
set_multicycle_path -hold 3 -from [get_ports if_sram_cfg*wr* -filter "direction==in"]
set_multicycle_path -hold 3 -to [get_ports if_sram_cfg*wr* -filter "direction==out"]
set_multicycle_path -hold 3 -through [get_cells -hier if_sram_cfg*wr*]
set_multicycle_path -hold 3 -to [get_cells -hier if_sram_cfg*wr*]
set_multicycle_path -hold 3 -from [get_cells -hier if_sram_cfg*wr*]

# tile id is constant
set_input_delay -clock ${clock_name} 0 glb_tile_id
# glb_tile_id is constant
set_false_path -from {glb_tile_id*}

# these inputs are from configuration register
set_false_path -from {cfg_tile_connected_wsti}
set_false_path -from {cfg_pc_tile_connected_wsti}
set_false_path -to {cfg_tile_connected_esto}
set_false_path -to {cfg_pc_tile_connected_esto}

# path from configuration registers are false path
set_false_path -through [get_cells glb_tile_int/glb_tile_cfg/glb_pio/pio_logic/*] -through [get_ports glb_tile_int/glb_tile_cfg/cfg_* -filter "direction==out"]
set_false_path -from [get_cells glb_tile_int/glb_tile_cfg/glb_pio/pio_logic/*] -through [get_ports glb_tile_int/glb_tile_cfg/cfg_* -filter "direction==out"]

# jtag cgra configuration read
# ignore timing when rd_en is 1
set_case_analysis 0 cgra_cfg_jtag_wsti_rd_en
set_multicycle_path -setup 10 -from cgra_cfg_jtag_wsti_rd_en
set_multicycle_path -hold 9 -from cgra_cfg_jtag_wsti_rd_en
set_multicycle_path -setup 10 -from cgra_cfg_jtag_wsti_addr -to cgra_cfg_jtag_esto_addr
set_multicycle_path -hold 9 -from cgra_cfg_jtag_wsti_addr -to cgra_cfg_jtag_esto_addr
set_multicycle_path -setup 10 -from cgra_cfg_jtag_wsti_data -to cgra_cfg_jtag_esto_data
set_multicycle_path -hold 9 -from cgra_cfg_jtag_wsti_data -to cgra_cfg_jtag_esto_data
set_false_path -from cgra_cfg_jtag_wsti_wr_en -to cgra_cfg_jtag_esto_wr_en

# Make all signals limit their fanout
# loose fanout number to reduce the number of buffer and meet timing
set_max_fanout 25 $dc_design_name

# Make all signals meet good slew
set_max_transition [expr 0.25*${dc_clock_period}] $dc_design_name

#set_input_transition 1 [all_inputs]
#set_max_transition 10 [all_outputs]

