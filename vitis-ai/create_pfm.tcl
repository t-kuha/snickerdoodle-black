	#
# Create acceleration platform
#

set PFM_NAME    sd_blk_vai
set OUT_DIR     _pfm
set IMG_DIR     _image

# Remove existing directories
file delete -force ${OUT_DIR}
file delete -force ${IMG_DIR}

# Copy image.ub & boot.scr into _image
file mkdir ${IMG_DIR}
file copy petalinux/images/linux/boot.scr ${IMG_DIR}
file copy petalinux/images/linux/image.ub ${IMG_DIR}

platform create -name ${PFM_NAME} -hw ${PFM_NAME}.xsa -no-boot-bsp -out ${OUT_DIR}
platform write
platform active ${PFM_NAME}

domain create -name xrt -os linux -proc ps7_cortexa9
domain active xrt
domain config -bif {src/linux.bif}
domain config -boot {petalinux/images/linux}
domain config -image ${IMG_DIR}
domain config -qemu-data {petalinux/images/linux}
#domain config -qemu-args {src/qemu_args.txt}
#domain config -pmuqemu-args {src/pmu_args.txt}
platform write

platform generate

