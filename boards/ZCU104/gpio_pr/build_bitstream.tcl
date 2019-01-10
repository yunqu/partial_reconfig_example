set overlay_name "gpio_pr"
set design_name "gpio_pr"

# open project and block design
open_project -quiet ./${overlay_name}/${overlay_name}.xpr
open_bd_design ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd
set_param project.enablePRFlowIPI 1
set_param bitstream.enablePR 2341
set_param hd.enablePR 1234

# synthesis
launch_runs synth_1 -jobs 8
wait_on_run synth_1

set proj_pr_flow [get_property PR_FLOW [current_project]]
if {$proj_pr_flow == 1} { 
   setup_pr_configuration -v
}

# implementation
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

set child_impl_runs [get_runs child_*]
foreach  { impl_run } $child_impl_runs  {
   launch_runs $impl_run -to_step write_bitstream -jobs 4
   wait_on_run $impl_run
}
