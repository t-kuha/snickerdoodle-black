# Building Vitis AI platform

- Vitis AI version: 1.2.1

***

## Create hardware

```shell-session
$ vivado -mode batch -source create_xsa.tcl
```

## Build petaLinux project

```shell-session
$ export PRJ=petalinux
$ petalinux-config -p ${PRJ}

# Build project
$ petalinux-build -p ${PRJ}
```

## Create Vitis platform

```shell-session
$ xsct create_pfm.tcl
```

***

## Build Vitis AI platform

- Clone Vitis AI repo:

```shell-session
$ git clone https://github.com/Xilinx/Vitis-AI.git -b v1.2.1
$ cp -R Vitis-AI/DPU-TRD/ .
```

- Copy config files

```shell-session
$ cp prj_config  DPU-TRD/prj/Vitis/config_file/
$ cp dpu_conf.vh DPU-TRD/prj/Vitis/
```

- Edit _DPU-TRD/prj/Vitis/Makefile_: 

  - Before

  ```Makefile
  XOCC_OPTS = -t ${TARGET} --platform ${SDX_PLATFORM} --save-temps --config ${DIR_PRJ}/config_file/prj_config_102_3dpu_LPD --xp param:compiler.userPostSysLinkOverlayTcl=${DIR_PRJ}/syslink/strip_interconnects.tcl
  ...
  v++ -t ${TARGET} --platform ${SDX_PLATFORM} -p binary_container_1/dpu.xclbin --package.out_dir binary_container_1 --package.rootfs $(EDGE_COMMON_SW)/rootfs.ext4 --package.sd_file $(EDGE_COMMON_SW)/Image
  ```

  - After

  ```Makefile
  XOCC_OPTS = -t ${TARGET} --platform ${SDX_PLATFORM} --save-temps --config ${DIR_PRJ}/config_file/prj_config
  ...

  ```

- Build

```shell-session
$ export SDX_PLATFORM=<path to .xpfm>

$ cd DPU-TRD/prj/Vitis/
$ make KERNEL=DPU DEVICE=sd_blk_vai MPSOC_CXX=arm-linux-gnueabihf-g++
# or to build with the SoftMax core...
$ make KERNEL=DPU_SM DEVICE=sd_blk_vai
```

***

## Creating PetaLinux project from scratch

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

- Add following content to ``petalinux/project-spec/meta-user/conf/user-rootfsconfig``

```text
CONFIG_xrt
CONFIG_xrt-dev
CONFIG_zocl
CONFIG_opencl-clhpp-dev
CONFIG_opencl-headers-dev
```

- Edit device tree (``petalinux/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi``)

```text
&amba {
    zyxclmm_drm {
        compatible = "xlnx,zocl";
        status = "okay";
    };
};
```
