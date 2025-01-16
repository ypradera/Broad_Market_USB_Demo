// *************************  -*- Mode: Verilog -*- *********************
// ============================================================================
//                          COPYRIGHT NOTICE
// Copyright (c) 2007             Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from Lattice Semiconductor Corporation. The entire
// notice above must be reproduced on all authorized copies and copies may
// only be made to the extent permitted by a licensing agreement from
// Lattice Semiconductor Corporation.
//
// Lattice Semiconductor Corporation       TEL : 1-800-Lattice (USA and Canada)
// 5555 NE Moore Court                           408-826-6000 (other locations)
// Hillsboro, OR 97124                    web  : http://www.latticesemi.com/
// U.S.A                                  email: techsupport@latticesemi.com
// ============================================================================
// Description : Debugging clock generation module.
//
//-S O U R C E C O N T R O L---------------------------------------------------
// $Rev: 4345 $
//-----------------------------------------------------------------------------


module clock_debug
  (
    input  logic  clk_in,     // 50MHz input clock
    input  logic  resetn_i,

    output logic  clock_1khz, // 1khz Or 1ms pulses
    output logic  clock_1hz   // 1hz Or 1s pulses
  );

//----------------------------
//
// Local Variables
//
//----------------------------

  logic [31:0] khz_cntr;
  logic [31:0] hz_cntr;
  logic        clock_1khz_reg;
  logic        clock_1hz_reg;
  logic        khz_cntr_rst;
  logic        hz_cntr_rst;

//----------------------------
//
// Assign Statements
//
//----------------------------

  assign clock_1khz   = clock_1khz_reg;
  assign clock_1hz    = clock_1hz_reg;

  assign khz_cntr_rst = (khz_cntr == 32'd100000);     //decimal 125000
  assign hz_cntr_rst  = (hz_cntr  == 32'd100000000);  //decimal 125000000

//----------------------------
//
// Always Block
//
//----------------------------

  // Always block to count for 1ms Or 1khz
  always_ff @ ( posedge clk_in or negedge resetn_i )
    begin
      if ( ~resetn_i )
        begin
          khz_cntr <= '0;
        end
      else if ( khz_cntr_rst )
        begin
          khz_cntr <= '0;
        end
      else
        begin
          khz_cntr <= ( khz_cntr + 1'b1 );
        end
    end

  // Always block to generate clock for 1ms Or 1khz
  // Toggle at every 25000 clock (0.5ms) to generate 1ms Or 1KHz pulses
  always_ff @ ( posedge clk_in or negedge resetn_i )
    begin
      if ( ~resetn_i )
        begin
          clock_1khz_reg <= '0;
        end
      else if ( khz_cntr_rst )
        begin
          clock_1khz_reg <= ~clock_1khz_reg;
        end
    end

  // Always block to count for 1s Or 1hz
  always_ff @ ( posedge clk_in or negedge resetn_i )
    begin
      if ( ~resetn_i )
        begin
          hz_cntr <= '0;
        end
      else if ( hz_cntr_rst )
        begin
          hz_cntr <= '0;
        end
      else
        begin
          hz_cntr <= ( hz_cntr + 1'b1 );
        end
    end

  // Always block to generate clock for 1s Or 1hz
  // Toggle at every 25000000 clock (0.5s) to generate 1s Or 1Hz pulses
  always_ff @ ( posedge clk_in or negedge resetn_i )
    begin
      if ( ~resetn_i )
        begin
          clock_1hz_reg <= 0;
        end
      else if ( hz_cntr_rst )
        begin
          clock_1hz_reg <= ~clock_1hz_reg;
        end
    end

endmodule
