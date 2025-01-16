
module spi_master_model #(
    parameter integer  DATA_WIDTH = 32,
    parameter integer  SLV_NUM    = 1,    // Supports 1 to 8 slaves
    parameter [0:0]    LSB_FIRST  = 1'b1,
    parameter [0:0]    SSNP       = 1'b1,
    parameter [0:0]    CPOL       = 1'b1,
    parameter [0:0]    CPHA       = 1'b1,
    parameter [7:0]    SSPOL      = 1'b1, // Polarity of ss_i signal
    parameter [10:0]   PRESCALER  = 25,   // 1MHz sck_o
    parameter [8*15:1] model_name = "SPI_MST"
  )(
    input                    clk_i  ,
    input                    rst_n_i,
    output reg               sck_o  ,
    output reg [SLV_NUM-1:0] ss_o   ,
    output reg               mosi_o ,
    input                    miso_i
  );
  
  localparam ST_WIDTH       = 6;
  localparam ST_IDLE        = 6'h01;
  localparam ST_SSN_ASSERT  = 6'h02;
  localparam ST_DATA_TX     = 6'h04;
  localparam ST_DATA_RX     = 6'h08;
  localparam ST_SSN_RELEASE = 6'h10;
  localparam ST_SSN_RECOVER = 6'h20;
  
  // control settings
  integer               ctrl_dwidth_m1;
  reg                   ctrl_lsb_first;
  reg                   ctrl_ssnp;
  reg                   ctrl_cpol;
  reg                   ctrl_cpha;
  reg [SLV_NUM-1:0]     ctrl_sspol;
  
  
  reg  [ST_WIDTH-1:0]   cs_sm;
  reg  [ST_WIDTH-1:0]   ns_sm;
  reg  [4:0]            rx_bit_cnt_r;
  reg  [10:0]           sck_count_r;
  reg                   count_eq_0_r;
  reg  [DATA_WIDTH-1:0] data_r;  
  reg  [DATA_WIDTH-1:0] data_shift_nxt;
  reg                   mosi_bit_out;
  
  //user interface control
  reg  [SLV_NUM-1:0]    usr_ss;
  reg  [DATA_WIDTH-1:0] usr_data;
  reg                   usr_tx_en;
  
  // initialization of control settings
  // may be updated by the user during idle state
  initial begin
    ctrl_dwidth_m1 = DATA_WIDTH - 1;
    ctrl_lsb_first = LSB_FIRST;
    ctrl_ssnp      = SSNP     ;
    ctrl_cpol      = CPOL     ;
    ctrl_cpha      = CPHA     ;
    ctrl_sspol     = SSPOL[SLV_NUM-1:0];
    usr_ss         = {SLV_NUM{1'b0}};
    usr_data       = {DATA_WIDTH{1'b0}};
    usr_tx_en      = 1'b0;
  end
  

  always @ ( * ) begin
    case (cs_sm)
      ST_IDLE        : begin
        ns_sm    = usr_tx_en ? ST_SSN_ASSERT : ST_IDLE;
      end  
      ST_SSN_ASSERT  : begin
        ns_sm    = ctrl_cpha ? ST_DATA_TX : ST_DATA_RX;
      end
      ST_DATA_TX     : begin
        if (count_eq_0_r)
          ns_sm  = ST_DATA_RX;
        else 
          ns_sm  = ST_DATA_TX;
      end
      ST_DATA_RX     : begin
        if (count_eq_0_r)
          ns_sm  = (rx_bit_cnt_r == ctrl_dwidth_m1) ? ST_SSN_RELEASE : ST_DATA_TX;
        else 
          ns_sm  = ST_DATA_RX;
      end
      ST_SSN_RELEASE : begin
        if (count_eq_0_r && (sck_o == ctrl_cpol))
          ns_sm  = ST_SSN_RECOVER;
        else
          ns_sm  = ST_SSN_RELEASE;
      end
      ST_SSN_RECOVER : begin
        if (count_eq_0_r)
          ns_sm  = usr_tx_en ? ST_SSN_ASSERT : ST_IDLE;
        else 
          ns_sm  = ST_SSN_RECOVER;
      end
      default       : begin
        ns_sm    = ST_IDLE;
      end
    endcase
  end
  
  always @ (posedge clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
        ss_o            <= ~SSPOL;
        sck_o           <= CPOL;
        mosi_o          <= 1'b0;
        data_r          <= {DATA_WIDTH{1'b0}};
        rx_bit_cnt_r    <= 5'd0 ;
        sck_count_r     <= PRESCALER; // for clock generation
        cs_sm           <= ST_IDLE;
    end
    else begin
      cs_sm               <= ns_sm;  // state registering
      // For clock generation
      if ((cs_sm == ST_IDLE) || count_eq_0_r) begin
        sck_count_r  <= PRESCALER;          
        count_eq_0_r <= 1'b0;
      end
      else begin
        sck_count_r  <= sck_count_r - 11'h001;
        count_eq_0_r <= (sck_count_r == 11'h001);
      end
      
      case (cs_sm)
        ST_IDLE        : begin
          rx_bit_cnt_r    <= 5'd0;
          ss_o            <= ~ctrl_sspol;           // negate all ss_o
          sck_o           <= ctrl_cpol;
          mosi_o          <= 1'b0;
          if (usr_tx_en)
            data_r        <= usr_data;
        end
        ST_SSN_ASSERT  : begin
          rx_bit_cnt_r    <=  5'd0 ;
          ss_o            <= ~usr_ss ^ ctrl_sspol;  // assert selected slave with correct polarity
          sck_o           <= ctrl_cpol;
          mosi_o          <= ctrl_cpha ? 1'b0 : mosi_bit_out;
        end
        ST_DATA_TX     : begin
          if (count_eq_0_r) begin
            sck_o         <= ~sck_o;
            mosi_o        <= mosi_bit_out;
          end
        end
        ST_DATA_RX     : begin
          if (count_eq_0_r) begin
            rx_bit_cnt_r  <= rx_bit_cnt_r + 5'h1;
            sck_o         <= ~sck_o;
            data_r        <= data_shift_nxt;
          end
        end
        ST_SSN_RELEASE : begin
          if (count_eq_0_r) begin
            if (sck_o == ctrl_cpol) begin
              if (!(usr_tx_en && !ctrl_ssnp))
                ss_o     <= ~ctrl_sspol;  // negate ss_o 
            end
            else begin
              sck_o      <= ~sck_o;
            end
          end
        end
        ST_SSN_RECOVER : begin          
          if (count_eq_0_r && usr_tx_en) begin
            data_r       <= usr_data;
            rx_bit_cnt_r <= 5'd0;
          end
        end
        // no action on default case
      endcase
    end
  end // always
  
  // LSB first adjustment
  always @(*) begin
    if (ctrl_lsb_first == 1) begin
      mosi_bit_out   = data_r[0];
      data_shift_nxt = {miso_i, data_r[DATA_WIDTH-1:1]};
    end 
    else begin
      mosi_bit_out   = data_r[DATA_WIDTH-1];
      data_shift_nxt = {data_r[DATA_WIDTH-2:0], miso_i};
    end
  end
  
  
  // This is a blocking method that sets the next data for 
  task tx_rx_data (
    input  [SLV_NUM-1:0]    slv_sel,  // bit value = 1 selects the corresponding slave
    input  [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out
  );
    begin
      $display("[%010t] [%0s]: Transmitting data: 0x%0x ",$time, model_name, data_in);
      // wait for ST_IDLE or ST_SSN_RECOVER state
      while(!((cs_sm == ST_IDLE) || (cs_sm == ST_SSN_RECOVER))) @(posedge clk_i); 
      // Set user inputs
      usr_ss   = slv_sel;
      usr_data = data_in;
      usr_tx_en    = 1'b1;
      @(posedge clk_i);
      while(cs_sm != ST_SSN_ASSERT) @(posedge clk_i);  // wait for ST_SSN_ASSERT state
      usr_tx_en    = 1'b0;
      while(cs_sm != ST_SSN_RELEASE) @(posedge clk_i); // wait for ST_SSN_RELEASE state
      data_out = data_r;
      $display("[%010t] [%0s]: Received data: 0x%0x ",$time, model_name, data_r);
    end
  endtask

endmodule