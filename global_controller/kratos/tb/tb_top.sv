module top();
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
   axil_if axil_ifc_inst (
       .clk(clk),
       .rst_n(rst_n)
   );
   
//============================================================================//
// Instantiate dut
//============================================================================//
   glc glc_dut ();

   //Since we aren't using interface here, assign singals 
   //Inputs
   assign dut.tck = dut_ifc.tck;
   assign dut.clk_in = dut_ifc.Clk;
   assign dut.reset_in = dut_ifc.Reset;
   assign dut.tdi = dut_ifc.tdi;
   assign dut.tms = dut_ifc.tms;
   assign dut.trst_n = dut_ifc.trst_n;
   assign dut.config_data_in = dut_ifc.config_data_cgra2gc;
   assign dut.glb_config_data_in = dut_ifc.glb_config_data_cgra2gc;
   assign dut.glb_sram_config_data_in = dut_ifc.glb_sram_config_data_cgra2gc;
   assign dut.cgra_done_pulse = dut_ifc.cgra_done_pulse;
   assign dut.config_done_pulse = dut_ifc.config_done_pulse;

   // AXI inputs
   assign dut.AWADDR = dut_ifc.AWADDR;
   assign dut.AWVALID = dut_ifc.AWVALID;
   assign dut.WDATA = dut_ifc.WDATA;
   assign dut.WVALID = dut_ifc.WVALID;

   assign dut.ARADDR = dut_ifc.ARADDR;
   assign dut.ARVALID = dut_ifc.ARVALID;
   assign dut.RREADY = dut_ifc.RREADY;

   //Outputs
   assign dut_ifc.config_addr_gc2cgra = dut.config_addr_out;
   assign dut_ifc.config_data_gc2cgra = dut.config_data_out;
   assign dut_ifc.glb_config_addr_gc2cgra = dut.glb_config_addr_out;
   assign dut_ifc.glb_config_data_gc2cgra = dut.glb_config_data_out;
   assign dut_ifc.glb_sram_config_addr_gc2cgra = dut.glb_sram_config_addr_out;
   assign dut_ifc.glb_sram_config_data_gc2cgra = dut.glb_sram_config_data_out;
   assign dut_ifc.tdo = dut.tdo;

   // AXI outputs
   assign dut_ifc.AWREADY = dut.AWREADY;
   assign dut_ifc.WREADY = dut.WREADY;
   assign dut_ifc.RDATA = dut.RDATA;
   assign dut_ifc.RVALID = dut.RVALID;
   assign dut_ifc.ARREADY = dut.ARREADY;
   assign dut_ifc.RRESP = dut.RRESP;

//============================================================================//
// Instantiate test_glc
//============================================================================//
    test_glc test_glc_inst (
        .ifc(axil_ifc_inst)
    );
      
endmodule
 
