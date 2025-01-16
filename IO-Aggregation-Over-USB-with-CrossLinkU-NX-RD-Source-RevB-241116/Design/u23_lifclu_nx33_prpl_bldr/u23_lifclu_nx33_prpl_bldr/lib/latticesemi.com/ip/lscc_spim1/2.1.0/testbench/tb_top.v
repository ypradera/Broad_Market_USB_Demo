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
// Project :
// File : tb_top.v
// Title :
// Dependencies : 1.
//              : 2.
// Description :
// =============================================================================
// REVISION HISTORY
// Version : 1.0
// Author(s) :
// Mod. Date :
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
`include "spi_target_model.v"
`include "lscc_lmmi2ahbl_single.v"

module tb_top;

`include "dut_params.v"

// -----------------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------------
parameter  integer SYS_CLK_PERIOD    = 1000 / SYS_CLOCK_FREQ;

// Localparams
localparam    REG_OUTPUT   = 1 ;
localparam    CLKS_PER_BIT = PRESCALER * 16;


//********************************************************************************
// Internal Reg/Wires
//********************************************************************************

// Clock and Reset Signals
reg                      clk_i      ;
reg                      slv_clk_i  ;
reg                      rst_i      ;
reg                      rst_n_i    ;

// wires connected to DUT when LMMI I/F
wire                     lmmi_request_i    ;
wire                     lmmi_wr_rdn_i     ;
wire [3:0]               lmmi_offset_i     ;
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
wire                     miso_i ;
wire                     sclk_o ;
wire                     mosi_o ;
wire [SLAVE_COUNT-1:0]   ssn_o  ;


// -----------------------------------------------------------------------------
// Clock Generator
// -----------------------------------------------------------------------------
initial begin
  clk_i     = 0;
  slv_clk_i = 0;
end

always #(SYS_CLK_PERIOD/2) clk_i     = ~clk_i;
always #(SYS_CLK_PERIOD/4) slv_clk_i = ~slv_clk_i;

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
GSR GSR_INST ( .GSR_N(1'b1), .CLK(1'b0));

`include "dut_inst.v"

 spi_slave_model #(
    .DATA_WIDTH(DATA_WIDTH),
    .LSB_FIRST (LSB_FIRST ),
    .SSNP      (SSNP[0]   ),
    .CPOL      (CPOL[0]   ),
    .CPHA      (CPHA[0]   ),
    .SSPOL     (SSPOL[0]  ),
    .model_name("SPI_SLV0"))
  spi_slv_0(
    .clk_i     (slv_clk_i ),  // slave model needs 2x clock to keep up for max freq
    .rst_n_i   (rst_n_i   ),
    .sck_i     (sclk_o    ),
    .ss_i      (ssn_o[0]  ),
    .mosi_i    (mosi_o    ),
    .miso_o    (miso_i    )
  );

tb_lmmi_mst #(
  .AWIDTH          (4                 ),
  .DWIDTH          (DATA_WIDTH        ))
lmmi_mst_0 (
  .lmmi_clk        (clk_i             ),
  .lmmi_resetn     (rst_n_i           ),
  .lmmi_rdata      (lmmi_rdata_o      ),
  .lmmi_rdata_valid(lmmi_rdata_valid_o),
  .lmmi_ready      (lmmi_ready_o      ),
  .lmmi_offset     (lmmi_offset_i     ),
  .lmmi_request    (lmmi_request_i    ),
  .lmmi_wdata      (lmmi_wdata_i      ),
  .lmmi_wr_rdn     (lmmi_wr_rdn_i     )
);

generate
  if (INTERFACE == "APB") begin: apb_en
    lscc_lmmi2apb # (
      .DATA_WIDTH        (DATA_WIDTH                    ),
      .ADDR_WIDTH        (6                             ),
      .REG_OUTPUT        (1                             ))
    lmmi2apb_0 (
      .clk_i             (clk_i                         ),
      .rst_n_i           (rst_n_i                       ),
      .lmmi_request_i    (lmmi_request_i                ),
      .lmmi_wr_rdn_i     (lmmi_wr_rdn_i                 ),
      .lmmi_offset_i     ({lmmi_offset_i,2'b00}         ),
      .lmmi_wdata_i      (lmmi_wdata_i                  ),
      .lmmi_ready_o      (lmmi_ready_o                  ),
      .lmmi_rdata_valid_o(lmmi_rdata_valid_o            ),
      .lmmi_ext_error_o  (                              ), // unconnected
      .lmmi_rdata_o      (lmmi_rdata_o                  ),
      .lmmi_resetn_o     (                              ), // unconnected
      .apb_pready_i      (apb_pready_o                  ),
      .apb_pslverr_i     (apb_pslverr_o                 ),
      .apb_prdata_i      (apb_prdata_o[DATA_WIDTH-1:0]  ),
      .apb_penable_o     (apb_penable_i                 ),
      .apb_psel_o        (apb_psel_i                    ),
      .apb_pwrite_o      (apb_pwrite_i                  ),
      .apb_paddr_o       (apb_paddr_i                   ),
      .apb_pwdata_o      (apb_pwdata_i[DATA_WIDTH-1:0]  ));
  end
  else if (INTERFACE == "AHBL") begin : ahbl_en
  lscc_lmmi2ahbl_single
  #(
    .DATA_WIDTH        (DATA_WIDTH                    ),
    .ADDR_WIDTH        (6                             ))
  lmmi2ahbl_0 (
    .clk_i             (clk_i                         ),
    .rst_n_i           (rst_n_i                       ),
    .lmmi_request_i    (lmmi_request_i                ),
    .lmmi_wr_rdn_i     (lmmi_wr_rdn_i                 ),
    .lmmi_offset_i     ({lmmi_offset_i,2'b00}         ),
    .lmmi_wdata_i      (lmmi_wdata_i                  ),
    .lmmi_rdata_o      (lmmi_rdata_o                  ),
    .lmmi_rdata_valid_o(lmmi_rdata_valid_o            ),
    .lmmi_ready_o      (lmmi_ready_o                  ),
    .lmmi_ext_error_o  (                              ),
    .ahbl_hready_i     (ahbl_hreadyout_o              ),
    .ahbl_hresp_i      (ahbl_hresp_o                  ),
    .ahbl_hrdata_i     (ahbl_hrdata_o[DATA_WIDTH-1:0] ),
    .ahbl_haddr_o      (ahbl_haddr_i                  ),
    .ahbl_hburst_o     (ahbl_hburst_i                 ),
    .ahbl_hsize_o      (ahbl_hsize_i                  ),
    .ahbl_hmastlock_o  (ahbl_hmastlock_i              ),
    .ahbl_hprot_o      (ahbl_hprot_i                  ),
    .ahbl_htrans_o     (ahbl_htrans_i                 ),
    .ahbl_hwrite_o     (ahbl_hwrite_i                 ),
    .ahbl_hwdata_o     (ahbl_hwdata_i[DATA_WIDTH-1:0] ));

    assign ahbl_hsel_i   = 1'b1;
    assign ahbl_hready_i = ahbl_hreadyout_o;
  end
endgenerate

integer i, j;
integer error_count;

localparam ADDR_DATA         = 4'h0;
localparam ADDR_SLV_SEL      = 4'h1;
localparam ADDR_CFG          = 4'h2;
localparam ADDR_CLK_PRESCL   = 4'h3;
localparam ADDR_CLK_PRESCH   = 4'h4;
localparam ADDR_INT_STATUS   = 4'h5;
localparam ADDR_INT_ENABLE   = 4'h6;
localparam ADDR_INT_SET      = 4'h7;
localparam ADDR_WORD_CNT     = 4'h8;
localparam ADDR_WORD_CNT_RST = 4'h9;
localparam ADDR_TGT_WORD_CNT = 4'hA;
localparam ADDR_FIFO_RST     = 4'hB;
localparam ADDR_SS_POL       = 4'hC;
localparam ADDR_FIFO_STATUS  = 4'hD;
localparam ADDR_SPI_ENABLE   = 4'hE;

localparam [1:0] DS =  (DATA_WIDTH == 8 ) ? 2'b00 :
                      ((DATA_WIDTH == 16) ? 2'b01 :
                      ((DATA_WIDTH == 24) ? 2'b10 : 2'b11));

reg [25:0]    reg_list [0:13];
reg [8*23:1]  reg_names[0:13];

reg [8*24:1]  test_names;

reg [8:0]     tx_fifo_count;
reg [8:0]     rx_fifo_count;
reg [8:0]     tx_spi_count;
reg [7:0]     exp_status;
reg [7:0]     int_status;
reg [7:0]     int_enable;

reg           interrupt_check_enable;

// initialize register list
initial begin
  // reg_type = 2'b00 - do not check
  // reg_type = 2'b01 - read only
  // reg_type = 2'b10 - write only
  // reg_type = 2'b11 - R/W
  // { reg_type, exp_value, writable_bits, reset value}
  reg_list[0]  = {2'b00, 8'h00, 8'h00, 8'h00};            // DATA_REG
  reg_list[1]  = {2'b11, 8'h00, (8'h00 | {SLAVE_COUNT{1'b1}}), 8'h01}; // SLV_SEL_REG
  reg_list[2]  = {2'b11, 8'h00, 8'hE7, {SPI_EN[0],LSB_FIRST[0],ONLY_WRITE[0],DS,SSNP[0],CPOL[0],CPHA[0]}}; // CFG_REG
  reg_list[3]  = {2'b11, 8'h00, 8'hFF, PRESCALER[7:0]};   // CLK_PRESCL_REG
  reg_list[4]  = {2'b11, 8'h00, 8'hFF, PRESCALER[15:8]};  // CLK_PRESCH_REG
  reg_list[5]  = {2'b00, 8'h00, 8'hBF, 8'h00};            // INT_STATUS_REG
  reg_list[6]  = {2'b11, 8'h00, 8'hBF, 8'h00};            // INT_ENABLE_REG
  reg_list[7]  = {2'b10, 8'h00, 8'h00, 8'h00};            // INT_SET_REG
  reg_list[8]  = {2'b01, 8'h00, 8'h00, 8'h00};            // BYTE_COUNT_REG
  reg_list[9]  = {2'b10, 8'h00, 8'hFF, 8'h00};            // BYTE_COUNT_RST_REG
  reg_list[10] = {2'b11, 8'h00, 8'hFF, 8'h00};            // TARGET_WORD_COUNT_REG
  reg_list[11] = {2'b10, 8'h00, 8'h03, 8'h00};            // FIFO_RST_REG
  reg_list[12] = {2'b11, 8'h00, (8'h00 | {SLAVE_COUNT{1'b1}}), SSPOL[7:0]}; // SS_POL_REG
  reg_list[13] = {2'b01, 8'h00, 8'h00, 8'h19};            // FIFO_STATUS_REG
  reg_list[14] = {2'b11, 8'h00, 8'h01, 8'h00};            // SPI_ENABLE_REG
  reg_names[ 0] = "DATA_REG";
  reg_names[ 1] = "SLV_SEL_REG";
  reg_names[ 2] = "CFG_REG";
  reg_names[ 3] = "CLK_PRESCL_REG";
  reg_names[ 4] = "CLK_PRESCH_REG";
  reg_names[ 5] = "INT_STATUS_REG";
  reg_names[ 6] = "INT_ENABLE_REG";
  reg_names[ 7] = "INT_SET_REG";
  reg_names[ 8] = "BYTE_COUNT_REG";
  reg_names[ 9] = "BYTE_COUNT_RST_REG";
  reg_names[10] = "TARGET_WORD_COUNT_REG";
  reg_names[11] = "FIFO_RST_REG";
  reg_names[12] = "SS_POL_REG";
  reg_names[13] = "FIFO_STATUS_REG";
  reg_names[14] = "SPI_ENABLE_REG";
end

// Test
initial begin
  error_count   = 0;
  tx_fifo_count = 0;
  rx_fifo_count = 0;
  exp_status    = 0;
  int_status    = 0;
  int_enable    = 0;

  interrupt_check_enable = 0;

  repeat(20) @(posedge clk_i); // wait for some time

  test_names = "Register Check";
  register_check();

  @(posedge clk_i)
  test_names = "Reset during IDLE";
  reset_during_idle();

  @(posedge clk_i)
  test_names = "Set Configuration Reg"; //Testbench only supports ssnp=1, cpol=0, cpha=0
  set_cfg_reg();

  @(posedge clk_i)
  test_names = "Normal Operation";
  normal_operation_test();

  if (SPI_EN[0]) begin
    @(posedge clk_i)
    test_names = "Additional Test";
    additional_test();
  end

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
  begin
    $display("\n[%010t] [TEST]: Register access test start!", $time);
    // Set Expected read data to default
    rd_check_all_regs_default();
    $display("[%010t] [TEST]: Register access check Start.", $time);
    for (j=0; j < 5; j=j+1) begin
      for (i=0; i < 15; i=i+1) begin    // write random data to testable regs
        if (reg_list[i][25:24] != 2'b00) begin
          if (j==0)
            wr_data    = 32'hFFFFFFFF;
          else if (j==1)
            wr_data    = 32'h00000000;
          else
            wr_data    = $random;
          lmmi_mst_0.m_write(i[3:0], wr_data);
          reg_list[i][23:16] = get_exp_data(reg_list[i][25:24], reg_list[i][15:8], wr_data[7:0], reg_list[i][7:0]);
        end
      end
      if ((j == 1) || (j == 3)) begin
        $display("[%010t] [TEST]: Reserved address check start.", $time);
        for (i=15; i < 16; i=i+1) begin
          wr_data = $random;
          lmmi_mst_0.m_write(i[3:0], $random);
        end
        for (i=15; i < 16; i=i+1) begin
          lmmi_mst_0.m_read(i[3:0], rd_data);
          data_compare_reg(rd_data,8'h00, "Reserved", i[3:0]);
        end
        $display("[%010t] [TEST]: Reserved address check end.", $time);
      end
      rd_check_all_regs();
    end
    $display("[%010t] [TEST]: Register access check end.", $time);
    $display("[%010t] [TEST]:Register test end!\n", $time);
  end
endtask

task set_cfg_reg();
  reg [DATA_WIDTH-1:0]  rd_data;
  reg [DATA_WIDTH-1:0]  wr_data;
  begin
    lmmi_mst_0.m_read(ADDR_CFG, rd_data);
    wr_data[DATA_WIDTH-1:0] = rd_data[DATA_WIDTH-1:0];
    // wr_data[2:0] = 3'b100;
    reg_write(ADDR_CFG, wr_data);
  end
endtask

task rd_check_all_regs_default();
  reg [DATA_WIDTH-1:0]  rd_data;
  begin
    $display("\n[%010t] [TEST]: Register default data check start.", $time);
    for (i=0; i < 15; i=i+1) begin
      lmmi_mst_0.m_read(i[3:0], rd_data);
      data_compare_reg(rd_data[7:0],reg_list[i][7:0], reg_names[i], i[3:0]);
    end
    $display("[%010t] [TEST]: Register default data check end.\n", $time);
  end
endtask

task rd_check_all_regs();
  reg [DATA_WIDTH-1:0]  rd_data;
  begin
    for (i=0; i < 15; i=i+1) begin
      if (reg_list[i][25:24] != 2'b00) begin
        lmmi_mst_0.m_read(i[3:0], rd_data);
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
    for (i=1; i < 14; i=i+1) begin
      reg_list[i][23:16] = reg_list[i][7:0];
    end
    rd_check_all_regs_default();
    $display("[%010t] [TEST]: Reset during IDLE end.", $time);
    tx_fifo_count = 0;
    rx_fifo_count = 0;
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
    int_status[7] = (tx_spi_count  == (FIFO_DEPTH-8))   ? 1'b1 : 1'b0;
    int_status[6] = 1'b0;
    int_status[5] = (tx_fifo_count == FIFO_DEPTH)       ? 1'b1 : 1'b0;
    int_status[4] = (tx_fifo_count == TX_FIFO_AE_FLAG)  ? 1'b1 : 1'b0;
    int_status[3] = (tx_fifo_count == {9{1'b0}})        ? 1'b1 : 1'b0;
    int_status[2] = (rx_fifo_count == FIFO_DEPTH)       ? 1'b1 : 1'b0;
    int_status[1] = (rx_fifo_count == RX_FIFO_AF_FLAG)  ? 1'b1 : 1'b0;
    int_status[0] = (rx_fifo_count == 9'd1)             ? 1'b1 : 1'b0;
    int_status    = int_status & int_enable;
  end
endtask

task interrupt_check();
  reg [8*40:1]          int_name;
  reg [DATA_WIDTH-1:0]  rd_data;
  reg            [7:0]  int_mask;
  reg            [7:0]  compare_data;
  begin
    //just wait for some time
    for (i=1; i<2*PRESCALER; i=i+1) @(posedge clk_i);

    lmmi_mst_0.m_read(ADDR_INT_ENABLE, rd_data);
    int_enable = rd_data[7:0];
    lmmi_mst_0.m_read(ADDR_INT_STATUS, rd_data);
    int_mask = ~rd_data[7:0];
    compare_data = rd_data[7:0] & int_enable;

    //interrupt naming
    //interrupts can be triggered at the same time
    if (int_status[0])
      int_name = "rx_fifo_ready_en";
    else if (int_status[1])
      int_name = "rx_fifo_afull_en";
    else if (int_status[2])
      int_name = "rx_fifo_full_en";
    else if (int_status[3])
      int_name = "tx_fifo_empty_en";
    else if (int_status[4])
      int_name = "tx_fifo_aempty_en";
    else if (int_status[5])
      int_name = "tx_fifo_full_en";
    else if (int_status[7])
      int_name = "tr_cmp_en";

    if (compare_data == int_status) begin
      $display("[%010t] [TEST]: %0s asserted as expected. INT_STATUS_REG = 0x%02x", $time, int_name, rd_data[7:0]);
      if (PRESCALER <= 2) begin
        // when SPI is very fast, tedious interrupt check will fail since interrupt can re-assert fast
        reg_write(ADDR_INT_STATUS, int_status); // just clear interrupt after checking correct assertion
      end
      else begin
        // interrupt masking check
        reg_write(ADDR_INT_ENABLE, int_mask);
        lmmi_mst_0.m_read(ADDR_INT_ENABLE, rd_data); // dummy read
        if (int_o) begin
          $error("[%010t] [TEST]: Error: interrupt is still asserted when %0s is disabled", $time, int_name);
          error_count = error_count + 1;
        end
        reg_write(ADDR_INT_ENABLE, int_enable);
        lmmi_mst_0.m_read(ADDR_INT_ENABLE, rd_data); // dummy read
        if (~int_o) begin
          $error("[%010t] [TEST]: Error: interrupt did not re-assert when %0s is enabled", $time, int_name);
          error_count = error_count + 1;
        end

        // interrupt clearing check
        reg_write(ADDR_INT_STATUS, ~int_mask);
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

      int_enable[7] = int_status[7] ? 0 : int_enable[7];
      int_enable[5] = int_status[5] ? 0 : int_enable[5];
      int_enable[4] = int_status[4] ? 0 : int_enable[4];
      int_enable[3] = int_status[3] ? 0 : int_enable[3];
      int_enable[2] = int_status[2] ? 0 : int_enable[2];
      int_enable[1] = int_status[1] ? 0 : int_enable[1];
      int_enable[0] = int_status[0] ? 0 : int_enable[0];
      reg_write(ADDR_INT_ENABLE, int_enable);
    end
    else begin
      $error("[%010t] [TEST]: Error: INT_STATUS_REG = 0x%02x when expecting 0x%x while checking for %0s", $time, compare_data, int_status, int_name);
      reg_write(ADDR_INT_STATUS, 8'hFF); // clear all interrupt
      error_count = error_count + 1;
    end
  end
endtask

task check_exp_status();
  begin
    exp_status[7:6] = 2'b0;
    exp_status[5] = (tx_fifo_count == FIFO_DEPTH)      ? 1'b1 : 1'b0;
    exp_status[4] = (tx_fifo_count <= TX_FIFO_AE_FLAG) ? 1'b1 : 1'b0;
    exp_status[3] = (tx_fifo_count == {9{1'b0}})       ? 1'b1 : 1'b0;
    exp_status[2] = (rx_fifo_count >= FIFO_DEPTH)      ? 1'b1 : 1'b0;
    exp_status[1] = (rx_fifo_count >= RX_FIFO_AF_FLAG) ? 1'b1 : 1'b0;
    exp_status[0] = (rx_fifo_count == {9{1'b0}})       ? 1'b1 : 1'b0;
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
  reg [DATA_WIDTH-1:0]  tx_data_lst[1:FIFO_DEPTH];
  reg [DATA_WIDTH-1:0]  rx_data_lst[1:FIFO_DEPTH];
  reg [DATA_WIDTH-1:0]  rd_data;
  reg [DATA_WIDTH-1:0]  mdl_rx_data;
  reg                   cfg_reg_ssnp;
  integer    j, k;
  begin
    $display("[%010t] [TEST]: Normal operation test start.", $time);
    check_fifo_status("FSR_Check0"); //RX_FIFO & TX_FIFO empty check
    // Let's use register default values as set in the GUI
    reg_write(ADDR_TGT_WORD_CNT, (FIFO_DEPTH-8));

    for(i=1;i<FIFO_DEPTH+1;i=i+1) begin // generate data to transmit and receive
      tx_data_lst[i] = $random;
      rx_data_lst[i] = $random;
    end

    //SPI Enable (Start SPI Transfer)
    if (SPI_EN[0])
      reg_write(ADDR_SPI_ENABLE, 8'd1);

    fork
      begin
        repeat(5) @(posedge clk_i); // Added for correct timing of checking FIFO flags
        for(i=1;i<3;i=i+1) begin // Write 2 data to Transmit FIFO
          lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[i]);
          tx_fifo_count = tx_fifo_count + 1;
        end

        @(posedge clk_i);
        @(posedge clk_i);
        check_fifo_status("FSR_Check1"); //TX_FIFO not empty check

        for(i=3;i<(TX_FIFO_AE_FLAG+1);i=i+1) begin // Write data to Transmit FIFO until AlmostEmpty
          lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[i]);
          tx_fifo_count = tx_fifo_count + 1;
        end
        check_fifo_status("FSR_Check2"); //TX_FIFO almost_empty (1) boundary check

        lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[i]); // Write 1 data to Transmit FIFO for AlmostEmpty + 1
        tx_fifo_count = tx_fifo_count + 1;
        check_fifo_status("FSR_Check3"); //TX_FIFO almost_empty (0) boundary check

        if (FIFO_DEPTH > (TX_FIFO_AE_FLAG+1)) begin
          if (FIFO_DEPTH != (TX_FIFO_AE_FLAG+1)) begin
            for(i=i+1;i<FIFO_DEPTH+1;i=i+1) begin // Write data to Transmit FIFO until Full
              lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[i]);
              tx_fifo_count = tx_fifo_count + 1;
            end
            check_fifo_status("FSR_Check4"); //TX_FIFO full (0) is expected here because data has already popped out from Transmit FIFO
          end
        end

        // Clear and enable all interrupts
        reg_write(ADDR_INT_STATUS, 8'hFF);
        int_enable = 8'hFF;
        reg_write(ADDR_INT_ENABLE, int_enable);
        interrupt_check_enable = 1;
      end

      begin // Transmit data checks: SPI master IP Core -> SPI Slave Model
        @(posedge clk_i);
        for(j=1;j<FIFO_DEPTH+1;j=j+1) begin
          fork
            begin
              spi_slv_0.get_rx_data(mdl_rx_data);
              tx_spi_count = tx_spi_count + 1;
              check_int_status();
            end

            begin
            // Get SSNP configuration
              lmmi_mst_0.m_read(ADDR_CFG, rd_data);
              cfg_reg_ssnp = rd_data[2];

              if (cfg_reg_ssnp) begin
                @(negedge ssn_o[0]);
              end

              tx_fifo_count = tx_fifo_count - 1;
              check_int_status();
            end
          join

          if (mdl_rx_data == tx_data_lst[j])
            $display("[%010t] [TEST]: Tx Data[%0d] = 0x%0x as expected.", $time, j, mdl_rx_data);
          else begin
            $error("[%010t] [TEST]: Tx Data[%0d] mismatch expected=0x%0x actual=0x%0x.", $time, j, tx_data_lst[j], mdl_rx_data);
            error_count = error_count + 1;
          end
        end
        @(posedge clk_i);

      //SPI Disable (Stop SPI Transfer)
      if (SPI_EN[0]) begin
        for (i=1; i<CLKS_PER_BIT; i=i+1) @(posedge clk_i); // just wait for some time
        reg_write(ADDR_SPI_ENABLE, 8'd0);
      end

        $display("[%010t] [TEST]: Tx data checks done in SPI Slave Side.", $time);
      end

      begin // Set Receive data: SPI Slave Model -> SPI master IP Core
        if (ONLY_WRITE == 0) begin
		  //@(posedge clk_i);  //JIRA[DNG-16354]
          for(k=1;k<FIFO_DEPTH+1;k=k+1) begin
            spi_slv_0.set_tx_data(rx_data_lst[k]);
            rx_fifo_count = rx_fifo_count + 1;
            check_int_status();
          end

          @(posedge clk_i);
          $display("[%010t] [TEST]: SPI Slave0: data transmission finished.", $time);

          for (k=1; k<CLKS_PER_BIT*4; k=k+1) @(posedge clk_i); //wait for FIFO pop/push
          $display("[%010t] [TEST]: Checking received data", $time);

          for(k=1;k<FIFO_DEPTH+1;k=k+1) begin
            lmmi_mst_0.m_read(ADDR_DATA, rd_data);
            rx_fifo_count = rx_fifo_count - 1;
            check_int_status();
            if (rd_data == rx_data_lst[k])
              $display("[%010t] [TEST]: Rx Data[%0d] = 0x%0x as expected", $time, k, rx_data_lst[k]);
            else begin
              $error("[%010t] [TEST]: Rx Data[%0d] mismatch: expected=0x%0x actual=%0x", $time, k, rx_data_lst[k], rd_data);
              error_count = error_count + 1;
            end
          end
        end
      end
    join

    //Disable interrupt checking
    interrupt_check_enable = 0;
    int_enable = 8'h00;
    reg_write(ADDR_INT_ENABLE, int_enable);

    for (i=1; i<100; i=i+1) @(posedge clk_i); // just wait for some time
    $display("[%010t] [TEST]: Normal operation test end.", $time);
  end
endtask // normal_operation_test

task additional_test();
  reg [DATA_WIDTH-1:0]  tx_data_lst[1:FIFO_DEPTH];
  reg [DATA_WIDTH-1:0]  rd_data;
  begin
    $display("[%010t] [TEST]: Additional test for SPI Enable Register.", $time);
    //just wait for some time
    for (i=1; i<CLKS_PER_BIT; i=i+1) @(posedge clk_i);

    // generate data to transmit
    for(i=1;i<FIFO_DEPTH+1;i=i+1)
      tx_data_lst[i] = $random;

    // Write 2 data to Transmit FIFO
    for(i=1;i<3;i=i+1)
      lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[i]);

    //SPI Enable (Start SPI Transfer)
    reg_write(ADDR_SPI_ENABLE, 8'd1);

    //Wait a long time to see if chip select is still active
    for (i=1; i<((DATA_WIDTH/2)*CLKS_PER_BIT); i=i+1) @(posedge clk_i);

    // Write 2 data to Transmit FIFO
    for(i=3;i<5;i=i+1)
      lmmi_mst_0.m_write(ADDR_DATA, tx_data_lst[i]);

    // Poll Transmit FIFO empty
    for (i=1; i<100; i=i+1) @(posedge clk_i); // just wait for some time
    rd_data = 0;
    while (!rd_data[3]) begin
      lmmi_mst_0.m_read(ADDR_FIFO_STATUS, rd_data);
      for (i=1; i<PRESCALER; i=i+1) @(posedge clk_i); // just wait for some time
    end
    for (i=1; i<(2*CLKS_PER_BIT); i=i+1) @(posedge clk_i); // just wait for some time

    //SPI Disable (Stop SPI Transfer)
    reg_write(ADDR_SPI_ENABLE, 8'd0);

    for (i=1; i<100; i=i+1) @(posedge clk_i); // just wait for some time
    $display("[%010t] [TEST]: Additional test end.", $time);
  end
endtask // additional_test


task wait_for_int(
  input     [31:0] timeout_val
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
      $error("[%010t] [TEST]: Timeout occured while waiting for interrupt.", $time);
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
    if (exp != act) begin
      error_count = error_count + 1;
      $error("[%010t] [reg_test]: Data compare error on %0s register (LMMI Addr=0x%02x). Actual (0x%02x) != Expected (0x%02x)!", $time, reg_name, addr, act, exp);
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

//Check interrupt then disable after checking
always @(posedge clk_i)
  if (interrupt_check_enable) begin
    wait_for_int(32'hFFFFFFFF);
    interrupt_check();
    for (i=1; i<7; i=i+1) @(posedge clk_i); // just wait for some time
    // if (tx_fifo_count == 0)
    //   for (i=1; i<CLKS_PER_BIT; i=i+1) @(posedge clk_i); // just wait for some time
    // check_fifo_status("FSR_Check5");
  end

endmodule
`endif
