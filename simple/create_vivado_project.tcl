# Setting
set PRJ_DIR     _vivado
set PRJ_NAME    sd_blk
set BD_NAME     ${PRJ_NAME}
set SRC_DIR     src


# Create project
create_project ${PRJ_NAME} ${PRJ_DIR} -part xc7z020clg400-3
set_property board_part krtkl.com:snickerdoodle_black:part0:1.0 [current_project]

# Create block design
source ${SRC_DIR}/bd.tcl

# Set top-level source
make_wrapper -files [get_files ${PRJ_DIR}/${PRJ_NAME}.srcs/sources_1/bd/${BD_NAME}/${BD_NAME}.bd] -top
add_files -norecurse ${PRJ_DIR}/${PRJ_NAME}.srcs/sources_1/bd/${BD_NAME}/hdl/${BD_NAME}_wrapper.v
set_property top ${BD_NAME}_wrapper [current_fileset]
update_compile_order -fileset sources_1

# Generate block design
regenerate_bd_layout
# validate_bd_design
save_bd_design
generate_target all [get_files  ${PRJ_DIR}/${PRJ_NAME}.srcs/sources_1/bd/${BD_NAME}/${BD_NAME}.bd]

# Create .dsa
write_dsa ${PRJ_NAME}.dsa
validate_dsa ${PRJ_NAME}.dsa

# Finish - close project
close_project
