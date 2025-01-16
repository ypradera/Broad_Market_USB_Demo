// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2019 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED 
// -----------------------------------------------------------------------------
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
// -----------------------------------------------------------------------------
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
// -----------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS         
// Project               : 
// File                  : lscc_lmmi2ahbl.v
// Title                 : 
// Dependencies          : 1.
//                       : 2.
// Description           : 
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0.0
// Author(s)             : 
// Mod. Date             : 
// Changes Made          : Initial release.
// =============================================================================

`ifndef LSCC_LMMI2AHBL_SINGLE
`define LSCC_LMMI2AHBL_SINGLE

`timescale 1 ns / 1 ps

module lscc_lmmi2ahbl_single 
  #(
// -----------------------------------------------------------------------------
// Module Parameters
// -----------------------------------------------------------------------------
    parameter               DATA_WIDTH  = 32,  // 8/16/32/64/128/256/512/1024
    parameter               ADDR_WIDTH  = 32)  // 11-32
// -----------------------------------------------------------------------------
// Input/Output Ports
// -----------------------------------------------------------------------------
  (
    input                   clk_i,
    input                   rst_n_i,
    // ------------------------
    // LMMI Interface
    // ------------------------
    input                   lmmi_request_i,
    input                   lmmi_wr_rdn_i,
    input  [ADDR_WIDTH-1:0] lmmi_offset_i,
    input  [DATA_WIDTH-1:0] lmmi_wdata_i,
    output [DATA_WIDTH-1:0] lmmi_rdata_o,
    output                  lmmi_rdata_valid_o,
    output                  lmmi_ready_o,
    // ------------------------
    // LMMI Extended signals
    // ------------------------
    output                  lmmi_ext_error_o,
    
    // ------------------------
    // AHB-Lite Interface
    // ------------------------
    input                   ahbl_hready_i,
    input                   ahbl_hresp_i,
    input  [DATA_WIDTH-1:0] ahbl_hrdata_i,
    
    output [ADDR_WIDTH-1:0] ahbl_haddr_o,
    output [2:0]            ahbl_hburst_o,     // Unused, fixed to 3'h0
    output [2:0]            ahbl_hsize_o,      // Unused, fixed to corresponding data width
    output                  ahbl_hmastlock_o,  // Unused, fixed to 1'b0
    output [3:0]            ahbl_hprot_o,      // Unused, fixed to 4'h1
    output [1:0]            ahbl_htrans_o,
    output                  ahbl_hwrite_o,
    output [DATA_WIDTH-1:0] ahbl_hwdata_o);

  localparam [2:0] HSIZE_VAL = (DATA_WIDTH == 8   ) ? 3'b000 : (
                               (DATA_WIDTH == 16  ) ? 3'b001 : ( 
                               (DATA_WIDTH == 32  ) ? 3'b010 : (
                               (DATA_WIDTH == 64  ) ? 3'b011 : (
                               (DATA_WIDTH == 128 ) ? 3'b100 : (
                               (DATA_WIDTH == 256 ) ? 3'b101 : (
                               (DATA_WIDTH == 512 ) ? 3'b110 : 3'b111))))));
                               
  // 2-Statage FIFO for Address
  reg  [ADDR_WIDTH+1:0]  haddr_in_r;    // {lmmi_wr_rdn_i, valid_bit, lmmi_offset_i}
  reg  [ADDR_WIDTH+1:0]  haddr_out_r;
  reg  [ADDR_WIDTH+1:0]  haddr_in_nxt; 
  reg  [ADDR_WIDTH+1:0]  haddr_out_nxt;
  reg                    haddr_in_get_input;  
  reg                    haddr_in_clr_instg; 
  reg                    haddr_out_get_input; 
  reg                    haddr_out_get_instg;  
  reg                    haddr_push;
  reg                    haddr_pop;  
  // 3-Stage FIFO for Write Data
  reg  [DATA_WIDTH:0]    hwdata_in_r;
  reg  [DATA_WIDTH:0]    hwdata_mid_r;
  reg  [DATA_WIDTH:0]    hwdata_out_r;
  reg  [DATA_WIDTH:0]    hwdata_in_nxt;
  reg  [DATA_WIDTH:0]    hwdata_mid_nxt;
  reg  [DATA_WIDTH:0]    hwdata_out_nxt;
  reg                    hwdata_in_get_input;
  reg                    hwdata_in_clr_instg;
  reg                    hwdata_mid_get_input;
  reg                    hwdata_mid_get_instg;
  reg                    hwdata_out_get_input;
  reg                    hwdata_out_get_midstg;
  reg                    hwdata_push;
  reg                    hwdata_pop;  
  
  reg                    hwdata_en_r;
  reg                    hrdata_en_r;
  reg  [1:0]             htrans_r;
  
  reg [DATA_WIDTH-1:0]   lmmi_rdata_r;
  reg                    lmmi_rdata_v_r;
  reg                    lmmi_ready_r;
  reg                    lmmi_error_r;

  // 2-Stage FIFO next_value generation
  always @* begin
    haddr_push          = lmmi_request_i & lmmi_ready_o;
    haddr_pop           = haddr_out_r[ADDR_WIDTH] & ahbl_hready_i;
    haddr_out_get_input = ( haddr_push &  haddr_pop & ~haddr_in_r[ADDR_WIDTH]) |
                          ( haddr_push &              ~haddr_out_r[ADDR_WIDTH]);
    haddr_out_get_instg = (               haddr_pop &  haddr_out_r[ADDR_WIDTH]);
    haddr_in_get_input  = ( haddr_push &  haddr_pop &  haddr_in_r[ADDR_WIDTH]) |
                          ( haddr_push & ~haddr_pop &  haddr_out_r[ADDR_WIDTH] & ~haddr_in_r[ADDR_WIDTH]);
    haddr_in_clr_instg  = (~haddr_push &  haddr_pop &  haddr_in_r[ADDR_WIDTH]);

    if (haddr_out_get_input)
      haddr_out_nxt = {lmmi_wr_rdn_i,1'b1,lmmi_offset_i};
    else if (haddr_out_get_instg)
      haddr_out_nxt = haddr_in_r;
    else
      haddr_out_nxt = haddr_out_r;
    if (haddr_in_get_input)
      haddr_in_nxt  = {lmmi_wr_rdn_i,1'b1,lmmi_offset_i};
    else if (haddr_in_clr_instg)  // only clear the valid bit
      haddr_in_nxt  = {haddr_in_r[DATA_WIDTH+1],1'b0,haddr_in_r[DATA_WIDTH-1:0]};
    else
      haddr_in_nxt  = haddr_in_r;
  end
  
  // 3-Stage FIFO for Write Data
  always @* begin
    hwdata_push             = lmmi_request_i & lmmi_ready_o & lmmi_wr_rdn_i;
    hwdata_pop              = hwdata_en_r & ahbl_hready_i;  
    hwdata_out_get_input    = ( hwdata_push &  hwdata_pop & ~hwdata_mid_r[DATA_WIDTH]) |
                              ( hwdata_push &               ~hwdata_out_r[DATA_WIDTH]);
    hwdata_out_get_midstg   = (                hwdata_pop &  hwdata_out_r[DATA_WIDTH]);
    hwdata_mid_get_input    = ( hwdata_push &  hwdata_pop &  hwdata_mid_r[DATA_WIDTH] & ~hwdata_in_r[DATA_WIDTH]) |
                              ( hwdata_push & ~hwdata_pop &  hwdata_out_r[DATA_WIDTH] & ~hwdata_mid_r[DATA_WIDTH]);
    hwdata_mid_get_instg    = (                hwdata_pop &  hwdata_mid_r[DATA_WIDTH]);
    hwdata_in_get_input     = ( hwdata_push &  hwdata_pop &  hwdata_in_r[DATA_WIDTH]) |
                              ( hwdata_push & ~hwdata_pop &  hwdata_mid_r[DATA_WIDTH] & ~hwdata_in_r[DATA_WIDTH]);
    hwdata_in_clr_instg     = (~hwdata_push &  hwdata_pop &  hwdata_in_r[DATA_WIDTH]);
    
    // 3 stage fifo for write data 
    if (hwdata_out_get_input)
      hwdata_out_nxt = {1'b1,lmmi_wdata_i};
    else if (hwdata_out_get_midstg)
      hwdata_out_nxt = hwdata_mid_r;
    else
      hwdata_out_nxt = hwdata_out_r;
    if (hwdata_mid_get_input)
      hwdata_mid_nxt = {1'b1,lmmi_wdata_i};
    else if (hwdata_mid_get_instg)
      hwdata_mid_nxt = hwdata_in_r;
    else
      hwdata_mid_nxt = hwdata_mid_r;
    if (hwdata_in_get_input)
      hwdata_in_nxt  = {1'b1,lmmi_wdata_i};
    else if (hwdata_in_clr_instg)
      hwdata_in_nxt  = {1'b0,hwdata_in_r[DATA_WIDTH-1:0]};
    else
      hwdata_in_nxt  = hwdata_in_r;
  end
  
  // registering
  always @(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
      haddr_in_r     <= {(ADDR_WIDTH+2){1'b0}};
      haddr_out_r    <= {(ADDR_WIDTH+2){1'b0}};
      hwdata_in_r    <= {(DATA_WIDTH+1){1'b0}};
      hwdata_mid_r   <= {(DATA_WIDTH+1){1'b0}};
      hwdata_out_r   <= {(DATA_WIDTH+1){1'b0}};
      hwdata_en_r    <= 1'b0;
      hrdata_en_r    <= 1'b0;
      htrans_r       <= 2'b0;
      lmmi_rdata_r   <= {DATA_WIDTH{1'b0}};
      lmmi_rdata_v_r <= 1'b0;
      lmmi_ready_r   <= 1'b0;
      lmmi_error_r   <= 1'b0;
    end
    else begin
      haddr_in_r     <= haddr_in_nxt  ;
      haddr_out_r    <= haddr_out_nxt ;
      hwdata_in_r    <= hwdata_in_nxt ;
      hwdata_mid_r   <= hwdata_mid_nxt;
      hwdata_out_r   <= hwdata_out_nxt;
      if ((haddr_out_r[ADDR_WIDTH+1:ADDR_WIDTH] == 2'b11) && ahbl_hready_i)
        hwdata_en_r  <= 1'b1;
      else if (ahbl_hready_i)
        hwdata_en_r  <= 1'b0;
      if ((haddr_out_r[ADDR_WIDTH+1:ADDR_WIDTH] == 2'b01) && ahbl_hready_i)
        hrdata_en_r  <= 1'b1;
      else if (ahbl_hready_i)
        hrdata_en_r  <= 1'b0;
      htrans_r       <= haddr_out_nxt[ADDR_WIDTH] ? 2'b10 : 2'b00;

      lmmi_ready_r   <= ~haddr_in_nxt[ADDR_WIDTH];
      lmmi_error_r   <= lmmi_error_r ? 1'b0 : ahbl_hresp_i;
      if (hrdata_en_r & ahbl_hready_i) begin
        lmmi_rdata_r   <= ahbl_hrdata_i;
        lmmi_rdata_v_r <= 1'b1;
      end
      else
        lmmi_rdata_v_r <= 1'b0;
    end
  end
  
  assign ahbl_haddr_o     = haddr_out_r[ADDR_WIDTH-1:0];
  assign ahbl_hburst_o    = 3'h0;
  assign ahbl_hsize_o     = HSIZE_VAL;
  assign ahbl_hmastlock_o = 1'b0;
  assign ahbl_hprot_o     = 4'h1;
  assign ahbl_htrans_o    = htrans_r;
  assign ahbl_hwrite_o    = haddr_out_r[ADDR_WIDTH+1];
  assign ahbl_hwdata_o    = hwdata_out_r;

  assign lmmi_rdata_o       = lmmi_rdata_r;
  assign lmmi_rdata_valid_o = lmmi_rdata_v_r;
  assign lmmi_ready_o       = lmmi_ready_r;
  assign lmmi_ext_error_o   = lmmi_error_r;
endmodule
//=============================================================================
// lscc_lmmi2ahbl.v
//=============================================================================
`endif
