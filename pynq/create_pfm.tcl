#
# Create Vitis Acceleration Platform
#

set PFM_NAME    sd_blk_pynq
set OUT_DIR     _pfm
set IMG_DIR     _img

# Remove existing directories
file delete -force ${OUT_DIR}
file delete -force ${IMG_DIR}

# Copy necessary files
file mkdir ${IMG_DIR}
file copy petalinux/images/linux/boot.scr ${IMG_DIR}
file copy petalinux/images/linux/image.ub ${IMG_DIR}
file copy petalinux/images/linux/rootfs.tar.gz ${IMG_DIR}

# Generate
platform create -name ${PFM_NAME} -hw {sd_blk.xsa} -no-boot-bsp -out ${OUT_DIR}
platform write
platform active ${PFM_NAME}

domain create -name xrt -os linux -proc ps7_cortexa9
domain active xrt
# domain config -generate-bif
domain config -bif {src/linux.bif}
domain config -boot {petalinux/images/linux}
domain config -sd-dir ${IMG_DIR}
domain config -qemu-data {petalinux/images/linux}
platform write

platform generate
