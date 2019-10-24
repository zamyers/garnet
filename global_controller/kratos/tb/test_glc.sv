/*=============================================================================
** Module: test_glc.sv
** Description:
**              test file for glc
** Author: Taeyoung Kong
** Change history:  10/22/2019 - Implement first version of testbench
**===========================================================================*/
program automatic test_glc(interface ifc);
    
    // some variables to control the test
    int                 file_des;
    int                 config_count=0;
    enum {reading, writing, other, glb_reading, glb_writing, glb_sram_reading, glb_sram_writing} state = other; 

    axi_driver axi_driver;
    axi_trans_t axi_trans;

    //Property assertion
    assert property (!(top.dut.read && top.dut.write)) else $error("read and write both asserted");
    assert property (!((state==reading) && (top.dut.write))) else $error("write asserted while reading");
    assert property (!((state==glb_reading) && (top.dut.glb_write))) else $error("glb write asserted while glb reading");
    assert property (!((state==glb_sram_reading) && (top.dut.glb_sram_write))) else $error("glb sram write asserted while glb sram reading");
    assert property (!((state==writing) && (top.dut.read))) else $error("read asserted while writing");
    assert property (!((state==glb_writing) && (top.dut.glb_read))) else $error("glb read asserted while glb writing");
    assert property (!((state==glb_sram_writing) && (top.dut.glb_sram_read))) else $error("glb sram read asserted while glb sram writing");
    assert property (!((state==other) && (top.dut.read | top.dut.write))) else $error("r/w asserted while not doing either");
    
    //Add assertions for read sequence
    //At some point during the read, the output address must equal the input address
    //and the read signal must be asserted
    sequence begin_read;
           ~(state==reading) ##1 (state==reading);
    endsequence
    
    sequence assert_read;
           ##[0:400] ((state==reading) && (top.dut.read==1)
           && (((gc_interface==axi4) && (top.dut.config_addr_out==top.dut.int_cgra_config_addr))
           || ((gc_interface==jtag) && (top.dut.config_addr_out==jtag_trans.addr))));
    endsequence
    
    property correct_read;
           @(posedge ifc.Clk)
           begin_read |-> assert_read;
    endproperty
       
    assert property(correct_read) else $error("incorrect read sequence");
    
    //Add assertions for write sequence
    //At some point during the write, the output address must equal the input address,
    //output data must equal input data, and the write signal must be asserted
    sequence begin_write;
           ~(state==writing) ##1 (state==writing);
    endsequence
    
    sequence assert_write;
           ##[0:800] ((state==writing) && (top.dut.write==1)
           && (((gc_interface==jtag) && (top.dut.config_addr_out==jtag_trans.addr) && (top.dut.config_data_out==jtag_trans.data_in))
           || ((gc_interface==axi4) && (top.dut.config_addr_out==top.dut.int_cgra_config_addr) && (top.dut.config_data_out==axi_trans.data_in))));
    endsequence
    
    property correct_write;
           @(posedge ifc.Clk)
           begin_write |-> assert_write;
    endproperty
       
    assert property(correct_write) else $error("incorrect write sequence");
    
    //Add assertions for glb read sequence
    //At some point during the read, the output address must equal the input address
    //and the read signal must be asserted
    sequence begin_glb_read;
           ~(state==glb_reading) ##1 (state==glb_reading);
    endsequence
    
    sequence assert_glb_read;
           ##[0:400] ((state==glb_reading) && (top.dut.glb_read==1)
           && (((gc_interface==jtag) && (top.dut.glb_config_addr_out==jtag_trans.addr))
           || ((gc_interface==axi4) && (top.dut.glb_config_addr_out==axi_trans.addr))));
    endsequence
    
    property correct_glb_read;
           @(posedge ifc.Clk)
           begin_glb_read |-> assert_glb_read;
    endproperty
       
    assert property(correct_glb_read) else $error("incorrect glb read sequence");

    //Add assertions for glb write sequence
    //At some point during the write, the output address must equal the input address,
    //output data must equal input data, and the write signal must be asserted
    sequence begin_glb_write;
           ~(state==glb_writing) ##1 (state==glb_writing);
    endsequence
    
    sequence assert_glb_write;
           ##[0:800] ((state==glb_writing) && (top.dut.glb_write==1)
           && (((gc_interface==jtag) && (top.dut.glb_config_addr_out==jtag_trans.addr) && (top.dut.glb_config_data_out==jtag_trans.data_in))
           || ((gc_interface==axi4) && (top.dut.glb_config_addr_out==axi_trans.addr) && (top.dut.glb_config_data_out==axi_trans.data_in))));
    endsequence
    
    property correct_glb_write;
           @(posedge ifc.Clk)
           begin_glb_write |-> assert_glb_write;
    endproperty
       
    assert property(correct_glb_write) else $error("incorrect glb write sequence");

    sequence begin_glb_sram_read;
           ~(state==glb_sram_reading) ##1 (state==glb_sram_reading);
    endsequence
    
    sequence assert_glb_sram_read;
           ##[0:400] ((state==glb_sram_reading) && (top.dut.glb_sram_read==1) 
           && (((gc_interface==jtag) && (top.dut.glb_sram_config_addr_out==jtag_trans.addr))
           || ((gc_interface==axi4) && (top.dut.glb_sram_config_addr_out==top.dut.int_glb_sram_config_addr))));
    endsequence
    
    property correct_glb_sram_read;
           @(posedge ifc.Clk)
           begin_glb_sram_read |-> assert_glb_sram_read;
    endproperty
       
    assert property(correct_glb_sram_read) else $error("incorrect glb read sequence");

    //Add assertions for glb write sequence
    //At some point during the write, the output address must equal the input address,
    //output data must equal input data, and the write signal must be asserted
    sequence begin_glb_sram_write;
           ~(state==glb_sram_writing) ##1 (state==glb_sram_writing);
    endsequence
    
    sequence assert_glb_sram_write;
           ##[0:800] ((state==glb_sram_writing) && (top.dut.glb_sram_write==1)
           && (((gc_interface==jtag) && (top.dut.glb_sram_config_addr_out==jtag_trans.addr) && (top.dut.glb_sram_config_data_out==jtag_trans.data_in))
           || ((gc_interface==axi4) && (top.dut.glb_sram_config_addr_out==top.dut.int_glb_sram_config_addr) && (top.dut.glb_sram_config_data_out==axi_trans.data_in))));
    endsequence
    
    property correct_glb_sram_write;
           @(posedge ifc.Clk)
           begin_glb_sram_write |-> assert_glb_sram_write;
    endproperty
       
    assert property(correct_glb_sram_write) else $error("incorrect glb write sequence");

    // run_test task
    task run_test; begin
    logic [31:0] addr;
    logic [31:0] data;

    
    @(posedge ifc.Clk);
    switch_clk(0); // Switch to slow clk

    @(posedge ifc.Clk);
    switch_clk(1); // Switch to fast clk

    
    @(posedge ifc.Clk);
    write_gc_reg(wr_rd_delay_reg, 32'd10);
    repeat(2) jdrv.Next_tck();
    check_register(top.dut.rd_delay_reg,jtag_trans.data_in); 

    @(posedge ifc.Clk);
    write_config();

    @(posedge ifc.Clk);
    read_config(); 
    
    @(posedge ifc.Clk);
    write_gc_reg(wr_delay_sel_reg, 32'b1);
    repeat(2) jdrv.Next_tck();
    check_register(top.dut.delay_sel, jtag_trans.data_in);
    
    @(posedge ifc.Clk);
    read_gc_reg(rd_delay_sel_reg);
    check_register(top.dut.delay_sel, jtag_trans.data_out);

    @(posedge ifc.Clk);
    write_gc_reg(wr_rd_delay_reg, 32'd10);
    repeat(2) jdrv.Next_tck();
    check_register(top.dut.rd_delay_reg,jtag_trans.data_in); 

    @(posedge ifc.Clk);
    read_config(); 
    
    @(posedge ifc.Clk);
    read_gc_reg(rd_rd_delay_reg);
    check_register(top.dut.rd_delay_reg,jtag_trans.data_out);   

    @(posedge ifc.Clk);
    read_config();
    
    @(posedge ifc.Clk);
    switch_clk(1); // Switch to fast clk
 
    @(posedge ifc.Clk);
    read_gc_reg(read_clk_domain);
    check_register(top.dut.sys_clk_activated,jtag_trans.data_out);

    @(posedge ifc.Clk);
    switch_clk(0); // Switch to slow clock
 
    @(posedge ifc.Clk);
    read_gc_reg(read_clk_domain);
    check_register(top.dut.sys_clk_activated,jtag_trans.data_out);
    
    @(posedge ifc.Clk);
    write_gc_reg(wr_delay_sel_reg,32'b10);
    repeat(2) jdrv.Next_tck();
    check_register(top.dut.delay_sel,jtag_trans.data_in);

    @(posedge ifc.Clk);
    switch_clk(1); //switch to fast clock 

    @(posedge ifc.Clk);
    read_gc_reg(read_clk_domain);
    check_register(top.dut.sys_clk_activated,jtag_trans.data_out);
    
    @(posedge ifc.Clk);
    write_gc_reg(write_stall,32'h1);
    repeat(2) jdrv.Next_tck();
    check_register(top.dut.cgra_stalled,jtag_trans.data_in);
    
    @(posedge ifc.Clk);
    read_gc_reg(read_stall);
    check_register(top.dut.cgra_stalled,jtag_trans.data_out);
    
    @(posedge ifc.Clk);
    jtag_trans.op = advance_clk;
    jtag_trans.data_in = 32'd6;
    jtag_trans.addr = 32'b1010;
    jtag_trans.done = 0;
    jdrv.Send(jtag_trans);
    $fdisplay(file_des,"%t: %m: Trans 6 (advance_clk):  Address to GC=%d, Data to GC=%d",    
            $time, ifc.config_addr_gc2cgra, ifc.config_data_gc2cgra,1);
    //TODO: TEST CLOCK ADVANCE
 
    @(posedge ifc.Clk);
    write_gc_reg(write_stall,32'd0);
    check_register(top.dut.cgra_stalled,jtag_trans.data_in);    
    
    @(posedge ifc.Clk);
    read_config();
 
    @(posedge ifc.Clk);
    read_gc_reg(wr_A050);
    check_register(32'hA050,jtag_trans.data_out);
    

    @(posedge ifc.Clk);
    write_gc_reg(wr_TST, 32'd123);
    repeat(2) jdrv.Next_tck();
    check_register(top.dut.TST,jtag_trans.data_in);
 
    @(posedge ifc.Clk);
    read_gc_reg(rd_TST);
    check_register(top.dut.TST,jtag_trans.data_out);   
    
    @(posedge ifc.Clk);
    jtag_trans.op = global_reset;
    jtag_trans.data_in = 32'd50;
    jtag_trans.done = 0;
    jdrv.Send(jtag_trans);
    $fdisplay(file_des,"%t: %m: Trans 14 (global_reset):  Address to GC=%d, Data to GC=%d",  
            $time, ifc.config_addr_gc2cgra, ifc.config_data_gc2cgra);
    check_register(top.dut.reset_out,1);
    //TODO: CHECK RESET ASSERTION LENGTH

    @(posedge ifc.Clk);
    write_glb_config(32'd1234, 32'd5678);

    @(posedge ifc.Clk);
    read_glb_config(32'd1234);

    @(posedge ifc.Clk);
    write_glb_sram_config(32'd9876, 32'd5432);

    @(posedge ifc.Clk);
    read_glb_sram_config(32'd9876);

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CGRA_START, 1);
    check_register(top.dut.int_cgra_start, 1);

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CGRA_START, 0);
    check_register(top.dut.int_cgra_start, 0);

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CGRA_START, 1);
    check_register(top.dut.int_cgra_start, 1);

    // Check whether cgra_start is cleared on cgra_done_pulse
    repeat(10) jdrv.Next_tck();
    ifc.cgra_done_pulse = 1;
    @(posedge ifc.Clk);
    ifc.cgra_done_pulse = 0;
    repeat(10) jdrv.Next_tck();
    check_register(top.dut.int_cgra_start, 0);

    @(posedge ifc.Clk);
    read_cgra_ctrl_reg(AXI_ADDR_CGRA_START);
    check_register(top.dut.int_cgra_start, jtag_trans.data_out);   

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CGRA_AUTO_RESTART, 1);
    check_register(top.dut.int_cgra_auto_restart, 0);

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CGRA_START, 1);
    check_register(top.dut.int_cgra_start, 1);

    // Check whether cgra_start is cleared on cgra_done_pulse
    repeat(10) jdrv.Next_tck();
    ifc.cgra_done_pulse = 1;
    @(posedge ifc.Clk);
    ifc.cgra_done_pulse = 0;
    repeat(10) jdrv.Next_tck();
    // it auto starts.
    check_register(top.dut.int_cgra_start, 0);

    repeat(10) jdrv.Next_tck();
    ifc.cgra_done_pulse = 1;
    @(posedge ifc.Clk);
    ifc.cgra_done_pulse = 0;
    repeat(10) jdrv.Next_tck();
    check_register(top.dut.int_cgra_start, 0);

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CGRA_AUTO_RESTART, 1);
    check_register(top.dut.int_cgra_auto_restart, 0);


    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CONFIG_START, 1);
    check_register(top.dut.int_config_start, 1);

    @(posedge ifc.Clk);
    read_cgra_ctrl_reg(AXI_ADDR_CONFIG_START);
    check_register(top.dut.int_config_start, jtag_trans.data_out);   

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CONFIG_START, 0);
    check_register(top.dut.int_config_start, 0);

    @(posedge ifc.Clk);
    read_cgra_ctrl_reg(AXI_ADDR_CONFIG_START);
    check_register(top.dut.int_config_start, jtag_trans.data_out);   

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CONFIG_START, 1);
    check_register(top.dut.int_config_start, 1);

    repeat(10) jdrv.Next_tck();
    ifc.config_done_pulse = 1;
    @(posedge ifc.Clk);
    ifc.config_done_pulse = 0;
    repeat(10) jdrv.Next_tck();
    check_register(top.dut.int_config_start, 0);

    // cgra_done interrupt enable
    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_IER, 1);
    check_register(top.dut.int_ier, 1);

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CGRA_START, 1);
    check_register(top.dut.int_cgra_start, 1);

    // Check whether cgra_start is cleared on cgra_done_pulse
    repeat(20) jdrv.Next_tck();
    ifc.cgra_done_pulse = 1;
    @(posedge ifc.Clk);
    ifc.cgra_done_pulse = 0;
    repeat(20) jdrv.Next_tck();
    check_register(top.dut.int_cgra_start, 0);

    // Toggle ISR
    check_register(top.dut.int_isr[0], 1);
    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_ISR, 1);
    check_register(top.dut.int_isr[0], 0);

    // config_done interrupt enable
    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_IER, 2);
    check_register(top.dut.int_ier[1], 1);

    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_CONFIG_START, 1);
    check_register(top.dut.int_config_start, 1);

    // Check whether config_start is cleared on config_done_pulse
    repeat(20) jdrv.Next_tck();
    ifc.config_done_pulse = 1;
    @(posedge ifc.Clk);
    ifc.config_done_pulse = 0;
    repeat(20) jdrv.Next_tck();
    check_register(top.dut.int_config_start, 0);
    check_register(top.dut.interrupt, 1);

    // Toggle ISR
    check_register(top.dut.int_isr[1], 1);
    @(posedge ifc.Clk);
    write_cgra_ctrl_reg(AXI_ADDR_ISR, 2);
    check_register(top.dut.int_isr[1], 0);

    // AXI4 testing starts
    // axi4 config write
    @(posedge ifc.Clk);
    axi_write_config(32'hF0F0F000, 32'hF0F0F0F0);

    @(posedge ifc.Clk);
    axi_write_config(32'h1234, 32'h5678);

    // axi4 config read
    @(posedge ifc.Clk);
    axi_read_config(32'hFFFFFF00, 32'hFFFFFFFF);

    // axi4 glb config write
    @(posedge ifc.Clk);
    axi_write_glb_config(io_ctrl, 0, 4, 1);

    // axi4 glb config write
    @(posedge ifc.Clk);
    axi_write_glb_config(cfg_ctrl, 7, 3, 32'b1111);

    // axi4 glb config read
    @(posedge ifc.Clk);
    axi_read_glb_config(io_ctrl, 0, 4, 1);

    // axi4 glb sram config write
    @(posedge ifc.Clk);
    axi_write_glb_sram_config(32'd1234, 32'd2345);

    // axi4 glb sram config read
    @(posedge ifc.Clk);
    axi_read_glb_sram_config(32'd9876, 32'd2345);

    // axi4 write_TST
    @(posedge ifc.Clk);
    axi_write(axi_tst, 32'd1234);
    check_register(top.dut.TST, axi_trans.data_in);

    // axi4 read_TST
    @(posedge ifc.Clk);
    axi_read(axi_tst);
    check_register(top.dut.TST, axi_trans.data_out);

    // axi4 write_rd_delay
    @(posedge ifc.Clk);
    axi_write(axi_rd_delay, 32'd50);
    check_register(top.dut.rd_delay_reg, axi_trans.data_in);

    // axi4 read_rd_delay
    @(posedge ifc.Clk);
    axi_read(axi_rd_delay);
    check_register(top.dut.rd_delay_reg, axi_trans.data_out);

    // axi4 config read
    @(posedge ifc.Clk);
    axi_read_config(32'hFFFFFF00, 32'hFFFFFFFF);

    // axi4 write_reset
    @(posedge ifc.Clk);
    axi_write(axi_reset, 20);

    // axi4 write_cgra_start
    @(posedge ifc.Clk);
    axi_write(axi_cgra_start, 1);
    check_register(top.dut.int_cgra_start, 1);

    // Check whether cgra_start is cleared on cgra_done_pulse
    repeat(10) @(posedge ifc.Clk);
    ifc.cgra_done_pulse = 1;
    @(posedge ifc.Clk);
    ifc.cgra_done_pulse = 0;
    repeat(10) @(posedge ifc.Clk);
    check_register(top.dut.int_cgra_start, 0);

    // axi4 write_cgra_soft_reset_en
    @(posedge ifc.Clk);
    axi_write(axi_cgra_soft_reset_en, 1);
    check_register(top.dut.int_cgra_soft_reset_en, 1);

    // axi4 write_ier
    @(posedge ifc.Clk);
    axi_write(axi_ier, 2'b01);
    check_register(top.dut.int_ier, 2'b01);

    // axi4 write_cgra_auto_restart
    @(posedge ifc.Clk);
    axi_write(axi_cgra_auto_restart, 1);
    check_register(top.dut.int_cgra_auto_restart, 0);

    // axi4 write_cgra_start
    @(posedge ifc.Clk);
    axi_write(axi_cgra_start, 1);
    check_register(top.dut.int_cgra_start, 1);

    // Check whether cgra_start is cleared on cgra_done_pulse
    repeat(10) @(posedge ifc.Clk);
    ifc.cgra_done_pulse = 1;
    @(posedge ifc.Clk);
    ifc.cgra_done_pulse = 0;
    repeat(10) @(posedge ifc.Clk);
    // auto restart
    check_register(top.dut.int_cgra_start, 0);


    // Toggle ISR
    check_register(top.dut.int_isr[0], 1);
    @(posedge ifc.Clk);
    axi_write(axi_isr, 1);
    check_register(top.dut.int_isr[0], 0);

    // axi4 write_cgra_soft_reset_en
    @(posedge ifc.Clk);
    axi_write(axi_soft_reset_delay, 4);
    check_register(top.dut.int_soft_reset_delay, 4);

    // axi4 write_cgra_start
    @(posedge ifc.Clk);
    axi_write(axi_cgra_start, 1);
    check_register(top.dut.int_cgra_start, 1);

    // axi4 write_config_start
    @(posedge ifc.Clk);
    axi_write(axi_config_start, 1);
    check_register(top.dut.int_config_start, 1);

    // Check whether cgra_start is cleared on cgra_done_pulse
    repeat(10) @(posedge ifc.Clk);
    ifc.config_done_pulse = 1;
    @(posedge ifc.Clk);
    ifc.config_done_pulse = 0;
    repeat(10) @(posedge ifc.Clk);
    check_register(top.dut.int_config_start, 0);

    repeat(50) jdrv.Next_tck();
    end
    endtask // run_test


    /****************************************************************************
       * Control the simulation
       * *************************************************************************/
    initial begin
        $display("%t:\t********************Loading Arguments***********************",$time);
        init_test;
        fd = $fopen("test.log","w");
        
        $display("%t:\t*************************START*****************************",$time);
        @(negedge ifc.Reset);
        repeat (10) @(posedge ifc.Clk);
        run_test;
        repeat (10) @(posedge ifc.Clk);
        $display("%t:\t*************************FINISH****************************",$time);
        $fclose(fd);
        $finish(2);
    end
    
    task axi_write_config(int addr, int data);
    begin
        gc_interface = axi4;
        state = writing;
        config_count++;
        // first write to cgra_config_addr register
        axi_trans.addr = axi_cgra_config_addr;
        axi_trans.data_in = addr;
        axi_driver.axi_write(axi_trans.addr, axi_trans.data_in);

        axi_trans.addr = axi_cgra_config_data;
        axi_trans.data_in = data;
        axi_driver.axi_write(axi_trans.addr, axi_trans.data_in);
        axi_trans = axi_driver.GetResult();
        $fdisplay(file_des,"%t: %m: Trans %d (AXI4 write):  Address to CGRA=%d, Data to CGRA=%d",  
            $time, config_count, ifc.AWADDR, ifc.WDATA);
        repeat (500) @(posedge ifc.Clk); 
        state = other;
    end
    endtask

    task axi_read_config(int addr, int data);
    begin
        gc_interface = axi4;
        state = reading;
        config_count++;
        ifc.config_data_cgra2gc = data; //$urandom_range((2 ** 32)-1);

        axi_trans.addr = axi_cgra_config_addr;
        axi_trans.data_in = addr;
        axi_driver.axi_write(axi_trans.addr, axi_trans.data_in);

        axi_trans.addr = axi_cgra_config_data;
        axi_driver.axi_read(axi_trans.addr);
        axi_trans = axi_driver.GetResult();
        $fdisplay(file_des,"%t: %m: Trans %d (AXI4 Read):  Address to CGRA=%d, Data from CGRA=%d, Data Read=%d",  
            $time, config_count, ifc.ARADDR, top.dut.config_data_in, axi_trans.data_out);
        repeat (500) @(posedge ifc.Clk); 
        assert(top.dut.config_data_in == axi_trans.data_out);
        state = other;
    end
    endtask

    task axi_write_glb_config(tile_id _tile, bit[3:0] _feature, bit[3:0] _reg, int data);
    begin
        gc_interface = axi4;
        state = glb_writing;
        axi_trans.addr = {{_tile}, {_feature}, {_reg}, {2'b00}};
        axi_trans.data_in = data;
        config_count++;
        axi_driver.axi_write(axi_trans.addr, axi_trans.data_in);
        axi_trans = axi_driver.GetResult();
        $fdisplay(file_des,"%t: %m: Trans %d (AXI4 glb write):  Address to CGRA=%d, Data to CGRA=%d",  
            $time, config_count, ifc.AWADDR, ifc.WDATA);
        repeat (500) @(posedge ifc.Clk); 
        state = other;
    end
    endtask

    task axi_read_glb_config(tile_id _tile, bit[3:0] _feature, bit[3:0] _reg, int data);
    begin
        gc_interface = axi4;
        state = glb_reading;
        config_count++;
        ifc.glb_config_data_cgra2gc = data; //$urandom_range((2 ** 32)-1);
        axi_trans.addr = {{_tile}, {_feature}, {_reg}, {2'b00}};
        axi_driver.axi_read(axi_trans.addr);
        axi_trans = axi_driver.GetResult();
        $fdisplay(file_des,"%t: %m: Trans %d (AXI4 glb Read):  Address to CGRA=%d, Data from CGRA=%d, Data Read=%d",  
            $time, config_count, ifc.ARADDR, top.dut.glb_config_data_in, axi_trans.data_out);
        repeat (500) @(posedge ifc.Clk); 
        assert(top.dut.glb_config_data_in == axi_trans.data_out);
        state = other;
    end
    endtask

    task axi_write_glb_sram_config(int addr, int data);
    begin
        gc_interface = axi4;
        state = glb_sram_writing;
        config_count++;
        axi_trans.addr = axi_glb_sram_config_addr;
        axi_trans.data_in = addr;
        axi_driver.axi_write(axi_trans.addr, axi_trans.data_in);

        axi_trans.addr = axi_glb_sram_config_data;
        axi_trans.data_in = data;
        axi_driver.axi_write(axi_trans.addr, axi_trans.data_in);
        axi_trans = axi_driver.GetResult();
        $fdisplay(file_des,"%t: %m: Trans %d (AXI4 glb SRAM write):  Address to CGRA=%d, Data to CGRA=%d",  
            $time, config_count, ifc.AWADDR, ifc.WDATA);
        repeat (500) @(posedge ifc.Clk); 
        state = other;
    end
    endtask

    task axi_read_glb_sram_config(int addr, int data);
    begin
        gc_interface = axi4;
        state = glb_sram_reading;
        config_count++;
        ifc.glb_sram_config_data_cgra2gc = data; //$urandom_range((2 ** 32)-1);

        axi_trans.addr = axi_glb_sram_config_addr;
        axi_trans.data_in = addr;
        axi_driver.axi_write(axi_trans.addr, axi_trans.data_in);

        axi_trans.addr = axi_glb_sram_config_data;
        axi_driver.axi_read(axi_trans.addr);
        axi_trans = axi_driver.GetResult();
        $fdisplay(file_des,"%t: %m: Trans %d (AXI4glb SRAM  Read):  Address to CGRA=%d, Data from CGRA=%d, Data Read=%d",  
            $time, config_count, ifc.ARADDR, top.dut.glb_sram_config_data_in, axi_trans.data_out);
        assert(top.dut.glb_sram_config_data_in == axi_trans.data_out);
        repeat (500) @(posedge ifc.Clk); 
        state = other;
    end
    endtask

    task axi_write(int addr, int data);
    begin
        gc_interface = axi4;
        config_count++;
        axi_trans.addr = addr;
        axi_trans.data_in = data;
        axi_driver.axi_write(axi_trans.addr, axi_trans.data_in);
        axi_trans = axi_driver.GetResult();
        $fdisplay(file_des,"%t: %m: Trans %d (write_gc_reg):  Address to CGRA=%d, Data to CGRA=%d",  
            $time, config_count, ifc.AWADDR, ifc.WDATA);
        repeat (500) @(posedge ifc.Clk); 
        state = other;
    end
    endtask

    task axi_read(int addr);
    begin
        gc_interface = axi4;
        config_count++;
        axi_trans.addr = addr;
        axi_driver.axi_read(axi_trans.addr);
        axi_trans = axi_driver.GetResult();
        $fdisplay(file_des,"%t: %m: Trans %d (write_gc_reg):  Address to CGRA=%d, Data to CGRA=%d",  
            $time, config_count, ifc.AWADDR, ifc.WDATA);
        repeat (500) @(posedge ifc.Clk); 
        state = other;
    end
    endtask

    task init_test();
    begin
        // instantiate axi driver
        axi_driver = new(ifc);
        axi_driver.Reset();
        
        // ZERO out any inputs to the DUT
        // TODO

        repeat (2) @(posedge ifc.Clk); 
    end
    endtask // init_test

    task check_register(int register, int value);
        begin
            assert(register == value) else $display("reg: %d, val: %d",register,value);
        end
    endtask // check_register
 
endprogram
    
