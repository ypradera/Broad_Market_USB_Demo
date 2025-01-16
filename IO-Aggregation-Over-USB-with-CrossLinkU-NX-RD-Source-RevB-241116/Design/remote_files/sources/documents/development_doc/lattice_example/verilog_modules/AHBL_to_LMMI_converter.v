//AHB-Lite 2 LMMI converter

module AHBL_to_LMMI_converter
  #
  (
   parameter data_width = 32,
   parameter address_width = 15,
   parameter RD_TIMEOUT = 255,
   parameter EN_TIMEOUT_RD = 0
   )
  (
   //clock & reset_active_low
   input                          clk_i,
   input                          rst_n_i,
   //AHB-Lite interface
   input [31:0]                   ahbl_haddr_i,
   input [data_width-1:0]         ahbl_hwdata_i,
   input [2:0]                    ahbl_hburst_i, //not handled
   input                          ahbl_hmastlock_i, //not handled
   input [3:0]                    ahbl_hprot_i, //not handled
   input                          ahbl_hready_i,
   input                          ahbl_hsel_i,
   input [2:0]                    ahbl_hsize_i, //not handled
   input [1:0]                    ahbl_htrans_i,
   input                          ahbl_hwrite_i,

   output reg [data_width-1:0]    ahbl_hrdata_o,
   output reg                     ahbl_hreadyout_o,
   output reg                     ahbl_hresp_o /* synthesis syn_preserve = 1 */,
   // LMMI Interface
   input [data_width-1:0]         lmmi_rdata_i,
   input                          lmmi_rdata_valid_i,
   input                          lmmi_ready_i,

   output reg                     lmmi_request_o,
   output reg                     lmmi_wr_rdn_o,
   output reg [address_width-1:0] lmmi_offset_o,
   output [data_width-1:0]        lmmi_wdata_o
   // output                           lmmi_resetn_o
   );

  function [31:0] clog2;
    input [31:0]                  value;
    reg [31:0]                    num;

    begin
      num = value - 1;
      for (clog2=0; num>0; clog2=clog2+1) num = num>>1;
    end
  endfunction

  localparam   CNTRWID = clog2(RD_TIMEOUT+1);

  wire              ahbl_ready;
  wire              ahbl_req;
  wire              ahbl_rd;
  wire              ahbl_wr;

  reg               pending_read;
  reg [CNTRWID-1:0] timeout_cntr               /* synthesis syn_preserve = 1 */;
  reg               timeout_hit                /* synthesis syn_preserve = 1 */;

  assign ahbl_ready    = ahbl_hreadyout_o & ahbl_hready_i;
  assign ahbl_req      = ahbl_hsel_i & ahbl_htrans_i[1];

  assign ahbl_wr       = ahbl_req & ahbl_ready &  ahbl_hwrite_i;
  assign ahbl_rd       = ahbl_req & ahbl_ready & !ahbl_hwrite_i;

  assign lmmi_wdata_o  = ahbl_hwdata_i;

  always @(posedge clk_i or negedge rst_n_i)
    begin
      if(!rst_n_i)
        begin
          ahbl_hreadyout_o  <= 1'h0;
          ahbl_hresp_o      <= 1'h0;
          lmmi_request_o    <= 1'h0;
          lmmi_wr_rdn_o     <= 1'h0;
	      pending_read      <= 1'h0;
	      lmmi_offset_o     <= {address_width{1'b0}};
          ahbl_hrdata_o     <= {data_width{1'b0}};
	      timeout_cntr      <= {CNTRWID{1'b0}};
          timeout_hit       <= 1'h0;
        end
      else
        begin

          // read request timeout
          timeout_hit  <= (EN_TIMEOUT_RD)? (&timeout_cntr) : 1'b0;
          if(timeout_hit)
            begin
              timeout_cntr <= {CNTRWID{1'b0}};
            end
          else
            begin
              timeout_cntr <= (pending_read & EN_TIMEOUT_RD)? (timeout_cntr + {{(CNTRWID-1){1'b0}},(~&timeout_cntr)}) : {CNTRWID{1'b0}};
            end

	  // LMMI Request
          if(lmmi_request_o)
            begin
              if(lmmi_ready_i)
                begin
	              lmmi_request_o <= ahbl_req & ahbl_ready;
                  lmmi_wr_rdn_o  <= ahbl_hwrite_i;
                end
            end
	      else
            begin
              lmmi_request_o <= ahbl_req & ahbl_ready;
              lmmi_wr_rdn_o  <= ahbl_hwrite_i;
            end

          // hold current address
          if(ahbl_req & ahbl_ready)
            begin
              lmmi_offset_o <= ahbl_haddr_i[16:2];
            end

	     // AHB-Lite ready
          ahbl_hresp_o <= 1'b0;
          if(ahbl_hreadyout_o)
            begin
              if(ahbl_req & ahbl_ready)
                begin
                  ahbl_hreadyout_o <= 1'b0;
                  pending_read     <= !ahbl_hwrite_i;
                end
              else
                ahbl_hreadyout_o <= 1'b1;
            end
          else
            begin
              if(pending_read)
                begin
                  ahbl_hreadyout_o <=  (lmmi_rdata_valid_i | timeout_hit);
                  pending_read     <= !(lmmi_rdata_valid_i | timeout_hit);
                  ahbl_hrdata_o    <= lmmi_rdata_i;
                  ahbl_hresp_o     <= timeout_hit;
                end
              else
                begin
                  ahbl_hreadyout_o <= lmmi_ready_i;
                end
            end

        end
    end

endmodule
