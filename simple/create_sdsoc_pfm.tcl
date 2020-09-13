# May have to delete existing platform directory

# Platform name
set PFM_NAME    sd_blk
set SRC_DIR     pfm_files
set PREBUILT_DATA_DIR   ${SRC_DIR}/_prebuilt
set BOOT_DIR    ${SRC_DIR}/_boot
set IMG_DIR     ${SRC_DIR}/_image
set PLNX_ROOT   petalinux

# Check whether prebuilt data folder exists
set HAS_PREBUILT [file exists ${PREBUILT_DATA_DIR}]

if { ${HAS_PREBUILT} } then {
    set OUTDIR  _pfm
} else {
    set OUTDIR  _pfm_0
}

# Remove existing directory
file delete -force ${OUTDIR}
file delete -force ${BOOT_DIR}
file delete -force ${IMG_DIR}

file mkdir ${BOOT_DIR}
file mkdir ${IMG_DIR}

# Copy necessary output products
file copy ${PLNX_ROOT}/images/linux/u-boot.elf      ${BOOT_DIR}
file copy ${PLNX_ROOT}/images/linux/zynq_fsbl.elf   ${BOOT_DIR}
file copy ${PLNX_ROOT}/images/linux/image.ub        ${IMG_DIR}

# Create platform
platform create -name ${PFM_NAME} -hw ${PFM_NAME}.dsa -out ${OUTDIR}


# ----- Standalone -----
sysconfig create -name "standalone" -display-name "standalone" -desc "Standalone / Zynq-7000" 

sysconfig config -boot ${BOOT_DIR}
sysconfig config -bif {pfm_files/sdsoc_standalone.bif}
sysconfig config -readme {pfm_files/generic.readme}

# Use APU core #0
domain create -name {standalone} -os {standalone} -proc {ps7_cortexa9_0} -display-name {standalone} -desc "Standalone" -runtime "C++"

# Add prebuilt data
if { ${HAS_PREBUILT} } then {
    domain config -prebuilt-data ${PREBUILT_DATA_DIR}
}

# Generate linker script automatically
::scw::set_lscript_autogen true

platform write


# ----- Linux -----
# Create system configuration
sysconfig create -name "linux" -display-name "linux" -desc "Linux / Zynq-7000" 

sysconfig config -boot ${BOOT_DIR}
sysconfig config -bif {pfm_files/sdsoc_linux.bif}
sysconfig config -readme {pfm_files/generic.readme}

domain create -name {linux} -os {linux} -proc {ps7_cortexa9_0} -display-name {linux} -desc "Linux" -runtime "C++"

# Add prebuilt data
if { ${HAS_PREBUILT} } then {
    domain config -prebuilt-data ${PREBUILT_DATA_DIR}
}

::scw::set_linux_configured true

domain config -image ${IMG_DIR}
platform write


# Generate platform
platform generate
