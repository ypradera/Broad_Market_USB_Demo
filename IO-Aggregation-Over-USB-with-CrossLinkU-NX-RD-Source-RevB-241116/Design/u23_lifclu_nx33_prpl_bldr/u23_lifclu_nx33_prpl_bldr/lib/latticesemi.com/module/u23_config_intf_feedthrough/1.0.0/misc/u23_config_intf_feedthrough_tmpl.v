    u23_config_intf_feedthrough __(.ahbl_hsel_slv_i( ),
        .ahbl_haddr_slv_i( ),
        .ahbl_hburst_slv_i( ),
        .ahbl_hsize_slv_i( ),
        .ahbl_hmastlock_slv_i( ),
        .ahbl_hprot_slv_i( ),
        .ahbl_htrans_slv_i( ),
        .ahbl_hwdata_slv_i( ),
        .ahbl_hwrite_slv_i( ),
        .ahbl_hready_slv_i( ),
        .ahbl_hreadyout_slv_o( ),
        .ahbl_hresp_slv_o( ),
        .ahbl_hrdata_slv_o( ),
        .ahbl_hsel_mstr_o( ),
        .ahbl_haddr_mstr_o( ),
        .ahbl_hburst_mstr_o( ),
        .ahbl_hsize_mstr_o( ),
        .ahbl_hmastlock_mstr_o( ),
        .ahbl_hprot_mstr_o( ),
        .ahbl_htrans_mstr_o( ),
        .ahbl_hwdata_mstr_o( ),
        .ahbl_hwrite_mstr_o( ),
        .ahbl_hready_mstr_o( ),
        .ahbl_hready_mstr_i( ),
        .ahbl_hresp_mstr_i( ),
        .ahbl_hrdata_mstr_i( ));
