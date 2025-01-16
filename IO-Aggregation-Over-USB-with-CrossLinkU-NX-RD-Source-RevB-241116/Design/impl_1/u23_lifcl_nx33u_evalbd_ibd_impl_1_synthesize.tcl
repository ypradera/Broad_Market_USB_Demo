if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2024.2} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) "1"
set para(prj_dir) "C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design"
if {![file exists {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/impl_1}]} {
  file mkdir {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/impl_1}
}
cd {C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/impl_1}
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- u23_lifcl_nx33u_evalbd_ibd_impl_1_cpe.ldc
::radiant::runengine::run_engine_newmsg cpe -syn synpro -f "u23_lifcl_nx33u_evalbd_ibd_impl_1.cprj" "pll_60m.cprj" "cpu0.cprj" "sysmem0.cprj" "ahbl0.cprj" "ahbl2apb0.cprj" "apb0.cprj" "uart0.cprj" "u23_config_intf_feedthrough.cprj" "lscc_i2cm1.cprj" "lscc_spim1.cprj" "HW_ver_gpio.cprj" "gpio0.cprj" -a "LIFCL"  -o u23_lifcl_nx33u_evalbd_ibd_impl_1_cpe.ldc
# synthesize top design
file delete -force -- u23_lifcl_nx33u_evalbd_ibd_impl_1.vm u23_lifcl_nx33u_evalbd_ibd_impl_1.ldc
if {[file normalize "C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/impl_1/u23_lifcl_nx33u_evalbd_ibd_impl_1_synplify.tcl"] != [file normalize "./u23_lifcl_nx33u_evalbd_ibd_impl_1_synplify.tcl"]} {
  file copy -force "C:/Users/whan/Documents/AppProject/USB_LIFCL_NX33U/RD_IOA_USB2_REVB/Design/impl_1/u23_lifcl_nx33u_evalbd_ibd_impl_1_synplify.tcl" "./u23_lifcl_nx33u_evalbd_ibd_impl_1_synplify.tcl"
}
if {[ catch {::radiant::runengine::run_engine synpwrap -prj "u23_lifcl_nx33u_evalbd_ibd_impl_1_synplify.tcl" -log "u23_lifcl_nx33u_evalbd_ibd_impl_1.srf"} result options ]} {
    file delete -force -- u23_lifcl_nx33u_evalbd_ibd_impl_1.vm u23_lifcl_nx33u_evalbd_ibd_impl_1.ldc
    return -options $options $result
}
::radiant::runengine::run_postsyn [list -a LIFCL -p LIFCL-33U -t FCCSP104 -sp 7_High-Performance_1.0V -oc Commercial -top -w -o u23_lifcl_nx33u_evalbd_ibd_impl_1_syn.udb u23_lifcl_nx33u_evalbd_ibd_impl_1.vm] [list u23_lifcl_nx33u_evalbd_ibd_impl_1.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
