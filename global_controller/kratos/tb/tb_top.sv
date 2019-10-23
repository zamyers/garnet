/*=============================================================================
** Module: tb_top.sv
** Description:
**              top testbench for axi-lite
** Author: Taeyoung Kong
** Change history:  10/22/2019 - Implement first version of testbench
**===========================================================================*/

localparam AXI_DWIDTH = 32;
localparam AXI_AWIDTH = 12;

module tb_top();
    logic clk;
    logic rst_n;

//============================================================================//
// Instantiate clocks
//============================================================================//
    clocker clocker_inst (
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        repeat(100000) @(posedge clk);
        $display("\n%0t\tERROR: The 100000 cycles marker has passed!", $time);
        $finish(2);
    end

//============================================================================//
// Instantiate interface
//============================================================================//
   axil_if #(
       .AXI_DWIDTH(AXI_DWIDTH),
       .AXI_AWIDTH(AXI_AWIDTH)
   )
   axil_ifc(
       .clk(clk),
       .rst_n(rst_n)
   );
   
//============================================================================//
// Instantiate dut
//============================================================================//
   glc dut ();

   //Since we are not using interface for glc, directly assign singals 
   assign dut.AWADDR = axil_ifc.AWADDR;
   assign dut.AWVALID = axil_ifc.AWVALID;
   assign dut.AWPROT = axil_ifc.AWPROT;
   assign axil_ifc.AWREADY = dut.AWREADY;

   assign dut.WDATA = axil_ifc.WDATA;
   assign dut.WSTRB = axil_ifc.WSTRB;
   assign dut.WVALID = axil_ifc.WVALID;
   assign axil_ifc.WREADY = dut.WREADY;

   assign dut.ARADDR = axil_ifc.ARADDR;
   assign dut.ARVALID = axil_ifc.ARVALID;
   assign dut.ARPROT = axil_ifc.ARPROT;
   assign axil_ifc.ARREADY = dut.ARREADY;

   assign axil_ifc.BVALID = dut.BVALID;
   assign axil_ifc.BRESP = dut.BRESP;
   assign dut.BREADY = axil_ifc.BREADY;

   assign dut.RREADY = axil_ifc.RREADY;
   assign axil_ifc.RDATA = dut.RDATA;
   assign axil_ifc.RVALID = dut.RVALID;
   assign axil_ifc.RRESP = dut.RRESP;

//============================================================================//
// Instantiate test_glc
//============================================================================//
    test_glc test_glc_inst (
        .ifc(axil_ifc)
    );
      
endmodule
