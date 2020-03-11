//
//--------------------------------------------------------------------------------
//          THIS FILE WAS AUTOMATICALLY GENERATED BY THE GENESIS2 ENGINE        
//  FOR MORE INFORMATION: OFER SHACHAM (CHIP GENESIS INC / STANFORD VLSI GROUP)
//    !! THIS VERSION OF GENESIS2 IS NOT FOR ANY COMMERCIAL USE !!
//     FOR COMMERCIAL LICENSE CONTACT SHACHAM@ALUMNI.STANFORD.EDU
//--------------------------------------------------------------------------------
//
//  
//	-----------------------------------------------
//	|            Genesis Release Info             |
//	|  $Change: 11904 $ --- $Date: 2013/08/03 $   |
//	-----------------------------------------------
//	
//
//  Source file: /sim/ajcars/aha-arm-soc-june-2019/components/cgra/garnet/global_controller/genesis/jtag.svp
//  Source template: jtag
//
// --------------- Begin Pre-Generation Parameters Status Report ---------------
//
//	From 'generate' statement (priority=5):
// Parameter SYSCLK_CFG_BUS_WIDTH 	= 32
// Parameter SYSCLK_CFG_OPCODE_WIDTH 	= 5
// Parameter SYSCLK_CFG_ADDR_WIDTH 	= 32
//
//		---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
//
//	From Command Line input (priority=4):
//
//		---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
//
//	From XML input (priority=3):
//
//		---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
//
//	From Config File input (priority=2):
//
// ---------------- End Pre-Generation Pramameters Status Report ----------------

/* *****************************************************************************
 * File: template.vp
 * Author: Ofer Shacham
 * 
 * Description:
 * This module is the top of the actual design.
 * 
 * REQUIRED GENESIS PARAMETERS:
 * ----------------------------
 * * IO_LIST -  List of main design IOs. For each IO you must specify:
 *   * name
 *   * width
 *   * direction - allowed directions are 'in'/'out'
 *   * bsr - put IO on boundary scan? (yes/no)
 *   * pad - pad type (analog or anl/digital or dig)
 *   * orientation - Orientation of the IO pad. allowed values are {left, right, 
 *		     top, bottom}
 * 
 * SYSCLK_CFG_BUS_WIDTH (48) -  Bus width for system clocked configuration entities
 * SYSCLK_CFG_ADDR_WIDTH (18) - Address width for system clocked configuration entities
 * TESTCLK_CFG_BUS_WIDTH (32) - Bus width for test clocked configuration entities
 * TESTCLK_CFG_ADDR_WIDTH (12) - Address width for test clocked configuration entities
 * 
 * 
 * Inputs:
 * -------
 * Main design inputs, plus  
 * inputs that regard the boundary scan and pads control
 * 
 * Outputs:
 * --------
 * Main design outputs, plus 
 * outputs that regard the boundary scan and pads control
 * 
 * Change bar:
 * -----------
 * Date          Author   Description
 * Mar 28, 2010  shacham  init version  --  
 * May 18, 2010  shacham  Added orientation feild to IO parameter list
 * May 24, 2010  shacham  Pulled config bus parameters to top level
 *			  Added cfg_ifc as the proper way to implement config
 *			  bus uniformity amongst modules.
 *			  Made declaration of IO params into a force_param to
 *			  make it immutable
 * ****************************************************************************/
// ACTUAL GENESIS2 PARAMETERIZATIONS
// SYSCLK_CFG_BUS_WIDTH (_GENESIS2_INHERITANCE_PRIORITY_) = 32
//
// SYSCLK_CFG_ADDR_WIDTH (_GENESIS2_INHERITANCE_PRIORITY_) = 32
//
// SYSCLK_CFG_OPCODE_WIDTH (_GENESIS2_INHERITANCE_PRIORITY_) = 5
//
// IDCODE (_GENESIS2_DECLARATION_PRIORITY_) = 0x28a
//
// IO_LIST (_GENESIS2_IMMUTABLE_PRIORITY_) = 
//	[ { bsr=>no, direction=>in, name=>trst_n, orientation=>right, pad=>digital, width=>1 },
//	  { bsr=>no, direction=>in, name=>tck, orientation=>right, pad=>digital, width=>1 },
//	  { bsr=>no, direction=>in, name=>tms, orientation=>right, pad=>digital, width=>1 },
//	  { bsr=>no, direction=>in, name=>tdi, orientation=>right, pad=>digital, width=>1 },
//	  { bsr=>no, direction=>out, name=>tdo, orientation=>right, pad=>digital, width=>1 },
//	  { bsr=>no, direction=>in, name=>config_data_from_gc, orientation=>right, pad=>digital, width=>32 },
//	  { bsr=>no, direction=>out, name=>config_data_to_gc, orientation=>right, pad=>digital, width=>32 },
//	  { bsr=>no, direction=>out, name=>config_addr_to_gc, orientation=>right, pad=>digital, width=>32 },
//	  { bsr=>no, direction=>out, name=>config_op_to_gc, orientation=>right, pad=>digital, width=>5 }
//	]
//


module jtag_unq1
  (
   // main IOs
   output [31:0] ifc_config_addr_to_gc,
   output [31:0] ifc_config_data_to_gc,
   input [31:0] ifc_config_data_from_gc,
   output [4:0]  ifc_config_op_to_gc,

   input 	 ifc_trst_n,
   input 	 ifc_tck,
   input 	 ifc_tms,
   input 	 ifc_tdi,
   output 	 ifc_tdo,
   
   input 	 clk,
   input 	 reset,
   input 	 sys_clk_activated, //Is global controller on sys clk yet?
   //Signals for boundary scan register
   output 	 bsr_tdi,
   output 	 bsr_sample,
   output 	 bsr_intest,
   output 	 bsr_extest,
   output 	 bsr_update_en,
   output 	 bsr_capture_en,
   output 	 bsr_shift_dr,
   output 	 bsr_tdo
   );


   // Connect Forward the reset and clock inputs to the global controller
   wire [31:0] sc_jtag2gc_ifc_addr;
   wire [31:0] sc_jtag2gc_ifc_data;
   wire [4:0] sc_jtag2gc_ifc_op;

   wire [31:0] sc_gc2jtag_ifc_data;
   wire [31:0] sc_gc2jtag_ifc_addr;
   wire [4:0] sc_gc2jtag_ifc_op;

//The opcode is the upper 3 address bits to the gc
   assign ifc_config_addr_to_gc = sc_jtag2gc_ifc_addr;
   assign ifc_config_data_to_gc = sc_jtag2gc_ifc_data;
   assign ifc_config_op_to_gc = sc_jtag2gc_ifc_op;
   assign sc_gc2jtag_ifc_data = ifc_config_data_from_gc;
   assign sc_gc2jtag_ifc_addr = 0;
   assign sc_gc2jtag_ifc_op = 3;//Set to Bypass so that input data_rd reg is always enabled. Is this ok?

   
   //These signals aren't used. Only included to avoid warnings.			
   reg tdo_en;
   // Instantiate the JTAG to reg-files controller
   cfg_and_dbg_unq1 cfg_and_dbg
     (
      // JTAG signals
      .tms(ifc_tms),
      .tck(ifc_tck),
      .trst_n(ifc_trst_n),
      .tdi(ifc_tdi),
      .tdo(ifc_tdo),
      .tdo_en(tdo_en), 
      
      // Boundary Scan Signals (not used in this design. Only connected to supress warnings)
      .bsr_tdi(bsr_tdi),
      .bsr_sample(bsr_sample),
      .bsr_intest(bsr_intest),
      .bsr_extest(bsr_extest),
      .bsr_update_en(bsr_update_en),
      .bsr_capture_en(bsr_capture_en),
      .bsr_shift_dr(bsr_shift_dr),
      .bsr_tdo(bsr_tdo),

      // signals to the System-clocked global controller
      .sc_cfgReq_addr(sc_jtag2gc_ifc_addr),
      .sc_cfgReq_data(sc_jtag2gc_ifc_data),
      .sc_cfgReq_op(sc_jtag2gc_ifc_op),
      .sc_cfgRep_addr(sc_gc2jtag_ifc_addr),
      .sc_cfgRep_data(sc_gc2jtag_ifc_data),
      .sc_cfgRep_op(sc_gc2jtag_ifc_op),      
      .Reset(reset), //ifc.Reset),
      .Clk(clk), //ifc.Clk),
      .sys_clk_activated(sys_clk_activated)
      );
   
endmodule // jtag_unq1
