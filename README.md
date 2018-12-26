# snickerdoodle-black
Projects for snickerdoodle black

***
### simple

- Simple SDSoC platform; no I/O


***
### How to create platform

```bash
cd simple

# Create HW in Vivado
vivado -mode batch -source create_vivado_project.tcl

# Create Linux system with Petalinux


# Generate SDSoC platform


```


***
### How to create Petalinux project

- Refer to 

```bash
cd petalinux

export PRJ_NAME=sd_blk

# Create project
petalinux-create --type project --name ${PRJ_NAME} --template zynq
petalinux-config --project ${PRJ_NAME} --get-hw-description

# Modify kernel & rootfs settings
petalinux-config --project ${PRJ_NAME} -c kernel
petalinux-config --project ${PRJ_NAME} -c rootfs

# Build project
petalinux-build
```