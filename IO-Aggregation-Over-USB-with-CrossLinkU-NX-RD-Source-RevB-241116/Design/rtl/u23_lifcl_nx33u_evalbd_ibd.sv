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
// Description  : Design top file.
//
//-----------------------------------------------------------------------------

// Timescale
`timescale 1ns/100ps

// ------------------------------------
// Design top module.
// ------------------------------------
module u23_lifcl_nx33u_evalbd_ibd
  (
   // Clock and Reset
   input logic 	    clk_25m_i,
   //input logic                  reset_n_i,

   input logic 	    uart_rxd_i,
   output logic     uart_txd_o,


   // ************************************************
   // USB23 IO ports
   // ************************************************
   inout wire 	    dp_z,
   inout wire 	    dm_z,
   input wire 	    u3_rxm_i,
   input wire 	    u3_rxp_i,
   inout wire 	    vbus_z,
   inout wire 	    u2_reset_ext_z,

   // Differential clock for USB23 controller.
   input logic 	    REFINCLKEXTP_i,
   input logic 	    REFINCLKEXTM_i,

   inout wire [1:0] gpio_0_z,
/* -----\/----- EXCLUDED -----\/-----
   inout wire [1:0] i2cc_scl_z,
   inout wire [1:0] i2cc_sda_z,
 -----/\----- EXCLUDED -----/\----- */
   inout wire 	    i2cm_scl,
   inout wire 	    i2cm_sda,

//   inout wire 	    i2cs_scl,
//   inout wire 	    i2cs_sda,

   output wire 	    spim_sclk_o,
   output wire 	    spim_ssn_o,
   output wire 	    spim_mosi_o,
   input wire 	    spim_miso_i,
		     
/* -----\/----- EXCLUDED -----\/-----
   input wire 	    spis_sclk_i,
   input wire 	    spis_ssn_i,
   input wire 	    spis_mosi_i,
   output wire 	    spis_miso_o,
 -----/\----- EXCLUDED -----/\----- */

   output logic     u3_txm_o,
   output logic     u3_txp_o
  );

  // Local parameters...

  // -------------------------------------------------------
  // Hardware version indicator parameter

  // Digit information (32-bit): A.B.C.D
  // A.B = Base FPGA Design Identification.
  //       Like generic enumeration, IO Aggr, UVC etc..
  //
  // C.D = Incremental version of base FPGA design

  // Each digit (A,B,C and D) will have range 0x0 to 0xF.

  // -----------------------------------------------
  // HW Version - Description.
  // -----------------------------------------------
  // 1.0.0.0    - Initial release

  // HW Design Major version
  localparam FPGA_DES_MAJOR_VERSION = { 8'h02 , 8'h00 };

  // HW Design Minor version
  localparam FPGA_DES_MINOR_VERSION = { 8'h00 , 8'h00 };

  // HW_VERSION indicator
  localparam FPGA_VERSION_TRACKER = { FPGA_DES_MAJOR_VERSION , FPGA_DES_MINOR_VERSION};

  // *******************************************************
  // *******************************************************
  // Local variables...
  logic                 clk_pll_60m;
  logic                 clk_pll_100m;
  logic                 cpu_reset_n_60m;
  logic                 pll_60m_locked;
  logic                 risc_v_system_reset_n;
  logic                 risc_v_system_reset_n_60m;

  logic [1:0]           drv_scl_low;
  logic [1:0]           drv_sda_low;
  logic [1:0]           scl_data_in;
  logic [1:0]           sda_data_in;

  //--------------------------------------------------------
  // These signals are output from AHBL_to_LMMI_converter
  // and input to usb23 primitive.
  //--------------------------------------------------------
  logic                 lmmi_request;
  logic                 lmmi_wr_rdn;
  logic [16:0]          lmmi_offset;
  logic [31:0]          lmmi_wdata;

  //--------------------------------------------------------
  // These signals are output from usb23 primitive
  // and input to AHBL_to_LMMI_converter.
  //--------------------------------------------------------
  logic [31:0]          lmmi_rdata;
  logic                 lmmi_rdata_valid;
  logic                 lmmi_ready;


  // *******************************************************
  // USB23
  // -------------------------------------------------------
  // Configuration Interface
  // -------------------------------------------------------
  logic                 u23_cnfg_intf_ahbl_hsel;
  logic                 u23_cnfg_intf_ahbl_hready;
  logic [31:0]          u23_cnfg_intf_ahbl_haddr;
  logic [2:0]           u23_cnfg_intf_ahbl_hburst;
  logic [2:0]           u23_cnfg_intf_ahbl_hsize;
  logic                 u23_cnfg_intf_ahbl_hmastlock;
  logic [3:0]           u23_cnfg_intf_ahbl_hprot;
  logic [1:0]           u23_cnfg_intf_ahbl_htrans;
  logic                 u23_cnfg_intf_ahbl_hwrite;
  logic [31:0]          u23_cnfg_intf_ahbl_hwdata;
  logic                 u23_cnfg_intf_ahbl_hreadyout;
  logic                 u23_cnfg_intf_ahbl_hresp;
  logic [31:0]          u23_cnfg_intf_ahbl_hrdata;

  // -------------------------------------------------------
  // AXI Interface
  // -------------------------------------------------------
  logic [31:0]          u23_axim_XMAWADDR;
  logic [1:0]           u23_axim_XMAWBURST;
  logic [3:0]           u23_axim_XMAWCACHE;
  logic [7:0]           u23_axim_XMAWID;
  logic [7:0]           u23_axim_XMAWLEN;
  logic [2:0]           u23_axim_XMAWPROT;
  logic [2:0]           u23_axim_XMAWSIZE;
  logic [1:0]           u23_axim_XMAWLOCK;
  logic                 u23_axim_XMAWREADY;
  logic                 u23_axim_XMAWVALID;

  logic [63:0]          u23_axim_XMWDATA;
  logic [7:0]           u23_axim_XMWSTRB;
  logic                 u23_axim_XMWLAST;
  logic                 u23_axim_XMWREADY;
  logic                 u23_axim_XMWVALID;

  logic [31:0]          u23_axim_XMARADDR;
  logic [1:0]           u23_axim_XMARBURST;
  logic [3:0]           u23_axim_XMARCACHE;
  logic [7:0]           u23_axim_XMARID;
  logic [7:0]           u23_axim_XMARLEN;
  logic [2:0]           u23_axim_XMARPROT;
  logic [2:0]           u23_axim_XMARSIZE;
  logic [1:0]           u23_axim_XMARLOCK;
  logic                 u23_axim_XMARREADY;
  logic                 u23_axim_XMARVALID;

  logic [63:0]          u23_axim_XMRDATA;
  logic [7:0]           u23_axim_XMRID;
  logic [1:0]           u23_axim_XMRRESP;
  logic                 u23_axim_XMRLAST;
  logic                 u23_axim_XMRREADY;
  logic                 u23_axim_XMRVALID;

  logic [7:0]           u23_axim_XMBID;
  logic [1:0]           u23_axim_XMBRESP;
  logic                 u23_axim_XMBREADY;
  logic                 u23_axim_XMBVALID;

  // -------------------------------------------------------
  // AXI-to-AHB Interface
  // -------------------------------------------------------
  logic                 u23_axi_2_ahbl_intf_hsel;
  logic                 u23_axi_2_ahbl_intf_hready;
  logic [31:0]          u23_axi_2_ahbl_intf_haddr;
  logic [2:0]           u23_axi_2_ahbl_intf_hburst;
  logic [2:0]           u23_axi_2_ahbl_intf_hsize;
  logic                 u23_axi_2_ahbl_intf_hmastlock;
  logic [3:0]           u23_axi_2_ahbl_intf_hprot;
  logic [1:0]           u23_axi_2_ahbl_intf_htrans;
  logic                 u23_axi_2_ahbl_intf_hwrite;
  logic [31:0]          u23_axi_2_ahbl_intf_hwdata;
  logic                 u23_axi_2_ahbl_intf_hreadyout;
  logic                 u23_axi_2_ahbl_intf_hresp;
  logic [31:0]          u23_axi_2_ahbl_intf_hrdata;

  // Interrupt line
  logic                 u23_interrupt;


  // Local variables definition part ends here.
  // *******************************************************

    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  // I2C Misc assignments.
  // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

  // In I2C, a logic 0 is output by pulling the line to ground, and a logic 1 is
  // output by letting the line float (output high impedance) so that the
  // pull-up resistor pulls it high.

  // According to this, when IP core wishes to drive 0 on bus, we will drive 0
  // otherwise we will drive high impedance.
  // I2C 0
/* -----\/----- EXCLUDED -----\/-----
  assign i2cc_scl_z[0] = drv_scl_low[0] ? 1'b0: 1'bz;
  assign scl_data_in[0] = i2cc_scl_z[0];

  assign i2cc_sda_z[0] = drv_sda_low[0] ? 1'b0: 1'bz;
  assign sda_data_in[0] = i2cc_sda_z[0];

  // I2C 1
  assign i2cc_scl_z[1] = drv_scl_low[1] ? 1'b0: 1'bz;
  assign scl_data_in[1] = i2cc_scl_z[1];

  assign i2cc_sda_z[1] = drv_sda_low[1] ? 1'b0: 1'bz;
  assign sda_data_in[1] = i2cc_sda_z[1];
 -----/\----- EXCLUDED -----/\----- */

  // *******************************************************
  // PLL-60MHz.
  // This IP core will generate the 60MHz of clock from
  // input 25MHz of clock.
  pll_60m
    pll_60m
    (
     .clki_i      ( clk_25m_i      ),
     .clkop_o     ( clk_pll_60m    ),
     .lock_o      ( pll_60m_locked )
     );

  // Clock debug LED.
  clock_debug
    cd
    (
     .clk_in       ( clk_pll_60m   ),
     .resetn_i     ( pll_60m_locked ),

     .clock_1khz   (            ),
     .clock_1hz    ( gpio_io    )
     );


  // Reset synchronizer.
  resetn_sync
    rs_pll_locked_60m
    (
     .clk_i            ( clk_pll_60m     ),
     .reset_n_i        ( pll_60m_locked  ),
     .sync_reset_n_o   ( cpu_reset_n_60m )
     );


  // Reset synchronizer.
  resetn_sync
    rs_r5_sys_rstn_60m
    (
     .clk_i            ( clk_pll_60m     ),
     .reset_n_i        ( risc_v_system_reset_n  ),
     .sync_reset_n_o   ( risc_v_system_reset_n_60m )
     );


  // Propel builder system.
  u23_lifclu_nx33_prpl_bldr_des
    nxU_prpl_bldr
    (
     .clk_i                                  ( clk_pll_60m     ),
     .rstn_i                                 ( cpu_reset_n_60m ),
     
     .system_reset_n_o                       ( risc_v_system_reset_n ),

     // UART
     .uart_rxd_i                             ( uart_rxd_i      ),
     .uart_txd_o                             ( uart_txd_o      ),

     // GPIO 0 - output
     .gpio_0_z                               ( gpio_0_z[1:0] ),

     // GPIO For HW Design Version - 32-bit Input
     .HW_ver_i                               ( FPGA_VERSION_TRACKER ),

     // I2C lines
/* -----\/----- EXCLUDED -----\/-----
	 .i2cm0_drv_scl_low_o                    ( drv_scl_low[0] ),
	 .i2cm0_drv_sda_low_o                    ( drv_sda_low[0] ),
     .i2cm0_scl_i                            ( scl_data_in[0] ),
	 .i2cm0_sda_i                            ( sda_data_in[0] ),
	 
	 
	 .i2cm1_drv_scl_low_o                    ( drv_scl_low[1] ),
	 .i2cm1_drv_sda_low_o                    ( drv_sda_low[1] ),
     .i2cm1_scl_i                            ( scl_data_in[1] ),
	 .i2cm1_sda_i                            ( sda_data_in[1] ),
 -----/\----- EXCLUDED -----/\----- */
     .i2cm0_scl                               (i2cm_scl),
     .i2cm0_sda                               (i2cm_sda),

//     .i2cs0_scl                               (i2cs_scl),
//     .i2cs0_sda                               (i2cs_sda),

     // SPI lines
     .spim0_sclk_o                            (spim_sclk_o),
     .spim0_ssn_o                             (spim_ssn_o),
     .spim0_mosi_o                            (spim_mosi_o),
     .spim0_miso_i                            (spim_miso_i),

/* -----\/----- EXCLUDED -----\/-----
     .spis0_sclk_i                            (spis_sclk_i),
     .spis0_ssn_i                             (spis_ssn_i),
     .spis0_mosi_i                            (spis_mosi_i),
     .spis0_miso_o                            (spis_miso_o),
 -----/\----- EXCLUDED -----/\----- */

     /* USB23 Configuration interface  */
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_haddr_mstr_o_portbus   ( u23_cnfg_intf_ahbl_haddr      ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hburst_mstr_o_portbus  ( u23_cnfg_intf_ahbl_hburst     ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hprot_mstr_o_portbus   ( u23_cnfg_intf_ahbl_hprot      ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hrdata_mstr_i_portbus  ( u23_cnfg_intf_ahbl_hrdata     ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hsize_mstr_o_portbus   ( u23_cnfg_intf_ahbl_hsize      ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_htrans_mstr_o_portbus  ( u23_cnfg_intf_ahbl_htrans     ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hwdata_mstr_o_portbus  ( u23_cnfg_intf_ahbl_hwdata     ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hmastlock_mstr_o_port  ( u23_cnfg_intf_ahbl_hmastlock  ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hready_mstr_i_port     ( u23_cnfg_intf_ahbl_hreadyout  ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hready_mstr_o_port     ( u23_cnfg_intf_ahbl_hready     ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hresp_mstr_i_port      ( u23_cnfg_intf_ahbl_hresp      ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hsel_mstr_o_port       ( u23_cnfg_intf_ahbl_hsel       ),
     .u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hwrite_mstr_o_port     ( u23_cnfg_intf_ahbl_hwrite     ),

     /* USB23 AXI4-to-AHBL interface */
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_haddr_slv_i_portbus                     ( u23_axi_2_ahbl_intf_haddr     ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hburst_slv_i_portbus                    ( u23_axi_2_ahbl_intf_hburst    ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hprot_slv_i_portbus                     ( u23_axi_2_ahbl_intf_hprot     ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hrdata_slv_o_portbus                    ( u23_axi_2_ahbl_intf_hrdata    ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hsize_slv_i_portbus                     ( u23_axi_2_ahbl_intf_hsize     ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_htrans_slv_i_portbus                    ( u23_axi_2_ahbl_intf_htrans    ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hwdata_slv_i_portbus                    ( u23_axi_2_ahbl_intf_hwdata    ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hmastlock_slv_i_port                    ( u23_axi_2_ahbl_intf_hmastlock ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hready_slv_i_port                       ( u23_axi_2_ahbl_intf_hready    ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hreadyout_slv_o_port                    ( u23_axi_2_ahbl_intf_hreadyout ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hresp_slv_o_port                        ( u23_axi_2_ahbl_intf_hresp     ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hsel_slv_i_port                         ( u23_axi_2_ahbl_intf_hsel      ),
     .ahbl0_inst_AHBL_S01_interface_ahbl_s01_hwrite_slv_i_port                       ( u23_axi_2_ahbl_intf_hwrite    ),

     /* Interrupt line/s */
     .cpu0_inst_IRQ_S1_interface_irq1_i_port                                         ( u23_interrupt                 )

     );

  //--------------------------------------------------
  // AHBL-LMMI Bridge
  //--------------------------------------------------

  AHBL_to_LMMI_converter
    #
    (
     .data_width                 ( 32              ),
     .address_width              ( 17              )
     )
  AHBL_to_LMMI_converter_inst
    (

     // *********************************************************************
     // Clock & Reset Signals
     // *********************************************************************

     .clk_i                      ( clk_pll_60m     ),
     .rst_n_i                    ( risc_v_system_reset_n_60m ),

     // *********************************************************************
     // LMMI Interface Signals
     // *********************************************************************

     .lmmi_rdata_i               ( lmmi_rdata       ),
     .lmmi_rdata_valid_i         ( lmmi_rdata_valid ),
     .lmmi_ready_i               ( lmmi_ready       ),
     .lmmi_request_o             ( lmmi_request     ),
     .lmmi_wr_rdn_o              ( lmmi_wr_rdn      ),
     .lmmi_offset_o              ( lmmi_offset      ),
     .lmmi_wdata_o               ( lmmi_wdata       ),

     // *********************************************************************
     // AHBL Interface Signals
     // *********************************************************************

     .ahbl_hsel_i                ( u23_cnfg_intf_ahbl_hsel       ),
     .ahbl_hready_i              ( u23_cnfg_intf_ahbl_hready     ),
     .ahbl_haddr_i               ( u23_cnfg_intf_ahbl_haddr      ),
     .ahbl_hburst_i              ( u23_cnfg_intf_ahbl_hburst     ),
     .ahbl_hsize_i               ( u23_cnfg_intf_ahbl_hsize      ),
     .ahbl_hmastlock_i           ( u23_cnfg_intf_ahbl_hmastlock  ),
     .ahbl_hprot_i               ( u23_cnfg_intf_ahbl_hprot      ),
     .ahbl_htrans_i              ( u23_cnfg_intf_ahbl_htrans     ),
     .ahbl_hwrite_i              ( u23_cnfg_intf_ahbl_hwrite     ),
     .ahbl_hwdata_i              ( u23_cnfg_intf_ahbl_hwdata     ),
     .ahbl_hreadyout_o           ( u23_cnfg_intf_ahbl_hreadyout  ),
     .ahbl_hresp_o               ( u23_cnfg_intf_ahbl_hresp      ),
     .ahbl_hrdata_o              ( u23_cnfg_intf_ahbl_hrdata     )
    );

  // ----------------------------------------------------------------------------------------------------------
  // AXI4 (64bit Data width) to AHBL (32bit Data width) Conversion
  // ----------------------------------------------------------------------------------------------------------
  // Note1: The ports of the axi64_to_ahbl32_conv module are unconnected due to a lack of connection ports
  //        with the USB23 controller ports.
  axi64_to_ahbl32_conv
    axi_ahb_conv
    (
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_addr_o_portbus     ( u23_axi_2_ahbl_intf_haddr      ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_burst_o_portbus    ( u23_axi_2_ahbl_intf_hburst     ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_prot_o_portbus     ( u23_axi_2_ahbl_intf_hprot      ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_rdata_i_portbus    ( u23_axi_2_ahbl_intf_hrdata     ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_size_o_portbus     ( u23_axi_2_ahbl_intf_hsize      ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_trans_o_portbus    ( u23_axi_2_ahbl_intf_htrans     ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_wdata_o_portbus    ( u23_axi_2_ahbl_intf_hwdata     ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_mastlock_o_port    ( u23_axi_2_ahbl_intf_hmastlock  ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_ready_i_port       ( u23_axi_2_ahbl_intf_hreadyout  ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_ready_o_port       ( u23_axi_2_ahbl_intf_hready     ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_resp_i_port        ( u23_axi_2_ahbl_intf_hresp      ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_sel_o_port         ( u23_axi_2_ahbl_intf_hsel       ),
     .axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_write_o_port       ( u23_axi_2_ahbl_intf_hwrite     ),

     // AXI Master Write Address Channel Signals
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awaddr_i_portbus    ( u23_axim_XMAWADDR              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awburst_i_portbus   ( u23_axim_XMAWBURST             ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awcache_i_portbus   ( u23_axim_XMAWCACHE             ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awid_i_portbus      ( u23_axim_XMAWID                ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awlen_i_portbus     ( u23_axim_XMAWLEN               ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awprot_i_portbus    ( u23_axim_XMAWPROT              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awsize_i_portbus    ( u23_axim_XMAWSIZE              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awlock_i_port       ( u23_axim_XMAWLOCK              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awready_o_port      ( u23_axim_XMAWREADY             ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awvalid_i_port      ( u23_axim_XMAWVALID             ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awuser_i_portbus    (                                ),//Why? ... Read Note1 for this.
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awqos_i_portbus     (                                ),//Why? ... Read Note1 for this.
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_awregion_i_portbus  (                                ),//Why? ... Read Note1 for this.

     // AXI Master Write Data Channel Signals
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_wdata_i_portbus     ( u23_axim_XMWDATA               ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_wstrb_i_portbus     ( u23_axim_XMWSTRB               ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_wlast_i_port        ( u23_axim_XMWLAST               ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_wready_o_port       ( u23_axim_XMWREADY              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_wvalid_i_port       ( u23_axim_XMWVALID              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_wuser_i_portbus     (                                ),//Why? ... Read Note1 for this.

     // AXI Master Read Address Channel Signals
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_araddr_i_portbus    ( u23_axim_XMARADDR              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arburst_i_portbus   ( u23_axim_XMARBURST             ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arcache_i_portbus   ( u23_axim_XMARCACHE             ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arid_i_portbus      ( u23_axim_XMARID                ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arlen_i_portbus     ( u23_axim_XMARLEN               ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arprot_i_portbus    ( u23_axim_XMARPROT              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arsize_i_portbus    ( u23_axim_XMARSIZE              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arlock_i_port       ( u23_axim_XMARLOCK              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arready_o_port      ( u23_axim_XMARREADY             ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arvalid_i_port      ( u23_axim_XMARVALID             ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arqos_i_portbus     (                                ),//Why? ... Read Note1 for this.
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_arregion_i_portbus  (                                ),//Why? ... Read Note1 for this.
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_aruser_i_portbus    (                                ),//Why? ... Read Note1 for this.

     // AXI Master Read Data Channel Signals
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_rdata_o_portbus     ( u23_axim_XMRDATA               ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_rid_o_portbus       ( u23_axim_XMRID                 ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_rresp_o_portbus     ( u23_axim_XMRRESP               ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_rlast_o_port        ( u23_axim_XMRLAST               ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_rready_i_port       ( u23_axim_XMRREADY              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_rvalid_o_port       ( u23_axim_XMRVALID              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_ruser_o_portbus     (                                ),//Why? ... Read Note1 for this.

     // AXI Master Write Response Channel Signals
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_bid_o_portbus       ( u23_axim_XMBID                 ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_bresp_o_portbus     ( u23_axim_XMBRESP               ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_bready_i_port       ( u23_axim_XMBREADY              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_bvalid_o_port       ( u23_axim_XMBVALID              ),
     .axi4_interconnect_inst_AXI_S00_interface_axi_S00_buser_o_portbus     (                                ),//Why? ... Read Note1 for this.

     .clk_i                                                                ( clk_pll_60m                    ),
     .rstn_i                                                               ( risc_v_system_reset_n_60m      )
    );


  //----------------------------------------------------------------------------------------------------------
  //`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-
  //----------------------------------------------------------------------------------------------------------
  //
  //                                              USB23 Primitive
  //
  //----------------------------------------------------------------------------------------------------------
  //`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-`-
  //----------------------------------------------------------------------------------------------------------

  USB23
    #
    (
     .USB_MODE                   ( "USB23"             ),
     .GSR                        ( "ENABLED"           )
     )
  USB23_primitive_inst
    (

     // *********************************************************************
     // Clock Signals
     // *********************************************************************

     // USB 2.0 & 3.0 Internal Clock
     .USBPHY_REFCLK_ALT          ( clk_pll_60m         ),

     // USB 2.0 PHY External Clock
     .XOIN18                     ( 1'b0                ),
     .XOOUT18                    (                     ),

     // USB 3.0 PHY External Differential Clock
     .REFINCLKEXTP               ( REFINCLKEXTP_i      ),
     .REFINCLKEXTM               ( REFINCLKEXTM_i      ),

     // Other Clocks
     .USB3_MCUCLK                ( clk_pll_60m        ),
     .USB_SUSPENDCLK             ( clk_pll_60m         ),

     // *********************************************************************
     // Reset Signals
     // *********************************************************************

     .USB3_SYSRSTN               ( risc_v_system_reset_n_60m     ),
     .USB_RESETN                 ( risc_v_system_reset_n_60m     ),
     .USB2_RESET                 ( !risc_v_system_reset_n_60m    ),

     // *********************************************************************
     // USB23 High Speed Lines
     // *********************************************************************

     // USB 2.0 Lines
     .DP                         ( dp_z                ),
     .DM                         ( dm_z                ),

     // USB 3.0 Lines
     .RXM                        ( u3_rxm_i            ),
     .RXP                        ( u3_rxp_i            ),
     .TXM                        ( u3_txm_o            ),
     .TXP                        ( u3_txp_o            ),

     // *********************************************************************
     // Configuration Path
     // *********************************************************************

     // LMMI Configuration path Signals
     .LMMICLK                    ( clk_pll_60m         ),
     .LMMIRESETN                 ( risc_v_system_reset_n_60m     ),
     .LMMIREQUEST                ( lmmi_request        ),
     .LMMIWRRD_N                 ( lmmi_wr_rdn         ),
     .LMMIOFFSET                 ( lmmi_offset         ),
     .LMMIWDATA                  ( lmmi_wdata          ),
     .LMMIRDATAVALID             ( lmmi_rdata_valid    ),
     .LMMIREADY                  ( lmmi_ready          ),
     .LMMIRDATA                  ( lmmi_rdata          ),

     // *********************************************************************
     // Data Path
     // *********************************************************************

     // AXI Master Write Address Channel Signals
     .XMAWADDR                   ( u23_axim_XMAWADDR   ),
     .XMAWBURST                  ( u23_axim_XMAWBURST  ),
     .XMAWCACHE                  ( u23_axim_XMAWCACHE  ),
     .XMAWID                     ( u23_axim_XMAWID     ),
     .XMAWLEN                    ( u23_axim_XMAWLEN    ),
     .XMAWPROT                   ( u23_axim_XMAWPROT   ),
     .XMAWSIZE                   ( u23_axim_XMAWSIZE   ),
     .XMAWLOCK                   ( u23_axim_XMAWLOCK   ),
     .XMAWREADY                  ( u23_axim_XMAWREADY  ),
     .XMAWVALID                  ( u23_axim_XMAWVALID  ),
     .XMAWMISC_INFO              (                     ),//Why? ... Read Note1 for this.
     // AXI Master Write Data Channel Signals
     .XMWDATA                    ( u23_axim_XMWDATA    ),
     .XMWSTRB                    ( u23_axim_XMWSTRB    ),
     .XMWLAST                    ( u23_axim_XMWLAST    ),
     .XMWREADY                   ( u23_axim_XMWREADY   ),
     .XMWVALID                   ( u23_axim_XMWVALID   ),
     .XMWID                      (                     ),//Why? ... Read Note1 for this.
     // AXI Master Read Address Channel Signals
     .XMARADDR                   ( u23_axim_XMARADDR   ),
     .XMARBURST                  ( u23_axim_XMARBURST  ),
     .XMARCACHE                  ( u23_axim_XMARCACHE  ),
     .XMARID                     ( u23_axim_XMARID     ),
     .XMARLEN                    ( u23_axim_XMARLEN    ),
     .XMARPROT                   ( u23_axim_XMARPROT   ),
     .XMARSIZE                   ( u23_axim_XMARSIZE   ),
     .XMARLOCK                   ( u23_axim_XMARLOCK   ),
     .XMARREADY                  ( u23_axim_XMARREADY  ),
     .XMARVALID                  ( u23_axim_XMARVALID  ),
     .XMARMISC_INFO              (                     ),//Why? ... Read Note1 for this.
     // AXI Master Read Data Channel Signals
     .XMRDATA                    ( u23_axim_XMRDATA    ),
     .XMRID                      ( u23_axim_XMRID      ),
     .XMRRESP                    ( u23_axim_XMRRESP    ),
     .XMRLAST                    ( u23_axim_XMRLAST    ),
     .XMRREADY                   ( u23_axim_XMRREADY   ),
     .XMRVALID                   ( u23_axim_XMRVALID   ),
     .XMRMISC_INFO               (                     ),//Why? ... Read Note1 for this.
     // AXI Master Write Response Channel Signals
     .XMBID                      ( u23_axim_XMBID      ),
     .XMBRESP                    ( u23_axim_XMBRESP    ),
     .XMBREADY                   ( u23_axim_XMBREADY   ),
     .XMBVALID                   ( u23_axim_XMBVALID   ),
     .XMBMISC_INFO               (                     ),//Why? ... Read Note1 for this.
     // AXI bus for Lower Power
     .XMCSYSREQ                  (                     ),//Why? ... Read Note1 for this.
     .XMCSYSACK                  (                     ),//Why? ... Read Note1 for this.
     .XMCACTIVE                  (                     ),//Why? ... Read Note1 for this.

     // *********************************************************************
     // Power and Pad Signal
     // *********************************************************************

     .VBUS                       ( vbus_z              ),
     .ID                         ( 1'b1                ),

     // *********************************************************************
     // Interrupt Signal
     // *********************************************************************

     .INTERRUPT                  ( u23_interrupt       ),

     // *********************************************************************
     // Other Signal
     // *********************************************************************

     // Type C Support signals Controller
     .STARTRXDETU3RXDET          ( '0                  ),
     .DISRXDETU3RXDET            ( '0                  ),
     .SS_RX_ACJT_EN              ( '0                  ),
     .SS_RX_ACJT_ININ            ( '0                  ),
     .SS_RX_ACJT_INIP            ( '0                  ),
     .SS_RX_ACJT_INIT_EN         ( '0                  ),
     .SS_RX_ACJT_MODE            ( '0                  ),
     .SS_TX_ACJT_DRVEN           ( '0                  ),
     .SS_TX_ACJT_DATAIN          ( '0                  ),
     .SS_TX_ACJT_HIGHZ           ( '0                  ),
     .SCANEN_CTRL                ( '0                  ),
     .SCANEN_USB3PHY             ( '0                  ),
     .SCANEN_CGUSB3PHY           ( '0                  ),
     .SCANEN_USB2PHY             ( '0                  ),
     .RESEXTUSB3                 (                     ),
     .RESEXTUSB2                 ( u2_reset_ext_z      ),
     .DISRXDETU3RXDETACK         (                     ),
     .SS_RX_ACJT_OUTN            (                     ),
     .SS_RX_ACJT_OUTP            (                     )
    );

endmodule // nx33u_u23_jediD9_board_des

// " Satya... Prem... Karuna "
