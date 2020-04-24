#
# Create acceleration platform
#

set PFM_NAME    sd_blk_accel
set OUT_DIR     _pfm

# Remove existing directory
file delete -force ${OUT_DIR}

platform create -name ${PFM_NAME} -hw ${PFM_NAME}.xsa -no-boot-bsp -out ${OUT_DIR}
platform write
platform active ${PFM_NAME}

domain create -name xrt -os linux -proc ps7_cortexa9
domain active xrt
domain config -bif {src/linux.bif}
domain config -boot {petalinux/images/linux}
domain config -image {_image}
domain config -qemu-data {petalinux/images/linux}
domain config -qemu-args {src/qemu_args.txt}
domain config -pmuqemu-args {src/pmu_args.txt}
platform write

platform generate
