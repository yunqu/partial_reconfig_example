set overlay_name "gpio_pr"
set design_name "gpio_pr"
set pr_region "gpio_0"
set partition_def "pd_gpio_0"
set rm_0 "led_0"
set rm_1 "led_5"
set rm_2 "led_a"

# function to add reconfigurable module
proc add_rm {pd_name rm_name} {
   create_bd_design "rm_${rm_name}"
   source ${rm_name}.tcl
   validate_bd_design
   save_bd_design
   set_property synth_checkpoint_mode None [get_files rm_${rm_name}.bd]
   create_reconfig_module -name rm_${rm_name} -partition_def [get_partition_defs ${pd_name}] -define_from rm_${rm_name}
}

# open project and block design
open_project -quiet ./${overlay_name}/${overlay_name}.xpr
open_bd_design ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd
set_param project.enablePRFlowIPI 1
set_param bitstream.enablePR 2341
set_param hd.enablePR 1234

# add constraints file into project
import_files -fileset constrs_1 -norecurse ./vivado/constraints/${overlay_name}.xdc
update_compile_order -fileset sources_1
import_files -fileset constrs_1 -norecurse ./vivado/constraints/${pr_region}.xdc
update_compile_order -fileset sources_1

# add partition definition and default reconfigurable module
set_property PR_FLOW true [current_project]
set curdesign [current_bd_design]
create_bd_design -cell [get_bd_cells /${pr_region}] ${rm_0}
set_property synth_checkpoint_mode None [get_files ${rm_0}.bd]
set pd_instance [create_partition_def -name ${partition_def} -module ${rm_0}]
create_reconfig_module -name ${rm_0} -partition_def $pd_instance -define_from ${rm_0}

# replace the pr region
current_bd_design $curdesign
set new_pd_cell [create_bd_cell -type module -reference $pd_instance pr_region_temp]
replace_bd_cell  [get_bd_cells /${pr_region}] $new_pd_cell
delete_bd_objs  [get_bd_cells /${pr_region}]
set_property name ${pr_region} $new_pd_cell

# validate and save current top design
validate_bd_design
save_bd_design

# add rm
add_rm ${partition_def} ${rm_0}
add_rm ${partition_def} ${rm_1}
add_rm ${partition_def} ${rm_2}
