set overlay_name "gpio_pr"
set design_name "gpio_pr"
set pr_region "gpio_0"
set rm_0 "led_0"
set rm_1 "led_5"
set rm_2 "led_a"

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
file copy -force ./${overlay_name}/${overlay_name}.runs/impl_1/${design_name}_wrapper.bit ${overlay_name}.bit

set child_impl_runs [get_runs child_*]
foreach  { impl_run } $child_impl_runs  {
    launch_runs $impl_run -to_step write_bitstream -jobs 4
    wait_on_run $impl_run
    set bits [glob -type f ./${overlay_name}/${overlay_name}.runs/${impl_run}/*_partial.bit]
    foreach { bit } $bits {
        file copy -force $bit ./
    }
}

# rename partial bit files
file rename -force ${design_name}_i_${pr_region}_rm_${rm_0}_partial.bit ${rm_0}.bit
file rename -force ${design_name}_i_${pr_region}_rm_${rm_1}_partial.bit ${rm_1}.bit
file rename -force ${design_name}_i_${pr_region}_rm_${rm_2}_partial.bit ${rm_2}.bit

# copy hwh files
file copy -force ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/hw_handoff/${design_name}.hwh ${overlay_name}.hwh
file copy -force ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/rm_${rm_0}/hw_handoff/rm_${rm_0}.hwh ${rm_0}.hwh
file copy -force ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/rm_${rm_1}/hw_handoff/rm_${rm_1}.hwh ${rm_1}.hwh
file copy -force ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/rm_${rm_2}/hw_handoff/rm_${rm_2}.hwh ${rm_2}.hwh
