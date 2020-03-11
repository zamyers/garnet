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
//  Source file: /sim/ajcars/aha-arm-soc-june-2019/components/cgra/garnet/memory_core/genesis_new/fifo_control.svp
//  Source template: fifo_control
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
// CGRA memory generator
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

module fifo_control_unq1(
   clk,
   clk_en,
   reset,
   flush,
   ren,
   wen,
   data_in,
   data_out,

   almost_empty,
   almost_full,
   empty,
   full,
   valid,

   fifo_to_mem_data,
   fifo_to_mem_cen,
   fifo_to_mem_wen,
   fifo_to_mem_addr,
   mem_to_fifo_data,

   num_words_mem,

   almost_count,
   circular_en,
   depth
);

input logic 	clk;
input 		clk_en;
input logic 	reset;
input logic	flush;
input logic	ren;
input logic	wen;
input logic [15:0] data_in;	
output logic [15:0] data_out;	
output logic	almost_empty;
output logic	almost_full;
output logic	empty;
output logic	full;
output logic    valid;

output logic [15:0] fifo_to_mem_data [1:0];
output logic [1:0] fifo_to_mem_cen;
output logic [1:0] fifo_to_mem_wen;
output logic [8:0] fifo_to_mem_addr [1:0];
input logic  [15:0] mem_to_fifo_data [1:0];

output logic [15:0] num_words_mem;
input logic [15:0] depth;
input logic [3:0] almost_count;
input logic circular_en;

logic [15:0] almost_count_extended;

// ==========================
// Address generation
// ==========================
logic [9:0] read_addr;
logic [9:0] write_addr;

logic [8:0] read_addr_mem;
logic [8:0] write_addr_mem;

logic [1: 0] ren_mem;
logic [1: 0] wen_mem;
logic [1: 0] cen_mem;

logic [1:0] write_buffed;
logic [15:0] write_buff [1:0];
logic [8:0] write_buff_addr [1:0];

logic [15:0] data_out_sel [1:0];

logic [8:0] data_addr [1:0];

logic [15:0] next_num_words_mem;
logic init_stage;
logic read_to_write;
logic passthru;
logic [15:0] passthru_reg;
logic [1:0] wen_mem_en;
logic [15:0] data_out_reg;
logic [1:0] ren_mem_reg;
logic [1:0] same_bank;

logic empty_d1;
logic write_d1;

always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        empty_d1 <= 0;
        write_d1 <= 0;
    end
    else if(clk_en) begin
        if(flush) begin
            empty_d1 <= 0;
            write_d1 <= 0;
        end
        else begin
            empty_d1 <= empty;
            write_d1 <= wen;
        end
    end
end

assign read_addr_mem = read_addr[9:1];
assign write_addr_mem = write_addr[9:1];
assign almost_count_extended = {12'b0, almost_count};
assign almost_empty = (num_words_mem <= almost_count_extended);
assign almost_full = (num_words_mem >= (depth - almost_count_extended));

assign empty = (num_words_mem == 0);
assign full = (num_words_mem == depth);

assign same_bank[0] = ren_mem[0] & wen_mem[0];
assign same_bank[1] = ren_mem[1] & wen_mem[1];
assign cen_mem[0] = ren_mem[0] | wen_mem_en[0];
assign cen_mem[1] = ren_mem[1] | wen_mem_en[1];

// ================
// Status signals
// ================
   assign ren_mem[1] = ren & ((read_addr[0:0]) == 1);
   assign ren_mem[0] = ren & ((read_addr[0:0] == 0) | init_stage);

   assign wen_mem[1] = wen & ((write_addr[0]) == 1);
  assign wen_mem[0] = wen & ((write_addr[0:0] == 0) | init_stage);

   assign wen_mem_en[0] = (wen_mem[0] & ~(same_bank[0])) | write_buffed[0];
   assign wen_mem_en[1] = (wen_mem[1] & ~(same_bank[1])) | write_buffed[1];

   assign fifo_to_mem_data[0] = write_buffed[0] ? write_buff[0] : data_in;
   assign fifo_to_mem_data[1] = write_buffed[1] ? write_buff[1] : data_in;
   assign fifo_to_mem_cen[0] = cen_mem[0];
   assign fifo_to_mem_cen[1] = cen_mem[1];
   assign fifo_to_mem_wen[0] = wen_mem_en[0];
   assign fifo_to_mem_wen[1] = wen_mem_en[1];
   assign fifo_to_mem_addr[0] = data_addr[0];
   assign fifo_to_mem_addr[1] = data_addr[1];
   assign data_out_sel[0] = mem_to_fifo_data[0];
   assign data_out_sel[1] = mem_to_fifo_data[1];

always_ff @(posedge clk or posedge reset) begin
  if(reset) begin
    valid <= 0;
  end
  else if(clk_en) begin
    if(flush) begin
      valid <= 0;
    end
    else begin
      valid <= ren & (~empty | wen);
    end
  end
end

// =========================
// Combinational updates
// =========================
always_ff @(posedge clk or posedge reset) begin
   if(reset) begin
      num_words_mem <= 0;
   end
   else if(clk_en) begin
      if (flush) begin
         num_words_mem <= 0;
      end
      else begin
         num_words_mem <= num_words_mem + next_num_words_mem;
      end
   end
end

always_comb begin

   next_num_words_mem = 0;

   if(ren & wen) begin
      next_num_words_mem = 0;
   end
   else if(ren & ~empty) begin
      next_num_words_mem = -1;
   end
   else if(wen & ~full) begin
      next_num_words_mem = 1;
   end
end

always_comb begin

   data_addr[0] = write_buffed[0] ?
			  write_buff_addr[0] :
			  (ren_mem[0] ? read_addr_mem : write_addr_mem);	
   data_addr[1] = write_buffed[1] ?
			  write_buff_addr[1] :
			  (ren_mem[1] ? read_addr_mem : write_addr_mem);	
   if (ren_mem_reg[0] & (~empty_d1 | write_d1)) begin
      data_out = (passthru) ? passthru_reg : data_out_sel[0];
   end
   else if (ren_mem_reg[1] & (~empty_d1 | write_d1)) begin
      data_out = (passthru) ? passthru_reg : data_out_sel[1];
   end
   else begin
      data_out = data_out_reg;
   end
end

// =======================
// State updates
// =======================
always_ff @(posedge clk or posedge reset) begin
   if(reset) begin
      read_addr <= 0;
      write_addr <= 0;
	  init_stage <= 1;
	  read_to_write <= 1;
	  data_out_reg <= 0;
      passthru <= 0;
      passthru_reg <= 0;
	  write_buffed[0] <= 0;
	  write_buff[0] <= 0;
	  write_buff_addr[0] <= 0;
	  ren_mem_reg[0] <= 0;
	  write_buffed[1] <= 0;
	  write_buff[1] <= 0;
	  write_buff_addr[1] <= 0;
	  ren_mem_reg[1] <= 0;
   end
   else if(clk_en) begin
      if (flush) begin
         read_addr <= 0;
		 write_addr <= 0;
		 init_stage <= 1;
		 read_to_write <= 1;
		 data_out_reg <= 0;
         passthru <= 0;
         passthru_reg <= 0;
		 write_buffed[0] <= 0;
		 write_buff[0] <= 0;
		 write_buff_addr[0] <= 0;
		 ren_mem_reg[0] <= 0;
		 write_buffed[1] <= 0;
		 write_buff[1] <= 0;
		 write_buff_addr[1] <= 0;
		 ren_mem_reg[1] <= 0;
      end	
	  else begin
	  ///
         if (same_bank[0] == 1'b1) begin
		    write_buffed[0] <= 1'b1;
			write_buff[0] <= data_in;
			write_buff_addr[0] <= write_addr_mem;
		 end
		 else if (same_bank[1]) begin
			write_buffed[1] <= 1;
			write_buff[1] <= data_in;
			write_buff_addr[1] <= write_addr_mem;			
		 end

		 if (write_buffed[0]) begin
			write_buffed[0] <= 0;
		 end
		 if (write_buffed[1]) begin
			write_buffed[1] <= 0;
		 end
			// If READ AND NO WRITE
         if (ren & ~wen) begin
            if(~empty) begin 
                passthru <= 0;
            end
			if(circular_en & ~empty) begin
			   if ((read_addr + 1) == write_addr) begin
			      // circular buffer
			      read_addr <= 0;
				  // caught up to write
				  read_to_write <= 1;
			   end
			   else begin
				  read_addr <= (read_addr + 1);
				  read_to_write <= 0;
			   end
			end
			else begin
			   if (~empty) begin				
			      read_addr <= (read_addr + 1);
				  if ((read_addr + 1) == write_addr) begin
				     read_to_write <= 1;
				  end
				  else begin
				     read_to_write <= 0;
				  end			
			   end
			end
         end
		 // If WRITE AND NO READ
		 else if (wen & ~ren) begin
            if(~full) begin
                passthru <= 0;
				write_addr <= (write_addr + 1);
				read_to_write <= 0;
            end
         end	
		 // If READ AND WRITE
		 else if (ren & wen) begin
            if(empty & (|same_bank)) begin
               passthru <= 1;
               passthru_reg <= data_in;
            end
            else begin
               passthru <= 0;
            end
			
            read_addr <= (read_addr + 1);
			write_addr <= (write_addr + 1);

	  end
         // Transition out of the init stage after a read or write
		 if (ren | wen) begin
	        init_stage <= 0;
		 end
		 ren_mem_reg[0] <= ren_mem[0];
		 ren_mem_reg[1] <= ren_mem[1];
		 data_out_reg <= data_out;
      end
   end
end

endmodule
