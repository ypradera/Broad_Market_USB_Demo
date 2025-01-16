// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
// Copyright (c) 2019 by Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// --------------------------------------------------------------------
//
// Permission:
//
// Lattice SG Pte. Ltd. grants permission to use this code
// pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
// Disclaimer:
//
// This VHDL or Verilog source code is intended as a design reference
// which illustrates how these types of functions can be implemented.
// It is the user's responsibility to verify their design for
// consistency and functionality through the use of formal
// verification methods. Lattice provides no warranty
// regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                     Lattice SG Pte. Ltd.
//                     101 Thomson Road, United Square #07-02
//                     Singapore 307591
//
//
//                     TEL: 1-800-Lattice (USA and Canada)
//                     +65-6631-2000 (Singapore)
//                     +1-503-268-8001 (other locations)
//
//                     web: http://www.latticesemi.com/
//                     email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------
//
// =============================================================================
// FILE DETAILS
// Project : <UART>
// File : tb_top.v
// Title :
// Dependencies : 1.
//              : 2.
// Description :
// =============================================================================
// REVISION HISTORY
// Version : 1.0
// Changes Made : Initial version of RTL
// -----------------------------------------------------------------------------
// Version : 1.0
// Author(s) :
// Mod. Date :
// Changes Made :
// =============================================================================
//--------------------------------------------------------------------------------------------------

`ifndef TB_TOP
`define TB_TOP
`timescale 1ns/1ps

`include "tb_lmmi_mst.v"
`include "lscc_lmmi2apb.v"
`include "spi_controller_model.v"
`include "lscc_lmmi2ahbl_single.v"

module tb_top;

`include "dut_params.v"

// -----------------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------------
localparam          SYS_CLOCK_FREQ = 50  ; // 50MHz
localparam  integer SYS_CLK_PERIOD = 1000 / SYS_CLOCK_FREQ;

// Localparams
localparam          REG_OUTPUT     = 1   ;
localparam          PRESCALER      = 25  ; // 1Mhz sclk_o
localparam  integer SLV_NUM        = 1   ;
localparam  [0:0]   SSNP           = 1   ;

//********************************************************************************
// Internal Reg/Wires
//********************************************************************************

// Clock and Reset Signals
reg                      clk_i      ;
reg                      rst_i      ;
reg                      rst_n_i    ;

// wires connected to DUT when LMMI I/F
wire                     lmmi_request_i    ; 
wire                     lmmi_wr_rdn_i     ; 
wire [5:0]               lmmi_offset_i     ; 
wire [DATA_WIDTH-1:0]    lmmi_wdata_i      ; 
wire                     lmmi_ready_o      ;
wire [DATA_WIDTH-1:0]    lmmi_rdata_o      ; 
wire                     lmmi_rdata_valid_o; 
// wires connected to DUT when APB I/F
wire                     apb_penable_i   ; 
wire                     apb_psel_i      ; 
wire                     apb_pwrite_i    ; 
wire [5:0]               apb_paddr_i     ; 
wire [31:0]              apb_pwdata_i    ; 
wire                     apb_pready_o    ; 
wire                     apb_pslverr_o   ; 
wire [31:0]              apb_prdata_o    ; 
// wires connected to DUT when AHBL I/F
wire                     ahbl_hsel_i     ; 
wire                     ahbl_hready_i   ; 
wire [5:0]               ahbl_haddr_i    ; 
wire [2:0]               ahbl_hburst_i   ; 
wire [2:0]               ahbl_hsize_i    ; 
wire                     ahbl_hmastlock_i; 
wire [3:0]               ahbl_hprot_i    ; 
wire [1:0]               ahbl_htrans_i   ; 
wire                     ahbl_hwrite_i   ; 
wire [31:0]              ahbl_hwdata_i   ; 
wire                     ahbl_hreadyout_o; 
wire                     ahbl_hresp_o    ; 
wire [31:0]              ahbl_hrdata_o   ; 

// wires connected to SPI I/F
wire                   miso_o ; 
wire                   sclk_i ; 
wire                   mosi_i ; 
wire                   ss_i   ; 


// -----------------------------------------------------------------------------
// Clock Generator
// -----------------------------------------------------------------------------
initial begin
  clk_i     = 0;
end

always #(SYS_CLK_PERIOD/2) clk_i = ~clk_i;

// -----------------------------------------------------------------------------
// Reset Signals
// -----------------------------------------------------------------------------
initial begin
  rst_i     = 1;
  rst_n_i   = 0;
  #(10*SYS_CLK_PERIOD)
  rst_i     = 0;
  rst_n_i   = 1;
end
  
// ----------------------------
// GSR instance
// ----------------------------
`ifndef iCE40UP
GSR GSR_INST ( .GSR_N(1'b1), .CLK(1'b0));
`endif
 
`include "dut_inst.v"

 wire [SLV_NUM-1:0] ss_w;
 assign ss_i = ss_w[0];
 
 spi_master_model #(
    .DATA_WIDTH(DATA_WIDTH),
    .SLV_NUM   (SLV_NUM   ),
    .LSB_FIRST (LSB_FIRST ),
    .SSNP      (SSNP      ),
    .CPOL      (CPOL      ),
    .CPHA      (CPHA      ),
    .SSPOL     (SS_POL    ),
    .PRESCALER (PRESCALER ),
    .model_name("SPI_MASTER"))
  u_spi_master(
    .clk_i  (clk_i   ),
    .rst_n_i(rst_n_i ),
    .sck_o  (sclk_i  ),
    .ss_o   (ss_w    ),
    .mosi_o (mosi_i  ),
    .miso_i (miso_o  )
  );


tb_lmmi_mst #(
  .AWIDTH          (4         ),
  .DWIDTH          (DATA_WIDTH))
lmmi_mst_0 (
  .lmmi_clk        (clk_i             ),
  .lmmi_resetn     (rst_n_i           ),
  .lmmi_rdata      (lmmi_rdata_o      ),
  .lmmi_rdata_valid(lmmi_rdata_valid_o),
  .lmmi_ready      (lmmi_ready_o      ),
  .lmmi_offset     (lmmi_offset_i[3:0]),
  .lmmi_request    (lmmi_request_i    ),
  .lmmi_wdata      (lmmi_wdata_i      ),
  .lmmi_wr_rdn     (lmmi_wr_rdn_i     )
);


generate
  if (INTERFACE == "APB") begin: apb_en
    lscc_lmmi2apb # (
      .DATA_WIDTH(DATA_WIDTH   ),
      .ADDR_WIDTH(6            ),
      .REG_OUTPUT(1            ))
    lmmi2apb_0 (
      .clk_i             (clk_i             ),
      .rst_n_i           (rst_n_i           ),
      .lmmi_request_i    (lmmi_request_i    ),
      .lmmi_wr_rdn_i     (lmmi_wr_rdn_i     ),
      .lmmi_offset_i     ({lmmi_offset_i,2'b00}),
      .lmmi_wdata_i      (lmmi_wdata_i      ),
      .lmmi_ready_o      (lmmi_ready_o      ),
      .lmmi_rdata_valid_o(lmmi_rdata_valid_o),
      .lmmi_ext_error_o  (                  ), // unconnected
      .lmmi_rdata_o      (lmmi_rdata_o      ),
      .lmmi_resetn_o     (                  ), // unconnected
      .apb_pready_i      (apb_pready_o      ),
      .apb_pslverr_i     (apb_pslverr_o     ),
      .apb_prdata_i      (apb_prdata_o      ),
      .apb_penable_o     (apb_penable_i     ),
      .apb_psel_o        (apb_psel_i        ),
      .apb_pwrite_o      (apb_pwrite_i      ),
      .apb_paddr_o       (apb_paddr_i       ),
      .apb_pwdata_o      (apb_pwdata_i      ));
  end
  else if (INTERFACE == "AHBL") begin : ahbl_en
  lscc_lmmi2ahbl_single 
  #(
    .DATA_WIDTH(DATA_WIDTH   ),
    .ADDR_WIDTH(6            ))
  lmmi2ahbl_0 (
    .clk_i             (clk_i             ),
    .rst_n_i           (rst_n_i           ),
    .lmmi_request_i    (lmmi_request_i    ),
    .lmmi_wr_rdn_i     (lmmi_wr_rdn_i     ),
    .lmmi_offset_i     ({lmmi_offset_i,2'b00}),
    .lmmi_wdata_i      (lmmi_wdata_i      ),
    .lmmi_rdata_o      (lmmi_rdata_o      ),
    .lmmi_rdata_valid_o(lmmi_rdata_valid_o),
    .lmmi_ready_o      (lmmi_ready_o      ),
    .lmmi_ext_error_o  (                  ),
    .ahbl_hready_i     (ahbl_hreadyout_o  ),
    .ahbl_hresp_i      (ahbl_hresp_o      ),
    .ahbl_hrdata_i     (ahbl_hrdata_o     ),
    .ahbl_haddr_o      (ahbl_haddr_i      ),
    .ahbl_hburst_o     (ahbl_hburst_i     ),
    .ahbl_hsize_o      (ahbl_hsize_i      ),
    .ahbl_hmastlock_o  (ahbl_hmastlock_i  ),
    .ahbl_hprot_o      (ahbl_hprot_i      ),
    .ahbl_htrans_o     (ahbl_htrans_i     ),
    .ahbl_hwrite_o     (ahbl_hwrite_i     ),
    .ahbl_hwdata_o     (ahbl_hwdata_i     ));
    
    assign ahbl_hsel_i   = 1'b1;
    assign ahbl_hready_i = ahbl_hreadyout_o;
  end
endgenerate

integer i, j;
integer error_count;

localparam ADDR_DATA         = 4'h0;
localparam ADDR_CFG          = 4'h1;
localparam ADDR_INT_STATUS   = 4'h2;
localparam ADDR_INT_ENABLE   = 4'h3;
localparam ADDR_INT_SET      = 4'h4;
localparam ADDR_WORD_CNT     = 4'h5;
localparam ADDR_WORD_CNT_RST = 4'h6;
localparam ADDR_TGT_WORD_CNT = 4'h7;
localparam ADDR_FIFO_RST     = 4'h8;
localparam ADDR_FIFO_STATUS  = 4'h9;

localparam [1:0] DS = (DATA_WIDTH == 8) ? 2'b00 : ((DATA_WIDTH == 16) ? 2'b01 : ((DATA_WIDTH == 24) ? 2'b10:2'b11));

reg [25:0]   reg_list[0:10];
reg [8*23:1] reg_names[0:10];

reg [8:0] tx_fifo_count;
reg [8:0] rx_fifo_count;
reg [8:0] tx_spi_count;
reg [7:0] exp_status;
reg [7:0] int_status;

initial begin // initialize register list
  // reg_type = 2'b00 - do not check
  // reg_type = 2'b01 - read only
  // reg_type = 2'b10 - write only
  // reg_type = 2'b11 - R/W
  // { reg_type, exp_value, writable_bits, reset value}
  reg_list[0]   = {2'b00, 8'h00, 8'h00, 8'h00};            // DATA_REG
  reg_list[1]   = {2'b11, 8'h00, 8'hCF, {SVAL_EN[0],SS_POL[0],DS,LSB_FIRST[0],DAISY_CHAIN[0],CPOL[0],CPHA[0]}}; // CFG_REG
  reg_list[2]   = {2'b00, 8'h00, 8'hBF, 8'h00};            // INT_STATUS_REG
  reg_list[3]   = {2'b11, 8'h00, 8'hBF, 8'h00};            // INT_ENABLE_REG
  reg_list[4]   = {2'b10, 8'h00, 8'h00, 8'h00};            // INT_SET_REG
  reg_list[5]   = {2'b01, 8'h00, 8'h00, 8'h00};            // WORD_CNT_REG
  reg_list[6]   = {2'b10, 8'h00, 8'hFF, 8'h00};            // WORD_CNT_RST_REG
  reg_list[7]   = {2'b11, 8'h00, 8'hFF, 8'h00};            // TGT_WORD_CNT_REG
  reg_list[8]   = {2'b10, 8'h00, 8'h03, 8'h00};            // FIFO_RST_REG
  reg_list[9]   = {2'b01, 8'h00, 8'h00, 8'h19};            // FIFO_STATUS_REG
  reg_list[10]  = {2'b11, 8'h00, 8'hFF, SVAL[7:0]};        // STATIC_VALUE_REG, will not use for reg comparison
  reg_names[0]  = "DATA_REG";
  reg_names[1]  = "CFG_REG";
  reg_names[2]  = "INT_STATUS_REG";
  reg_names[3]  = "INT_ENABLE_REG";
  reg_names[4]  = "INT_SET_REG";
  reg_names[5]  = "WORD_CNT_REG";
  reg_names[6]  = "WORD_CNT_RST_REG";
  reg_names[7]  = "TGT_WORD_CNT_REG";
  reg_names[8]  = "FIFO_RST_REG";
  reg_names[9]  = "FIFO_STATUS_REG";
  reg_names[10] = "STATIC_VALUE_REG";
end

// Test
initial begin
  error_count = 0;
  repeat(20) @(posedge clk_i); // wait for some time
  register_check();
  reset_during_idle();
  normal_operation_test();
  if (error_count == 0)
    $display("\n[%010t] [TEST]: SIMULATION PASSED \n", $time);
  else
    $display("\n[%010t] [TEST]: SIMULATION FAILED - No of Errors = %0d.\n", $time, error_count);
  $finish;
end

// Test routines
task register_check();
  reg [31:0]  wr_data;
  reg [31:0]  rd_data;
  reg [DATA_WIDTH-1:0] exp_sval;
  begin
    $display("\n[%010t] [TEST]: Register access test start!", $time);
    // Set Expected read data to default
    rd_check_all_regs_default();
    $display("[%010t] [TEST]: Register access check Start.", $time);
    for (j=0; j < 5; j=j+1) begin // number of runs
	  // i iterates for all regs
      for (i=0; i < 11; i=i+1) begin    // write random data to testable regs
        if (reg_list[i][25:24] != 2'b00) begin
          if (j==0)
            wr_data    = 32'hFFFFFFFF;
          else if (j==1)
            wr_data    = 32'h00000000;
          else
            wr_data    = $random;
          lmmi_mst_0.m_write(i[3:0], wr_data);
          reg_list[i][23:16] = get_exp_data(reg_list[i][25:24], reg_list[i][15:8], wr_data[7:0], reg_list[i][7:0]);
          if (i==10)
            exp_sval = wr_data;
        end
      end      
      if ((j == 1) || (j == 3)) begin
        $display("[%010t] [TEST]: Reserved address check start.", $time);
        for (i=11; i < 16; i=i+1) begin
          wr_data = $random;
          lmmi_mst_0.m_write(i[3:0], $random);
        end
        for (i=11; i < 16; i=i+1) begin
          lmmi_mst_0.m_read(i[3:0], rd_data);
          data_compare_reg(rd_data,8'h00, "Reserved", i[3:0]);
        end
        $display("[%010t] [TEST]: Reserved address check end.", $time);
      end
      rd_check_all_regs(exp_sval); 
    end
    $display("[%010t] [TEST]: Register access check end.", $time);
    $display("[%010t] [TEST]:Register test end!\n", $time);
  end
endtask

task rd_check_all_regs_default();
  reg [DATA_WIDTH-1:0]  rd_data;
  begin
    $display("\n[%010t] [TEST]: Register default data check start.", $time);
    for (i=1; i < 11; i=i+1) begin //Exclude RD_DATA_REG 
      lmmi_mst_0.m_read(i[3:0], rd_data);
      if (i == 10)
        data_compare_reg_dw(rd_data, SVAL, reg_names[i], i[3:0]);
      else 
        data_compare_reg(rd_data[7:0],reg_list[i][7:0], reg_names[i], i[3:0]);
    end
    $display("[%010t] [TEST]: Register default data check end.\n", $time);
  end
endtask

task rd_check_all_regs(
  input  [DATA_WIDTH-1:0] exp_sval
);
  reg    [DATA_WIDTH-1:0] rd_data;
  begin
    for (i=0; i < 11; i=i+1) begin
      if (reg_list[i][25:24] != 2'b00) begin
        lmmi_mst_0.m_read(i[3:0], rd_data);
        if (i == 10)
          data_compare_reg_dw(rd_data, exp_sval, reg_names[i], i[3:0]);
        else
          data_compare_reg(rd_data[7:0],reg_list[i][23:16], reg_names[i], i[3:0]);
      end
    end
  end
endtask

task reset_during_idle();
  begin
    $display("[%010t] [TEST]: Reset during IDLE start.", $time);
    // Previous register test updated the register values  
    @(posedge clk_i);
    @(posedge clk_i);
    @(posedge clk_i);

    $display("[%010t] [TEST]: Asserting reset for 2 clock cycles.", $time);
    @(posedge clk_i);
    rst_i     <= 1'b1;
    rst_n_i   <= 1'b0;
    @(posedge clk_i);
    @(posedge clk_i);
    rst_i     <= 1'b0;
    rst_n_i   <= 1'b1;
    @(posedge clk_i);
    $display("[%010t] [TEST]: Check that register default values are correct.", $time);
    for (i=1; i < 10; i=i+1) begin
      reg_list[i][23:16] = reg_list[i][7:0];
    end
    rd_check_all_regs_default();
    $display("[%010t] [TEST]: Reset during IDLE end.", $time);
	tx_fifo_count = {9{1'b1}};
	rx_fifo_count = {9{1'b1}};
	tx_spi_count  = 0;
  end
endtask

task reg_write(
  input  [3:0] addr,
  input  [7:0] data
);
  reg [DATA_WIDTH-1:0] wr_data;
  begin
    wr_data      = {DATA_WIDTH{1'b0}};
    wr_data[7:0] = data;
    lmmi_mst_0.m_write(addr, wr_data);
  end
endtask

task check_int_status();
  begin
	int_status[7] = (tx_spi_count == (FIFO_DEPTH)) ? 1'b1 : 1'b0;
	int_status[6] = 1'b0;
	int_status[5] = (tx_fifo_count == FIFO_DEPTH) ? 1'b1 : 1'b0;
	int_status[4] = (tx_fifo_count == TX_FIFO_AE_FLAG) ? 1'b1 : 1'b0;
	int_status[3] = (tx_fifo_count == {9{1'b0}}) ? 1'b1 : 1'b0;
	int_status[2] = (rx_fifo_count == FIFO_DEPTH-1) ? 1'b1 : 1'b0;
	int_status[1] = (rx_fifo_count == RX_FIFO_AF_FLAG-1) ? 1'b1 : 1'b0;
	int_status[0] = (rx_fifo_count == 0) ? 1'b1 : 1'b0;	
  end
endtask

task interrupt_check(
  input   [8*30:1] int_name
);
  reg [DATA_WIDTH-1:0]  rd_data;
  reg            [7:0]  int_mask;
  reg            [7:0]  int_enable;
  begin
	check_int_status();
    int_mask = ~int_status;
    lmmi_mst_0.m_read(ADDR_INT_ENABLE, rd_data);
    int_enable = rd_data[7:0];
    lmmi_mst_0.m_read(ADDR_INT_STATUS, rd_data);
    if (rd_data[7:0] == int_status) begin
      $display("[%010t] [TEST]: %0s asserted as expected. INT_STATUS_REG = 0x%02x", $time, int_name, rd_data[7:0]);
      // interrupt masking check
      reg_write(ADDR_INT_ENABLE, int_mask);
      lmmi_mst_0.m_read(ADDR_INT_ENABLE, rd_data);
      if (int_o) begin
        $error("[%010t] [TEST]: Error: interrupt is still asserted when %0s is disabled", $time, int_name);
        error_count = error_count + 1;
      end
      reg_write(ADDR_INT_ENABLE, int_enable);
      lmmi_mst_0.m_read(ADDR_INT_ENABLE, rd_data);
      if (~int_o) begin
        $error("[%010t] [TEST]: Error: interrupt did not re-assert when %0s is enabled", $time, int_name);
        error_count = error_count + 1;
      end      
      // interrupt clearing check
      reg_write(ADDR_INT_STATUS, int_status);
      lmmi_mst_0.m_read(ADDR_INT_STATUS, rd_data);
      if (rd_data[7:0] != 8'h00) begin
        $error("[%010t] [TEST]: Error: INT_STATUS_REG = 0x%02x when %0s is cleared", $time, rd_data[7:0], int_name);
        error_count = error_count + 1;
      end
      if (int_o) begin
        $error("[%010t] [TEST]: Error: interrupt is still asserted when %0s is cleared", $time, int_name);
        error_count = error_count + 1;
      end
    end
    else begin
      $error("[%010t] [TEST]: Error: INT_STATUS_REG = 0x%02x when expecting 0x%02x while checking for %0s", $time, rd_data[7:0], int_status, int_name);
      error_count = error_count + 1;
    end
  end
endtask

task check_exp_status();
	reg [8:0]  i_tx_fifo_count;
	reg [8:0]  i_rx_fifo_count;
  begin
	i_tx_fifo_count = tx_fifo_count+1;
	i_rx_fifo_count = rx_fifo_count+1;
    exp_status[7:6] = 2'b0;
	exp_status[5] = (tx_fifo_count ==  FIFO_DEPTH) ? 1'b1 : 1'b0;
	exp_status[4] = (i_tx_fifo_count <=  (TX_FIFO_AE_FLAG+1)) ? 1'b1 : 1'b0;
	exp_status[3] = (tx_fifo_count ==  {9{1'b1}} || tx_fifo_count == {9{1'b0}}) ? 1'b1 : 1'b0;
	exp_status[2] = (i_rx_fifo_count >=  FIFO_DEPTH) ? 1'b1 : 1'b0;
	exp_status[1] = (i_rx_fifo_count >=  (RX_FIFO_AF_FLAG)) ? 1'b1 : 1'b0;
	exp_status[0] = (rx_fifo_count ==  {9{1'b1}}) ? 1'b1 : 1'b0;	
  end
endtask

task check_fifo_status(
  input [8*30:1] comment
);
  reg [DATA_WIDTH-1:0]  rd_data;
  begin
	@(posedge clk_i);
	@(posedge clk_i);	
    lmmi_mst_0.m_read(ADDR_FIFO_STATUS, rd_data);
	check_exp_status();
    if (rd_data[7:0] == exp_status) 
      $display("[%010t] [TEST]: FIFO_STATUS_REG=%02x as expected. (%0s)", $time, exp_status, comment);
    else begin
      $error("[%010t] [TEST]: Error: FIFO_STATUS_REG=%02x when expecting 0x%x. (%0s)", $time, rd_data[7:0], exp_status, comment);
      error_count = error_count + 1;
    end
  end
endtask

task normal_operation_test();
  reg [DATA_WIDTH-1:0]  tx_data_lst[0:FIFO_DEPTH];
  reg [DATA_WIDTH-1:0]  rx_data_lst[0:FIFO_DEPTH];
  reg [DATA_WIDTH-1:0]  rd_data;
  reg [DATA_WIDTH-1:0]  mdl_rx_data;
  reg [DATA_WIDTH-1:0]  exp_sval;

  integer    j, k;

  begin
    $display("[%010t] [TEST]: Normal operation test start.", $time);
  	check_fifo_status("FSR_Tx_Check0"); //RX_FIFO & TX_FIFO empty check
    reg_write(ADDR_TGT_WORD_CNT, (FIFO_DEPTH-1));

    for(i=0;i<=FIFO_DEPTH;i=i+1) begin // generate data to transmit and receive
      tx_data_lst[i] = $random;
      rx_data_lst[i] = $random;
    end

	  for(i=0;i<2;i=i+1) begin // Write 2 data to Transmit FIFO 
	    lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[i]);
	    tx_fifo_count = tx_fifo_count + 1;
	  end
  	@(posedge clk_i);
  	check_fifo_status("FSR_Tx_Check1"); //TX_FIFO not empty check 

	  for(i=2;i<(TX_FIFO_AE_FLAG+1);i=i+1) begin // Write data to Transmit FIFO until AlmostEmpty - 1
      lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[i]);
	    tx_fifo_count = tx_fifo_count + 1;
    end
	  check_fifo_status("FSR_Tx_Check2"); //TX_FIFO almost_empty (1) boundary check

    lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[TX_FIFO_AE_FLAG+1]); // Write data to Transmit FIFO to AlmostEmpty
  	tx_fifo_count = tx_fifo_count + 1;
	  check_fifo_status("FSR_Tx_Check3"); //TX_FIFO almost_empty (0) boundary check

  	if (FIFO_DEPTH > (TX_FIFO_AE_FLAG+1)) begin
	    if (FIFO_DEPTH != (TX_FIFO_AE_FLAG+1)) begin
	      for(i=TX_FIFO_AE_FLAG+2;i<(FIFO_DEPTH);i=i+1) begin // Write data to Transmit FIFO until Full - 1
		      lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[i]);
	        tx_fifo_count = tx_fifo_count + 1;
	   	  end
		    check_fifo_status("FSR_Tx_Check4"); //TX_FIFO full (0) boundary check
	    end
	  
	    lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[FIFO_DEPTH]);
	    tx_fifo_count = tx_fifo_count + 1;
	    check_fifo_status("FSR_Tx_Check5"); //TX_FIFO full (1) boundary check
	  end

    fork
      begin // Interrupt check sequence
        reg_write(ADDR_INT_STATUS, 8'hFF);  // Clear all interrupts
        reg_write(ADDR_INT_ENABLE, 8'hFF);  // Enable all interrupts for checking those will assert

        wait_for_int(32'hFFFFFFFF, "rx_fifo_ready_int"); 
        interrupt_check("rx_fifo_ready_int");
        check_fifo_status("FSR_Rx_Check1"); //RX_FIFO not empty check

        wait_for_int(32'hFFFFFFFF, "tx_fifo_aempty_int or rx_fifo_afull_int"); 
        interrupt_check("tx_fifo_aempty_int or rx_fifo_afull_int");
        check_fifo_status("FSR_Rx_Check2");

        wait_for_int(32'hFFFFFFFF, "tx_fifo_empty_int");
        interrupt_check("tx_fifo_empty_int");
        check_fifo_status("FSR_Rx_Check3");

        $display("[%010t] [TEST]: DUT sequence done.", $time);
      end
     
      begin // Transmit data checks: SPI master IP Core -> SPI Slave Model
            // Set Receive data: SPI Slave Model -> SPI master IP Core
        @(posedge clk_i);
		    tx_fifo_count = tx_fifo_count + 1;
        
        for(j=0;j<FIFO_DEPTH+1;j=j+1) begin
		      tx_spi_count = tx_spi_count + 1;
		      tx_fifo_count = tx_fifo_count - 1;

          u_spi_master.tx_rx_data(1'b1, rx_data_lst[j], mdl_rx_data);

		      rx_fifo_count = rx_fifo_count + 1;

		      if (mdl_rx_data == tx_data_lst[j]) 
            $display("[%010t] [TEST]: Tx Data[%0d] = 0x%0x as expected.", $time, j, mdl_rx_data);
          else begin
            $error("[%010t] [TEST]: Tx Data[%0d] mismatch expected=0x%0x actual=0x%0x.", $time, j, tx_data_lst[j], mdl_rx_data);
            error_count = error_count + 1;
          end
        end

		    tx_fifo_count = tx_fifo_count - 1;
        check_fifo_status("FSR_Rx_Check4");

		    for (i=0; i<50; i=i+1) @(posedge clk_i); // just wait for some time

        $display("[%010t] [TEST]: Checking received data", $time);			
        for(i=0;i<FIFO_DEPTH;i=i+1) begin
          lmmi_mst_0.m_read(ADDR_DATA, rd_data);
		      rx_fifo_count = rx_fifo_count - 1;
          if (rd_data == rx_data_lst[i]) 
            $display("[%010t] [TEST]: Rx Data[%0d] = 0x%0x as expected", $time, i, rx_data_lst[i]);
          else begin
            $error("[%010t] [TEST]: Rx Data[%0d] mismatch: expected=0x%0x actual=%0x", $time, i, rx_data_lst[i], rd_data);
            error_count = error_count + 1;
          end
        end

		    rx_fifo_count = rx_fifo_count - 1;

		    for (i=0; i<50; i=i+1) @(posedge clk_i); // just wait for some time		
		    check_fifo_status("FSR_Rx_Check5");

        @(posedge clk_i);
        $display("[%010t] [TEST]: Tx data checks done in SPI Slave Side.", $time);
      end
    join

    // Check miso_o when Write FIFO is empty
    for (i=0; i<400; i=i+1) @(posedge clk_i); // just wait for some time
    u_spi_master.tx_rx_data(1'b1, rx_data_lst[0], mdl_rx_data);

    if (~SVAL_EN[0])
      exp_sval = rx_data_lst[j-1];
    else
      exp_sval = SVAL;

    if (mdl_rx_data === exp_sval) 
      $display("[%010t] [TEST]: Tx Data during Write FIFO is empty = 0x%0x as expected.", $time, mdl_rx_data);
    else begin
      $error("[%010t] [TEST]: Tx Data mismatch during Write FIFO is empty, expected=0x%0x actual=0x%0x.", $time, exp_sval, mdl_rx_data);
      error_count = error_count + 1;
    end

    for (i=10; i<1000; i=i+1) @(posedge clk_i); // just wait for some time
    $display("[%010t] [TEST]: Normal operation test end.", $time);
  end
endtask // normal_operation_fifo_full_test

task wait_for_int(
  input     [31:0] timeout_val,
  input   [8*20:1] comment      // To identify the call
);
  reg [31:0] count;
  begin
    $display("[%010t] [TEST]: Waiting for interrupt to assert (Timeout=%0d).", $time, timeout_val);
    count = 32'h0;
    while(~int_o && (count < timeout_val)) begin 
      @(posedge clk_i);
      count = count+1;
      if (int_o)
        $display("[%010t] [TEST]: Interrupt asserted.", $time);
    end
    if (count < timeout_val)
      $display("[%010t] [TEST]: Interrupt asserted.", $time);
    else begin
      error_count = error_count + 1;
      $error("[%010t] [TEST]: Timeout occured while waiting for interrupt (%0s).", $time, comment);
      $display("\n[%010t] [TEST]: SIMULATION FAILED - No of Errors = %0d.\n", $time, error_count);
      $finish;
    end
  end
endtask

task data_compare_reg(
  input     [7:0]         act,
  input     [7:0]         exp,
  input reg [8*23:1]      reg_name,
  input     [3:0]         addr
);
  begin
    if (exp !== act) begin
      error_count = error_count + 1;
      $error("[%010t] [reg_test]: Data compare error on %0s register (LMMI Addr=0x%02x). Actual (0x%02x) != Expected (0x%02x)!", $time, reg_name, addr, act, exp);
    end
  end
endtask

task data_compare_reg_dw(
  input     [DATA_WIDTH-1:0]  act,
  input     [DATA_WIDTH-1:0]  exp,
  input reg [8*23:1]          reg_name,
  input     [3:0]             addr
);
  begin
    if (exp !== act) begin
      error_count = error_count + 1;
      $error("[%010t] [reg_test]: Data compare error on %0s register (LMMI Addr=0x%02x). Actual (0x%0x) != Expected (0x%0x)!", $time, reg_name, addr, act, exp);
    end
  end
endtask

//functions
function [7:0] get_exp_data(input [1:0] access,
                            input [7:0] wrbits, 
                            input [7:0] data,
                            input [7:0] def);
  begin
    if (access == 2'b10) // write-only
      get_exp_data = 8'h00;
    else if ((access == 2'b01) || (wrbits == 8'h00))
      get_exp_data = def;
    else
      get_exp_data = (wrbits & data) | (~wrbits & def);
  end
endfunction

endmodule
`endif
