`ifndef SPI_SLAVE_MODEL
`define SPI_SLAVE_MODEL

module spi_slave_model #(
    parameter integer  DATA_WIDTH = 32,
    parameter [0:0]    LSB_FIRST  = 1'b1,
    parameter [0:0]    SSNP       = 1'b1,
    parameter [0:0]    CPOL       = 1'b1,
    parameter [0:0]    CPHA       = 1'b1,
    parameter [0:0]    SSPOL      = 1'b1, // Polarity of ss_i signal
    parameter [8*15:1] model_name = "SPI_SLV"
  )(
    input                   clk_i  ,
    input                   rst_n_i,
    input                   sck_i  ,
    input                   ss_i   ,
    input                   mosi_i ,
    output reg              miso_o 
  );
  
  localparam [0:0] SAMP_EDGE = (CPOL == CPHA) ? 1'b1 : 1'b0;
 
  reg                   mosi_r;
  reg                   ss_r;
  reg                   ss_d1_r;
  reg                   sck_r;
  reg                   sck_d1_r;
  reg  [DATA_WIDTH-1:0] data_nxt, data_r;
  reg                   done_nxt, done_r;
  reg  [4:0]            bit_cnt_nxt, bit_cnt_r;
  reg  [4:0]            max_cnt;
  reg  [DATA_WIDTH-1:0] dout_nxt, dout_r;
  reg                   miso_nxt, miso_r;
  reg  [DATA_WIDTH-1:0] din;
  reg data_en_r;
  reg data_en_nxt;
  
  wire [DATA_WIDTH-1:0] data_shift_nxt_w;
  wire                  miso_bit_out_w;
  wire                  sclk_edge_w;
 
  initial begin
    max_cnt    = (DATA_WIDTH == 8) ? 5'h07 : ((DATA_WIDTH == 16) ? 5'hF : ((DATA_WIDTH == 24) ? 5'h17 : 5'h1F));
    din        = {DATA_WIDTH{1'b0}};
    data_en_r  = 0;
  end
  
  assign sclk_edge_w = (sck_d1_r != sck_r);
  
  generate
    if (LSB_FIRST == 1) begin : lsb_first
      assign miso_bit_out_w   = data_r[0];
      assign data_shift_nxt_w = {mosi_r, data_r[DATA_WIDTH-1:1]};
    end 
    else begin : msb_first
      assign miso_bit_out_w   = data_r[DATA_WIDTH-1];
      assign data_shift_nxt_w = {data_r[DATA_WIDTH-2:0], mosi_r};
    end
  endgenerate
 
  always @(*) begin
    miso_nxt    = miso_o;
    data_nxt    = data_r;
    done_nxt    = 1'b0;
    bit_cnt_nxt = bit_cnt_r;
    dout_nxt    = dout_r;
    data_en_nxt = data_en_r;
 
    if (ss_r != SSPOL) begin                               // if slave select negated (NOT selected)
      bit_cnt_nxt = 5'h00;                                 // reset bit counter
      data_nxt    = din;                                   // read in data
      miso_nxt    = miso_bit_out_w;                        // output the first tx bit
    end 
    else begin                                         // else slave select is asserted (selected)
      if (sclk_edge_w) begin                               // There is SCK edge
        if (sck_r == SAMP_EDGE) begin                      // sampling edge
          data_nxt    = data_shift_nxt_w;                  // shift in MOSI to data register
//          bit_cnt_nxt = bit_cnt_r + 5'h1;                  // increment the bit counter
          if (bit_cnt_r == max_cnt) begin                  // if we are on the last bit
            dout_nxt  = data_shift_nxt_w;                  // output the received data
            done_nxt  = 1'b1;                              // set transfer done flag
//            data_nxt  = din;                             // read in new byte
            data_en_nxt = 1;
            bit_cnt_nxt = 5'h00;
          end
          else begin
            bit_cnt_nxt = bit_cnt_r + 5'h1;                  // increment the bit counter
          end
        end
        else begin                                        // Shifting edge
          data_en_nxt = 0;
          if (SSNP) begin                                 // SSN pulse mode
            miso_nxt    = miso_bit_out_w;                 // Drive MISO on non-trigger edge
          end
          else begin 
            if (data_en_r) begin
              data_nxt  = din;
              miso_nxt  = (LSB_FIRST == 1) ? din[0] : din[DATA_WIDTH-1];
            end
            else begin
              miso_nxt    = miso_bit_out_w;
            end
          end
        end
      end
    end
  end
 
  always @(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
      done_r    <= 1'b0;
      bit_cnt_r <= 3'b0;
      dout_r    <= {DATA_WIDTH{1'b0}};
      data_r    <= {DATA_WIDTH{1'b0}};
      miso_o    <= 1'b1;
      data_en_r <= 1'b0;
    end else begin
      done_r    <= done_nxt;
      bit_cnt_r <= bit_cnt_nxt;
      dout_r    <= dout_nxt;
      miso_o    <= miso_nxt;
      data_r    <= data_nxt;
      data_en_r <= data_en_nxt;
    end 
    
      mosi_r    <= mosi_i;
      ss_r      <= ss_i;
      ss_d1_r   <= ss_r;
      sck_r     <= sck_i;
      sck_d1_r  <= sck_r;
  end
  
  // This is a blocking method that sets the next data for 
  task set_tx_data (
    input [DATA_WIDTH-1:0] data_in
  );
    begin
      $display("[%010t] [%0s]: Transmitting data: 0x%0x ",$time, model_name, data_in);
      if (ss_r == SSPOL)
        while(~done_r) @(posedge clk_i); // wait for done_r=1
      @(posedge clk_i);
//      @(posedge clk_i);
      din <= data_in;
      while(~(done_r && (ss_r == SSPOL))) @(posedge clk_i); // wait for done_r=1 during slave is selected
    end
  endtask
  
  task get_rx_data (
    output [DATA_WIDTH-1:0] data_out
  );
    begin
      if (done_r)
        while(done_r) @(posedge clk_i);      // wait for done_r=0
      while(ss_r != SSPOL) @(posedge clk_i); // Wait until slave is selected
      while(~done_r) @(posedge clk_i);     // wait for done_r=1
      $display("[%010t] [%0s]: Received data: 0x%0x ",$time, model_name, dout_r);
      data_out = dout_r;
    end
  endtask
  
  
endmodule
`endif