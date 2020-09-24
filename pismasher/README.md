# Large linux rootfs with various libraries

***

## Build hardware

- Generate bitstream

```shell-session
# This will also create HW definition file (_system.hdf)
$ vivado -mode batch -source create_vivado_project.tcl
```

***

## Create PetaLinux project

- Create project (usually can be skipped to "petalinux-build")

```shell-session
$ export PRJ=petalinux
$ petalinux-create -t project -n ${PRJ} --template zynq
$ petalinux-config -p ${PRJ} --get-hw-description=.

# Kernel config
$ petalinux-config -p ${PRJ} -c kernel

# u-boot config
$ petalinux-config -p ${PRJ} -c u-boot

# rootfs config
$ petalinux-config -p ${PRJ} -c rootfs

# Build
$ petalinux-build -p ${PRJ}

# Generate SDK (optional)
$ petalinux-build --sdk -p ${PRJ}
```

***

## Generate BOOT.bin

```shell-session
$ bootgen -arch zynq -image src/boot_bin_linux.bif -w -o BOOT.bin
# or ...
$ petalinux-package -p ${PRJ} --boot --format BIN \
--fsbl ${PRJ}/images/linux/zynq_fsbl.elf \
--u-boot ${PRJ}/images/linux/u-boot.elf \
--fpga ${PRJ}/project-spec/hw-description/sd_blk_wrapper.bit
# or ...
# --fpga _vivado/sd_blk.runs/impl_1/sd_blk_wrapper.bit
# BOOT.BIN is in ${PRJ}/images/linux/
```

***

## Simulation in QEMU

```shell-session
# Collect prebuilt image
$ cd ${PRJ}
$ petalinux-package --prebuilt

# Run Linux Kernel on QEMU
$ petalinux-boot --qemu --kernel
```
