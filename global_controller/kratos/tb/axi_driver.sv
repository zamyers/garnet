/*=============================================================================
** Module: axi_driver.sv
** Description:
**              driver for the axi interface
** Author: Taeyoung Kong
** Change history:  10/22/2019 - Implement first version of axi driver
**===========================================================================*/

parameter AXI_DWIDTH = 32;
parameter AXI_AWIDTH = 12;

typedef struct {
    logic [AXI_DWIDTH-1:0] wr_data;
    logic [AXI_DWIDTH-1:0] rd_data;
    logic [AXI_AWIDTH-1:0] addr;
} axi_trans_t;

//============================================================================//
// Class axi_driver
//============================================================================//
class axi_driver;
    virtual axi_if.test ifc; // interface for the axi signals

    // current transaction 
    axi_trans_t cur_trans;
   
    function new(virtual axi_if.test ifc);
        this.ifc = ifc;
    endfunction 

    // Extern tasks in axi driver
    // write axi instruction
    extern task axi_write(input [AXI_AWIDTH-1:0] addr, input [AXI_DWIDTH-1:0] data);
    // read axi instruction
    extern task axi_read(input [AXI_AWIDTH-1:0] addr);

    // get the results of the latest transaction sent
    extern function axi_trans_t GetResult();

    // reset
    extern task Reset();

endclass: axi_driver


//============================================================================//
// Axi driver function
// Get the results of the latest transaction sent
//============================================================================//
function axi_trans_t axi_driver::GetResult();
    return cur_trans;
endfunction // axi_trans_t
   
//============================================================================//
// AXI transaction task
//============================================================================//
task axi_driver::Reset();
    repeat (2) @(posedge this.ifc.clk);
    this.ifc.AWADDR = 0;
    this.ifc.AWVALID = 0;
    this.ifc.WDATA = 0;
    this.ifc.WVALID = 0;
    this.ifc.ARADDR = 0;
    this.ifc.ARVALID = 0;
    this.ifc.RREADY = 0;
    repeat (2) @(posedge this.ifc.clk);
endtask // Reset

task axi_driver::Write(input axi_trans_t new_trans);
    cur_trans = new_trans;

    @(posedge this.ifc.clk);
    this.ifc.AWADDR = cur_trans.addr;
    this.ifc.AWVALID = 1;

    for (int i=0; i<100; i++) begin
        if (this.ifc.AWREADY==1) break;
        @(posedge this.ifc.clk);
    end

    @(posedge this.ifc.clk);
    this.ifc.AWVALID = 0;

    @(posedge this.ifc.clk);
    this.ifc.WDATA = cur_trans.wr_data;
    this.ifc.WVALID = 1;
    for (int i=0; i<100; i++) begin
        if (this.ifc.WREADY==1) break;
        @(posedge this.ifc.clk);
    end

    @(posedge this.ifc.clk);
    this.ifc.WVALID = 0;
    @(posedge this.ifc.clk);
endtask // Write

task axi_driver::Read(input axi_trans_t new_trans);
    cur_trans = new_trans;

    @(posedge this.ifc.clk);
    this.ifc.ARADDR = cur_trans.addr;
    this.ifc.ARVALID = 1;
    this.ifc.RREADY = 1;

    for (int i=0; i<100; i++) begin
        if (this.ifc.ARREADY==1) break;
        @(posedge this.ifc.clk);
    end

    @(posedge this.ifc.clk);
    this.ifc.ARVALID = 0;

    @(posedge this.ifc.clk);
    for (int i=0; i<100; i++) begin
        if (this.ifc.RVALID==1) break;
        @(posedge this.ifc.clk);
    end

    cur_trans.rd_data = this.ifc.RDATA;
    @(posedge this.ifc.clk);
    this.ifc.RREADY = 0;
    @(posedge this.ifc.clk);
endtask // Read

task axi_driver::axi_write(input [AXI_AWIDTH-1:0] addr, input [AXI_DWIDTH-1:0] data);
    axi_trans_t axi_trans;
    axi_trans.addr = addr;
    axi_trans.wr_data = data;
    Write(axi_trans);
endtask // axi_write

task axi_driver::axi_read(input [AXI_AWIDTH-1:0] addr);
    axi_trans_t axi_trans;
    axi_trans.addr = addr;
    Read(axi_trans);
endtask // axi_read
