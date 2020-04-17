#!/bin/sh
# Copy PetaLinux products for platform creation

PFM_FILE_DIR=pfm_files
PLNX_ROOT=petalinux

mkdir -p ${PFM_FILE_DIR}/boot ${PFM_FILE_DIR}/image

# Copy necessary output products
cp ${PLNX_ROOT}/images/linux/u-boot.elf      ${PFM_FILE_DIR}/boot
cp ${PLNX_ROOT}/images/linux/zynq_fsbl.elf   ${PFM_FILE_DIR}/boot
cp ${PLNX_ROOT}/images/linux/image.ub        ${PFM_FILE_DIR}/image
