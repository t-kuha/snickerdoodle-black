# Embedded Linux with piSmasher baseboard

***

## Create hardware

```shell
$ vivado -notrace -nojournal -mode batch -source create_xsa.tcl
```

## Create PetaLinux project

```shell
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

## Generate BOOT.bin

- Output is: ``petalinux/images/linux/BOOT.BIN``

```shell
$ petalinux-package -p ${PRJ} --boot --force \
--fsbl petalinux/images/linux/zynq_fsbl.elf \
--fpga petalinux/images/linux/system.bit \
--u-boot petalinux/images/linux/u-boot-dtb.elf
```

## Set up SD card

- Copy following files into boot partiion:
  - ``petalinux/images/linux/BOOT.bin``
  - ``petalinux/images/linux/boot.scr``
  - ``petalinux/images/linux/image.ub``

- Extract ``petalinux/images/linux/rootfs.tar.gz`` into rootfs partition

***

## Status

|  I/F  | status             |
|:-----:|:------------------:|
| Wi-Fi | :heavy_check_mark: |
| USB   |                    |
| HDMI (in) |                |
| HDMI (out) |               |
| audio |                    |
| Ether |                    |

***

## How to create PetaLinux project from scratch

```shell
$ export PRJ=petalinux
$ petalinux-create project -n ${PRJ} --template zynq
$ petalinux-config -p ${PRJ} --get-hw-description=.

# Do some configuration
$ petalinux-config -p ${PRJ} -c kernel
$ petalinux-config -p ${PRJ} -c u-boot
$ petalinux-config -p ${PRJ} -c rootfs

# Build project
$ petalinux-build -p ${PRJ}

# Generate SDK
$ petalinux-build -p ${PRJ} --sdk
```
