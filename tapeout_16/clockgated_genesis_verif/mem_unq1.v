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
//	|  $Change: 11879 $ --- $Date: 2013/06/11 $   |
//	-----------------------------------------------
//	
//
//  Source file: /nobackup/kzf/garnet/memory_core/genesis_new/mem.vp
//  Source template: mem
//
// --------------- Begin Pre-Generation Parameters Status Report ---------------
//
//	From 'generate' statement (priority=5):
// Parameter wwidth 	= 16
// Parameter dwidth 	= 16
// Parameter use_sram_stub 	= 0
// Parameter ddepth 	= 512
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

///////////////////////////////////////////////////////////////////
// CGRA Memory Wrapper
// Author: Maxwell Strange
/////////////////////////////////////////////////////////////////
`define xassert(condition, message) if(condition) begin $display(message); $finish(1); end

// dwidth (_GENESIS2_INHERITANCE_PRIORITY_) = 16
//
// ddepth (_GENESIS2_INHERITANCE_PRIORITY_) = 0x200
//
// wwidth (_GENESIS2_INHERITANCE_PRIORITY_) = 16
//
// use_sram_stub (_GENESIS2_INHERITANCE_PRIORITY_) = 0
//

module mem_unq1 (
  data_out, 
  data_in,
  clk,
  cen,
  wen,
  addr
);

output [15:0] data_out;
input [15:0] data_in;
input clk;
input cen;
input wen;
input [8:0] addr;


// Instance of mem module
TS1N16FFCLLSBLVTC512X16M8S m (
  // Main interface
  .CLK(clk), // Clock - 1
  .CEB(~cen), // Chip Enable (low) - 1
  .WEB(~wen), // Write Enable (low) - 1
  .A(addr), 
  .D(data_in),
  .Q(data_out),
  // Testing interface (unused)
  .RTSEL(2'b00), //'
  .WTSEL(2'b00) //'
  );



endmodule
