# Building Vitis AI platform

***

## Create hardware

```shell-session
$ vivado -mode batch -source create_xsa.tcl
```

## Create Linux

- Create PetaLinux project

```shell-session
$ export PRJ=petalinux
$ petalinux-config -p ${PRJ}

# Start build
$ petalinux-build -p ${PRJ}

# Generate SDK (optional)
$ petalinux-build -p ${PRJ} --sdk
```

## Generate platform

```shell-session
$ xsct create_pfm.tcl
```

## Create Vitis-AI platform

```shell-session
$ git clone https://github.com/Xilinx/Vitis-AI.git -b v1.4.1
$ cp -R Vitis-AI/dsa/DPU-TRD/ . 
```

- Copy config files

```shell-session
$ cp prj_config  DPU-TRD/prj/Vitis/config_file/
$ cp dpu_conf.vh DPU-TRD/prj/Vitis/
```

- Edit ``DPU-TRD/prj/Vitis/Makefile`` as follows:

```diff
package:
-       v++ -t ${TARGET} --platform ${SDX_PLATFORM} -p binary_container_1/dpu.xclbin  -o dpu.xclbin --package.out_dir binary_container_1 --package.rootfs $(EDGE_COMMON_SW)/rootfs.ext4 --package.sd_file $(EDGE_COMMON_SW)/Image 
-       cp ./binary_*/link/vivado/vpl/prj/prj*/sources_1/bd/*/hw_handoff/*.hwh ./binary_*/sd_card
-       cp ./binary_*/link/vivado/vpl/prj/prj.gen/sources_1/bd/*/ip/*_DPUCZDX8G_1_0/arch.json ./binary_*/sd_card
+       v++ -t ${TARGET} --platform ${SDX_PLATFORM} -p binary_container_1/dpu.xclbin  -o dpu.xclbin --package.no_image
+       cp ./binary_*/link/vivado/vpl/prj/prj*/sources_1/bd/*/hw_handoff/*.hwh ./sd_card
+       cp ./binary_*/link/vivado/vpl/prj/prj.gen/sources_1/bd/*/ip/*_DPUCZDX8G_1_0/arch.json ./sd_card

clean:
```

- Build

```shell-session
# Set path to generated platform (.xpfm file)
$ export SDX_PLATFORM=$(pwd)/_pfm/sd_blk_vai/export/sd_blk_vai/sd_blk_vai.xpfm

$ cd DPU-TRD/prj/Vitis/
$ make KERNEL=DPU DEVICE=sd_blk
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
