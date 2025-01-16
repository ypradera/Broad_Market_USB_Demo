`ifndef __RTL_MODULE__TB_TOP__
`define __RTL_MODULE__TB_TOP__

//`include "tb_fifo.v"
`include "lscc_lmmi_initiator.v"
`include "lscc_i2c_controller.v"
`include "lscc_lmmi2apb.v"

//`timescale 1ns / 1ps
//==========================================================================
// Module : tb_top
//==========================================================================
module tb_top;

localparam data_width      = 8;
localparam addr_width      = 4;
localparam req_width       =  2;
localparam i2c_mode        = "STANDARD";
localparam configurable    = 1;
localparam clk_div_lsb     = 8'h30;
localparam pull_up_enable  = "YES";

// I2C Slave Registers
localparam I2C_S_OFFSET_WIDTH          = 4'd4;
localparam I2C_S_DATA_WIDTH            = 4'd8;
localparam I2C_S_REQ_WIDTH             = 4'd2;

// I2C Slave Registers
//localparam I2C_S_WR_DATA_REG_ADDR      = 4'b0000; // Write|----                                
//localparam I2C_S_RD_DATA_REG_ADDR      = 4'b0000; // -----|Read
//localparam I2C_S_SLAVE_ADDRL_REG_ADDR  = 4'b0001; // Write|Read
//localparam I2C_S_SLAVE_ADDRH_REG_ADDR  = 4'b0010; // Write|Read
//localparam I2C_S_TIMEOUT_L_REG_ADDR    = 4'b0011; // Write|Read
//localparam I2C_S_TIMEOUT_H_REG_ADDR    = 4'b0100; // Write|Read
//localparam I2C_S_CTRL_REG_ADDR         = 4'b0101; // Write|Read
//localparam I2C_S_CTRL_REG_ADDR1        = 4'b0110; // Write|Read
//localparam I2C_S_BYTE_COUNT_ADDR       = 4'b0111; // Write|Read
//localparam I2C_S_INT_STATUS1_REG_ADDR  = 4'b1000; // Read |Write 1 to clear
//localparam I2C_S_INT_ENABLE1_REG_ADDR  = 4'b1001; // Write|Read
//localparam I2C_S_INT_SET1_REG_ADDR     = 4'b1010; // Write|Read
//localparam I2C_S_RESERVED_0            = 4'b1011; // -----|----
localparam I2C_S_WR_DATA_REG_ADDR      = 4'b0000; // Write|----
localparam I2C_S_RD_DATA_REG_ADDR      = 4'b0000; // -----|Read
localparam I2C_S_SLAVE_ADDRL_REG_ADDR  = 4'b0001; // Write|Read
localparam I2C_S_SLAVE_ADDRH_REG_ADDR  = 4'b0010; // Write|Read
localparam I2C_S_CTRL_REG_ADDR         = 4'b0011; // Write|Read
localparam I2C_S_TBT_BYTE_CNT_ADDR     = 4'b0110; // Write|Read
localparam I2C_S_INT_STATUS1_REG_ADDR  = 4'b0101; // Read |Write 1 to clear
localparam I2C_S_INT_ENABLE1_REG_ADDR  = 4'b0110; // Write|Read
localparam I2C_S_INT_SET1_REG_ADDR     = 4'b0111; // Write|Read
localparam I2C_S_RESERVED_0            = 4'b1100; // -----|----

// I2C Master Registers
localparam WR_DATA_REG_ADDR            =  4'b0000;  // Write|----
localparam RD_DATA_REG_ADDR            =  4'b0000;  // ---- |Read
localparam SLAVE_ADDRL_REG_ADDR        =  4'b0001;  // Write|Read
localparam SLAVE_ADDRH_REG_ADDR        =  4'b0010;  // Write|Read
localparam CMD_STATUS_REG_ADDR         =  4'b0011;  // ---- |Read
localparam CONFIG_REG_ADDR             =  4'b0100;  // Write|Read
localparam CONFIG_REG_SET_ADDR         =  4'b0101;  // Write|----
localparam CONFIG_REG_RESET_ADDR       =  4'b0110;  // Write|----
localparam BYTE_CNT_REG_ADDR           =  4'b0111;  // Write|Read
localparam MODE_REG_ADDR               =  4'b1000;  // Write|Read
localparam CLK_DIV_LSB_REG_ADDR        =  4'b1001;  // Write|Read
localparam INT_STATUS1_REG_ADDR        =  4'b1010;  // Write 1 to clear
localparam INT_ENABLE1_REG_ADDR        =  4'b1011;  // ---- |Read
localparam INT_SET1_REG_ADDR           =  4'b1100;  // Write|Read
localparam INT_STATUS2_REG_ADDR        =  4'b1101;  // Write 1 to clear
localparam INT_ENABLE2_REG_ADDR        =  4'b1110;  // ---- |Read
localparam INT_SET2_REG_ADDR           =  4'b1111;  // Write|Read

`include "dut_params.v"

localparam integer   DATA_WIDTH        = 8;
localparam integer   WDATA_WIDTH       = DATA_WIDTH;
localparam integer   RDATA_WIDTH       = DATA_WIDTH;
localparam integer   OFFSET_WIDTH      = 4;
localparam           I2C_MODE          = "HIGH_SPEED"; // "FAST"; "STANDARD"
localparam           ARBT              = "ON";
localparam           CLK_DIV_LSB       = 8'h30;
localparam           PULL_UP_ENABLE    = 1;
localparam [15:0]    PRESCALER         = 8'd255;
localparam           TX_DONE_IE        = 0;
localparam           RX_DONE_IE        = 0;
localparam           TX_ERROR_IE       = 0;
localparam           RX_ERROR_IE       = 0;
localparam           ABOR_ACK_IE       = 0;
localparam           ARBTR_LOST_IE     = 0;
localparam           SCL_TIMEOUT_IE    = 0;
//localparam           SYS_CLOCK_FREQ    = 200;

localparam SYS_CLK_PERIOD = (1000/SYS_CLOCK_FREQ);


//LMMI related
wire                             clk_i                ;
wire                             lmmi_error           ;
wire        [addr_width - 1:0]   lmmi_offset_i          ;

wire        [data_width - 1:0]   lmmi_rdata_o         ;
wire        [data_width - 1:0]   lmmi_rdata_m         ;
wire        [data_width - 1:0]   lmmi_rdata_comb      ;

wire                             lmmi_rdata_valid_o   ;
wire                             lmmi_rdata_valid_m   ;
wire                             lmmi_rdata_valid_comb;

wire                             lmmi_ready_o         ;
wire                             lmmi_ready_m         ;
wire                             lmmi_ready_comb      ;

wire        [req_width  - 1:0]   lmmi_request         ;
wire                             lmmi_reset           ;
wire                             rst_n_i          ;
wire        [data_width - 1:0]   lmmi_wdata_i           ;
wire                             lmmi_wr_rdn_i          ;

wire                             int_o          ;
wire                             lintr_int_m          ;
wire                             lintr_int_comb       ;
//I2C related
tri1                             scl_io                ;
tri1                             sda_io                  ;
wire                             scl_i;
wire                             scl_oe_o;
wire                             sda_o;
wire                             sda_oe_o;

wire [1:0]                       active_interface     ;

/// APB
wire                             apb_penable_i;
wire                             apb_psel_i;
wire                             apb_pwrite_i;
wire [15:0]                      apb_paddr_i;
wire [31:0]                      apb_pwdata_i;
wire                             apb_pready_o;
wire                             apb_pslverr_o;
wire [31:0]                      apb_prdata_o;
/// APB <=> Initiator
wire [32:0]            apb_lmmi_wdata_w;
wire [32:0]            apb_lmmi_rdata_o;
wire                             apb_lmmi_rdata_valid_o;
wire                             apb_lmmi_ready_o;
wire [15:0]                      lmmi_offset_w;
//--------------------------------------------------------------------------
//--- Module Instantiation ---
//--------------------------------------------------------------------------
lscc_lmmi_initiator #
(
 //--begin_param--
//----------------------------
// Parameters
//----------------------------
  .APB_ENABLE                    (APB_ENABLE),
  .I2C_S_OFFSET_WIDTH            (I2C_S_OFFSET_WIDTH),
  .I2C_S_DATA_WIDTH              (I2C_S_DATA_WIDTH),
  .I2C_S_REQ_WIDTH               (I2C_S_REQ_WIDTH),
//  .I2C_S_WR_DATA_REG_ADDR        (I2C_S_WR_DATA_REG_ADDR),
//  .I2C_S_RD_DATA_REG_ADDR        (I2C_S_RD_DATA_REG_ADDR),
//  .I2C_S_SLAVE_ADDRL_REG_ADDR    (I2C_S_SLAVE_ADDRL_REG_ADDR),
//  .I2C_S_SLAVE_ADDRH_REG_ADDR    (I2C_S_SLAVE_ADDRH_REG_ADDR),
//  .I2C_S_TIMEOUT_L_REG_ADDR      (I2C_S_TIMEOUT_L_REG_ADDR),
//  .I2C_S_TIMEOUT_H_REG_ADDR      (I2C_S_TIMEOUT_H_REG_ADDR),
//  .I2C_S_CTRL_REG_ADDR           (I2C_S_CTRL_REG_ADDR),
//  .I2C_S_BYTE_COUNT_ADDR         (I2C_S_BYTE_COUNT_ADDR),
//  .I2C_S_INT_STATUS1_REG_ADDR    (I2C_S_INT_STATUS1_REG_ADDR),
//  .I2C_S_INT_ENABLE1_REG_ADDR    (I2C_S_INT_ENABLE1_REG_ADDR),
//  .I2C_S_INT_SET1_REG_ADDR       (I2C_S_INT_SET1_REG_ADDR),
//  .I2C_S_RESERVED_0              (I2C_S_RESERVED_0),
  .I2C_S_WR_DATA_REG_ADDR        (I2C_S_WR_DATA_REG_ADDR    ),
  .I2C_S_RD_DATA_REG_ADDR        (I2C_S_RD_DATA_REG_ADDR    ),
  .I2C_S_SLAVE_ADDRL_REG_ADDR    (I2C_S_SLAVE_ADDRL_REG_ADDR),
  .I2C_S_SLAVE_ADDRH_REG_ADDR    (I2C_S_SLAVE_ADDRH_REG_ADDR),
  .I2C_S_CTRL_REG_ADDR           (I2C_S_CTRL_REG_ADDR       ),
  .I2C_S_TBT_BYTE_CNT_ADDR       (I2C_S_TBT_BYTE_CNT_ADDR   ),
  .I2C_S_INT_STATUS1_REG_ADDR    (I2C_S_INT_STATUS1_REG_ADDR),
  .I2C_S_INT_ENABLE1_REG_ADDR    (I2C_S_INT_ENABLE1_REG_ADDR),
  .I2C_S_INT_SET1_REG_ADDR       (I2C_S_INT_SET1_REG_ADDR   ),
  .I2C_S_RESERVED_0              (I2C_S_RESERVED_0          ),
  .WR_DATA_REG_ADDR              (WR_DATA_REG_ADDR),
  .RD_DATA_REG_ADDR              (RD_DATA_REG_ADDR),
  .SLAVE_ADDRL_REG_ADDR          (SLAVE_ADDRL_REG_ADDR),
  .SLAVE_ADDRH_REG_ADDR          (SLAVE_ADDRH_REG_ADDR),
  .CMD_STATUS_REG_ADDR           (CMD_STATUS_REG_ADDR),
  .CONFIG_REG_ADDR               (CONFIG_REG_ADDR),
  .CONFIG_REG_SET_ADDR           (CONFIG_REG_SET_ADDR),
  .CONFIG_REG_RESET_ADDR         (CONFIG_REG_RESET_ADDR),
  .BYTE_CNT_REG_ADDR             (BYTE_CNT_REG_ADDR),
  .MODE_REG_ADDR                 (MODE_REG_ADDR),
  .CLK_DIV_LSB_REG_ADDR          (CLK_DIV_LSB_REG_ADDR),
  .INT_STATUS1_REG_ADDR          (INT_STATUS1_REG_ADDR),
  .INT_ENABLE1_REG_ADDR          (INT_ENABLE1_REG_ADDR),
  .INT_SET1_REG_ADDR             (INT_SET1_REG_ADDR),
  .INT_STATUS2_REG_ADDR          (INT_STATUS2_REG_ADDR),
  .INT_ENABLE2_REG_ADDR          (INT_ENABLE2_REG_ADDR),
  .INT_SET2_REG_ADDR             (INT_SET2_REG_ADDR),
  .ADDR_MODE                     (ADDR_MODE),
  .CORE_CLK_MHZ                  (SYS_CLOCK_FREQ),
  .SLAVE_ADDR                    (SLAVE_ADDR)
)
u_lscc_lmmi_initiator
(
// Inputs
.lmmi_rdata_i                            (lmmi_rdata_comb      ),
.lmmi_rdata_valid_i                      (lmmi_rdata_valid_comb),
.lmmi_ready_i                            (lmmi_ready_comb      ),
//.lmmi_error_i                            (lmmi_error           ),
// Outputs
.lmmi_clk_o                              (clk_i        ),
.lmmi_reset_o                            (lmmi_reset      ),
.lmmi_resetn_o                           (rst_n_i     ),
.lmmi_offset_o                           (lmmi_offset_i     ),
.lmmi_request_o                          (lmmi_request    ),
.lmmi_wdata_o                            (lmmi_wdata_i      ),
.lmmi_wr_rdn_o                           (lmmi_wr_rdn_i     ),
.active_interface                        (active_interface     )
);


assign lmmi_ready_comb       = active_interface == 2'b01 ? lmmi_ready_o       : lmmi_ready_m;
assign lmmi_rdata_valid_comb = active_interface == 2'b01 ? lmmi_rdata_valid_o : lmmi_rdata_valid_m;
assign lmmi_rdata_comb       = active_interface == 2'b01 ? lmmi_rdata_o       : lmmi_rdata_m;
assign lintr_int_comb        = active_interface == 2'b01 ? int_o              : lintr_int_m;

wire lmmi_request_i = lmmi_request[0];

lscc_i2c_master
#(
  .DATA_WIDTH        (DATA_WIDTH    ),
  .WDATA_WIDTH       (WDATA_WIDTH   ),
  .RDATA_WIDTH       (RDATA_WIDTH   ),
  .OFFSET_WIDTH      (OFFSET_WIDTH  ),
  .I2C_MODE          (I2C_MODE      ),
  // .CONFIGURABLE      (CONFIGURABLE  ),
  .ARBT              (ARBT          ),
  .CLK_DIV_LSB       (CLK_DIV_LSB   ),
  .PULL_UP_ENABLE    (PULL_UP_ENABLE),
  .STRETCHING        (0             ),
  .PRESCALER         (PRESCALER     ),
  .BC_IE             (0             ),
  .TC_IE             (0             ),
  .TX_DONE_IE        (TX_DONE_IE    ),
  .RX_DONE_IE        (RX_DONE_IE    ),
  .TX_ERROR_IE       (TX_ERROR_IE   ),
  .RX_ERROR_IE       (RX_ERROR_IE   ),
  .ABOR_ACK_IE       (ABOR_ACK_IE   ),
  .ARBTR_LOST_IE     (ARBTR_LOST_IE ),
  .SCL_TIMEOUT_IE    (SCL_TIMEOUT_IE),
  .ADDR_MODE         (ADDR_MODE     ),
  .SYS_CLOCK_FREQ    (SYS_CLOCK_FREQ)
) u_lscc_i2c_master (
// LMMI Interface
    // LMMI System Signals
  .lmmi_resetn_i      (rst_n_i),
  .lmmi_clk_i         (clk_i),
    // LMMI Write Signals
  .lmmi_wdata_i       (lmmi_wdata_i),
    // LMMI Read Signals
  .lmmi_rdata_o       (lmmi_rdata_m),
  .lmmi_rdata_valid_o (lmmi_rdata_valid_m),
    // LMMI Controll Signals
  .lmmi_ready_o       (lmmi_ready_m),
  .lmmi_wr_rdn_i      (lmmi_wr_rdn_i),
  .lmmi_offset_i      (lmmi_offset_i),
  .lmmi_request_i     (lmmi_request[1]),
// Lattice Interrupt Interface (LINTR)
  .int_o        (lintr_int_m),
// I2C Interface
    // I2C Clock
  .scl_io           (scl_io),
    // I2C Data
  .sda_io          (sda_io)
);



//I2C slave
// ----------------------------
// GSR instance
// ----------------------------
GSR GSR_INST ( .GSR_N(1'b1), .CLK(1'b0));

`include "dut_inst.v"

generate
  if (APB_ENABLE) begin
    lscc_lmmi2apb #(
      .DATA_WIDTH         (32),
      .ADDR_WIDTH         (6),
      .REG_OUTPUT         (0)
    )
    u_lscc_lmmi2apb(
      .clk_i              (clk_i),
      .rst_n_i            (rst_n_i),
      .lmmi_request_i     (lmmi_request_i),
      .lmmi_wr_rdn_i      (lmmi_wr_rdn_i), //connects to lmmi_wr_rdn_o (initiator) through lmmi_wr_rdn_i wire
      .lmmi_offset_i      (lmmi_offset_w), //connects to lmmi_offset_o (initiator) through lmmi_offset_i wire
      .lmmi_wdata_i       (apb_lmmi_wdata_w),   //connects to lmmi_wdata_o (initiator) through lmmi_wdata_i wire
      .lmmi_rdata_o       (apb_lmmi_rdata_o),
      .lmmi_rdata_valid_o (apb_lmmi_rdata_valid_o),
      .lmmi_ready_o       (apb_lmmi_ready_o),
      .lmmi_error_o       (),
      .lmmi_resetn_o      (),
      .apb_pready_i       (apb_pready_o),
      .apb_pslverr_i      (apb_pslverr_o),
      .apb_prdata_i       (apb_prdata_o),
      .apb_penable_o      (apb_penable_i),
      .apb_psel_o         (apb_psel_i),
      .apb_pwrite_o       (apb_pwrite_i),
      .apb_paddr_o        (apb_paddr_i),
      .apb_pwdata_o       (apb_pwdata_i)
    );
    ///
    assign apb_lmmi_wdata_w   = {24'd0,lmmi_wdata_i};
    assign lmmi_rdata_o       = apb_lmmi_rdata_o;
    assign lmmi_rdata_valid_o = apb_lmmi_rdata_valid_o;
    assign lmmi_ready_o       = apb_lmmi_ready_o;
    assign lmmi_offset_w      = {lmmi_offset_i,2'h0};
    ///
  end
endgenerate

generate
    if (REMOVE_TRISTATE == 1) begin
        BB
        u_BB_sclk(
          .B(scl_io),
          .I(sda_o),
          .O(scl_i),
          .T(scl_oe_o)
        );
        BB
        u_BB_sda(
          .B(sda_io),
          .I(sda_o),
          .O(sda_i),
          .T(sda_oe_o)
        );
    end
endgenerate

///////////////////// GSR /////////////////////
//`ifdef LIFCL
//reg CLK_GSR = 0;
//reg USER_GSR = 1;
//
//initial begin
//    forever begin
//        #5;
//        CLK_GSR = ~CLK_GSR;
//    end
//end
//
//GSR GSR_INST (
//    .GSR_N(USER_GSR),
//    .CLK(CLK_GSR)
//);
//`endif

endmodule //--tb_top--
`endif // __RTL_MODULE__TB_TOP__

