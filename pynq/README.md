# Building Vitis Application Acceleration Platform

***

## Create hardware

```shell-session
$ vivado -mode batch -source create_xsa.tcl
```

## Create PetaLinux project

```shell-session
# get recipe for jupyter
$ git clone https://github.com/Xilinx/meta-jupyter.git -b xlnx-rel-v2022.1 petalinux/project-spec

$ export PRJ=petalinux
$ petalinux-config -p ${PRJ}

# Make additional configuration if necessary
$ petalinux-config -p ${PRJ} -c u-boot
$ petalinux-config -p ${PRJ} -c kernel
$ petalinux-config -p ${PRJ} -c rootfs

# Start build
$ petalinux-build -p ${PRJ}

# Generate SDK (optional)
$ petalinux-build -p ${PRJ} --sdk
```

## Generate platform

```shell-session
$ xsct create_pfm.tcl
```

## Generate BOOT.bin

```shell-session
$ petalinux-package -p ${PRJ} --boot --force \
--fsbl petalinux/images/linux/zynq_fsbl.elf \
--fpga petalinux/images/linux/system.bit \
--u-boot petalinux/images/linux/u-boot-dtb.elf
```

***

## How to create PetaLinux project from scratch

```shell-session
$ export PRJ=petalinux
$ petalinux-create -t project -n ${PRJ} --template zynq
$ petalinux-config -p ${PRJ} --get-hw-description=.

# Do some configuration
$ petalinux-config -p ${PRJ} -c kernel
$ petalinux-config -p ${PRJ} -c u-boot
$ petalinux-config -p ${PRJ} -c rootfs

# Show actual build time of Kernel & u-boot
$ petalinux-build -p ${PRJ} -x cleansstate

# Build project
$ petalinux-build -p ${PRJ}

# Generate SDK
$ petalinux-build -p ${PRJ} --sdk
```
