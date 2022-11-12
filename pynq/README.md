# Embedded Linux with piSmasher baseboard

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

***

## setup PYNQ

- Install Jupyter Lab

```bash
$ sudo dnf install -y \
python3-jupyterlab python3-jupyter_server python3-jupyterlab-pygments \
python3-ipywidgets python3-nbclassic python3-nbclient python3-websocket-client \
python3-requests python3-nest-asyncio python3-argon2-cffi-bindings \
python3-charset-normalizer python3-matplotlib python3-pillow

# start Jupyter Lab
$ jupyter lab --no-browser --ip=*
```

- PYNQ

sudo pip3 install wheel

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
