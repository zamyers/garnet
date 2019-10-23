interface axil_if #(
    parameter integer AXI_AWIDTH = 12,
    parameter integer AXI_DWIDTH = 32
)
(
    input logic clk,
    input logic rst_n
);

    logic                   clk;
    logic                   rst_n; 

    logic [AXI_AWIDTH-1:0]  AWADDR;
    logic                   AWVALID;
    logic [2:0]             AWPROT;
    logic                   AWREADY;

    logic [AXI_DWIDTH-1:0]  WDATA;
    logic                   WVALID;
    logic                   WREADY;
    logic [AXI_DWIDTH/8-1:0] WSTRB;

    logic                   BREADY;
    logic                   BVALID;
    logic [1:0]             BRESP;


    logic [AXI_AWIDTH-1:0]  ARADDR;
    logic                   ARVALID;
    logic [2:0]             ARPROT;
    logic                   ARREADY;

    logic [AXI_DWIDTH-1:0]  RDATA;
    logic                   RVALID;
    logic                   RREADY;
    logic [1:0]             RRESP;
   
    modport slave(
        input   AWADDR,
        input   AWVALID,
        input   AWPROT,
        output  AWREADY,

        input   WDATA,
        input   WVALID,
        output  WREADY,
        input   WSTRB,

        input   BREADY,
        output  BRESP,
        output  BVALID,

        input   ARADDR,
        input   ARVALID,
        input   ARPROT,
        output  ARREADY,

        output  RDATA,
        output  RVALID,
        input   RREADY,
        input   RRESP,

        input   clk,
        input   rst_n
    );
    
   
    modport master (
        output  AWADDR,
        output  AWVALID,
        output  AWPROT,
        input   AWREADY,

        output  WDATA,
        output  WVALID,
        input   WREADY,
        output  WSTRB,

        output  BREADY,
        input   BRESP,
        input   BVALID,

        output  ARADDR,
        output  ARVALID,
        output  ARPROT,
        input   ARREADY,

        input   RDATA,
        input   RVALID,
        output  RREADY,
        output  RRESP,

        input   clk,
        input   rst_n
    );
   
    modport test (
        output  AWADDR,
        output  AWVALID,
        output  AWPROT,
        input   AWREADY,

        output  WDATA,
        output  WVALID,
        input   WREADY,
        output  WSTRB,

        output  BREADY,
        input   BRESP,
        input   BVALID,

        output  ARADDR,
        output  ARVALID,
        output  ARPROT,
        input   ARREADY,

        input   RDATA,
        input   RVALID,
        output  RREADY,
        output  RRESP,

        input   clk,
        input   rst_n
    );
endinterface: axil_if
