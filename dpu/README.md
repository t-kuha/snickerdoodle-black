# DPU for Snickerdoodle Black

- DPU: v3.0 (DNNDK: v3.1)
- Vivado/PetaLinux: 2018.3

## Prerequisite

- DPU TRD design (190809) for DPU IP source
  - Download __zcu102-dpu-trd-2019-1-190809.zip__ from [Xilinx website](https://www.xilinx.com/products/design-tools/ai-inference/ai-developer-hub.html#edge)

- DNNDK (v3.1; 190809) for DPU Kernel module source & runtime library
  - Download __xilinx_dnndk_v3.1_190809.tar.gz__ also from [Xilinx website](https://www.xilinx.com/products/design-tools/ai-inference/ai-developer-hub.html#edge)

- Extract source

```shell-session
# IP
$ unzip zcu102-dpu-trd-2019-1-190809.zip
$ cp -R zcu102-dpu-trd-2019-1-timer/pl/srcs/dpu_ip src/_dpu_ip

# Kernel module
$ cd zcu102-dpu-trd-2019-1-timer/apu/dpu_petalinux_bsp
$ petalinux-create -t project -s xilinx-dpu-trd-zcu102-v2019.1.bsp
$ cp -R zcu102-dpu-trd-2019-1/project-spec/meta-user/recipes-modules/dpu ../../../src/_dpu

# Runtime library
$ tar xf xilinx_dnndk_v3.1_190809.tar.gz
$ cp -R xilinx_dnndk_v3.1/ZedBoard/pkgs src/_pkgs
```

***

## Build HW (Generate bitstream)

```shell-session
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
$ cp -R src/dpu/* ${PRJ}/project-spec/meta-user/recipes-modules/dpu/

# Add DNNDK files
$ petalinux-create -p ${PRJ} -t apps --template install --name dnndk --enable
$ rm ${PRJ}/project-spec/meta-user/recipes-apps/dnndk/files/dnndk
$ cp -R src/_pkgs/bin ${PRJ}/project-spec/meta-user/recipes-apps/dnndk/files/
$ cp -R src/_pkgs/lib ${PRJ}/project-spec/meta-user/recipes-apps/dnndk/files/
$ cp -R src/dnndk.bb  ${PRJ}/project-spec/meta-user/recipes-apps/dnndk/

# Add DPU driver (Kernel module)
$ petalinux-create -p ${PRJ} -t modules --name dpu --enable
$ cp -R src/_dpu/* ${PRJ}/project-spec/meta-user/recipes-modules/dpu/

# Build
$ petalinux-build -p ${PRJ}

# Generate SDK (optional)
$ petalinux-build --sdk -p ${PRJ}
```

- Generate BOOT.bin

```shell-session
$ petalinux-package -p ${PRJ} --boot --format BIN \
--fsbl ${PRJ}/images/linux/zynq_fsbl.elf \
--u-boot ${PRJ}/images/linux/u-boot.elf \
--fpga _vivado/sd_blk_dpu.runs/impl_1/sd_blk_dpu_wrapper.bit

# or...
$ petalinux-package -p ${PRJ} --boot --format BIN \
--fsbl ${PRJ}/images/linux/zynq_fsbl.elf \
--u-boot ${PRJ}/images/linux/u-boot.elf \
--fpga ${PRJ}/components/plnx_workspace/device-tree/device-tree/sd_blk_dpu_wrapper.bit
```

## Build application

- For how to build application, see [how-to-create-app.md](how-to-create-app.md)

- Copy ``petalinux/images/linux/image.ub``, ``petalinux/images/linux/BOOT.BIN``, & ``app_mnist/app_mnist.elf`` to SD card

- Run the .elf file

  - Console output would look like this:

  ```shell-session
  root@sd_blk_dpu:/run/media/mmcblk0p3# /media/card/app_mnist.elf
  ------ DPU (mnist) ------
  Alignment trap: app_mnist.elf (1273) PC=0xb6ef55bc Instr=0xe9d60102   Address=0xb6150582 FSR 0x011
  Alignment trap: app_mnist.elf (1273) PC=0xb6ef55bc Instr=0xe9d60102   Address=0xb6150622 FSR 0x011
  Alignment trap: app_mnist.elf (1273) PC=0xb6ef55bc Instr=0xe9d60102   Address=0xb61506c2 FSR 0x011
  Alignment trap: app_mnist.elf (1273) PC=0xb6ef55bc Instr=0xe9d60102   Address=0xb6150762 FSR 0x011
  ..... Pre-loading Images .....
  random: crng init done
  ..... Start Inference .....
  ..... Inference Result .....
  7, 2, 1, 0, 4, 1, 4, 9, 5, 9, 0, 6, 9, 0, 1, 5, 9, 7, 3, 4, 
  
  ...
  
  4, 6, 0, 7, 0, 3, 6, 8, 7, 1, 5, 2, 4, 9, 4, 3, 6, 4, 1, 7, 
  2, 6, 6, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 
  -------------------------
  ```

***

## Reference

- [DPU for Convolutional Neural Network v3.0 - DPU IP Product Guide](https://www.xilinx.com/support/documentation/ip_documentation/dpu/v3_0/pg338-dpu.pdf)
