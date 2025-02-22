/*******************************************************************************
    Verilog netlist generated by IPGEN Lattice Propel (64-bit)
    2023.2.2311232310
    Soft IP Version: 2.1.0
    2024 02 27 14:06:34
*******************************************************************************/
/*******************************************************************************
    Wrapper Module generated per user settings.
*******************************************************************************/
module lscc_spis1 (clk_i, rst_n_i, sclk_i, mosi_i, miso_o, ss_i, int_o,
    apb_penable_i, apb_psel_i, apb_pwrite_i, apb_paddr_i, apb_pwdata_i,
    apb_pready_o, apb_pslverr_o, apb_prdata_o)/* synthesis syn_black_box syn_declare_black_box=1 */;
    input  clk_i;
    input  rst_n_i;
    input  sclk_i;
    input  mosi_i;
    output  miso_o;
    input  ss_i;
    output  int_o;
    input  apb_penable_i;
    input  apb_psel_i;
    input  apb_pwrite_i;
    input  [5:0]  apb_paddr_i;
    input  [31:0]  apb_pwdata_i;
    output  apb_pready_o;
    output  apb_pslverr_o;
    output  [31:0]  apb_prdata_o;
endmodule