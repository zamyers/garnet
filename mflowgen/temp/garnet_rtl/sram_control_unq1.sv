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
//  Source file: /sim/ajcars/aha-arm-soc-june-2019/components/cgra/garnet/memory_core/genesis_new/sram_control.svp
//  Source template: sram_control
//
// --------------- Begin Pre-Generation Parameters Status Report ---------------
//
//	From 'generate' statement (priority=5):
// Parameter dwidth 	= 16
// Parameter ddepth 	= 512
// Parameter wwidth 	= 16
// Parameter bbanks 	= 2
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
// CGRA SRAM Controller Generator
// Author: Maxwell Strange (Keyi Zhang + Taeyoung Kong)
//////////////////////////////////////////////////////////////////
`define xassert(condition, message) if(condition) begin $display(message); $finish(1); end

// dwidth (_GENESIS2_INHERITANCE_PRIORITY_) = 16
//
// wwidth (_GENESIS2_INHERITANCE_PRIORITY_) = 16
//
// ddepth (_GENESIS2_INHERITANCE_PRIORITY_) = 0x200
//
// bbanks (_GENESIS2_INHERITANCE_PRIORITY_) = 2
//

module sram_control_unq1(
clk,
clk_en,
reset,
flush,

data_in,
wen,
data_out,
ren,
addr_in,

sram_to_mem_data,
sram_to_mem_cen,
sram_to_mem_wen,
sram_to_mem_addr,
mem_to_sram_data
);

input logic clk;
input logic clk_en;
input logic reset;
input logic flush;
input logic [15:0] data_in;
input logic wen;
input logic ren;
input logic [15:0] addr_in;
input logic [15:0] mem_to_sram_data [1:0];

output logic [15:0] data_out;
output logic [15:0] sram_to_mem_data [1:0];
output logic [1:0] sram_to_mem_cen;
output logic [1:0] sram_to_mem_wen;
output logic [8:0] sram_to_mem_addr [1:0];

logic [9:0] addr;
logic [1:0] bank_seld;
logic [1:0] sram_to_mem_ren_reg;
logic [15:0] data_out_reg;


assign addr = addr_in[9:0];

// ===========================
// Pass signals to actual memory module
// ===========================
	assign bank_seld[0] = (addr[9:9] == 0);
	assign bank_seld[1] = (addr[9:9] == 1);
	assign sram_to_mem_data[0] = data_in; 
	assign sram_to_mem_data[1] = data_in; 
	assign sram_to_mem_cen[0] = bank_seld[0] & (wen | ren);
	assign sram_to_mem_cen[1] = bank_seld[1] & (wen | ren);
	assign sram_to_mem_wen[0] = bank_seld[0] & wen;
	assign sram_to_mem_wen[1] = bank_seld[1] & wen;
	assign sram_to_mem_addr[0] = addr[8:0];
	assign sram_to_mem_addr[1] = addr[8:0];

// ===========================
// Pass the selected value to the data out
// ===========================
assign data_out = 
	sram_to_mem_ren_reg[1] ? mem_to_sram_data[1] :
	sram_to_mem_ren_reg[0] ? mem_to_sram_data[0] : data_out_reg;

// ===================
// Flop the ren for proper output
// ===================
always_ff @(posedge clk or posedge reset) begin
	if(reset) begin
		sram_to_mem_ren_reg[0] <= 1'b0; //'
		sram_to_mem_ren_reg[1] <= 1'b0; //'
    data_out_reg <= 0;
	end
    // Clk gate properly
	else if(clk_en) begin
		if(flush) begin
			sram_to_mem_ren_reg[0] <= 1'b0; //'
			sram_to_mem_ren_reg[1] <= 1'b0; //'
      data_out_reg <= 0;
		end
		else begin
			sram_to_mem_ren_reg[0] <=  bank_seld[0] & ren;
			sram_to_mem_ren_reg[1] <=  bank_seld[1] & ren;
      data_out_reg <= data_out;
		end
	end
end

endmodule
