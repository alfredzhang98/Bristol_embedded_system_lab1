# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xcvu095-ffva2104-2-e

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.cache/wt [current_project]
set_property parent.project_path W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo w:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.srcs/sources_1/imports/LAB2_ISE/Group04_files/CORTEXM0DS.v
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.srcs/sources_1/imports/LAB2_ISE/Group04_files/cortexm0ds_logic.v
}
read_vhdl -library xil_defaultlib {
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/lib/grlib/stdlib/config.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/lib/grlib/stdlib/version.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/lib/grlib/version.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/lib/grlib/stdlib/stdlib.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/lib/grlib/amba/amba.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/lib/grlib/amba/devices.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.srcs/sources_1/imports/LAB2_ISE/Group04_files/ahb_bridge.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.srcs/sources_1/imports/LAB2_ISE/lib/gaisler/misc/ahbmst.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.srcs/sources_1/imports/LAB2_ISE/Group04_files/data_swapper.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.srcs/sources_1/imports/LAB2_ISE/Group04_files/detectorbus.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.srcs/sources_1/imports/LAB2_ISE/Group04_files/state_machine.vhd
  W:/Modelsim/Embedded_Unit_Lab/LAB2_ISE/Vivoda_test/ahb_lab/ahb_lab.srcs/sources_1/imports/LAB2_ISE/Group04_files/cm0_wrapper.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}

synth_design -top cm0_wrapper -part xcvu095-ffva2104-2-e


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef cm0_wrapper.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file cm0_wrapper_utilization_synth.rpt -pb cm0_wrapper_utilization_synth.pb"
