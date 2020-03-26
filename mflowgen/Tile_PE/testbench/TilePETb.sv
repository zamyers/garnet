`define CLK_PERIOD 10
`define ASSIGNMENT_DELAY 0.5
`define FINISH_TIME 425400
`define NUM_TEST_VECTORS 8508

`define T0_EAST_B16 15:0
`define T0_EAST_B1 16
`define T0_NORTH_B16 47:32
`define T0_NORTH_B1 48
`define T0_SOUTH_B16 79:64
`define T0_SOUTH_B1 80
`define T0_WEST_B16 111:96
`define T0_WEST_B1 112
`define T1_EAST_B16 143:128
`define T1_EAST_B1 144
`define T1_NORTH_B16 175:160
`define T1_NORTH_B1 176
`define T1_SOUTH_B16 207:192
`define T1_SOUTH_B1 208
`define T1_WEST_B16 239:224
`define T1_WEST_B1 240
`define T2_EAST_B16 271:256
`define T2_EAST_B1 272
`define T2_NORTH_B16 303:288
`define T2_NORTH_B1 304
`define T2_SOUTH_B16 335:320
`define T2_SOUTH_B1 336
`define T2_WEST_B16 367:352
`define T2_WEST_B1 368
`define T3_EAST_B16 399:384
`define T3_EAST_B1 400
`define T3_NORTH_B16 431:416
`define T3_NORTH_B1 432
`define T3_SOUTH_B16 463:448
`define T3_SOUTH_B1 464
`define T3_WEST_B16 495:480
`define T3_WEST_B1 496
`define T4_EAST_B16 527:512
`define T4_EAST_B1 528
`define T4_NORTH_B16 559:544
`define T4_NORTH_B1 560
`define T4_SOUTH_B16 591:576
`define T4_SOUTH_B1 592
`define T4_WEST_B16 623:608
`define T4_WEST_B1 624
`define CONFIG_CONFIG_ADDR 671:640
`define CONFIG_CONFIG_DATA 703:672
`define CONFIG_READ 704
`define CONFIG_WRITE 720
`define READ_CONFIG_DATA_IN 767:736
`define RESET 768
`define STALL 784
`define TILE_ID 815:800


module TilePETb;

    localparam ADDR_WIDTH = $clog2(`NUM_TEST_VECTORS);
   
    reg [ADDR_WIDTH - 1 : 0] test_vec_addr;
 
    reg [815 : 0] test_vectors [`NUM_TEST_VECTORS - 1 : 0];
    reg [815 : 0] test_vector;
   
    wire  [15:0] SB_T0_EAST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T0_EAST_B16];
    wire  [0:0]  SB_T0_EAST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T0_EAST_B1];
    wire [0:0]  SB_T0_EAST_SB_OUT_B1;
    wire [15:0] SB_T0_EAST_SB_OUT_B16;
    wire  [15:0] SB_T0_NORTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T0_NORTH_B16];
    wire  [0:0]  SB_T0_NORTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T0_NORTH_B1];
    wire [0:0]  SB_T0_NORTH_SB_OUT_B1;
    wire [15:0] SB_T0_NORTH_SB_OUT_B16;
    wire  [15:0] SB_T0_SOUTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T0_SOUTH_B16];
    wire  [0:0]  SB_T0_SOUTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T0_SOUTH_B1];
    wire [0:0]  SB_T0_SOUTH_SB_OUT_B1;
    wire [15:0] SB_T0_SOUTH_SB_OUT_B16;
    wire  [15:0] SB_T0_WEST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T0_WEST_B16];
    wire  [0:0]  SB_T0_WEST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T0_WEST_B1];
    wire [0:0]  SB_T0_WEST_SB_OUT_B1;
    wire [15:0] SB_T0_WEST_SB_OUT_B16;
    wire  [15:0] SB_T1_EAST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T1_EAST_B16];
    wire  [0:0]  SB_T1_EAST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T1_EAST_B1];
    wire [0:0]  SB_T1_EAST_SB_OUT_B1;
    wire [15:0] SB_T1_EAST_SB_OUT_B16;
    wire  [15:0] SB_T1_NORTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T1_NORTH_B16];
    wire  [0:0]  SB_T1_NORTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T1_NORTH_B1];
    wire [0:0]  SB_T1_NORTH_SB_OUT_B1;
    wire [15:0] SB_T1_NORTH_SB_OUT_B16;
    wire  [15:0] SB_T1_SOUTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T1_SOUTH_B16];
    wire  [0:0]  SB_T1_SOUTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T1_SOUTH_B1];
    wire [0:0]  SB_T1_SOUTH_SB_OUT_B1;
    wire [15:0] SB_T1_SOUTH_SB_OUT_B16;
    wire  [15:0] SB_T1_WEST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T1_WEST_B16];
    wire  [0:0]  SB_T1_WEST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T1_WEST_B1];
    wire [0:0]  SB_T1_WEST_SB_OUT_B1;
    wire [15:0] SB_T1_WEST_SB_OUT_B16;
    wire  [15:0] SB_T2_EAST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T2_EAST_B16];
    wire  [0:0]  SB_T2_EAST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T2_EAST_B1];
    wire [0:0]  SB_T2_EAST_SB_OUT_B1;
    wire [15:0] SB_T2_EAST_SB_OUT_B16;
    wire  [15:0] SB_T2_NORTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T2_NORTH_B16];
    wire  [0:0]  SB_T2_NORTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T2_NORTH_B1];
    wire [0:0]  SB_T2_NORTH_SB_OUT_B1;
    wire [15:0] SB_T2_NORTH_SB_OUT_B16;
    wire  [15:0] SB_T2_SOUTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T2_SOUTH_B16];
    wire  [0:0]  SB_T2_SOUTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T2_SOUTH_B1];
    wire [0:0]  SB_T2_SOUTH_SB_OUT_B1;
    wire [15:0] SB_T2_SOUTH_SB_OUT_B16;
    wire  [15:0] SB_T2_WEST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T2_WEST_B16];
    wire  [0:0]  SB_T2_WEST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T2_WEST_B1];
    wire [0:0]  SB_T2_WEST_SB_OUT_B1;
    wire [15:0] SB_T2_WEST_SB_OUT_B16;
    wire  [15:0] SB_T3_EAST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T3_EAST_B16];
    wire  [0:0]  SB_T3_EAST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T3_EAST_B1];
    wire [0:0]  SB_T3_EAST_SB_OUT_B1;
    wire [15:0] SB_T3_EAST_SB_OUT_B16;
    wire  [15:0] SB_T3_NORTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T3_NORTH_B16];
    wire  [0:0]  SB_T3_NORTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T3_NORTH_B1];
    wire [0:0]  SB_T3_NORTH_SB_OUT_B1;
    wire [15:0] SB_T3_NORTH_SB_OUT_B16;
    wire  [15:0] SB_T3_SOUTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T3_SOUTH_B16];
    wire  [0:0]  SB_T3_SOUTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T3_SOUTH_B1];
    wire [0:0]  SB_T3_SOUTH_SB_OUT_B1;
    wire [15:0] SB_T3_SOUTH_SB_OUT_B16;
    wire  [15:0] SB_T3_WEST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T3_WEST_B16];
    wire  [0:0]  SB_T3_WEST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T3_WEST_B1];
    wire [0:0]  SB_T3_WEST_SB_OUT_B1;
    wire [15:0] SB_T3_WEST_SB_OUT_B16;
    wire  [15:0] SB_T4_EAST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T4_EAST_B16];
    wire  [0:0]  SB_T4_EAST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T4_EAST_B1];
    wire [0:0]  SB_T4_EAST_SB_OUT_B1;
    wire [15:0] SB_T4_EAST_SB_OUT_B16;
    wire  [15:0] SB_T4_NORTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T4_NORTH_B16];
    wire  [0:0]  SB_T4_NORTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T4_NORTH_B1];
    wire [0:0]  SB_T4_NORTH_SB_OUT_B1;
    wire [15:0] SB_T4_NORTH_SB_OUT_B16;
    wire  [15:0] SB_T4_SOUTH_SB_IN_B16_0 = test_vectors[test_vec_addr][`T4_SOUTH_B16];
    wire  [0:0]  SB_T4_SOUTH_SB_IN_B1_0 = test_vectors[test_vec_addr][`T4_SOUTH_B1];
    wire [0:0]  SB_T4_SOUTH_SB_OUT_B1;
    wire [15:0] SB_T4_SOUTH_SB_OUT_B16;
    wire  [15:0] SB_T4_WEST_SB_IN_B16_0 = test_vectors[test_vec_addr][`T4_WEST_B16];
    wire  [0:0]  SB_T4_WEST_SB_IN_B1_0 = test_vectors[test_vec_addr][`T4_WEST_B1];
    wire [0:0]  SB_T4_WEST_SB_OUT_B1;
    wire [15:0] SB_T4_WEST_SB_OUT_B16;
    reg         clk;
    wire        clk_out;
    reg         clk_pass_through;
    wire        clk_pass_through_out;
    wire [31:0] config_config_addr = test_vectors[test_vec_addr][`CONFIG_CONFIG_ADDR];
    wire [31:0] config_config_data = test_vectors[test_vec_addr][`CONFIG_CONFIG_DATA];
    wire [31:0] config_out_config_addr;
    wire [31:0] config_out_config_data;
    wire [0:0]  config_out_read;
    wire [0:0]  config_out_write;
    wire [0:0]  config_read = test_vectors[test_vec_addr][`CONFIG_READ];
    wire [0:0]  config_write = test_vectors[test_vec_addr][`CONFIG_WRITE];
    wire [8:0]  hi;
    wire [7:0]  lo;
    wire [31:0] read_config_data;
    wire [31:0] read_config_data_in = test_vectors[test_vec_addr][`READ_CONFIG_DATA_IN];
    wire        reset = test_vectors[test_vec_addr][`RESET];
    wire        reset_out;
    wire [0:0]  stall = test_vectors[test_vec_addr][`STALL];
    wire [0:0]  stall_out;
    wire [15:0] tile_id = test_vectors[test_vec_addr][`TILE_ID];

    Tile_PE Tile_PE_inst (
        .SB_T0_EAST_SB_IN_B16_0(SB_T0_EAST_SB_IN_B16_0),
        .SB_T0_EAST_SB_IN_B1_0(SB_T0_EAST_SB_IN_B1_0),
        .SB_T0_EAST_SB_OUT_B1(SB_T0_EAST_SB_OUT_B1),
        .SB_T0_EAST_SB_OUT_B16(SB_T0_EAST_SB_OUT_B16),
        .SB_T0_NORTH_SB_IN_B16_0(SB_T0_NORTH_SB_IN_B16_0),
        .SB_T0_NORTH_SB_IN_B1_0(SB_T0_NORTH_SB_IN_B1_0),
        .SB_T0_NORTH_SB_OUT_B1(SB_T0_NORTH_SB_OUT_B1),
        .SB_T0_NORTH_SB_OUT_B16(SB_T0_NORTH_SB_OUT_B16),
        .SB_T0_SOUTH_SB_IN_B16_0(SB_T0_SOUTH_SB_IN_B16_0),
        .SB_T0_SOUTH_SB_IN_B1_0(SB_T0_SOUTH_SB_IN_B1_0),
        .SB_T0_SOUTH_SB_OUT_B1(SB_T0_SOUTH_SB_OUT_B1),
        .SB_T0_SOUTH_SB_OUT_B16(SB_T0_SOUTH_SB_OUT_B16),
        .SB_T0_WEST_SB_IN_B16_0(SB_T0_WEST_SB_IN_B16_0),
        .SB_T0_WEST_SB_IN_B1_0(SB_T0_WEST_SB_IN_B1_0),
        .SB_T0_WEST_SB_OUT_B1(SB_T0_WEST_SB_OUT_B1),
        .SB_T0_WEST_SB_OUT_B16(SB_T0_WEST_SB_OUT_B16),
        .SB_T1_EAST_SB_IN_B16_0(SB_T1_EAST_SB_IN_B16_0),
        .SB_T1_EAST_SB_IN_B1_0(SB_T1_EAST_SB_IN_B1_0),
        .SB_T1_EAST_SB_OUT_B1(SB_T1_EAST_SB_OUT_B1),
        .SB_T1_EAST_SB_OUT_B16(SB_T1_EAST_SB_OUT_B16),
        .SB_T1_NORTH_SB_IN_B16_0(SB_T1_NORTH_SB_IN_B16_0),
        .SB_T1_NORTH_SB_IN_B1_0(SB_T1_NORTH_SB_IN_B1_0),
        .SB_T1_NORTH_SB_OUT_B1(SB_T1_NORTH_SB_OUT_B1),
        .SB_T1_NORTH_SB_OUT_B16(SB_T1_NORTH_SB_OUT_B16),
        .SB_T1_SOUTH_SB_IN_B16_0(SB_T1_SOUTH_SB_IN_B16_0),
        .SB_T1_SOUTH_SB_IN_B1_0(SB_T1_SOUTH_SB_IN_B1_0),
        .SB_T1_SOUTH_SB_OUT_B1(SB_T1_SOUTH_SB_OUT_B1),
        .SB_T1_SOUTH_SB_OUT_B16(SB_T1_SOUTH_SB_OUT_B16),
        .SB_T1_WEST_SB_IN_B16_0(SB_T1_WEST_SB_IN_B16_0),
        .SB_T1_WEST_SB_IN_B1_0(SB_T1_WEST_SB_IN_B1_0),
        .SB_T1_WEST_SB_OUT_B1(SB_T1_WEST_SB_OUT_B1),
        .SB_T1_WEST_SB_OUT_B16(SB_T1_WEST_SB_OUT_B16),
        .SB_T2_EAST_SB_IN_B16_0(SB_T2_EAST_SB_IN_B16_0),
        .SB_T2_EAST_SB_IN_B1_0(SB_T2_EAST_SB_IN_B1_0),
        .SB_T2_EAST_SB_OUT_B1(SB_T2_EAST_SB_OUT_B1),
        .SB_T2_EAST_SB_OUT_B16(SB_T2_EAST_SB_OUT_B16),
        .SB_T2_NORTH_SB_IN_B16_0(SB_T2_NORTH_SB_IN_B16_0),
        .SB_T2_NORTH_SB_IN_B1_0(SB_T2_NORTH_SB_IN_B1_0),
        .SB_T2_NORTH_SB_OUT_B1(SB_T2_NORTH_SB_OUT_B1),
        .SB_T2_NORTH_SB_OUT_B16(SB_T2_NORTH_SB_OUT_B16),
        .SB_T2_SOUTH_SB_IN_B16_0(SB_T2_SOUTH_SB_IN_B16_0),
        .SB_T2_SOUTH_SB_IN_B1_0(SB_T2_SOUTH_SB_IN_B1_0),
        .SB_T2_SOUTH_SB_OUT_B1(SB_T2_SOUTH_SB_OUT_B1),
        .SB_T2_SOUTH_SB_OUT_B16(SB_T2_SOUTH_SB_OUT_B16),
        .SB_T2_WEST_SB_IN_B16_0(SB_T2_WEST_SB_IN_B16_0),
        .SB_T2_WEST_SB_IN_B1_0(SB_T2_WEST_SB_IN_B1_0),
        .SB_T2_WEST_SB_OUT_B1(SB_T2_WEST_SB_OUT_B1),
        .SB_T2_WEST_SB_OUT_B16(SB_T2_WEST_SB_OUT_B16),
        .SB_T3_EAST_SB_IN_B16_0(SB_T3_EAST_SB_IN_B16_0),
        .SB_T3_EAST_SB_IN_B1_0(SB_T3_EAST_SB_IN_B1_0),
        .SB_T3_EAST_SB_OUT_B1(SB_T3_EAST_SB_OUT_B1),
        .SB_T3_EAST_SB_OUT_B16(SB_T3_EAST_SB_OUT_B16),
        .SB_T3_NORTH_SB_IN_B16_0(SB_T3_NORTH_SB_IN_B16_0),
        .SB_T3_NORTH_SB_IN_B1_0(SB_T3_NORTH_SB_IN_B1_0),
        .SB_T3_NORTH_SB_OUT_B1(SB_T3_NORTH_SB_OUT_B1),
        .SB_T3_NORTH_SB_OUT_B16(SB_T3_NORTH_SB_OUT_B16),
        .SB_T3_SOUTH_SB_IN_B16_0(SB_T3_SOUTH_SB_IN_B16_0),
        .SB_T3_SOUTH_SB_IN_B1_0(SB_T3_SOUTH_SB_IN_B1_0),
        .SB_T3_SOUTH_SB_OUT_B1(SB_T3_SOUTH_SB_OUT_B1),
        .SB_T3_SOUTH_SB_OUT_B16(SB_T3_SOUTH_SB_OUT_B16),
        .SB_T3_WEST_SB_IN_B16_0(SB_T3_WEST_SB_IN_B16_0),
        .SB_T3_WEST_SB_IN_B1_0(SB_T3_WEST_SB_IN_B1_0),
        .SB_T3_WEST_SB_OUT_B1(SB_T3_WEST_SB_OUT_B1),
        .SB_T3_WEST_SB_OUT_B16(SB_T3_WEST_SB_OUT_B16),
        .SB_T4_EAST_SB_IN_B16_0(SB_T4_EAST_SB_IN_B16_0),
        .SB_T4_EAST_SB_IN_B1_0(SB_T4_EAST_SB_IN_B1_0),
        .SB_T4_EAST_SB_OUT_B1(SB_T4_EAST_SB_OUT_B1),
        .SB_T4_EAST_SB_OUT_B16(SB_T4_EAST_SB_OUT_B16),
        .SB_T4_NORTH_SB_IN_B16_0(SB_T4_NORTH_SB_IN_B16_0),
        .SB_T4_NORTH_SB_IN_B1_0(SB_T4_NORTH_SB_IN_B1_0),
        .SB_T4_NORTH_SB_OUT_B1(SB_T4_NORTH_SB_OUT_B1),
        .SB_T4_NORTH_SB_OUT_B16(SB_T4_NORTH_SB_OUT_B16),
        .SB_T4_SOUTH_SB_IN_B16_0(SB_T4_SOUTH_SB_IN_B16_0),
        .SB_T4_SOUTH_SB_IN_B1_0(SB_T4_SOUTH_SB_IN_B1_0),
        .SB_T4_SOUTH_SB_OUT_B1(SB_T4_SOUTH_SB_OUT_B1),
        .SB_T4_SOUTH_SB_OUT_B16(SB_T4_SOUTH_SB_OUT_B16),
        .SB_T4_WEST_SB_IN_B16_0(SB_T4_WEST_SB_IN_B16_0),
        .SB_T4_WEST_SB_IN_B1_0(SB_T4_WEST_SB_IN_B1_0),
        .SB_T4_WEST_SB_OUT_B1(SB_T4_WEST_SB_OUT_B1),
        .SB_T4_WEST_SB_OUT_B16(SB_T4_WEST_SB_OUT_B16),
        .clk(clk),
        .clk_out(clk_out),
        .clk_pass_through(clk_pass_through),
        .clk_pass_through_out(clk_pass_through_out),
        .config_config_addr(config_config_addr),
        .config_config_data(config_config_data),
        .config_out_config_addr(config_out_config_addr),
        .config_out_config_data(config_out_config_data),
        .config_out_read(config_out_read),
        .config_out_write(config_out_write),
        .config_read(config_read),
        .config_write(config_write),
        .hi(hi),
        .lo(lo),
        .read_config_data(read_config_data),
        .read_config_data_in(read_config_data_in),
        .reset(reset),
        .reset_out(reset_out),
        .stall(stall),
        .stall_out(stall_out),
        .tile_id(tile_id)
    );
 
    always #(`CLK_PERIOD/2) clk =~clk;
    
    initial begin
      $readmemh("test_vectors.txt", test_vectors);
      clk <= 0;
      test_vec_addr <= 0;
    end
  
    always @ (posedge clk) begin
      //if (!reset) begin
        test_vec_addr <= # `ASSIGNMENT_DELAY (test_vec_addr + 1); // Don't change the inputs right after the clock edge because that will cause problems in gate level simulation
        test_vector <= test_vectors[test_vec_addr];
      //end
    end
  
    initial begin
      $vcdplusfile("dump.vcd");
      $vcdplusmemon();
      $vcdpluson(0, TilePETb);
      $set_toggle_region(TilePETb);
      $toggle_start();
      #(`FINISH_TIME);
      $toggle_stop();
      $toggle_report("outputs/run.saif", 10e-9, TilePETb);
      $finish(2);
    end

endmodule 
