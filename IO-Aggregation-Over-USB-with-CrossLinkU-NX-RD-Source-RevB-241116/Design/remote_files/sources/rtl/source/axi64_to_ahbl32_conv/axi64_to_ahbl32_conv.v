// >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ------------------------------------------------------------------
// Copyright (c) 2019-2023 by Lattice Semiconductor Corporation
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
// Verific Verilog Description of module axi64_to_ahbl32_conv
//
module axi64_to_ahbl32_conv (axi4_interconnect_inst_AXI_S00_interface_axi_S00_araddr_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arburst_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arcache_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arid_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arlen_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arprot_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arqos_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arregion_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arsize_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_aruser_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awaddr_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awburst_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awcache_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awid_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awlen_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awprot_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awqos_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awregion_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awsize_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awuser_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_bid_o_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_bresp_o_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_buser_o_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_rdata_o_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_rid_o_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_rresp_o_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_ruser_o_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_wdata_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_wstrb_i_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_wuser_i_portbus, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_addr_o_portbus, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_burst_o_portbus, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_prot_o_portbus, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_rdata_i_portbus, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_size_o_portbus, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_trans_o_portbus, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_wdata_o_portbus, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arlock_i_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arready_o_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_arvalid_i_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awlock_i_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awready_o_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_awvalid_i_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_bready_i_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_bvalid_o_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_rlast_o_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_rready_i_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_rvalid_o_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_wlast_i_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_wready_o_port, 
            axi4_interconnect_inst_AXI_S00_interface_axi_S00_wvalid_i_port, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_mastlock_o_port, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_ready_i_port, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_ready_o_port, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_resp_i_port, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_sel_o_port, 
            axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_write_o_port, 
            clk_i, rstn_i);
    input [31:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_araddr_i_portbus;
    input [1:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_arburst_i_portbus;
    input [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_arcache_i_portbus;
    input [5:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_arid_i_portbus;
    input [7:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_arlen_i_portbus;
    input [2:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_arprot_i_portbus;
    input [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_arqos_i_portbus;
    input [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_arregion_i_portbus;
    input [2:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_arsize_i_portbus;
    input [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_aruser_i_portbus;
    input [31:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awaddr_i_portbus;
    input [1:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awburst_i_portbus;
    input [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awcache_i_portbus;
    input [5:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awid_i_portbus;
    input [7:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awlen_i_portbus;
    input [2:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awprot_i_portbus;
    input [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awqos_i_portbus;
    input [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awregion_i_portbus;
    input [2:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awsize_i_portbus;
    input [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_awuser_i_portbus;
    output [5:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_bid_o_portbus;
    output [1:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_bresp_o_portbus;
    output [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_buser_o_portbus;
    output [63:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_rdata_o_portbus;
    output [5:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_rid_o_portbus;
    output [1:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_rresp_o_portbus;
    output [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_ruser_o_portbus;
    input [63:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_wdata_i_portbus;
    input [7:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_wstrb_i_portbus;
    input [3:0]axi4_interconnect_inst_AXI_S00_interface_axi_S00_wuser_i_portbus;
    output [31:0]axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_addr_o_portbus;
    output [2:0]axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_burst_o_portbus;
    output [3:0]axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_prot_o_portbus;
    input [31:0]axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_rdata_i_portbus;
    output [2:0]axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_size_o_portbus;
    output [1:0]axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_trans_o_portbus;
    output [31:0]axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_wdata_o_portbus;
    input axi4_interconnect_inst_AXI_S00_interface_axi_S00_arlock_i_port;
    output axi4_interconnect_inst_AXI_S00_interface_axi_S00_arready_o_port;
    input axi4_interconnect_inst_AXI_S00_interface_axi_S00_arvalid_i_port;
    input axi4_interconnect_inst_AXI_S00_interface_axi_S00_awlock_i_port;
    output axi4_interconnect_inst_AXI_S00_interface_axi_S00_awready_o_port;
    input axi4_interconnect_inst_AXI_S00_interface_axi_S00_awvalid_i_port;
    input axi4_interconnect_inst_AXI_S00_interface_axi_S00_bready_i_port;
    output axi4_interconnect_inst_AXI_S00_interface_axi_S00_bvalid_o_port;
    output axi4_interconnect_inst_AXI_S00_interface_axi_S00_rlast_o_port;
    input axi4_interconnect_inst_AXI_S00_interface_axi_S00_rready_i_port;
    output axi4_interconnect_inst_AXI_S00_interface_axi_S00_rvalid_o_port;
    input axi4_interconnect_inst_AXI_S00_interface_axi_S00_wlast_i_port;
    output axi4_interconnect_inst_AXI_S00_interface_axi_S00_wready_o_port;
    input axi4_interconnect_inst_AXI_S00_interface_axi_S00_wvalid_i_port;
    output axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_mastlock_o_port;
    input axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_ready_i_port;
    output axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_ready_o_port;
    input axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_resp_i_port;
    output axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_sel_o_port;
    output axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_write_o_port;
    input clk_i;
    input rstn_i;
    
    wire [31:0]axi4_interconnect_inst_AXI_M00_interconnect_ARADDR;
    wire [1:0]axi4_interconnect_inst_AXI_M00_interconnect_ARBURST;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_ARCACHE;
    wire [10:0]axi4_interconnect_inst_AXI_M00_interconnect_ARID;
    wire [7:0]axi4_interconnect_inst_AXI_M00_interconnect_ARLEN;
    wire [2:0]axi4_interconnect_inst_AXI_M00_interconnect_ARPROT;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_ARQOS;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_ARREGION;
    wire [2:0]axi4_interconnect_inst_AXI_M00_interconnect_ARSIZE;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_ARUSER;
    wire [31:0]axi4_interconnect_inst_AXI_M00_interconnect_AWADDR;
    wire [1:0]axi4_interconnect_inst_AXI_M00_interconnect_AWBURST;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_AWCACHE;
    wire [10:0]axi4_interconnect_inst_AXI_M00_interconnect_AWID;
    wire [7:0]axi4_interconnect_inst_AXI_M00_interconnect_AWLEN;
    wire [2:0]axi4_interconnect_inst_AXI_M00_interconnect_AWPROT;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_AWQOS;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_AWREGION;
    wire [2:0]axi4_interconnect_inst_AXI_M00_interconnect_AWSIZE;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_AWUSER;
    wire [10:0]axi4_interconnect_inst_AXI_M00_interconnect_BID;
    wire [1:0]axi4_interconnect_inst_AXI_M00_interconnect_BRESP;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_BUSER;
    wire [31:0]axi4_interconnect_inst_AXI_M00_interconnect_RDATA;
    wire [10:0]axi4_interconnect_inst_AXI_M00_interconnect_RID;
    wire [1:0]axi4_interconnect_inst_AXI_M00_interconnect_RRESP;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_RUSER;
    wire [31:0]axi4_interconnect_inst_AXI_M00_interconnect_WDATA;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_WSTRB;
    wire [3:0]axi4_interconnect_inst_AXI_M00_interconnect_WUSER;
    
    wire axi4_interconnect_inst_AXI_M00_interconnect_ARLOCK, axi4_interconnect_inst_AXI_M00_interconnect_ARREADY, 
        axi4_interconnect_inst_AXI_M00_interconnect_ARVALID, axi4_interconnect_inst_AXI_M00_interconnect_AWLOCK, 
        axi4_interconnect_inst_AXI_M00_interconnect_AWREADY, axi4_interconnect_inst_AXI_M00_interconnect_AWVALID, 
        axi4_interconnect_inst_AXI_M00_interconnect_BREADY, axi4_interconnect_inst_AXI_M00_interconnect_BVALID, 
        axi4_interconnect_inst_AXI_M00_interconnect_RLAST, axi4_interconnect_inst_AXI_M00_interconnect_RREADY, 
        axi4_interconnect_inst_AXI_M00_interconnect_RVALID, axi4_interconnect_inst_AXI_M00_interconnect_WLAST, 
        axi4_interconnect_inst_AXI_M00_interconnect_WREADY, axi4_interconnect_inst_AXI_M00_interconnect_WVALID;
    
    
    axi4_interconnect axi4_interconnect_inst (.axi_M00_araddr_o({axi4_interconnect_inst_AXI_M00_interconnect_ARADDR}), 
            .axi_M00_arburst_o({axi4_interconnect_inst_AXI_M00_interconnect_ARBURST}), 
            .axi_M00_arcache_o({axi4_interconnect_inst_AXI_M00_interconnect_ARCACHE}), 
            .axi_M00_arid_o({axi4_interconnect_inst_AXI_M00_interconnect_ARID}), 
            .axi_M00_arlen_o({axi4_interconnect_inst_AXI_M00_interconnect_ARLEN}), 
            .axi_M00_arprot_o({axi4_interconnect_inst_AXI_M00_interconnect_ARPROT}), 
            .axi_M00_arqos_o({axi4_interconnect_inst_AXI_M00_interconnect_ARQOS}), 
            .axi_M00_arregion_o({axi4_interconnect_inst_AXI_M00_interconnect_ARREGION}), 
            .axi_M00_arsize_o({axi4_interconnect_inst_AXI_M00_interconnect_ARSIZE}), 
            .axi_M00_aruser_o({axi4_interconnect_inst_AXI_M00_interconnect_ARUSER}), 
            .axi_M00_awaddr_o({axi4_interconnect_inst_AXI_M00_interconnect_AWADDR}), 
            .axi_M00_awburst_o({axi4_interconnect_inst_AXI_M00_interconnect_AWBURST}), 
            .axi_M00_awcache_o({axi4_interconnect_inst_AXI_M00_interconnect_AWCACHE}), 
            .axi_M00_awid_o({axi4_interconnect_inst_AXI_M00_interconnect_AWID}), 
            .axi_M00_awlen_o({axi4_interconnect_inst_AXI_M00_interconnect_AWLEN}), 
            .axi_M00_awprot_o({axi4_interconnect_inst_AXI_M00_interconnect_AWPROT}), 
            .axi_M00_awqos_o({axi4_interconnect_inst_AXI_M00_interconnect_AWQOS}), 
            .axi_M00_awregion_o({axi4_interconnect_inst_AXI_M00_interconnect_AWREGION}), 
            .axi_M00_awsize_o({axi4_interconnect_inst_AXI_M00_interconnect_AWSIZE}), 
            .axi_M00_awuser_o({axi4_interconnect_inst_AXI_M00_interconnect_AWUSER}), 
            .axi_M00_bid_i({axi4_interconnect_inst_AXI_M00_interconnect_BID}), 
            .axi_M00_bresp_i({axi4_interconnect_inst_AXI_M00_interconnect_BRESP}), 
            .axi_M00_buser_i({axi4_interconnect_inst_AXI_M00_interconnect_BUSER}), 
            .axi_M00_rdata_i({axi4_interconnect_inst_AXI_M00_interconnect_RDATA}), 
            .axi_M00_rid_i({axi4_interconnect_inst_AXI_M00_interconnect_RID}), 
            .axi_M00_rresp_i({axi4_interconnect_inst_AXI_M00_interconnect_RRESP}), 
            .axi_M00_ruser_i({axi4_interconnect_inst_AXI_M00_interconnect_RUSER}), 
            .axi_M00_wdata_o({axi4_interconnect_inst_AXI_M00_interconnect_WDATA}), 
            .axi_M00_wstrb_o({axi4_interconnect_inst_AXI_M00_interconnect_WSTRB}), 
            .axi_M00_wuser_o({axi4_interconnect_inst_AXI_M00_interconnect_WUSER}), 
            .axi_S00_araddr_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_araddr_i_portbus}), 
            .axi_S00_arburst_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_arburst_i_portbus}), 
            .axi_S00_arcache_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_arcache_i_portbus}), 
            .axi_S00_arid_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_arid_i_portbus}), 
            .axi_S00_arlen_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_arlen_i_portbus}), 
            .axi_S00_arprot_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_arprot_i_portbus}), 
            .axi_S00_arqos_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_arqos_i_portbus}), 
            .axi_S00_arregion_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_arregion_i_portbus}), 
            .axi_S00_arsize_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_arsize_i_portbus}), 
            .axi_S00_aruser_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_aruser_i_portbus}), 
            .axi_S00_awaddr_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awaddr_i_portbus}), 
            .axi_S00_awburst_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awburst_i_portbus}), 
            .axi_S00_awcache_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awcache_i_portbus}), 
            .axi_S00_awid_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awid_i_portbus}), 
            .axi_S00_awlen_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awlen_i_portbus}), 
            .axi_S00_awprot_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awprot_i_portbus}), 
            .axi_S00_awqos_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awqos_i_portbus}), 
            .axi_S00_awregion_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awregion_i_portbus}), 
            .axi_S00_awsize_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awsize_i_portbus}), 
            .axi_S00_awuser_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_awuser_i_portbus}), 
            .axi_S00_bid_o({axi4_interconnect_inst_AXI_S00_interface_axi_S00_bid_o_portbus}), 
            .axi_S00_bresp_o({axi4_interconnect_inst_AXI_S00_interface_axi_S00_bresp_o_portbus}), 
            .axi_S00_buser_o({axi4_interconnect_inst_AXI_S00_interface_axi_S00_buser_o_portbus}), 
            .axi_S00_rdata_o({axi4_interconnect_inst_AXI_S00_interface_axi_S00_rdata_o_portbus}), 
            .axi_S00_rid_o({axi4_interconnect_inst_AXI_S00_interface_axi_S00_rid_o_portbus}), 
            .axi_S00_rresp_o({axi4_interconnect_inst_AXI_S00_interface_axi_S00_rresp_o_portbus}), 
            .axi_S00_ruser_o({axi4_interconnect_inst_AXI_S00_interface_axi_S00_ruser_o_portbus}), 
            .axi_S00_wdata_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_wdata_i_portbus}), 
            .axi_S00_wstrb_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_wstrb_i_portbus}), 
            .axi_S00_wuser_i({axi4_interconnect_inst_AXI_S00_interface_axi_S00_wuser_i_portbus}), 
            .axi_M00_arlock_o(axi4_interconnect_inst_AXI_M00_interconnect_ARLOCK), 
            .axi_M00_arready_i(axi4_interconnect_inst_AXI_M00_interconnect_ARREADY), 
            .axi_M00_arvalid_o(axi4_interconnect_inst_AXI_M00_interconnect_ARVALID), 
            .axi_M00_awlock_o(axi4_interconnect_inst_AXI_M00_interconnect_AWLOCK), 
            .axi_M00_awready_i(axi4_interconnect_inst_AXI_M00_interconnect_AWREADY), 
            .axi_M00_awvalid_o(axi4_interconnect_inst_AXI_M00_interconnect_AWVALID), 
            .axi_M00_bready_o(axi4_interconnect_inst_AXI_M00_interconnect_BREADY), 
            .axi_M00_bvalid_i(axi4_interconnect_inst_AXI_M00_interconnect_BVALID), 
            .axi_M00_rlast_i(axi4_interconnect_inst_AXI_M00_interconnect_RLAST), 
            .axi_M00_rready_o(axi4_interconnect_inst_AXI_M00_interconnect_RREADY), 
            .axi_M00_rvalid_i(axi4_interconnect_inst_AXI_M00_interconnect_RVALID), 
            .axi_M00_wlast_o(axi4_interconnect_inst_AXI_M00_interconnect_WLAST), 
            .axi_M00_wready_i(axi4_interconnect_inst_AXI_M00_interconnect_WREADY), 
            .axi_M00_wvalid_o(axi4_interconnect_inst_AXI_M00_interconnect_WVALID), 
            .axi_S00_arlock_i(axi4_interconnect_inst_AXI_S00_interface_axi_S00_arlock_i_port), 
            .axi_S00_arready_o(axi4_interconnect_inst_AXI_S00_interface_axi_S00_arready_o_port), 
            .axi_S00_arvalid_i(axi4_interconnect_inst_AXI_S00_interface_axi_S00_arvalid_i_port), 
            .axi_S00_awlock_i(axi4_interconnect_inst_AXI_S00_interface_axi_S00_awlock_i_port), 
            .axi_S00_awready_o(axi4_interconnect_inst_AXI_S00_interface_axi_S00_awready_o_port), 
            .axi_S00_awvalid_i(axi4_interconnect_inst_AXI_S00_interface_axi_S00_awvalid_i_port), 
            .axi_S00_bready_i(axi4_interconnect_inst_AXI_S00_interface_axi_S00_bready_i_port), 
            .axi_S00_bvalid_o(axi4_interconnect_inst_AXI_S00_interface_axi_S00_bvalid_o_port), 
            .axi_S00_rlast_o(axi4_interconnect_inst_AXI_S00_interface_axi_S00_rlast_o_port), 
            .axi_S00_rready_i(axi4_interconnect_inst_AXI_S00_interface_axi_S00_rready_i_port), 
            .axi_S00_rvalid_o(axi4_interconnect_inst_AXI_S00_interface_axi_S00_rvalid_o_port), 
            .axi_S00_wlast_i(axi4_interconnect_inst_AXI_S00_interface_axi_S00_wlast_i_port), 
            .axi_S00_wready_o(axi4_interconnect_inst_AXI_S00_interface_axi_S00_wready_o_port), 
            .axi_S00_wvalid_i(axi4_interconnect_inst_AXI_S00_interface_axi_S00_wvalid_i_port), 
            .axi_aclk_i(clk_i), .axi_aresetn_i(rstn_i));
    defparam axi4_interconnect_inst.EXT_MAS_AXI_ADDR_WIDTH = 7'd32;
    defparam axi4_interconnect_inst.EXT_SLV_AXI_ADDR_WIDTH = {7'd32,7'd32};
    defparam axi4_interconnect_inst.EXT_SLV_FRAGMENT_BASE_ADDR = {64'h00000000};
    defparam axi4_interconnect_inst.EXT_SLV_FRAGMENT_CNT = {4'd1};
    defparam axi4_interconnect_inst.EXT_SLV_FRAGMENT_END_ADDR = {64'h0000FFFF};
    defparam axi4_interconnect_inst.EXT_SLV_MAX_FRAGMENT_CNT = 1;
    defparam axi4_interconnect_inst.TOTAL_EXTMAS_CNT = 1;
    axi4_to_ahbl_bridge axi4_to_ahbl_bridge_inst (.ahb_mas_addr_o({axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_addr_o_portbus}), 
            .ahb_mas_burst_o({axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_burst_o_portbus}), 
            .ahb_mas_prot_o({axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_prot_o_portbus}), 
            .ahb_mas_rdata_i({axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_rdata_i_portbus}), 
            .ahb_mas_size_o({axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_size_o_portbus}), 
            .ahb_mas_trans_o({axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_trans_o_portbus}), 
            .ahb_mas_wdata_o({axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_wdata_o_portbus}), 
            .axi_slv_araddr_i({axi4_interconnect_inst_AXI_M00_interconnect_ARADDR}), 
            .axi_slv_arburst_i({axi4_interconnect_inst_AXI_M00_interconnect_ARBURST}), 
            .axi_slv_arcache_i({axi4_interconnect_inst_AXI_M00_interconnect_ARCACHE}), 
            .axi_slv_arid_i({axi4_interconnect_inst_AXI_M00_interconnect_ARID}), 
            .axi_slv_arlen_i({axi4_interconnect_inst_AXI_M00_interconnect_ARLEN}), 
            .axi_slv_arprot_i({axi4_interconnect_inst_AXI_M00_interconnect_ARPROT}), 
            .axi_slv_arqos_i({axi4_interconnect_inst_AXI_M00_interconnect_ARQOS}), 
            .axi_slv_arregion_i({axi4_interconnect_inst_AXI_M00_interconnect_ARREGION}), 
            .axi_slv_arsize_i({axi4_interconnect_inst_AXI_M00_interconnect_ARSIZE}), 
            .axi_slv_aruser_i({axi4_interconnect_inst_AXI_M00_interconnect_ARUSER}), 
            .axi_slv_awaddr_i({axi4_interconnect_inst_AXI_M00_interconnect_AWADDR}), 
            .axi_slv_awburst_i({axi4_interconnect_inst_AXI_M00_interconnect_AWBURST}), 
            .axi_slv_awcache_i({axi4_interconnect_inst_AXI_M00_interconnect_AWCACHE}), 
            .axi_slv_awid_i({axi4_interconnect_inst_AXI_M00_interconnect_AWID}), 
            .axi_slv_awlen_i({axi4_interconnect_inst_AXI_M00_interconnect_AWLEN}), 
            .axi_slv_awprot_i({axi4_interconnect_inst_AXI_M00_interconnect_AWPROT}), 
            .axi_slv_awqos_i({axi4_interconnect_inst_AXI_M00_interconnect_AWQOS}), 
            .axi_slv_awregion_i({axi4_interconnect_inst_AXI_M00_interconnect_AWREGION}), 
            .axi_slv_awsize_i({axi4_interconnect_inst_AXI_M00_interconnect_AWSIZE}), 
            .axi_slv_awuser_i({axi4_interconnect_inst_AXI_M00_interconnect_AWUSER}), 
            .axi_slv_bid_o({axi4_interconnect_inst_AXI_M00_interconnect_BID}), 
            .axi_slv_bresp_o({axi4_interconnect_inst_AXI_M00_interconnect_BRESP}), 
            .axi_slv_buser_o({axi4_interconnect_inst_AXI_M00_interconnect_BUSER}), 
            .axi_slv_rdata_o({axi4_interconnect_inst_AXI_M00_interconnect_RDATA}), 
            .axi_slv_rid_o({axi4_interconnect_inst_AXI_M00_interconnect_RID}), 
            .axi_slv_rresp_o({axi4_interconnect_inst_AXI_M00_interconnect_RRESP}), 
            .axi_slv_ruser_o({axi4_interconnect_inst_AXI_M00_interconnect_RUSER}), 
            .axi_slv_wdata_i({axi4_interconnect_inst_AXI_M00_interconnect_WDATA}), 
            .axi_slv_wstrb_i({axi4_interconnect_inst_AXI_M00_interconnect_WSTRB}), 
            .axi_slv_wuser_i({axi4_interconnect_inst_AXI_M00_interconnect_WUSER}), 
            .aclk_i(clk_i), .ahb_mas_mastlock_o(axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_mastlock_o_port), 
            .ahb_mas_ready_i(axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_ready_i_port), 
            .ahb_mas_ready_o(axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_ready_o_port), 
            .ahb_mas_resp_i(axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_resp_i_port), 
            .ahb_mas_sel_o(axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_sel_o_port), 
            .ahb_mas_write_o(axi4_to_ahbl_bridge_inst_AHBL_M_interface_ahb_mas_write_o_port), 
            .aresetn_i(rstn_i), .axi_slv_arlock_i(axi4_interconnect_inst_AXI_M00_interconnect_ARLOCK), 
            .axi_slv_arready_o(axi4_interconnect_inst_AXI_M00_interconnect_ARREADY), 
            .axi_slv_arvalid_i(axi4_interconnect_inst_AXI_M00_interconnect_ARVALID), 
            .axi_slv_awlock_i(axi4_interconnect_inst_AXI_M00_interconnect_AWLOCK), 
            .axi_slv_awready_o(axi4_interconnect_inst_AXI_M00_interconnect_AWREADY), 
            .axi_slv_awvalid_i(axi4_interconnect_inst_AXI_M00_interconnect_AWVALID), 
            .axi_slv_bready_i(axi4_interconnect_inst_AXI_M00_interconnect_BREADY), 
            .axi_slv_bvalid_o(axi4_interconnect_inst_AXI_M00_interconnect_BVALID), 
            .axi_slv_rlast_o(axi4_interconnect_inst_AXI_M00_interconnect_RLAST), 
            .axi_slv_rready_i(axi4_interconnect_inst_AXI_M00_interconnect_RREADY), 
            .axi_slv_rvalid_o(axi4_interconnect_inst_AXI_M00_interconnect_RVALID), 
            .axi_slv_wlast_i(axi4_interconnect_inst_AXI_M00_interconnect_WLAST), 
            .axi_slv_wready_o(axi4_interconnect_inst_AXI_M00_interconnect_WREADY), 
            .axi_slv_wvalid_i(axi4_interconnect_inst_AXI_M00_interconnect_WVALID));
    
endmodule

