# simple

- Simple SDSoC platform for Zybo Z7-20 board

***

## How to create platform

### Create HW in Vivado

```shell-session
# Create Vivado project
$ vivado -mode batch -source create_vivado_project.tcl
```

### Build PetaLinux

```shell-session
$ cd petalinux
$ petalinux-create -t project -s sd_blk
$ petalinux-build -p sd_blk
```

### Generate platform (w/o prebuilt data)

```shell-session
# Create directory for platform components
$ mkdir pfm_files/boot pfm_files/image

# Copy necessary output products
$ cp petalinux/sd_blk/images/linux/u-boot.elf      pfm_files/boot
$ cp petalinux/sd_blk/images/linux/zynq_fsbl.elf   pfm_files/boot
$ cp petalinux/sd_blk/images/linux/image.ub        pfm_files/image

# Make sure to use xsct in SDx (not SDK)
$ xsct create_sdsoc_pfm.tcl
```

### Build pre-built HW

- Build _hello_world_

```shell-session
$ mkdir _prj_init
$ cd _prj_init
$ sdscc ../src/hello_world.c -c -o hello_world.o -sds-pf ../_platform_init/sd_blk/export/sd_blk -sds-sys-config linux -target-os linux
$ sdscc hello_world.o -o hello_world.elf -sds-pf ../_platform_init/sd_blk/export/sd_blk -sds-sys-config linux -target-os linux
```

- Copy prebuilt data

```shell-session
$ mkdir pfm_files/prebuilt

# system.bit file should be renamed to bitstream.bit
$ cp _prj_init/_sds/p0/vpl/system.bit    pfm_files/prebuilt/bitstream.bit
# system.hdf file should be renamed to <platform>.hdf
$ cp _prj_init/_sds/p0/vpl/system.hdf    pfm_files/prebuilt/sd_blk.hdf
$ cp _prj_init/_sds/.llvm/partitions.xml pfm_files/prebuilt
$ cp _prj_init/_sds/.llvm/apsys_0.xml    pfm_files/prebuilt
$ cp _prj_init/_sds/swstubs/portinfo.c   pfm_files/prebuilt
$ cp _prj_init/_sds/swstubs/portinfo.h   pfm_files/prebuilt
```

### Create final platform (with pre-built HW)

- Use xsct in SDx directory (not the one in XSDK directory)

```shell-session
$ xsct create_sdsoc_pfm.tcl
```

***

### How to create Petalinux project

```shell-session
cd petalinux

export PRJ_NAME=sd_blk

# Create project
petalinux-create --type project --name ${PRJ_NAME} --template zynq
petalinux-config --project ${PRJ_NAME} --get-hw-description

# Modify kernel & rootfs settings
petalinux-config --project ${PRJ_NAME} -c kernel
petalinux-config --project ${PRJ_NAME} -c rootfs

# Add sds_lib
petalinux-create --project ${PRJ_NAME} -t apps --template install --name sdslib --enable

# Build project
petalinux-build --project ${PRJ_NAME}
```

***

## Run conformance test

- Copy source code of comformance test from _< SDX installation directory >/samples/platforms/Conformance_

```shell-session
# Build comformance test
$ make PLATFORM=../platform/sd_blk OS=LINUX PLATFORM_TYPE=ZYNQ
```

***

## Reference

- UG1146: "SDSoC Environment Platform Development Guide"
- UG1144: "PetaLinux Tools Documentation"
