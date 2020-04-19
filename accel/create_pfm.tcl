# Create acceleration platform

platform create -name {sd_blk_accel} -hw {sd_blk_accel.xsa} -no-boot-bsp -out {_pfm}
platform write
platform active {sd_blk_accel}

# Add sysroot??
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
