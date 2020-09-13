# Simple SDSoC platform for Snickerdoodle Black

***

## How to create platform

### Create HW in Vivado

```shell-session
# Create Vivado project
$ vivado -mode batch -source create_vivado_project.tcl
```

### Build PetaLinux

```shell-session
$ export PRJ=petalinux

$ petalinux-create -t project -n ${PRJ} --template zynq
$ petalinux-config --project ${PRJ} --get-hw-description=.
$ petalinux-build -p ${PRJ}
```

### Generate platform (w/o prebuilt data)

```shell-session
# Make sure to use xsct in SDx (not SDK)
$ ${XILINX_SDX}/bin/xsct create_sdsoc_pfm.tcl
```

### Build pre-built HW

- Build _hello_world_

```shell-session
$ mkdir _prj_0
$ cd _prj_0
$ sdscc ../src/hello_world.c -c -o hello_world.o \
-sds-pf ../_pfm_0/sd_blk/export/sd_blk -sds-sys-config linux -target-os linux
$ sdscc hello_world.o -o hello_world.elf \
-sds-pf ../_pfm_0/sd_blk/export/sd_blk -sds-sys-config linux -target-os linux
$ cd ..
```

### Create final platform (with pre-built HW)

```shell-session
$ ${XILINX_SDX}/bin/xsct create_sdsoc_pfm.tcl
```

- The platform will be in ``_pfm/sd_blk/export/sd_blk``

***

## Build & run conformance test

- Build

```shell-session
$ cp -R ${XILINX_SDX}/samples/platforms/Conformance/ _conformance
$ cd _conformance/
$ make OS=LINUX PLATFORM=../_pfm/sd_blk/export/sd_blk PLATFORM_TYPE=ZYNQ
```

- Run

```shell-session
root@sd_blk:~# /media/card/ConformanceTest.elf 
Starting allocation tests from 65536 to 67108864 with increment 524288
done
Starting datamover tests....
Running test <axi_dma_simple, ACP, sds_alloc>
    using Index=1/114687, data size=64-7340032, Allocation=SDS Alloc, Unvalidated
 Complete
Running test <zero_copy, ACP, sds_alloc>
    using Index=1/262143, data size=64-16777216, Allocation=SDS Alloc, Unvalidated
 Complete
Running test <axi_dma_sg, ACP, malloc>
    using Index=1/262143, data size=64-16777216, Allocation=User new, Unvalidated
 Complete
Running test <axi_dma_sg, ACP, sds_alloc>
    using Index=1/262143, data size=64-16777216, Allocation=SDS Alloc, Unvalidated
 Complete
Running test <axi_dma_simple, HP, sds_alloc>
    using Index=1/114687, data size=64-7340032, Allocation=SDS Alloc, Unvalidated
 Complete
Running test <axi_dma_simple, HP, sds_alloc_noncacheable>
    using Index=1/114687, data size=64-7340032, Allocation=SDS Alloc (non-cacheable), Unvalidated
 Complete
Running test <zero_copy, HP, sds_alloc>
    using Index=1/262143, data size=64-16777216, Allocation=SDS Alloc, Unvalidated
 Complete
Running test <zero_copy, HP, sds_alloc_noncacheable>
    using Index=1/262143, data size=64-16777216, Allocation=SDS Alloc (non-cacheable), Unvalidated
 Complete
Running test <axi_dma_sg, HP, malloc>
    using Index=1/262143, data size=64-16777216, Allocation=User new, Unvalidated
 Complete
Running test <axi_dma_sg, HP, sds_alloc>
    using Index=1/262143, data size=64-16777216, Allocation=SDS Alloc, Unvalidated
 Complete
Running test <axi_dma_sg, HP, sds_alloc_noncacheable>
    using Index=1/262143, data size=64-16777216, Allocation=SDS Alloc (non-cacheable), Unvalidated
 Complete
Running test <axi_fifo, NONE, NONE>
    using Index=1/31, data size=64-2048, Allocation=User new, Unvalidated
 Complete
Datamover Testing complete.
Testing clocks
Clock tests complete.
Test passed.
```

***

### How to create Petalinux project

```shell-session
$ export PRJ=petalinux

# Create project
$ petalinux-create --type project --name ${PRJ} --template zynq
$ petalinux-config --project ${PRJ} --get-hw-description=.

# Kernel config
$ petalinux-config -p ${PRJ} -c kernel

# u-boot config
$ petalinux-config -p ${PRJ} -c u-boot

# rootfs config
$ petalinux-config -p ${PRJ} -c rootfs

# Add libsdslib*.so
$ petalinux-create -p ${PRJ} -t apps --template install --name sdslib --enable
$ rm ${PRJ}/project-spec/meta-user/recipes-apps/sdslib/files/sdslib
$ cp -R ${XILINX_SDX}/target/aarch32-linux/lib/libsds_lib*.so \
${PRJ}/project-spec/meta-user/recipes-apps/sdslib/files
$ cp src/sdslib.bb petalinux/project-spec/meta-user/recipes-apps/sdslib/sdslib.bb

# Build project
$ petalinux-build --project ${PRJ}
```

***

## Reference

- UG1146: "SDSoC Environment Platform Development Guide"
- UG1144: "PetaLinux Tools Documentation"