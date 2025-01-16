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
// Description  : This module synchronizes reset_n signal using two cascaded
//                registers.This module uses "Synchronized Asynchronous Reset"
//                method.
//-----------------------------------------------------------------------------

 `timescale 1ns/100ps


// Reset_n synchronizer
module resetn_sync
  (

  input logic  reset_n_i, // Active low reset input
  input logic  clk_i, // Clock to which register needs to be synchronized

  output logic sync_reset_n_o // Active low reset synchronized to clk
   );

  // O ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- !

  // ! Local Parameter

  // ! ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- !

  // Unit delay for simulation purpose
  parameter UD = 1'b1;


  // ! ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- !

  // ! Local Variables

  // ! ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- !

  logic        reset_n_f1;
  logic        reset_n_f2;

  // ! ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- !

  // !

  // ! ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- ~-~-~ -~-~- !

  /*
   Synchronized Asynchronous Reset :
   We have used here this method.In this method,resets are asynchronously asserted but are released
   synchronously.It combines advanages of synchronous and asynchronous resets.

   Reference: Reset resources,Chapter 10 Recommended design practices,Quatus Handbook (Volume 10
  */

  always_ff @ ( posedge clk_i or negedge reset_n_i )
    begin
      if ( ~reset_n_i )
        begin
          reset_n_f1 <= #UD 1'b0;
          reset_n_f2 <= #UD 1'b0;
        end
      else
        begin
          reset_n_f1 <= #UD 1'b1;
          reset_n_f2 <= #UD reset_n_f1;
        end
    end // always_ff @ ( posedge clk_i or negedge reset_n_i )

  // Synchronized reset_n
  assign sync_reset_n_o = reset_n_f2;


endmodule // resetn_sync
