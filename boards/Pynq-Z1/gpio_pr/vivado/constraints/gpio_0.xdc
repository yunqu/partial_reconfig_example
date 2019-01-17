create_pblock pblock_gpio_0
resize_pblock pblock_gpio_0 -add {SLICE_X50Y50:SLICE_X81Y100 RAMB18_X3Y20:RAMB18_X3Y39 RAMB36_X3Y10:RAMB36_X3Y19}
add_cells_to_pblock pblock_gpio_0 [get_cells -quiet [list gpio_pr_i/gpio_0]]
set_property RESET_AFTER_RECONFIG 1 [get_pblocks pblock_gpio_0]
set_property SNAPPING_MODE ROUTING [get_pblocks pblock_gpio_0]
