//   ==================================================================
//   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
//   ------------------------------------------------------------------
//   Copyright (c) 2014 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
//   ------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
//   --------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
//   --------------------------------------------------------------------

`ifndef __RTL_MODULE__LSCC_LMMI_INITIATOR__
`define __RTL_MODULE__LSCC_LMMI_INITIATOR__
//==========================================================================
// Module : lscc_lmmi_initiator
//==========================================================================
`timescale 1 ns / 1 ps

module lscc_lmmi_initiator

#( //--begin_param--
//----------------------------
// Parameters
//----------------------------

  parameter APB_ENABLE                    = 1,

  parameter I2C_S_OFFSET_WIDTH            = 4'd4,
  parameter I2C_S_DATA_WIDTH              = 4'd8,
  parameter I2C_S_REQ_WIDTH               = 4'd2,


  // I2C Slave Registers
//  parameter I2C_S_WR_DATA_REG_ADDR        = 4'b0000, // Write|----
//  parameter I2C_S_RD_DATA_REG_ADDR        = 4'b0000, // -----|Read
//  parameter I2C_S_SLAVE_ADDRL_REG_ADDR    = 4'b0001, // Write|Read
//  parameter I2C_S_SLAVE_ADDRH_REG_ADDR    = 4'b0010, // Write|Read
//  parameter I2C_S_TIMEOUT_L_REG_ADDR      = 4'b0011, // Write|Read
//  parameter I2C_S_TIMEOUT_H_REG_ADDR      = 4'b0100, // Write|Read
//  parameter I2C_S_CTRL_REG_ADDR           = 4'b0101, // Write|Read
//  parameter I2C_S_BYTE_COUNT_ADDR         = 4'b0110, // Write|Read
//  parameter I2C_S_INT_STATUS1_REG_ADDR    = 4'b0111, // Read |Write 1 to clear
//  parameter I2C_S_INT_ENABLE1_REG_ADDR    = 4'b1000, // Write|Read
//  parameter I2C_S_INT_SET1_REG_ADDR       = 4'b1001, // Write|Read
//  parameter I2C_S_RESERVED_0              = 4'b1010, // -----|----

  parameter I2C_S_WR_DATA_REG_ADDR        = 4'b0000, // Write|----
  parameter I2C_S_RD_DATA_REG_ADDR        = 4'b0000, // -----|Read
  parameter I2C_S_SLAVE_ADDRL_REG_ADDR    = 4'b0001, // Write|Read
  parameter I2C_S_SLAVE_ADDRH_REG_ADDR    = 4'b0010, // Write|Read
  parameter I2C_S_CTRL_REG_ADDR           = 4'b0011, // Write|Read
  parameter I2C_S_TBT_BYTE_CNT_ADDR       = 4'b0110, // Write|Read
  parameter I2C_S_INT_STATUS1_REG_ADDR    = 4'b0101, // Read |Write 1 to clear
  parameter I2C_S_INT_ENABLE1_REG_ADDR    = 4'b0110, // Write|Read
  parameter I2C_S_INT_SET1_REG_ADDR       = 4'b0111, // Write|Read
  parameter I2C_S_INT_STATUS2_REG_ADDR    = 4'b1000, // Read |Write 1 to clear
  parameter I2C_S_INT_ENABLE2_REG_ADDR    = 4'b1001, // Write|Read
  parameter I2C_S_INT_SET2_REG_ADDR       = 4'b1010, // Write|Read
  parameter I2C_S_FIFO_STATUS_REG_ADDR    = 4'b1011, // -----|Read
  parameter I2C_S_RX_ADDR_1_REG_ADDR      = 4'b1100, // -----|Read
  parameter I2C_S_RX_ADDR_2_REG_ADDR      = 4'b1101, // -----|Read
  parameter I2C_S_RESERVED_0              = 4'b1110, // -----|----
  // I2C Master Registers
  parameter WR_DATA_REG_ADDR              =  4'b0000,  // Write|----
  parameter RD_DATA_REG_ADDR              =  4'b0000,  // ---- |Read
  parameter SLAVE_ADDRL_REG_ADDR          =  4'b0001,  // Write|Read
  parameter SLAVE_ADDRH_REG_ADDR          =  4'b0010,  // Write|Read
  parameter CMD_STATUS_REG_ADDR           =  4'b0011,  // ---- |Read
  parameter CONFIG_REG_ADDR               =  4'b0100,  // Write|Read
  parameter CONFIG_REG_SET_ADDR           =  4'b0101,  // Write|----
  parameter CONFIG_REG_RESET_ADDR         =  4'b0110,  // Write|----
  parameter BYTE_CNT_REG_ADDR             =  4'b0111,  // Write|Read
  parameter MODE_REG_ADDR                 =  4'b1000,  // Write|Read
  parameter CLK_DIV_LSB_REG_ADDR          =  4'b1001,  // Write|Read
  parameter INT_STATUS1_REG_ADDR          =  4'b1010,  // Write 1 to clear
  parameter INT_ENABLE1_REG_ADDR          =  4'b1011,  // ---- |Read
  parameter INT_SET1_REG_ADDR             =  4'b1100,  // Write|Read
  parameter INT_STATUS2_REG_ADDR          =  4'b1101,  // Write 1 to clear
  parameter INT_ENABLE2_REG_ADDR          =  4'b1110,  // ---- |Read
  parameter INT_SET2_REG_ADDR             =  4'b1111,  // Write|Read
  parameter ADDR_MODE                     = 10,
  parameter CORE_CLK_MHZ                  = 50,
  parameter SLAVE_ADDR                    = 10

)

( //--begin_ports--
//----------------------------
// Inputs
//----------------------------
input [I2C_S_DATA_WIDTH-1:0]  lmmi_rdata_i,
input                         lmmi_rdata_valid_i,
input                         lmmi_ready_i,

//----------------------------
// Outputs
//----------------------------
output                         lmmi_clk_o,
output                         lmmi_reset_o,
output                         lmmi_resetn_o,
output  [I2C_S_OFFSET_WIDTH - 1 : 0] lmmi_offset_o,

//bit0 refers to I2C master, bit 1 refers to I2C slave
output reg  [I2C_S_REQ_WIDTH   - 1 :0]  active_interface,
output      [I2C_S_REQ_WIDTH   - 1 :0]  lmmi_request_o,


output   [I2C_S_DATA_WIDTH    -1:0]  lmmi_wdata_o,
output                         lmmi_wr_rdn_o

); //--end_ports--

//--------------------------------------------------------------------------
//--- Local Parameters/Defines ---
//--------------------------------------------------------------------------
real                          CLKPERIOD = 1000/CORE_CLK_MHZ;
localparam [9:0]              SLAVE_ADDRESS  = SLAVE_ADDR;
localparam                    I2C_MASTER = 2'b10;
localparam                    I2C_SLAVE  = 2'b01;
localparam [10:0] PRESCALER      = 11'b00000111100;

//--------------------------------------------------------------------------
//--- Combinational Wire/Reg ---
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//--- Registers ---
//--------------------------------------------------------------------------
reg                        lmmi_clk    ;
reg                        lmmi_reset  ;
reg                        lmmi_resetn ;
reg [I2C_S_REQ_WIDTH   - 1 :0]   lmmi_request;
reg [I2C_S_DATA_WIDTH    -1:0]   lmmi_wdata  ;
reg                        lmmi_wr_rdn ;
reg [I2C_S_OFFSET_WIDTH - 1 : 0] lmmi_offset ;
reg                        address_mode;

integer pass = 0;
integer fail = 0;
integer i, j;

assign lmmi_clk_o     = lmmi_clk     ;
assign lmmi_reset_o   = lmmi_reset   ;
assign lmmi_resetn_o  = lmmi_resetn  ;
assign lmmi_request_o = lmmi_request ;
assign lmmi_wdata_o   = lmmi_wdata   ;
assign lmmi_wr_rdn_o  = lmmi_wr_rdn  ;
assign lmmi_offset_o  = lmmi_offset  ;


initial begin
  lmmi_clk     = 0;
  lmmi_offset  = 0;
  lmmi_request = 0;
  lmmi_wdata   = 0;
  lmmi_wr_rdn  = 0;

  lmmi_reset = 1;
  lmmi_resetn = 0;
  #(10*CLKPERIOD)
  lmmi_reset = 0;
  lmmi_resetn = 1;
end

always #(CLKPERIOD/2) lmmi_clk = ~lmmi_clk;

reg  [I2C_S_OFFSET_WIDTH - 1 : 0] addr;
reg  [I2C_S_DATA_WIDTH   - 1 : 0] data;
reg  [I2C_S_DATA_WIDTH   - 1 : 0] rddata;



/// For register test
reg [25:0]   reg_list[0:13];
reg [8*23:1] reg_names[0:13];

initial begin // initialize register list
  // reg_type = 2'b00 - do not check
  // reg_type = 2'b01 - read only
  // reg_type = 2'b10 - write only
  // reg_type = 2'b11 - R/W
  // { reg_type, exp_value, writable_bits, reset value}
  reg_list[0]  = {2'b00, 8'h00, 8'h00, 8'h00};            // DATA_REG
  reg_list[1]  = {2'b11, 8'h00, 8'h7F, {1'b0,SLAVE_ADDRESS[6:0]}};  // SLV_ADDRL
  reg_list[2]  = {2'b11, 8'h00, 8'h07, {5'h00,SLAVE_ADDRESS[9:7]}}; // SLV_ADDRH
  reg_list[3]  = {2'b00, 8'h00, 8'h1F, 8'h00};            // CONTROL     
  reg_list[4]  = {2'b11, 8'h00, 8'hFF, 8'h00};            // TGT_BYTE_CNT
  reg_list[5]  = {2'b00, 8'h00, 8'hFF, 8'h00};            // INT_STATUS1 
  reg_list[6]  = {2'b11, 8'h00, 8'hFF, 8'h00};            // INT_ENABLE1 
  reg_list[7]  = {2'b10, 8'h00, 8'hFF, 8'h00};            // INT_SET1    
  reg_list[8]  = {2'b00, 8'h00, 8'h0F, 8'h00};            // INT_STATUS2 
  reg_list[9]  = {2'b11, 8'h00, 8'h0F, 8'h00};            // INT_ENABLE2 
  reg_list[10] = {2'b10, 8'h00, 8'h0F, 8'h00};            // INT_SET2    
  reg_list[11] = {2'b01, 8'h00, 8'h00, 8'h19};            // FIFO_STATUS 
  reg_list[12] = {2'b01, 8'h00, 8'h00, 8'h00};            // RX_ADDR_1   
  reg_list[13] = {2'b01, 8'h00, 8'h00, 8'h00};            // RX_ADDR_2   
  reg_names[ 0] = "DATA_REG";
  reg_names[ 1] = "SLAVE_ADDRL_REG";
  reg_names[ 2] = "SLAVE_ADDRH_REG";
  reg_names[ 3] = "CONTROL_REG";
  reg_names[ 4] = "TGT_BYTE_CNT_REG";
  reg_names[ 5] = "INT_STATUS1_REG";
  reg_names[ 6] = "INT_ENABLE1_REG";
  reg_names[ 7] = "INT_SET1_REG";
  reg_names[ 8] = "INT_STATUS2_REG";
  reg_names[ 9] = "INT_ENABLE2_REG";
  reg_names[10] = "INT_SET2_REG";
  reg_names[11] = "FIFO_STATUS_REG";
  reg_names[12] = "RX_ADDR1_REG";
  reg_names[13] = "RX_ADDR2_REG";
end



// Test routines
task register_check();
  reg [I2C_S_DATA_WIDTH-1:0]  wr_data;
  reg [I2C_S_DATA_WIDTH-1:0]  rd_data;
  begin
    $display("\n[%010t] : Register access test start!", $time);
    // Set Expected read data to default
    rd_check_all_regs_default();
    $display("[%010t] : Register access check Start.", $time);
    for (j=0; j < 5; j=j+1) begin
      for (i=0; i < 14; i=i+1) begin    // write random data to testable regs
        if (reg_list[i][25:24] != 2'b00) begin
          if (j==0)
            wr_data    = {I2C_S_DATA_WIDTH{1'b1}};
          else if (j==1)
            wr_data    = {I2C_S_DATA_WIDTH{1'b0}};
          else
            wr_data    = $random;
          m_write(i[3:0], I2C_SLAVE, wr_data);
          reg_list[i][23:16] = get_exp_data(reg_list[i][25:24], reg_list[i][15:8], wr_data[7:0], reg_list[i][7:0]);
        end
      end      
      if ((j == 1) || (j == 3)) begin
        $display("[%010t] : Reserved address check start.", $time);
        for (i=14; i < 16; i=i+1) begin
          wr_data = $random;
          m_write(i[3:0], I2C_SLAVE, $random);
        end
        for (i=14; i < 16; i=i+1) begin
          m_read(i[3:0], I2C_SLAVE, rd_data);
          data_compare_reg(rd_data,8'h00, "Reserved", i[3:0]);
        end
        $display("[%010t] : Reserved address check end.", $time);
      end
      rd_check_all_regs(); 
    end
    $display("[%010t] : Register access check end.", $time);
    $display("[%010t] :Register test end!\n", $time);
  end
endtask

task rd_check_all_regs_default();
  reg [I2C_S_DATA_WIDTH-1:0]  rd_data;
  begin
    $display("\n[%010t] : Register default data check start.", $time);
    for (i=0; i < 14; i=i+1) begin
      m_read(i[3:0], I2C_SLAVE, rd_data);
      data_compare_reg(rd_data[7:0],reg_list[i][7:0], reg_names[i], i[3:0]);
    end
    $display("[%010t] : Register default data check end.\n", $time);
  end
endtask

task rd_check_all_regs();
  reg [I2C_S_DATA_WIDTH-1:0]  rd_data;
  begin
    for (i=0; i < 14; i=i+1) begin
      if (reg_list[i][25:24] != 2'b00) begin
        m_read(i[3:0], I2C_SLAVE, rd_data);
        data_compare_reg(rd_data[7:0],reg_list[i][23:16], reg_names[i], i[3:0]);
      end
    end
  end
endtask

task reset_during_idle();
  begin
    $display("[%010t] : Reset during IDLE start.", $time);
    // Previous register test updated the register values  
    @(posedge lmmi_clk);
    @(posedge lmmi_clk);
    @(posedge lmmi_clk);

    $display("[%010t] : Asserting reset for 2 clock cycles.", $time);
    @(posedge lmmi_clk);
    lmmi_reset  <= 1'b1;
    lmmi_resetn <= 1'b0;
    @(posedge lmmi_clk);
    @(posedge lmmi_clk);
    lmmi_reset  <= 1'b0;
    lmmi_resetn <= 1'b1;
    @(posedge lmmi_clk);
    $display("[%010t] : Check that register default values are correct.", $time);
    for (i=1; i < 14; i=i+1) begin
      reg_list[i][23:16] = reg_list[i][7:0];
    end
    rd_check_all_regs_default();
    $display("[%010t] : Reset during IDLE end.", $time);
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
      fail = fail + 1;
      $error("[%010t] [reg_test]: Data compare error on %0s register (LMMI Addr=0x%02x). Actual (0x%02x) != Expected (0x%02x)!", $time, reg_name, addr, act, exp);
    end
    else 
      pass = pass + 1;
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

initial begin

  @(posedge lmmi_resetn);
  repeat(50) @(posedge lmmi_clk);

$display("[%0t]\t***REGISTER WRITE/READ TEST -- BEGIN***", $realtime);
  register_check();
  reset_during_idle();

//        Slave config and data
//        10 bit mode

  data = {
    3'h0, // reserved
    1'b0, // nack_data        = i2c_ctrl[4];
    1'b0, // nack_addr        = i2c_ctrl[3];
    1'b0, // reset            = i2c_ctrl[2];
    1'b0, // clk_stretch_en   = i2c_ctrl[1];
    1'd1};// addr_10bit_en    = i2c_ctrl[0];
  m_write(I2C_S_CTRL_REG_ADDR,        I2C_SLAVE,  data  );
  m_read (I2C_S_CTRL_REG_ADDR,        I2C_SLAVE,  rddata);
  CHK_RESP (data, rddata, I2C_S_CTRL_REG_ADDR);

  data = SLAVE_ADDRESS[7:0];
  m_write(I2C_S_SLAVE_ADDRL_REG_ADDR, I2C_SLAVE,  data  );
  m_read (I2C_S_SLAVE_ADDRL_REG_ADDR, I2C_SLAVE,  rddata);
  CHK_RESP (data, rddata, I2C_S_SLAVE_ADDRL_REG_ADDR);

  data = {6'b0, SLAVE_ADDRESS[9:8]};
  m_write(I2C_S_SLAVE_ADDRH_REG_ADDR, I2C_SLAVE,  data  );
  m_read (I2C_S_SLAVE_ADDRH_REG_ADDR, I2C_SLAVE,  rddata);
  CHK_RESP (data, rddata, I2C_S_SLAVE_ADDRH_REG_ADDR);


//        Master config and data
  addr = CLK_DIV_LSB_REG_ADDR;
  data = PRESCALER[7:0];
  m_write (addr, I2C_MASTER, data   );
  m_read  (addr, I2C_MASTER, rddata );
  CHK_RESP(data, rddata,     addr   );

$display("[%0t]\t***REGISTER WRITE/READ TEST -- END  ***", $realtime);

$display("[%0t]\t*** 10 Bit Address Mode ***", $realtime);
$display("\t\t Master-Receiver : Slave-Transmitter ");

  @(posedge lmmi_clk);
  data = {
      1'b0, //[7] Reserved
      1'b0, //[6] Reserved
      1'b0, //[5] soft_reset
      1'b0, //[4] abort_reg
      1'b1, //[3] tx_ie
      1'b0, //[2] rx_ie
      1'b0, //[1] intr_clr_reg
      1'b0  //[0] start_reg
  };
  m_write(CONFIG_REG_ADDR,            I2C_MASTER, data);
  m_write(SLAVE_ADDRL_REG_ADDR,       I2C_MASTER, {1'b0, SLAVE_ADDRESS[6:0]});
  m_write(SLAVE_ADDRH_REG_ADDR,       I2C_MASTER, {5'b0, SLAVE_ADDRESS[9:7]});
  m_write(BYTE_CNT_REG_ADDR,          I2C_MASTER, 8'h02);

  data =
  {
    2'b01,           // bps_mode   = mode_reg[7:6]
    1'b1,            // adr_mode   = mode_reg[5]
    1'b1,            // ack_mode   = mode_reg[4];
    1'b1,            // rw_mode    = mode_reg[3](1-read, 0-write)
    PRESCALER[10:8]  // scl_divcnt = mode_reg[2:0]
  };
  m_write(MODE_REG_ADDR,              I2C_MASTER, data);
  @(posedge lmmi_clk);
  @(posedge lmmi_clk);
  @(posedge lmmi_clk);
  m_read (CONFIG_REG_ADDR,            I2C_MASTER, rddata);

  data = 8'hAA;
  addr = I2C_S_WR_DATA_REG_ADDR;
  m_write (addr, I2C_SLAVE,  data  );
  data = 8'h55;
  addr = I2C_S_WR_DATA_REG_ADDR;
  m_write (addr, I2C_SLAVE,  data  );

  m_write(CONFIG_REG_ADDR,            I2C_MASTER, (8'h01 | rddata));
  rddata = 8'h00;

  while (rddata[6] == 1'b0 ) begin  // Polling for stop_det_int
    repeat (100) @(posedge lmmi_clk);
    m_read (I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, rddata);
  end /// Slave done write process


  /// Update Slaves transmit data register
  rddata[1] = 1'b0;

// No need to poll I2C Master when STOP Cond. is detected
//  while (rddata[1] == 1'b0 ) begin
//    repeat (10) @(posedge lmmi_clk);
//    m_read (INT_STATUS1_REG_ADDR,      I2C_MASTER, rddata);
//  end /// Master receives data from Slave

  /// Check data
  m_read (RD_DATA_REG_ADDR, I2C_MASTER, rddata);
  if (rddata == 8'hAA) begin
    $display("@ %010t: Data compare 1 PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: Data compare 1 FAIL", $time);
    fail = fail + 1;
  end


  /// Flush Masters status register1
  data = 8'hFF;
  addr = INT_STATUS1_REG_ADDR;
  m_write (addr, I2C_MASTER,  data  );


  repeat (3) @(posedge lmmi_clk);
//  rddata[1]  = 1'd0;
//
//  while (rddata[1] == 1'b0 ) begin
//    repeat (10) @(posedge lmmi_clk);
//    m_read (INT_STATUS1_REG_ADDR,      I2C_MASTER, rddata);
//  end
  /// Master receives data from Slave

  /// Check data
  m_read (RD_DATA_REG_ADDR, I2C_MASTER, rddata);
  if (rddata == 8'h55) begin
    $display("@ %010t: Data compare 2 PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: Data compare 2 FAIL", $time);
    fail = fail + 1;
  end

  // Check received register fields
  m_read (I2C_S_RX_ADDR_1_REG_ADDR, I2C_SLAVE, rddata);
    if (rddata == {{5'b11110},{SLAVE_ADDRESS[9:8]},{1'b0}}) begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR FAIL. Exp: %0x. Act:%0x", $time, {{5'b11110},{SLAVE_ADDRESS[9:8]},{1'b0}}, rddata);
    fail = fail + 1;
  end

  m_read (I2C_S_RX_ADDR_2_REG_ADDR, I2C_SLAVE, rddata);
    if (rddata == {SLAVE_ADDRESS[7:0]}) begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: I2C_S_RX_ADDR_2_REG_ADDR FAIL. Exp: %0x. Act:%0x", $time, {SLAVE_ADDRESS[7:0]}, rddata);
    fail = fail + 1;
  end

  m_read (CONFIG_REG_ADDR,            I2C_MASTER, rddata);
  m_write(CONFIG_REG_ADDR,            I2C_MASTER, (8'h08 | rddata));

  repeat (999) @(posedge lmmi_clk);


$display("[%0t]\t*** 10 Bit Address Mode ***", $realtime);
$display("\t\t Master-Transmitter : Slave-Receiver ");



  data = {
    2'b01,           // bps_mode   = mode_reg[7:6]
    1'b1,            // adr_mode   = mode_reg[5]
    1'b1,            // ack_mode   = mode_reg[4];
    1'b0,            // rw_mode    = mode_reg[3](1-read, 0-write)
    PRESCALER[10:8]  // scl_divcnt = mode_reg[2:0]
  };
  m_write(MODE_REG_ADDR,              I2C_MASTER, data);

  @(posedge lmmi_clk);
  data = {
      1'b0, //[7] Reserved
      1'b0, //[6] Reserved
      1'b0, //[5] soft_reset
      1'b0, //[4] abort_reg
      1'b1, //[3] tx_ie
      1'b1, //[2] rx_ie
      1'b0, //[1] intr_clr_reg
      1'b0  //[0] start_reg
  };
  m_write(CONFIG_REG_ADDR,   I2C_MASTER, data);
  m_write(BYTE_CNT_REG_ADDR, I2C_MASTER, 8'h02);
  m_write(WR_DATA_REG_ADDR,  I2C_MASTER, 8'hAA);
  m_write(WR_DATA_REG_ADDR,  I2C_MASTER, 8'h55);
  repeat (3) @(posedge lmmi_clk);
  /// Flush Masters status register1
  data = 8'hFF;
  addr = INT_STATUS1_REG_ADDR;
  m_write (addr, I2C_MASTER,  data  );

  m_read (CONFIG_REG_ADDR,            I2C_MASTER, rddata);
  m_write(CONFIG_REG_ADDR,            I2C_MASTER, (8'h01 | rddata));


  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, 8'hFF);

  rddata[6] = 1'b0;
  while (rddata[6] == 1'b0 ) begin    // polling for stop_det_int
    repeat (100) @(posedge lmmi_clk);
    m_read (I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, rddata);
  end /// Slave receives data from Master

  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, 8'hFF);

  /// Check data
  m_read (I2C_S_RD_DATA_REG_ADDR, I2C_SLAVE, rddata);
  if (rddata == 8'hAA) begin
    $display("@ %010t: Data compare 3 PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: Data compare 3 FAIL", $time);
    fail = fail + 1;
  end
  
  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, 8'hFF);
  
//  rddata[6] = 1'b0;
//  while (rddata[6] == 1'b0 ) begin
//    repeat (10) @(posedge lmmi_clk);
//    m_read (I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, rddata);
//  end /// Slave receives data from Master
//
//  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, 8'hFF);

  /// Check data
  m_read (I2C_S_RD_DATA_REG_ADDR, I2C_SLAVE, rddata);
  if (rddata == 8'h55) begin
    $display("@ %010t: Data compare 4 PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: Data compare 4 FAIL", $time);
    fail = fail + 1;
  end

  // Check received register fields
  m_read (I2C_S_RX_ADDR_1_REG_ADDR, I2C_SLAVE, rddata);
    if (rddata == {{5'b11110},{SLAVE_ADDRESS[9:8]},{1'b0}}) begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR FAIL. Exp: %0x. Act:%0x", $time, {{5'b11110},{SLAVE_ADDRESS[9:8]},{1'b0}}, rddata);
    fail = fail + 1;
  end

  m_read (I2C_S_RX_ADDR_2_REG_ADDR, I2C_SLAVE, rddata);
    if (rddata == {SLAVE_ADDRESS[7:0]}) begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: I2C_S_RX_ADDR_2_REG_ADDR FAIL. Exp: %0x. Act:%0x", $time, {SLAVE_ADDRESS[7:0]}, rddata);
    fail = fail + 1;
  end


  repeat (999) @(posedge lmmi_clk);


$display("[%0t]\t*** 7 Bit Address Mode ***", $realtime);
$display("\t\t Master-Receiver : Slave-Transmitter ");

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@(posedge lmmi_clk);
  data = {
      1'b0, //[7] Reserved
      1'b0, //[6] Reserved
      1'b0, //[5] soft_reset
      1'b0, //[4] abort_reg
      1'b1, //[3] tx_ie
      1'b0, //[2] rx_ie
      1'b0, //[1] intr_clr_reg
      1'b0  //[0] start_reg
  };
  m_write(CONFIG_REG_ADDR,            I2C_MASTER, data);
  m_write(SLAVE_ADDRL_REG_ADDR,       I2C_MASTER, {1'b0, SLAVE_ADDRESS[6:0]});
  m_write(SLAVE_ADDRH_REG_ADDR,       I2C_MASTER, {5'b0, SLAVE_ADDRESS[9:7]});
  m_write(BYTE_CNT_REG_ADDR,          I2C_MASTER, 8'h02);

  // Set slave address mode to 7 bit
  // for slave
  addr    = I2C_S_CTRL_REG_ADDR;
  data = {
    1'b1, // i2c_init_intr_en     = i2c_ctrl[7];
    1'b1, // i2c_rw_done_intr_en  = i2c_ctrl[6];
    1'b0, // i2c_timeout_intr_en  = i2c_ctrl[5];
    1'b0, // i2c_ack_busy         = i2c_ctrl[4];
    1'b0, // i2c_timeout_en       = i2c_ctrl[3];
    1'b0, // i2c_hs_mode_en       = i2c_ctrl[2];
    1'b0, // i2c_sclk_stretch_en  = i2c_ctrl[1];
    1'b0  // i2c_10bit_addr_en    = i2c_ctrl[0];
  };
  m_write(I2C_S_CTRL_REG_ADDR,        I2C_SLAVE,  data);

  data =
  {
    2'b01,           // bps_mode   = mode_reg[7:6]
    1'b0,            // adr_mode   = mode_reg[5]
    1'b1,            // ack_mode   = mode_reg[4];
    1'b1,            // rw_mode    = mode_reg[3](1-read, 0-write)
    PRESCALER[10:8]  // scl_divcnt = mode_reg[2:0]
  };
  m_write(MODE_REG_ADDR,              I2C_MASTER, data);
  m_read (CONFIG_REG_ADDR,            I2C_MASTER, rddata);

  data = 8'hAA;
  addr = I2C_S_WR_DATA_REG_ADDR;
  m_write (addr, I2C_SLAVE,  data  );
  /// Update Slaves transmit data register
  data = 8'h55;
  addr = I2C_S_WR_DATA_REG_ADDR;
  m_write (addr, I2C_SLAVE,  data  );

  m_write(CONFIG_REG_ADDR,            I2C_MASTER, (8'h01 | rddata));
  rddata = 8'h00;

  
  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, 8'hFF);
  
  while (rddata[6] == 1'b0 ) begin
    repeat (10) @(posedge lmmi_clk);
    m_read (I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, rddata);
  end /// Slave done write process


  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, 8'hFF);
  
  rddata[1] = 1'b0;

//  while (rddata[1] == 1'b0 ) begin
//    repeat (10) @(posedge lmmi_clk);
//    m_read (INT_STATUS1_REG_ADDR,      I2C_MASTER, rddata);
//  end /// Master receives data from Slave

  /// Check data
  m_read (RD_DATA_REG_ADDR, I2C_MASTER, rddata);
  if (rddata == 8'hAA) begin
    $display("@ %010t: Data compare 5 PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: Data compare 5 FAIL", $time);
    fail = fail + 1;
  end


  /// Flush Masters status register1
  data = 8'hFF;
  addr = INT_STATUS1_REG_ADDR;
  m_write (addr, I2C_MASTER,  data  );


  repeat (3) @(posedge lmmi_clk);
//  rddata[1]  = 1'd0;
//
//  while (rddata[1] == 1'b0 ) begin
//    repeat (10) @(posedge lmmi_clk);
//    m_read (INT_STATUS1_REG_ADDR,      I2C_MASTER, rddata);
//  end
  /// Master receives data from Slave

  /// Check data
  m_read (RD_DATA_REG_ADDR, I2C_MASTER, rddata);
  if (rddata == 8'h55) begin
    $display("@ %010t: Data compare 6 PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: Data compare 6 FAIL", $time);
    fail = fail + 1;
  end

  // Check received register fields
  m_read (I2C_S_RX_ADDR_1_REG_ADDR, I2C_SLAVE, rddata);
    if (rddata == {{SLAVE_ADDRESS[7:0]},{1'b1}}) begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR FAIL. Exp: %0x. Act:%0x", $time, {{SLAVE_ADDRESS[7:0]},{1'b1}}, rddata);
    fail = fail + 1;
  end


  m_read (CONFIG_REG_ADDR,            I2C_MASTER, rddata);
  m_write(CONFIG_REG_ADDR,            I2C_MASTER, (8'h08 | rddata));

  repeat (999) @(posedge lmmi_clk);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$display("[%0t]\t*** 7 Bit Address Mode ***", $realtime);
$display("\t\t Master-Transmitter : Slave-Receiver ");



  data = {
    2'b01,            // bps_mode   = mode_reg[7:6]
    1'b0,             // adr_mode   = mode_reg[5]
    1'b1,             // ack_mode   = mode_reg[4];
    1'b0,             // rw_mode    = mode_reg[3](1-read, 0-write)
    PRESCALER[10:8]   // scl_divcnt = mode_reg[2:0]
  };
  m_write(MODE_REG_ADDR,              I2C_MASTER, data);

  @(posedge lmmi_clk);
  data = {
      1'b0, //[7] Reserved
      1'b0, //[6] Reserved
      1'b0, //[5] soft_reset
      1'b0, //[4] abort_reg
      1'b1, //[3] tx_ie
      1'b1, //[2] rx_ie
      1'b0, //[1] intr_clr_reg
      1'b0  //[0] start_reg
  };
  m_write(CONFIG_REG_ADDR,                 I2C_MASTER, data);
  m_write(BYTE_CNT_REG_ADDR,               I2C_MASTER, 8'h02);
  m_write(WR_DATA_REG_ADDR,                I2C_MASTER, 8'hAA);
  m_write(WR_DATA_REG_ADDR,                I2C_MASTER, 8'h55);
  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE,  8'hFF);
  repeat (3) @(posedge lmmi_clk);
  /// Flush Masters status register1
  data = 8'hFF;
  addr = INT_STATUS1_REG_ADDR;
  m_write (addr, I2C_MASTER,  data  );

  m_read (CONFIG_REG_ADDR,            I2C_MASTER, rddata);
  m_write(CONFIG_REG_ADDR,            I2C_MASTER, (8'h01 | rddata));



  rddata[6] = 1'b0;
  while (rddata[6] == 1'b0 ) begin
    repeat (100) @(posedge lmmi_clk);
    m_read (I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, rddata);
  end /// Slave receives data from Master

  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, 8'hFF);

  /// Check data
  m_read (I2C_S_RD_DATA_REG_ADDR, I2C_SLAVE, rddata);
  if (rddata == 8'hAA) begin
    $display("@ %010t: Data compare 7 PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: Data compare 7 FAIL", $time);
    fail = fail + 1;
  end

  
  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, 8'hFF);
  
  rddata[6] = 1'b0;
//  while (rddata[6] == 1'b0 ) begin
//    repeat (10) @(posedge lmmi_clk);
//    m_read (I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, rddata);
//  end /// Slave receives data from Master

  m_write(I2C_S_INT_STATUS1_REG_ADDR,      I2C_SLAVE, 8'hFF);

  /// Check data
  m_read (I2C_S_RD_DATA_REG_ADDR, I2C_SLAVE, rddata);
  if (rddata == 8'h55) begin
    $display("@ %010t: Data compare 8 PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: Data compare 8 FAIL", $time);
    fail = fail + 1;
  end

  // Check received register fields
  m_read (I2C_S_RX_ADDR_1_REG_ADDR, I2C_SLAVE, rddata);
    if (rddata == {{SLAVE_ADDRESS[7:0]},{1'b0}}) begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR PASS", $time);
    pass = pass + 1;
  end
  else begin
    $display("@ %010t: I2C_S_RX_ADDR_1_REG_ADDR FAIL. Exp: %0x. Act:%0x", $time, {{SLAVE_ADDRESS[7:0]},{1'b0}}, rddata);
    fail = fail + 1;
  end


  repeat (999) @(posedge lmmi_clk);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (fail == 0 & pass != 0) begin
    $display("*** SIMULATION PASSED ***");
  end
  else begin
    $display("*** SIMULATION FAILED ***");
  end
  $stop;
  repeat (20000) @(posedge lmmi_clk);


  m_read (CONFIG_REG_ADDR,            I2C_MASTER, rddata);
  m_write(CONFIG_REG_ADDR,            I2C_MASTER, (8'b 11111101 & rddata));
  m_write(CONFIG_REG_ADDR,            I2C_MASTER, (8'b 00000010 | rddata));
  // `include "tmp.v"

  /// Davit

  $stop;
  /// Davit
end


task m_write
(
  input  [I2C_S_OFFSET_WIDTH - 1: 0] addr,
  input  [I2C_S_REQ_WIDTH  - 1: 0] request,
  input  [I2C_S_DATA_WIDTH - 1: 0] data
);
  reg           done;
  begin
    //@(posedge lmmi_clk);
    lmmi_request <= request;
    active_interface <= request;
    lmmi_wr_rdn <= 1'b1;
    lmmi_wdata <= data;
    lmmi_offset <= addr;
    if (APB_ENABLE && request == 2'd1) begin
      @(posedge lmmi_clk);
      lmmi_request <= 2'd0;
      @(negedge lmmi_ready_i);
      @(posedge lmmi_clk);
    end
    else begin
      done = 0;
      while(!done) begin
        @(posedge lmmi_clk);
          done = lmmi_ready_i;
      end
      
      lmmi_request <= 0;
      lmmi_wr_rdn <= 1'b0;
    end
  end
endtask // m_write

task m_read
(
  input  [I2C_S_OFFSET_WIDTH - 1: 0] addr,
  input  [I2C_S_REQ_WIDTH  - 1: 0] request,
  output [I2C_S_DATA_WIDTH - 1: 0] rddata
);
  reg           done;
  reg           valid;
  begin
    //@(posedge lmmi_clk);
    lmmi_request <= request;
    active_interface <= request;
    lmmi_wr_rdn <= 1'b0;
    lmmi_offset <= addr;
    if (APB_ENABLE && request == 2'd1) begin
      @(posedge lmmi_clk);
      lmmi_request <= 2'd0;
      while (!lmmi_rdata_valid_i) begin
        @(posedge lmmi_clk);
      end
      rddata = lmmi_rdata_i;
    end
    else begin
      fork
        begin // request
          done = 0;
          while(!done) begin
            @(posedge lmmi_clk);
              done = lmmi_ready_i;
          end
          lmmi_request <= 0;
        end
        begin // data
          valid = 0;
          while(!valid | !done) begin
            @(posedge lmmi_clk);
              valid = lmmi_rdata_valid_i;
          end
          rddata = lmmi_rdata_i;
        end
      join
    end
  end
endtask // m_read

task CHK_RESP
(
input [I2C_S_DATA_WIDTH - 1 : 0] wr_data,
input [I2C_S_DATA_WIDTH - 1 : 0] rd_data,
input [I2C_S_OFFSET_WIDTH - 1 : 0] addr
);
  if (wr_data != rd_data) begin
    $display ("[%0t] ERROR : Address = %0x; Expected Data = %0x; Actual Data = %0x", $realtime, addr, wr_data, rd_data);
    fail = fail + 1;
  end
  else begin
    $display ("[%0t] CHECK PASS : Address = %0x; Data = %0x;", $realtime, addr, rd_data);
    pass = pass + 1;
  end
endtask


endmodule //--lscc_lmmi_initiator--
`endif // __RTL_MODULE__LSCC_LMMI_INITIATOR__
