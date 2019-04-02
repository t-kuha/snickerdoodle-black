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
$ sdscc ../src/hello_world.c -c -o hello_world.o \
-sds-pf ../_platform_init/sd_blk/export/sd_blk -sds-sys-config linux -target-os linux
$ sdscc hello_world.o -o hello_world.elf \
-sds-pf ../_platform_init/sd_blk/export/sd_blk -sds-sys-config linux -target-os linux
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

## Build & run conformance test

- Copy source code of comformance test from _< SDX installation directory >/samples/platforms/Conformance_

```shell-session
root@sd_blk:~# /run/media/mmcblk0p1/ConformanceTest.elf 
xdma_probe: probe dma c7907450, nres 1, id 0
xilinx-axidma xilinx-axidma.0: AXIDMA device 0 physical base address=0x40400000
xilinx-axidma xilinx-axidma.0: AXIDMA device 0 remapped to 0xf09b0000
xilinx-axidma xilinx-axidma.0: has 1 channel(s)
  chan 0 name: dm_0:0
  chan 0 direction: TO_DEVICE
xlate_irq: hwirq 61, irq 46
  chan0 irq: 46
  chan0 poll mode: off
  chan0 bd ring @ 0x30100000 (size: 0x100000 bytes)
xdma_probe: probe dma c7b60c50, nres 1, id 1
xilinx-axidma xilinx-axidma.1: AXIDMA device 1 physical base address=0x40410000
xilinx-axidma xilinx-axidma.1: AXIDMA device 1 remapped to 0xf0ad0000
xilinx-axidma xilinx-axidma.1: has 1 channel(s)
  chan 0 name: dm_1:0
  chan 0 direction: TO_DEVICE
xlate_irq: hwirq 62, irq 47
  chan0 irq: 47
  chan0 poll mode: off
  chan0 bd ring @ 0x30200000 (size: 0x100000 bytes)
xdma_probe: probe dma c7914450, nres 1, id 2
xilinx-axidma xilinx-axidma.2: AXIDMA device 2 physical base address=0x40420000
xilinx-axidma xilinx-axidma.2: AXIDMA device 2 remapped to 0xf0bf0000
xilinx-axidma xilinx-axidma.2: has 1 channel(s)
  chan 0 name: dm_2:0
  chan 0 direction: FROM_DEVICE
xlate_irq: hwirq 63, irq 48
  chan0 irq: 48
  chan0 poll mode: off
  chan0 bd ring @ 0x30300000 (size: 0x100000 bytes)
xdma_probe: probe dma c784e050, nres 1, id 3
xilinx-axidma xilinx-axidma.3: AXIDMA device 3 physical base address=0x40430000
xilinx-axidma xilinx-axidma.3: AXIDMA device 3 remapped to 0xf0d10000
xilinx-axidma xilinx-axidma.3: has 1 channel(s)
  chan 0 name: dm_3:0
  chan 0 direction: FROM_DEVICE
xlate_irq: hwirq 64, irq 49
  chan0 irq: 49
  chan0 poll mode: off
  chan0 bd ring @ 0x30400000 (size: 0x100000 bytes)
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.4
xilinx-xlnk-eng xilinx-xlnk-eng.4: physical base : 0x40440000
xilinx-xlnk-eng xilinx-xlnk-eng.4: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.4: base remapped to: 0xf0e30000
xilinx-xlnk-eng xilinx-xlnk-eng.4: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.5
xilinx-xlnk-eng xilinx-xlnk-eng.5: physical base : 0x40450000
xilinx-xlnk-eng xilinx-xlnk-eng.5: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.5: base remapped to: 0xf0e50000
xilinx-xlnk-eng xilinx-xlnk-eng.5: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.6
xilinx-xlnk-eng xilinx-xlnk-eng.6: physical base : 0x40460000
xilinx-xlnk-eng xilinx-xlnk-eng.6: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.6: base remapped to: 0xf0e70000
xilinx-xlnk-eng xilinx-xlnk-eng.6: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.7
xilinx-xlnk-eng xilinx-xlnk-eng.7: physical base : 0x40470000
xilinx-xlnk-eng xilinx-xlnk-eng.7: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.7: base remapped to: 0xf0e90000
xilinx-xlnk-eng xilinx-xlnk-eng.7: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.8
xilinx-xlnk-eng xilinx-xlnk-eng.8: physical base : 0x43c00000
xilinx-xlnk-eng xilinx-xlnk-eng.8: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.8: base remapped to: 0xf0eb0000
xilinx-xlnk-eng xilinx-xlnk-eng.8: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.9
xilinx-xlnk-eng xilinx-xlnk-eng.9: physical base : 0x43c10000
xilinx-xlnk-eng xilinx-xlnk-eng.9: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.9: base remapped to: 0xf0ed0000
xilinx-xlnk-eng xilinx-xlnk-eng.9: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.10
xilinx-xlnk-eng xilinx-xlnk-eng.10: physical base : 0x43c20000
xilinx-xlnk-eng xilinx-xlnk-eng.10: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.10: base remapped to: 0xf0ef0000
xilinx-xlnk-eng xilinx-xlnk-eng.10: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.11
xilinx-xlnk-eng xilinx-xlnk-eng.11: physical base : 0x43c30000
xilinx-xlnk-eng xilinx-xlnk-eng.11: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.11: base remapped to: 0xf0f10000
xilinx-xlnk-eng xilinx-xlnk-eng.11: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.12
xilinx-xlnk-eng xilinx-xlnk-eng.12: physical base : 0x43c40000
xilinx-xlnk-eng xilinx-xlnk-eng.12: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.12: base remapped to: 0xf0f30000
xilinx-xlnk-eng xilinx-xlnk-eng.12: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.13
xilinx-xlnk-eng xilinx-xlnk-eng.13: physical base : 0x43c50000
xilinx-xlnk-eng xilinx-xlnk-eng.13: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.13: base remapped to: 0xf0f50000
xilinx-xlnk-eng xilinx-xlnk-eng.13: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.14
xilinx-xlnk-eng xilinx-xlnk-eng.14: physical base : 0x43c60000
xilinx-xlnk-eng xilinx-xlnk-eng.14: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.14: base remapped to: 0xf0f70000
xilinx-xlnk-eng xilinx-xlnk-eng.14: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.15
xilinx-xlnk-eng xilinx-xlnk-eng.15: physical base : 0x43c70000
xilinx-xlnk-eng xilinx-xlnk-eng.15: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.15: base remapped to: 0xf0f90000
xilinx-xlnk-eng xilinx-xlnk-eng.15: xilinx-xlnk-eng uio registered
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.16
xilinx-xlnk-eng xilinx-xlnk-eng.16: physical base : 0x43c80000
xilinx-xlnk-eng xilinx-xlnk-eng.16: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.16: base remapped to: 0xf0fb0000
xilinx-xlnk-eng xilinx-xlnk-eng.16: xilinx-xlnk-eng uio registered
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

- Run

```shell-session
# Build comformance test
$ make PLATFORM=../platform/sd_blk OS=LINUX PLATFORM_TYPE=ZYNQ
```


***

## Reference

- UG1146: "SDSoC Environment Platform Development Guide"
- UG1144: "PetaLinux Tools Documentation"
