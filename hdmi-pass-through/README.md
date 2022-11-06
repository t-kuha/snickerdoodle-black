# HDMI pass-through example

- Based on [krtkl's official example](https://github.com/krtkl/piSmasher-testing.git)

***

## Create hardware

```shell-session
$ vivado -mode batch -source create_xsa.tcl
```

## Create PetaLinux project

```shell-session
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

```shell-session
$ petalinux-package -p ${PRJ} --boot --force \
--fsbl petalinux/images/linux/zynq_fsbl.elf \
--fpga petalinux/images/linux/system.bit \
--u-boot petalinux/images/linux/u-boot-dtb.elf
```

## Run

- Copy ``BOOT.bin``, ``image.ub``, and ``boot.scr`` into micro SD card

- Boot the board

- Configure HDMI & Audio codec:
  - No need for GPIO export

```bash
$ sudo hdmi-config -m 1920x1080
$ sudo audio-config -i <linein|mic> -o <lineout|headphones>
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

# Build project
$ petalinux-build -p ${PRJ}

# Generate SDK
$ petalinux-build -p ${PRJ} --sdk
```
