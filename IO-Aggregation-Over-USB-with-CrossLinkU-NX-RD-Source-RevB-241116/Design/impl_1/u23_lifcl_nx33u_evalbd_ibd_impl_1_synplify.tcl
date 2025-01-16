#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology LIFCL
set_option -part LIFCL_33U
set_option -package FCCSP104C
set_option -speed_grade -7
#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog standard option
set_option -vlog_std sysv

#map options
set_option -frequency 200
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -retiming false; set_option -pipe true
set_option -force_gsr false
set_option -compiler_compatible 0


set_option -default_enum_encoding default

#timing analysis options



#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 0
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0


set_option -rw_check_on_ram 0
set_option -seqshift_no_replicate 0
set_option -automatic_compile_point 0

#-- set any command lines input by customer

set_option -dup false
set_option -disable_io_insertion false
add_file -constraint {C:/lscc/radiant/2024.2/scripts/tcl/flow/radiant_synplify_vars.tcl}
add_file -constraint {u23_lifcl_nx33u_evalbd_ibd_impl_1_cpe.ldc}
add_file -verilog {C:/lscc/radiant/2024.2/ip/pmi/pmi_lifcl.v}
add_file -vhdl -lib pmi {C:/lscc/radiant/2024.2/ip/pmi/pmi_lifcl.vhd}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/rtl/u23_lifcl_nx33u_evalbd_ibd.sv}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/rtl/clock_debug.sv}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/rtl/resetn_sync.sv}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr_des.v}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/rtl/pll/pll_60m/rtl/pll_60m.v}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/cpu0/2.7.0/rtl/cpu0.sv}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/sysmem0/2.3.0/rtl/sysmem0.v}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/module/ahbl0/1.3.2/rtl/ahbl0.v}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/module/ahbl2apb0/1.1.2/rtl/ahbl2apb0.sv}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/module/apb0/1.2.1/rtl/apb0.v}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/uart0/1.3.0/rtl/uart0.v}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/module/u23_config_intf_feedthrough/1.0.0/rtl/u23_config_intf_feedthrough.v}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/remote_files/sources/documents/development_doc/lattice_example/verilog_modules/AHBL_to_LMMI_converter.v}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/remote_files/sources/rtl/source/axi64_to_ahbl32_conv/axi64_to_ahbl32_conv.v}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/remote_files/sources/rtl/source/axi64_to_ahbl32_conv/lib/latticesemi.com/ip/axi4_interconnect/1.2.2/rtl/axi4_interconnect.sv}
add_file -verilog -vlog_std sysv {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/remote_files/sources/rtl/source/axi64_to_ahbl32_conv/lib/latticesemi.com/ip/axi4_to_ahbl_bridge/1.1.1/rtl/axi4_to_ahbl_bridge.v}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/lscc_i2cm1/2.0.1/rtl/lscc_i2cm1.v}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/lscc_spim1/2.1.0/rtl/lscc_spim1.v}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/HW_ver_gpio/1.6.2/rtl/HW_ver_gpio.v}
add_file -verilog -vlog_std v2001 {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/gpio0/1.6.2/rtl/gpio0.v}
#-- top module name
set_option -top_module u23_lifcl_nx33u_evalbd_ibd
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/rtl/pll/pll_60m}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/cpu0/2.7.0}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/gpio0/1.6.2}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/HW_ver_gpio/1.6.2}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/lscc_i2cm1/2.0.1}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/lscc_spim1/2.1.0}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/sysmem0/2.3.0}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/ip/uart0/1.3.0}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/module/ahbl0/1.3.2}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/module/ahbl2apb0/1.1.2}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/module/apb0/1.2.1}
set_option -include_path {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/u23_lifclu_nx33_prpl_bldr/u23_lifclu_nx33_prpl_bldr/lib/latticesemi.com/module/u23_config_intf_feedthrough/1.0.0}

#-- set result format/file last
project -result_format "vm"
project -result_file "./u23_lifcl_nx33u_evalbd_ibd_impl_1.vm"

#-- error message log file
project -log_file {u23_lifcl_nx33u_evalbd_ibd_impl_1.srf}

project -run -clean
