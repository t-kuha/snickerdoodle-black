# Direct-IO SDSoC platform for Snickerdoodle Black

- Based on [Using External I/O](https://www.xilinx.com/html_docs/xilinx2018_3/sdsoc_doc/using-external-i-o-cns1504034391929.html)

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

### Generate platform

```shell-session
$ ${XILINX_SDX}/bin/xsct create_sdsoc_pfm.tcl
```

***

## Building & running application

- Build _s2mm_data_copy_

```shell-session
$ mkdir _prj && cd _prj

$ sds++ ../src/main.cpp -c -o main.o \
-sds-pf ../_pfm_0/sd_blk_axis_io/export/sd_blk_axis_io \
-sds-hw s2mm_data_copy main.cpp -sds-end -sds-sys-config linux \
-sds-sys-config linux -target-os linux
$ sds++ main.o -o s2mm_data_copy.elf \
-sds-pf ../_pfm_0/sd_blk_axis_io/export/sd_blk_axis_io \
-sds-hw s2mm_data_copy main.cpp -sds-end -sds-sys-config linux \
-target-os linux
```

- Run the application

```shell-session
root@sd_blk_direct_io:~# mount /dev/mmcblk0p1 /mnt
root@sd_blk_direct_io:~# /mnt/s2mm_data_copy.elf
xlnk_eng_probe ...
uio name xilinx-xlnk-eng.0
xilinx-xlnk-eng xilinx-xlnk-eng.0: physical base : 0x43c00000
xilinx-xlnk-eng xilinx-xlnk-eng.0: register range : 0x10000
xilinx-xlnk-eng xilinx-xlnk-eng.0: base remapped to: 0xf09e0000
xilinx-xlnk-eng xilinx-xlnk-eng.0: xilinx-xlnk-eng uio registered
TEST PASSED
```
