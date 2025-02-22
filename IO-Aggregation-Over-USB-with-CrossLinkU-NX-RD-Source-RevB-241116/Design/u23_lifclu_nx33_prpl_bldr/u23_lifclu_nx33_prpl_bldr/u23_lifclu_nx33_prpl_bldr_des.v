// >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ------------------------------------------------------------------
// Copyright (c) 2019-2024 by Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// ------------------------------------------------------------------
//
// IMPORTANT: THIS FILE IS USED BY OR GENERATED BY the LATTICE PROPEL�
// DEVELOPMENT SUITE, WHICH INCLUDES PROPEL BUILDER AND PROPEL SDK.
//
// Lattice grants permission to use this code pursuant to the
// terms of the Lattice Propel License Agreement.
//
// DISCLAIMER:
//
//  LATTICE MAKES NO WARRANTIES ON THIS FILE OR ITS CONTENTS, WHETHER
//  EXPRESSED, IMPLIED, STATUTORY, OR IN ANY PROVISION OF THE LATTICE
//  PROPEL LICENSE AGREEMENT OR COMMUNICATION WITH LICENSEE, AND LATTICE
//  SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTY OF MERCHANTABILITY OR
//  FITNESS FOR A PARTICULAR PURPOSE.  LATTICE DOES NOT WARRANT THAT THE
//  FUNCTIONS CONTAINED HEREIN WILL MEET LICENSEE'S REQUIREMENTS, OR THAT
//  LICENSEE'S OPERATION OF ANY DEVICE, SOFTWARE OR SYSTEM USING THIS FILE
//  OR ITS CONTENTS WILL BE UNINTERRUPTED OR ERROR FREE, OR THAT DEFECTS
//  HEREIN WILL BE CORRECTED.  LICENSEE ASSUMES RESPONSIBILITY FOR 
//  SELECTION OF MATERIALS TO ACHIEVE ITS INTENDED RESULTS, AND FOR THE
//  PROPER INSTALLATION, USE, AND RESULTS OBTAINED THEREFROM.  LICENSEE
//  ASSUMES THE ENTIRE RISK OF THE FILE AND ITS CONTENTS PROVING DEFECTIVE
//  OR FAILING TO PERFORM PROPERLY AND IN SUCH EVENT, LICENSEE SHALL
//  ASSUME THE ENTIRE COST AND RISK OF ANY REPAIR, SERVICE, CORRECTION, OR
//  ANY OTHER LIABILITIES OR DAMAGES CAUSED BY OR ASSOCIATED WITH THE
//  SOFTWARE.  IN NO EVENT SHALL LATTICE BE LIABLE TO ANY PARTY FOR DIRECT,
//  INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST
//  PROFITS, ARISING OUT OF THE USE OF THIS FILE OR ITS CONTENTS, EVEN IF
//  LATTICE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. LATTICE'S
//  SOLE LIABILITY, AND LICENSEE'S SOLE REMEDY, IS SET FORTH ABOVE. 
//  LATTICE DOES NOT WARRANT OR REPRESENT THAT THIS FILE, ITS CONTENTS OR
//  USE THEREOF DOES NOT INFRINGE ON THIRD PARTIES' INTELLECTUAL PROPERTY
//  RIGHTS, INCLUDING ANY PATENT. IT IS THE USER'S RESPONSIBILITY TO VERIFY
//  THE USER SOFTWARE DESIGN FOR CONSISTENCY AND FUNCTIONALITY THROUGH THE
//  USE OF FORMAL SOFTWARE VALIDATION METHODS.
// ------------------------------------------------------------------

/* synthesis translate_off*/
`define SBP_SIMULATION
/* synthesis translate_on*/
`ifndef SBP_SIMULATION
`define SBP_SYNTHESIS
`endif



//
// Verific Verilog Description of module u23_lifclu_nx33_prpl_bldr_des
//
module u23_lifclu_nx33_prpl_bldr_des (HW_ver_i, ahbl0_inst_AHBL_S01_interface_ahbl_s01_haddr_slv_i_portbus, 
            ahbl0_inst_AHBL_S01_interface_ahbl_s01_hburst_slv_i_portbus, ahbl0_inst_AHBL_S01_interface_ahbl_s01_hprot_slv_i_portbus, 
            ahbl0_inst_AHBL_S01_interface_ahbl_s01_hrdata_slv_o_portbus, ahbl0_inst_AHBL_S01_interface_ahbl_s01_hsize_slv_i_portbus, 
            ahbl0_inst_AHBL_S01_interface_ahbl_s01_htrans_slv_i_portbus, ahbl0_inst_AHBL_S01_interface_ahbl_s01_hwdata_slv_i_portbus, 
            gpio_0_z, u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_haddr_mstr_o_portbus, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hburst_mstr_o_portbus, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hprot_mstr_o_portbus, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hrdata_mstr_i_portbus, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hsize_mstr_o_portbus, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_htrans_mstr_o_portbus, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hwdata_mstr_o_portbus, 
            ahbl0_inst_AHBL_S01_interface_ahbl_s01_hmastlock_slv_i_port, ahbl0_inst_AHBL_S01_interface_ahbl_s01_hready_slv_i_port, 
            ahbl0_inst_AHBL_S01_interface_ahbl_s01_hreadyout_slv_o_port, ahbl0_inst_AHBL_S01_interface_ahbl_s01_hresp_slv_o_port, 
            ahbl0_inst_AHBL_S01_interface_ahbl_s01_hsel_slv_i_port, ahbl0_inst_AHBL_S01_interface_ahbl_s01_hwrite_slv_i_port, 
            clk_i, cpu0_inst_IRQ_S1_interface_irq1_i_port, i2cm0_scl, 
            i2cm0_sda, rstn_i, spim0_miso_i, spim0_mosi_o, spim0_sclk_o, 
            spim0_ssn_o, system_reset_n_o, u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hmastlock_mstr_o_port, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hready_mstr_i_port, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hready_mstr_o_port, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hresp_mstr_i_port, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hsel_mstr_o_port, 
            u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hwrite_mstr_o_port, 
            uart_rxd_i, uart_txd_o);
    input [31:0]HW_ver_i;
    input [31:0]ahbl0_inst_AHBL_S01_interface_ahbl_s01_haddr_slv_i_portbus;
    input [2:0]ahbl0_inst_AHBL_S01_interface_ahbl_s01_hburst_slv_i_portbus;
    input [3:0]ahbl0_inst_AHBL_S01_interface_ahbl_s01_hprot_slv_i_portbus;
    output [31:0]ahbl0_inst_AHBL_S01_interface_ahbl_s01_hrdata_slv_o_portbus;
    input [2:0]ahbl0_inst_AHBL_S01_interface_ahbl_s01_hsize_slv_i_portbus;
    input [1:0]ahbl0_inst_AHBL_S01_interface_ahbl_s01_htrans_slv_i_portbus;
    input [31:0]ahbl0_inst_AHBL_S01_interface_ahbl_s01_hwdata_slv_i_portbus;
    inout [1:0]gpio_0_z;
    output [16:0]u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_haddr_mstr_o_portbus;
    output [2:0]u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hburst_mstr_o_portbus;
    output [3:0]u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hprot_mstr_o_portbus;
    input [31:0]u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hrdata_mstr_i_portbus;
    output [2:0]u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hsize_mstr_o_portbus;
    output [1:0]u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_htrans_mstr_o_portbus;
    output [31:0]u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hwdata_mstr_o_portbus;
    input ahbl0_inst_AHBL_S01_interface_ahbl_s01_hmastlock_slv_i_port;
    input ahbl0_inst_AHBL_S01_interface_ahbl_s01_hready_slv_i_port;
    output ahbl0_inst_AHBL_S01_interface_ahbl_s01_hreadyout_slv_o_port;
    output ahbl0_inst_AHBL_S01_interface_ahbl_s01_hresp_slv_o_port;
    input ahbl0_inst_AHBL_S01_interface_ahbl_s01_hsel_slv_i_port;
    input ahbl0_inst_AHBL_S01_interface_ahbl_s01_hwrite_slv_i_port;
    input clk_i;
    input cpu0_inst_IRQ_S1_interface_irq1_i_port;
    inout i2cm0_scl;
    inout i2cm0_sda;
    input rstn_i;
    input spim0_miso_i;
    output spim0_mosi_o;
    output spim0_sclk_o;
    output spim0_ssn_o;
    output system_reset_n_o;
    output u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hmastlock_mstr_o_port;
    input u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hready_mstr_i_port;
    output u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hready_mstr_o_port;
    input u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hresp_mstr_i_port;
    output u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hsel_mstr_o_port;
    output u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hwrite_mstr_o_port;
    input uart_rxd_i;
    output uart_txd_o;
    
    wire [31:0]apb0_inst_APB_M02_interconnect_PADDR;
    wire [31:0]apb0_inst_APB_M02_interconnect_PWDATA;
    wire [31:0]apb0_inst_APB_M02_interconnect_PRDATA;
    
    wire apb0_inst_APB_M02_interconnect_PENABLE, apb0_inst_APB_M02_interconnect_PSELx, 
        apb0_inst_APB_M02_interconnect_PWRITE, apb0_inst_APB_M02_interconnect_PSLVERR, 
        apb0_inst_APB_M02_interconnect_PREADY;
    wire [31:0]ahbl0_inst_AHBL_M02_interconnect_HRDATA;
    wire [31:0]ahbl0_inst_AHBL_M02_interconnect_HADDR;
    wire [2:0]ahbl0_inst_AHBL_M02_interconnect_HBURST;
    wire [2:0]ahbl0_inst_AHBL_M02_interconnect_HSIZE;
    wire [3:0]ahbl0_inst_AHBL_M02_interconnect_HPROT;
    wire [1:0]ahbl0_inst_AHBL_M02_interconnect_HTRANS;
    wire [31:0]ahbl0_inst_AHBL_M02_interconnect_HWDATA;
    wire [31:0]ahbl0_inst_AHBL_M01_interconnect_HRDATA;
    wire [31:0]ahbl0_inst_AHBL_M01_interconnect_HADDR;
    wire [2:0]ahbl0_inst_AHBL_M01_interconnect_HBURST;
    wire [2:0]ahbl0_inst_AHBL_M01_interconnect_HSIZE;
    wire [3:0]ahbl0_inst_AHBL_M01_interconnect_HPROT;
    wire [1:0]ahbl0_inst_AHBL_M01_interconnect_HTRANS;
    wire [31:0]ahbl0_inst_AHBL_M01_interconnect_HWDATA;
    wire [31:0]cpu0_inst_AHBL_M1_DATA_interconnect_HADDR;
    wire [2:0]cpu0_inst_AHBL_M1_DATA_interconnect_HBURST;
    wire [2:0]cpu0_inst_AHBL_M1_DATA_interconnect_HSIZE;
    wire [3:0]cpu0_inst_AHBL_M1_DATA_interconnect_HPROT;
    wire [1:0]cpu0_inst_AHBL_M1_DATA_interconnect_HTRANS;
    wire [31:0]cpu0_inst_AHBL_M1_DATA_interconnect_HWDATA;
    wire [31:0]cpu0_inst_AHBL_M1_DATA_interconnect_HRDATA;
    wire [31:0]ahbl0_inst_AHBL_M00_interconnect_HRDATA;
    wire [31:0]ahbl0_inst_AHBL_M00_interconnect_HADDR;
    wire [2:0]ahbl0_inst_AHBL_M00_interconnect_HBURST;
    wire [2:0]ahbl0_inst_AHBL_M00_interconnect_HSIZE;
    wire [3:0]ahbl0_inst_AHBL_M00_interconnect_HPROT;
    wire [1:0]ahbl0_inst_AHBL_M00_interconnect_HTRANS;
    wire [31:0]ahbl0_inst_AHBL_M00_interconnect_HWDATA;
    
    wire ahbl0_inst_AHBL_M02_interconnect_HREADYOUT, ahbl0_inst_AHBL_M02_interconnect_HRESP, 
        ahbl0_inst_AHBL_M02_interconnect_HSELx, ahbl0_inst_AHBL_M02_interconnect_HMASTLOCK, 
        ahbl0_inst_AHBL_M02_interconnect_HWRITE, ahbl0_inst_AHBL_M02_interconnect_HREADY, 
        ahbl0_inst_AHBL_M01_interconnect_HREADYOUT, ahbl0_inst_AHBL_M01_interconnect_HRESP, 
        ahbl0_inst_AHBL_M01_interconnect_HSELx, ahbl0_inst_AHBL_M01_interconnect_HMASTLOCK, 
        ahbl0_inst_AHBL_M01_interconnect_HWRITE, ahbl0_inst_AHBL_M01_interconnect_HREADY, 
        cpu0_inst_AHBL_M1_DATA_interconnect_HMASTLOCK, cpu0_inst_AHBL_M1_DATA_interconnect_HWRITE, 
        cpu0_inst_AHBL_M1_DATA_interconnect_HREADYOUT, cpu0_inst_AHBL_M1_DATA_interconnect_HRESP, 
        ahbl0_inst_AHBL_M00_interconnect_HREADYOUT, ahbl0_inst_AHBL_M00_interconnect_HRESP, 
        ahbl0_inst_AHBL_M00_interconnect_HSELx, ahbl0_inst_AHBL_M00_interconnect_HMASTLOCK, 
        ahbl0_inst_AHBL_M00_interconnect_HWRITE, ahbl0_inst_AHBL_M00_interconnect_HREADY;
    wire [31:0]ahbl2apb0_inst_APB_M0_interconnect_PRDATA;
    wire [31:0]ahbl2apb0_inst_APB_M0_interconnect_PADDR;
    wire [31:0]ahbl2apb0_inst_APB_M0_interconnect_PWDATA;
    
    wire ahbl2apb0_inst_APB_M0_interconnect_PREADY, ahbl2apb0_inst_APB_M0_interconnect_PSLVERR, 
        ahbl2apb0_inst_APB_M0_interconnect_PSELx, ahbl2apb0_inst_APB_M0_interconnect_PWRITE, 
        ahbl2apb0_inst_APB_M0_interconnect_PENABLE;
    wire [31:0]apb0_inst_APB_M04_interconnect_PRDATA;
    wire [31:0]apb0_inst_APB_M04_interconnect_PADDR;
    wire [31:0]apb0_inst_APB_M04_interconnect_PWDATA;
    wire [31:0]apb0_inst_APB_M03_interconnect_PRDATA;
    wire [31:0]apb0_inst_APB_M03_interconnect_PADDR;
    wire [31:0]apb0_inst_APB_M03_interconnect_PWDATA;
    wire [31:0]apb0_inst_APB_M01_interconnect_PRDATA;
    wire [31:0]apb0_inst_APB_M01_interconnect_PADDR;
    wire [31:0]apb0_inst_APB_M01_interconnect_PWDATA;
    wire [31:0]apb0_inst_APB_M00_interconnect_PRDATA;
    wire [31:0]apb0_inst_APB_M00_interconnect_PADDR;
    wire [31:0]apb0_inst_APB_M00_interconnect_PWDATA;
    
    wire apb0_inst_APB_M04_interconnect_PREADY, apb0_inst_APB_M04_interconnect_PSLVERR, 
        apb0_inst_APB_M04_interconnect_PSELx, apb0_inst_APB_M04_interconnect_PWRITE, 
        apb0_inst_APB_M04_interconnect_PENABLE, apb0_inst_APB_M03_interconnect_PREADY, 
        apb0_inst_APB_M03_interconnect_PSLVERR, apb0_inst_APB_M03_interconnect_PSELx, 
        apb0_inst_APB_M03_interconnect_PWRITE, apb0_inst_APB_M03_interconnect_PENABLE, 
        apb0_inst_APB_M01_interconnect_PREADY, apb0_inst_APB_M01_interconnect_PSLVERR, 
        apb0_inst_APB_M01_interconnect_PSELx, apb0_inst_APB_M01_interconnect_PWRITE, 
        apb0_inst_APB_M01_interconnect_PENABLE, apb0_inst_APB_M00_interconnect_PREADY, 
        apb0_inst_APB_M00_interconnect_PSLVERR, apb0_inst_APB_M00_interconnect_PSELx, 
        apb0_inst_APB_M00_interconnect_PWRITE, apb0_inst_APB_M00_interconnect_PENABLE;
    wire [31:0]cpu0_inst_AHBL_M0_INSTR_interconnect_HADDR;
    wire [2:0]cpu0_inst_AHBL_M0_INSTR_interconnect_HSIZE;
    wire [2:0]cpu0_inst_AHBL_M0_INSTR_interconnect_HBURST;
    wire [3:0]cpu0_inst_AHBL_M0_INSTR_interconnect_HPROT;
    wire [1:0]cpu0_inst_AHBL_M0_INSTR_interconnect_HTRANS;
    wire [31:0]cpu0_inst_AHBL_M0_INSTR_interconnect_HWDATA;
    wire [31:0]cpu0_inst_AHBL_M0_INSTR_interconnect_HRDATA;
    
    wire lscc_spim1_inst_INTR_interconnect_IRQ, lscc_i2cm1_inst_INTR_interconnect_IRQ, 
        gpio0_inst_INTR_interconnect_IRQ, uart0_inst_INT_M0_interconnect_IRQ, 
        cpu0_inst_AHBL_M0_INSTR_interconnect_HWRITE, cpu0_inst_AHBL_M0_INSTR_interconnect_HMASTLOCK, 
        cpu0_inst_AHBL_M0_INSTR_interconnect_HREADYOUT, cpu0_inst_AHBL_M0_INSTR_interconnect_HRESP;
    wire [0:0]lscc_spim1_inst_ssn_o_netbus;
    
    
    assign spim0_ssn_o = lscc_spim1_inst_ssn_o_netbus[0];

    HW_ver_gpio HW_ver_gpio_inst (.gpio_i({HW_ver_i}), .apb_paddr_i({apb0_inst_APB_M02_interconnect_PADDR[5:0]}), 
            .apb_pwdata_i({apb0_inst_APB_M02_interconnect_PWDATA}), .apb_prdata_o({apb0_inst_APB_M02_interconnect_PRDATA}), 
            .clk_i(clk_i), .resetn_i(system_reset_n_o), .apb_penable_i(apb0_inst_APB_M02_interconnect_PENABLE), 
            .apb_psel_i(apb0_inst_APB_M02_interconnect_PSELx), .apb_pwrite_i(apb0_inst_APB_M02_interconnect_PWRITE), 
            .apb_pslverr_o(apb0_inst_APB_M02_interconnect_PSLVERR), .apb_pready_o(apb0_inst_APB_M02_interconnect_PREADY));
    ahbl0 ahbl0_inst (.ahbl_m02_hrdata_mstr_i({ahbl0_inst_AHBL_M02_interconnect_HRDATA}), 
          .ahbl_m02_haddr_mstr_o({ahbl0_inst_AHBL_M02_interconnect_HADDR}), 
          .ahbl_m02_hburst_mstr_o({ahbl0_inst_AHBL_M02_interconnect_HBURST}), 
          .ahbl_m02_hsize_mstr_o({ahbl0_inst_AHBL_M02_interconnect_HSIZE}), 
          .ahbl_m02_hprot_mstr_o({ahbl0_inst_AHBL_M02_interconnect_HPROT}), 
          .ahbl_m02_htrans_mstr_o({ahbl0_inst_AHBL_M02_interconnect_HTRANS}), 
          .ahbl_m02_hwdata_mstr_o({ahbl0_inst_AHBL_M02_interconnect_HWDATA}), 
          .ahbl_s01_haddr_slv_i({ahbl0_inst_AHBL_S01_interface_ahbl_s01_haddr_slv_i_portbus}), 
          .ahbl_s01_hburst_slv_i({ahbl0_inst_AHBL_S01_interface_ahbl_s01_hburst_slv_i_portbus}), 
          .ahbl_s01_hsize_slv_i({ahbl0_inst_AHBL_S01_interface_ahbl_s01_hsize_slv_i_portbus}), 
          .ahbl_s01_hprot_slv_i({ahbl0_inst_AHBL_S01_interface_ahbl_s01_hprot_slv_i_portbus}), 
          .ahbl_s01_htrans_slv_i({ahbl0_inst_AHBL_S01_interface_ahbl_s01_htrans_slv_i_portbus}), 
          .ahbl_s01_hwdata_slv_i({ahbl0_inst_AHBL_S01_interface_ahbl_s01_hwdata_slv_i_portbus}), 
          .ahbl_s01_hrdata_slv_o({ahbl0_inst_AHBL_S01_interface_ahbl_s01_hrdata_slv_o_portbus}), 
          .ahbl_m01_hrdata_mstr_i({ahbl0_inst_AHBL_M01_interconnect_HRDATA}), 
          .ahbl_m01_haddr_mstr_o({ahbl0_inst_AHBL_M01_interconnect_HADDR}), 
          .ahbl_m01_hburst_mstr_o({ahbl0_inst_AHBL_M01_interconnect_HBURST}), 
          .ahbl_m01_hsize_mstr_o({ahbl0_inst_AHBL_M01_interconnect_HSIZE}), 
          .ahbl_m01_hprot_mstr_o({ahbl0_inst_AHBL_M01_interconnect_HPROT}), 
          .ahbl_m01_htrans_mstr_o({ahbl0_inst_AHBL_M01_interconnect_HTRANS}), 
          .ahbl_m01_hwdata_mstr_o({ahbl0_inst_AHBL_M01_interconnect_HWDATA}), 
          .ahbl_s00_haddr_slv_i({cpu0_inst_AHBL_M1_DATA_interconnect_HADDR}), 
          .ahbl_s00_hburst_slv_i({cpu0_inst_AHBL_M1_DATA_interconnect_HBURST}), 
          .ahbl_s00_hsize_slv_i({cpu0_inst_AHBL_M1_DATA_interconnect_HSIZE}), 
          .ahbl_s00_hprot_slv_i({cpu0_inst_AHBL_M1_DATA_interconnect_HPROT}), 
          .ahbl_s00_htrans_slv_i({cpu0_inst_AHBL_M1_DATA_interconnect_HTRANS}), 
          .ahbl_s00_hwdata_slv_i({cpu0_inst_AHBL_M1_DATA_interconnect_HWDATA}), 
          .ahbl_s00_hrdata_slv_o({cpu0_inst_AHBL_M1_DATA_interconnect_HRDATA}), 
          .ahbl_m00_hrdata_mstr_i({ahbl0_inst_AHBL_M00_interconnect_HRDATA}), 
          .ahbl_m00_haddr_mstr_o({ahbl0_inst_AHBL_M00_interconnect_HADDR}), 
          .ahbl_m00_hburst_mstr_o({ahbl0_inst_AHBL_M00_interconnect_HBURST}), 
          .ahbl_m00_hsize_mstr_o({ahbl0_inst_AHBL_M00_interconnect_HSIZE}), 
          .ahbl_m00_hprot_mstr_o({ahbl0_inst_AHBL_M00_interconnect_HPROT}), 
          .ahbl_m00_htrans_mstr_o({ahbl0_inst_AHBL_M00_interconnect_HTRANS}), 
          .ahbl_m00_hwdata_mstr_o({ahbl0_inst_AHBL_M00_interconnect_HWDATA}), 
          .ahbl_hclk_i(clk_i), .ahbl_hresetn_i(system_reset_n_o), .ahbl_m02_hready_mstr_i(ahbl0_inst_AHBL_M02_interconnect_HREADYOUT), 
          .ahbl_m02_hresp_mstr_i(ahbl0_inst_AHBL_M02_interconnect_HRESP), 
          .ahbl_m02_hsel_mstr_o(ahbl0_inst_AHBL_M02_interconnect_HSELx), .ahbl_m02_hmastlock_mstr_o(ahbl0_inst_AHBL_M02_interconnect_HMASTLOCK), 
          .ahbl_m02_hwrite_mstr_o(ahbl0_inst_AHBL_M02_interconnect_HWRITE), 
          .ahbl_m02_hready_mstr_o(ahbl0_inst_AHBL_M02_interconnect_HREADY), 
          .ahbl_s01_hsel_slv_i(ahbl0_inst_AHBL_S01_interface_ahbl_s01_hsel_slv_i_port), 
          .ahbl_s01_hmastlock_slv_i(ahbl0_inst_AHBL_S01_interface_ahbl_s01_hmastlock_slv_i_port), 
          .ahbl_s01_hwrite_slv_i(ahbl0_inst_AHBL_S01_interface_ahbl_s01_hwrite_slv_i_port), 
          .ahbl_s01_hready_slv_i(ahbl0_inst_AHBL_S01_interface_ahbl_s01_hready_slv_i_port), 
          .ahbl_s01_hreadyout_slv_o(ahbl0_inst_AHBL_S01_interface_ahbl_s01_hreadyout_slv_o_port), 
          .ahbl_s01_hresp_slv_o(ahbl0_inst_AHBL_S01_interface_ahbl_s01_hresp_slv_o_port), 
          .ahbl_m01_hready_mstr_i(ahbl0_inst_AHBL_M01_interconnect_HREADYOUT), 
          .ahbl_m01_hresp_mstr_i(ahbl0_inst_AHBL_M01_interconnect_HRESP), 
          .ahbl_m01_hsel_mstr_o(ahbl0_inst_AHBL_M01_interconnect_HSELx), .ahbl_m01_hmastlock_mstr_o(ahbl0_inst_AHBL_M01_interconnect_HMASTLOCK), 
          .ahbl_m01_hwrite_mstr_o(ahbl0_inst_AHBL_M01_interconnect_HWRITE), 
          .ahbl_m01_hready_mstr_o(ahbl0_inst_AHBL_M01_interconnect_HREADY), 
          .ahbl_s00_hsel_slv_i(1'b1), .ahbl_s00_hmastlock_slv_i(cpu0_inst_AHBL_M1_DATA_interconnect_HMASTLOCK), 
          .ahbl_s00_hwrite_slv_i(cpu0_inst_AHBL_M1_DATA_interconnect_HWRITE), 
          .ahbl_s00_hready_slv_i(cpu0_inst_AHBL_M1_DATA_interconnect_HREADYOUT), 
          .ahbl_s00_hreadyout_slv_o(cpu0_inst_AHBL_M1_DATA_interconnect_HREADYOUT), 
          .ahbl_s00_hresp_slv_o(cpu0_inst_AHBL_M1_DATA_interconnect_HRESP), 
          .ahbl_m00_hready_mstr_i(ahbl0_inst_AHBL_M00_interconnect_HREADYOUT), 
          .ahbl_m00_hresp_mstr_i(ahbl0_inst_AHBL_M00_interconnect_HRESP), 
          .ahbl_m00_hsel_mstr_o(ahbl0_inst_AHBL_M00_interconnect_HSELx), .ahbl_m00_hmastlock_mstr_o(ahbl0_inst_AHBL_M00_interconnect_HMASTLOCK), 
          .ahbl_m00_hwrite_mstr_o(ahbl0_inst_AHBL_M00_interconnect_HWRITE), 
          .ahbl_m00_hready_mstr_o(ahbl0_inst_AHBL_M00_interconnect_HREADY));
    defparam ahbl0_inst.FULL_DECODE_EN = 1;
    defparam ahbl0_inst.S0_ADDR_RANGE = 32'h00020000;
    defparam ahbl0_inst.S0_BASE_ADDR = 32'h00000000;
    defparam ahbl0_inst.S1_ADDR_RANGE = 32'h00001800;
    defparam ahbl0_inst.S1_BASE_ADDR = 32'h00040000;
    defparam ahbl0_inst.S2_ADDR_RANGE = 32'h00020000;
    defparam ahbl0_inst.S2_BASE_ADDR = 32'h00020000;
    ahbl2apb0 ahbl2apb0_inst (.ahbl_haddr_i({ahbl0_inst_AHBL_M01_interconnect_HADDR}), 
            .ahbl_hburst_i({ahbl0_inst_AHBL_M01_interconnect_HBURST}), .ahbl_hsize_i({ahbl0_inst_AHBL_M01_interconnect_HSIZE}), 
            .ahbl_hprot_i({ahbl0_inst_AHBL_M01_interconnect_HPROT}), .ahbl_htrans_i({ahbl0_inst_AHBL_M01_interconnect_HTRANS}), 
            .ahbl_hwdata_i({ahbl0_inst_AHBL_M01_interconnect_HWDATA}), .ahbl_hrdata_o({ahbl0_inst_AHBL_M01_interconnect_HRDATA}), 
            .apb_prdata_i({ahbl2apb0_inst_APB_M0_interconnect_PRDATA}), .apb_paddr_o({ahbl2apb0_inst_APB_M0_interconnect_PADDR}), 
            .apb_pwdata_o({ahbl2apb0_inst_APB_M0_interconnect_PWDATA}), .clk_i(clk_i), 
            .rst_n_i(system_reset_n_o), .ahbl_hsel_i(ahbl0_inst_AHBL_M01_interconnect_HSELx), 
            .ahbl_hready_i(ahbl0_inst_AHBL_M01_interconnect_HREADY), .ahbl_hmastlock_i(ahbl0_inst_AHBL_M01_interconnect_HMASTLOCK), 
            .ahbl_hwrite_i(ahbl0_inst_AHBL_M01_interconnect_HWRITE), .ahbl_hreadyout_o(ahbl0_inst_AHBL_M01_interconnect_HREADYOUT), 
            .ahbl_hresp_o(ahbl0_inst_AHBL_M01_interconnect_HRESP), .apb_pready_i(ahbl2apb0_inst_APB_M0_interconnect_PREADY), 
            .apb_pslverr_i(ahbl2apb0_inst_APB_M0_interconnect_PSLVERR), .apb_psel_o(ahbl2apb0_inst_APB_M0_interconnect_PSELx), 
            .apb_pwrite_o(ahbl2apb0_inst_APB_M0_interconnect_PWRITE), .apb_penable_o(ahbl2apb0_inst_APB_M0_interconnect_PENABLE));
    apb0 apb0_inst (.apb_m04_prdata_mstr_i({apb0_inst_APB_M04_interconnect_PRDATA}), 
         .apb_m04_paddr_mstr_o({apb0_inst_APB_M04_interconnect_PADDR}), .apb_m04_pwdata_mstr_o({apb0_inst_APB_M04_interconnect_PWDATA}), 
         .apb_m03_prdata_mstr_i({apb0_inst_APB_M03_interconnect_PRDATA}), 
         .apb_m03_paddr_mstr_o({apb0_inst_APB_M03_interconnect_PADDR}), .apb_m03_pwdata_mstr_o({apb0_inst_APB_M03_interconnect_PWDATA}), 
         .apb_m02_prdata_mstr_i({apb0_inst_APB_M02_interconnect_PRDATA}), 
         .apb_m02_paddr_mstr_o({apb0_inst_APB_M02_interconnect_PADDR}), .apb_m02_pwdata_mstr_o({apb0_inst_APB_M02_interconnect_PWDATA}), 
         .apb_m01_prdata_mstr_i({apb0_inst_APB_M01_interconnect_PRDATA}), 
         .apb_m01_paddr_mstr_o({apb0_inst_APB_M01_interconnect_PADDR}), .apb_m01_pwdata_mstr_o({apb0_inst_APB_M01_interconnect_PWDATA}), 
         .apb_s00_paddr_slv_i({ahbl2apb0_inst_APB_M0_interconnect_PADDR}), 
         .apb_s00_pwdata_slv_i({ahbl2apb0_inst_APB_M0_interconnect_PWDATA}), 
         .apb_s00_prdata_slv_o({ahbl2apb0_inst_APB_M0_interconnect_PRDATA}), 
         .apb_m00_prdata_mstr_i({apb0_inst_APB_M00_interconnect_PRDATA}), 
         .apb_m00_paddr_mstr_o({apb0_inst_APB_M00_interconnect_PADDR}), .apb_m00_pwdata_mstr_o({apb0_inst_APB_M00_interconnect_PWDATA}), 
         .apb_pclk_i(clk_i), .apb_presetn_i(system_reset_n_o), .apb_m04_pready_mstr_i(apb0_inst_APB_M04_interconnect_PREADY), 
         .apb_m04_pslverr_mstr_i(apb0_inst_APB_M04_interconnect_PSLVERR), 
         .apb_m04_psel_mstr_o(apb0_inst_APB_M04_interconnect_PSELx), .apb_m04_pwrite_mstr_o(apb0_inst_APB_M04_interconnect_PWRITE), 
         .apb_m04_penable_mstr_o(apb0_inst_APB_M04_interconnect_PENABLE), 
         .apb_m03_pready_mstr_i(apb0_inst_APB_M03_interconnect_PREADY), .apb_m03_pslverr_mstr_i(apb0_inst_APB_M03_interconnect_PSLVERR), 
         .apb_m03_psel_mstr_o(apb0_inst_APB_M03_interconnect_PSELx), .apb_m03_pwrite_mstr_o(apb0_inst_APB_M03_interconnect_PWRITE), 
         .apb_m03_penable_mstr_o(apb0_inst_APB_M03_interconnect_PENABLE), 
         .apb_m02_pready_mstr_i(apb0_inst_APB_M02_interconnect_PREADY), .apb_m02_pslverr_mstr_i(apb0_inst_APB_M02_interconnect_PSLVERR), 
         .apb_m02_psel_mstr_o(apb0_inst_APB_M02_interconnect_PSELx), .apb_m02_pwrite_mstr_o(apb0_inst_APB_M02_interconnect_PWRITE), 
         .apb_m02_penable_mstr_o(apb0_inst_APB_M02_interconnect_PENABLE), 
         .apb_m01_pready_mstr_i(apb0_inst_APB_M01_interconnect_PREADY), .apb_m01_pslverr_mstr_i(apb0_inst_APB_M01_interconnect_PSLVERR), 
         .apb_m01_psel_mstr_o(apb0_inst_APB_M01_interconnect_PSELx), .apb_m01_pwrite_mstr_o(apb0_inst_APB_M01_interconnect_PWRITE), 
         .apb_m01_penable_mstr_o(apb0_inst_APB_M01_interconnect_PENABLE), 
         .apb_s00_psel_slv_i(ahbl2apb0_inst_APB_M0_interconnect_PSELx), .apb_s00_pwrite_slv_i(ahbl2apb0_inst_APB_M0_interconnect_PWRITE), 
         .apb_s00_penable_slv_i(ahbl2apb0_inst_APB_M0_interconnect_PENABLE), 
         .apb_s00_pready_slv_o(ahbl2apb0_inst_APB_M0_interconnect_PREADY), 
         .apb_s00_pslverr_slv_o(ahbl2apb0_inst_APB_M0_interconnect_PSLVERR), 
         .apb_m00_pready_mstr_i(apb0_inst_APB_M00_interconnect_PREADY), .apb_m00_pslverr_mstr_i(apb0_inst_APB_M00_interconnect_PSLVERR), 
         .apb_m00_psel_mstr_o(apb0_inst_APB_M00_interconnect_PSELx), .apb_m00_pwrite_mstr_o(apb0_inst_APB_M00_interconnect_PWRITE), 
         .apb_m00_penable_mstr_o(apb0_inst_APB_M00_interconnect_PENABLE));
    defparam apb0_inst.FULL_DECODE_EN = 1;
    defparam apb0_inst.S0_ADDR_RANGE = 32'h00000400;
    defparam apb0_inst.S0_BASE_ADDR = 32'h00040400;
    defparam apb0_inst.S1_ADDR_RANGE = 32'h00000400;
    defparam apb0_inst.S1_BASE_ADDR = 32'h00040000;
    defparam apb0_inst.S2_ADDR_RANGE = 32'h00000400;
    defparam apb0_inst.S2_BASE_ADDR = 32'h00040800;
    defparam apb0_inst.S3_ADDR_RANGE = 32'h00000400;
    defparam apb0_inst.S3_BASE_ADDR = 32'h00040C00;
    defparam apb0_inst.S4_ADDR_RANGE = 32'h00000400;
    defparam apb0_inst.S4_BASE_ADDR = 32'h00041400;
    cpu0 cpu0_inst (.ahbl_m_instr_haddr_o({cpu0_inst_AHBL_M0_INSTR_interconnect_HADDR}), 
         .ahbl_m_instr_hsize_o({cpu0_inst_AHBL_M0_INSTR_interconnect_HSIZE}), 
         .ahbl_m_instr_hburst_o({cpu0_inst_AHBL_M0_INSTR_interconnect_HBURST}), 
         .ahbl_m_instr_hprot_o({cpu0_inst_AHBL_M0_INSTR_interconnect_HPROT}), 
         .ahbl_m_instr_htrans_o({cpu0_inst_AHBL_M0_INSTR_interconnect_HTRANS}), 
         .ahbl_m_instr_hwdata_o({cpu0_inst_AHBL_M0_INSTR_interconnect_HWDATA}), 
         .ahbl_m_instr_hrdata_i({cpu0_inst_AHBL_M0_INSTR_interconnect_HRDATA}), 
         .ahbl_m_data_haddr_o({cpu0_inst_AHBL_M1_DATA_interconnect_HADDR}), 
         .ahbl_m_data_hsize_o({cpu0_inst_AHBL_M1_DATA_interconnect_HSIZE}), 
         .ahbl_m_data_hburst_o({cpu0_inst_AHBL_M1_DATA_interconnect_HBURST}), 
         .ahbl_m_data_hprot_o({cpu0_inst_AHBL_M1_DATA_interconnect_HPROT}), 
         .ahbl_m_data_htrans_o({cpu0_inst_AHBL_M1_DATA_interconnect_HTRANS}), 
         .ahbl_m_data_hwdata_o({cpu0_inst_AHBL_M1_DATA_interconnect_HWDATA}), 
         .ahbl_m_data_hrdata_i({cpu0_inst_AHBL_M1_DATA_interconnect_HRDATA}), 
         .clk_i(clk_i), .rst_n_i(rstn_i), .system_resetn_o(system_reset_n_o), 
         .irq4_i(lscc_spim1_inst_INTR_interconnect_IRQ), .irq3_i(lscc_i2cm1_inst_INTR_interconnect_IRQ), 
         .irq2_i(gpio0_inst_INTR_interconnect_IRQ), .irq1_i(cpu0_inst_IRQ_S1_interface_irq1_i_port), 
         .irq0_i(uart0_inst_INT_M0_interconnect_IRQ), .ahbl_m_instr_hwrite_o(cpu0_inst_AHBL_M0_INSTR_interconnect_HWRITE), 
         .ahbl_m_instr_hmastlock_o(cpu0_inst_AHBL_M0_INSTR_interconnect_HMASTLOCK), 
         .ahbl_m_instr_hready_i(cpu0_inst_AHBL_M0_INSTR_interconnect_HREADYOUT), 
         .ahbl_m_instr_hresp_i(cpu0_inst_AHBL_M0_INSTR_interconnect_HRESP), 
         .ahbl_m_data_hwrite_o(cpu0_inst_AHBL_M1_DATA_interconnect_HWRITE), 
         .ahbl_m_data_hmastlock_o(cpu0_inst_AHBL_M1_DATA_interconnect_HMASTLOCK), 
         .ahbl_m_data_hready_i(cpu0_inst_AHBL_M1_DATA_interconnect_HREADYOUT), 
         .ahbl_m_data_hresp_i(cpu0_inst_AHBL_M1_DATA_interconnect_HRESP));
    defparam cpu0_inst.DCACHE_ENABLE = 0;
    defparam cpu0_inst.DCACHE_RANGE_HIGH = 32'h00000000;
    defparam cpu0_inst.DCACHE_RANGE_LOW = 32'hFFFFFFFF;
    defparam cpu0_inst.ICACHE_ENABLE = 0;
    defparam cpu0_inst.ICACHE_RANGE_HIGH = 32'h00000000;
    defparam cpu0_inst.ICACHE_RANGE_LOW = 32'hFFFFFFFF;
    gpio0 gpio0_inst (.gpio_io({gpio_0_z}), .apb_paddr_i({apb0_inst_APB_M01_interconnect_PADDR[5:0]}), 
          .apb_pwdata_i({apb0_inst_APB_M01_interconnect_PWDATA}), .apb_prdata_o({apb0_inst_APB_M01_interconnect_PRDATA}), 
          .clk_i(clk_i), .resetn_i(system_reset_n_o), .apb_penable_i(apb0_inst_APB_M01_interconnect_PENABLE), 
          .apb_psel_i(apb0_inst_APB_M01_interconnect_PSELx), .apb_pwrite_i(apb0_inst_APB_M01_interconnect_PWRITE), 
          .apb_pslverr_o(apb0_inst_APB_M01_interconnect_PSLVERR), .apb_pready_o(apb0_inst_APB_M01_interconnect_PREADY), 
          .int_o(gpio0_inst_INTR_interconnect_IRQ));
    lscc_i2cm1 lscc_i2cm1_inst (.apb_paddr_i({apb0_inst_APB_M03_interconnect_PADDR[5:0]}), 
            .apb_pwdata_i({apb0_inst_APB_M03_interconnect_PWDATA}), .apb_prdata_o({apb0_inst_APB_M03_interconnect_PRDATA}), 
            .scl_io(i2cm0_scl), .sda_io(i2cm0_sda), .clk_i(clk_i), .rst_n_i(system_reset_n_o), 
            .int_o(lscc_i2cm1_inst_INTR_interconnect_IRQ), .apb_penable_i(apb0_inst_APB_M03_interconnect_PENABLE), 
            .apb_psel_i(apb0_inst_APB_M03_interconnect_PSELx), .apb_pwrite_i(apb0_inst_APB_M03_interconnect_PWRITE), 
            .apb_pready_o(apb0_inst_APB_M03_interconnect_PREADY), .apb_pslverr_o(apb0_inst_APB_M03_interconnect_PSLVERR));
    lscc_spim1 lscc_spim1_inst (.ssn_o({lscc_spim1_inst_ssn_o_netbus}), .apb_paddr_i({apb0_inst_APB_M04_interconnect_PADDR[5:0]}), 
            .apb_pwdata_i({apb0_inst_APB_M04_interconnect_PWDATA}), .apb_prdata_o({apb0_inst_APB_M04_interconnect_PRDATA}), 
            .miso_i(spim0_miso_i), .sclk_o(spim0_sclk_o), .mosi_o(spim0_mosi_o), 
            .clk_i(clk_i), .rst_n_i(system_reset_n_o), .int_o(lscc_spim1_inst_INTR_interconnect_IRQ), 
            .apb_penable_i(apb0_inst_APB_M04_interconnect_PENABLE), .apb_psel_i(apb0_inst_APB_M04_interconnect_PSELx), 
            .apb_pwrite_i(apb0_inst_APB_M04_interconnect_PWRITE), .apb_pready_o(apb0_inst_APB_M04_interconnect_PREADY), 
            .apb_pslverr_o(apb0_inst_APB_M04_interconnect_PSLVERR));
    sysmem0 sysmem0_inst (.ahbl_s0_haddr_i({cpu0_inst_AHBL_M0_INSTR_interconnect_HADDR}), 
            .ahbl_s0_hburst_i({cpu0_inst_AHBL_M0_INSTR_interconnect_HBURST}), 
            .ahbl_s0_hsize_i({cpu0_inst_AHBL_M0_INSTR_interconnect_HSIZE}), 
            .ahbl_s0_hprot_i({cpu0_inst_AHBL_M0_INSTR_interconnect_HPROT}), 
            .ahbl_s0_htrans_i({cpu0_inst_AHBL_M0_INSTR_interconnect_HTRANS}), 
            .ahbl_s0_hwdata_i({cpu0_inst_AHBL_M0_INSTR_interconnect_HWDATA}), 
            .ahbl_s0_hrdata_o({cpu0_inst_AHBL_M0_INSTR_interconnect_HRDATA}), 
            .ahbl_s1_haddr_i({ahbl0_inst_AHBL_M00_interconnect_HADDR}), .ahbl_s1_hburst_i({ahbl0_inst_AHBL_M00_interconnect_HBURST}), 
            .ahbl_s1_hsize_i({ahbl0_inst_AHBL_M00_interconnect_HSIZE}), .ahbl_s1_hprot_i({ahbl0_inst_AHBL_M00_interconnect_HPROT}), 
            .ahbl_s1_htrans_i({ahbl0_inst_AHBL_M00_interconnect_HTRANS}), 
            .ahbl_s1_hwdata_i({ahbl0_inst_AHBL_M00_interconnect_HWDATA}), 
            .ahbl_s1_hrdata_o({ahbl0_inst_AHBL_M00_interconnect_HRDATA}), 
            .ahbl_hclk_i(clk_i), .ahbl_hresetn_i(system_reset_n_o), .ahbl_s0_hsel_i(1'b1), 
            .ahbl_s0_hready_i(cpu0_inst_AHBL_M0_INSTR_interconnect_HREADYOUT), 
            .ahbl_s0_hmastlock_i(cpu0_inst_AHBL_M0_INSTR_interconnect_HMASTLOCK), 
            .ahbl_s0_hwrite_i(cpu0_inst_AHBL_M0_INSTR_interconnect_HWRITE), 
            .ahbl_s0_hreadyout_o(cpu0_inst_AHBL_M0_INSTR_interconnect_HREADYOUT), 
            .ahbl_s0_hresp_o(cpu0_inst_AHBL_M0_INSTR_interconnect_HRESP), 
            .ahbl_s1_hsel_i(ahbl0_inst_AHBL_M00_interconnect_HSELx), .ahbl_s1_hready_i(ahbl0_inst_AHBL_M00_interconnect_HREADY), 
            .ahbl_s1_hmastlock_i(ahbl0_inst_AHBL_M00_interconnect_HMASTLOCK), 
            .ahbl_s1_hwrite_i(ahbl0_inst_AHBL_M00_interconnect_HWRITE), .ahbl_s1_hreadyout_o(ahbl0_inst_AHBL_M00_interconnect_HREADYOUT), 
            .ahbl_s1_hresp_o(ahbl0_inst_AHBL_M00_interconnect_HRESP));
    defparam sysmem0_inst.MEM_ID = "sysmem0";
    u23_config_intf_feedthrough u23_config_intf_feedthrough_inst (.ahbl_haddr_slv_i({ahbl0_inst_AHBL_M02_interconnect_HADDR[16:0]}), 
            .ahbl_hburst_slv_i({ahbl0_inst_AHBL_M02_interconnect_HBURST}), 
            .ahbl_hsize_slv_i({ahbl0_inst_AHBL_M02_interconnect_HSIZE}), .ahbl_hprot_slv_i({ahbl0_inst_AHBL_M02_interconnect_HPROT}), 
            .ahbl_htrans_slv_i({ahbl0_inst_AHBL_M02_interconnect_HTRANS}), 
            .ahbl_hwdata_slv_i({ahbl0_inst_AHBL_M02_interconnect_HWDATA}), 
            .ahbl_hrdata_slv_o({ahbl0_inst_AHBL_M02_interconnect_HRDATA}), 
            .ahbl_haddr_mstr_o({u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_haddr_mstr_o_portbus}), 
            .ahbl_hburst_mstr_o({u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hburst_mstr_o_portbus}), 
            .ahbl_hsize_mstr_o({u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hsize_mstr_o_portbus}), 
            .ahbl_hprot_mstr_o({u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hprot_mstr_o_portbus}), 
            .ahbl_htrans_mstr_o({u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_htrans_mstr_o_portbus}), 
            .ahbl_hwdata_mstr_o({u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hwdata_mstr_o_portbus}), 
            .ahbl_hrdata_mstr_i({u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hrdata_mstr_i_portbus}), 
            .ahbl_hsel_slv_i(ahbl0_inst_AHBL_M02_interconnect_HSELx), .ahbl_hmastlock_slv_i(ahbl0_inst_AHBL_M02_interconnect_HMASTLOCK), 
            .ahbl_hwrite_slv_i(ahbl0_inst_AHBL_M02_interconnect_HWRITE), .ahbl_hready_slv_i(ahbl0_inst_AHBL_M02_interconnect_HREADY), 
            .ahbl_hreadyout_slv_o(ahbl0_inst_AHBL_M02_interconnect_HREADYOUT), 
            .ahbl_hresp_slv_o(ahbl0_inst_AHBL_M02_interconnect_HRESP), .ahbl_hsel_mstr_o(u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hsel_mstr_o_port), 
            .ahbl_hmastlock_mstr_o(u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hmastlock_mstr_o_port), 
            .ahbl_hwrite_mstr_o(u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hwrite_mstr_o_port), 
            .ahbl_hready_mstr_o(u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hready_mstr_o_port), 
            .ahbl_hready_mstr_i(u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hready_mstr_i_port), 
            .ahbl_hresp_mstr_i(u23_config_intf_feedthrough_inst_AHBL_M0_interface_ahbl_hresp_mstr_i_port));
    uart0 uart0_inst (.apb_paddr_i({apb0_inst_APB_M00_interconnect_PADDR[5:0]}), 
          .apb_pwdata_i({apb0_inst_APB_M00_interconnect_PWDATA}), .apb_prdata_o({apb0_inst_APB_M00_interconnect_PRDATA}), 
          .rxd_i(uart_rxd_i), .txd_o(uart_txd_o), .clk_i(clk_i), .rst_n_i(system_reset_n_o), 
          .int_o(uart0_inst_INT_M0_interconnect_IRQ), .apb_penable_i(apb0_inst_APB_M00_interconnect_PENABLE), 
          .apb_psel_i(apb0_inst_APB_M00_interconnect_PSELx), .apb_pwrite_i(apb0_inst_APB_M00_interconnect_PWRITE), 
          .apb_pready_o(apb0_inst_APB_M00_interconnect_PREADY), .apb_pslverr_o(apb0_inst_APB_M00_interconnect_PSLVERR));
    
endmodule

